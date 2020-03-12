using System.Collections;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;
using Leap;
using System;

// This class needed to get the x-, and y-, and z-coordinates of the LeapMotion at certain moments of calibration (at a certain location/coder index)
public static class EM
{
    public static int[] FindAllIndexof<T>(this IEnumerable<T> values, T val)
    {
        return values.Select((b, i) => object.Equals(b, val) ? i : -1).Where(i => i != -1).ToArray();
    }
}

public static class AR
{
    public static T[] SubArray<T>(this T[] data, int index, int length)
    {
        T[] result = new T[length];
        Array.Copy(data, index, result, 0, length);
        return result;
    }
}

public class Calibration : MonoBehaviour
{
    static string filePath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
    static string ID = System.IO.File.ReadAllText(filePath + @"\OPM\SUBCODE.txt");
    static string folder = Path.Combine(filePath, "OPM", ID, ID + "_Calibration");
    static string subjectPath = Path.Combine(filePath, "OPM", ID);

    public static string tracking = System.IO.File.ReadAllText(subjectPath + @"\Configuration\TRACKING.txt");           // IndexFingerTip (0), PalmPosition (1), StabilizedPalmPosition (2)
    public static int Tracking = Int32.Parse(tracking);

    public static List<float> xCo = new List<float>();
    public static List<float> yCo = new List<float>();
    public static List<float> zCo = new List<float>();
    public static List<int> Coder = new List<int>();
    public static List<double> tvec = new List<double>();

    public static GameObject player;
    public GameObject Cilinder;

    //private Vector3 target;
    Vector3[] Location = new[] { new Vector3(0f, 0f, 0f), new Vector3(0f, 2f, 0f), new Vector3(-2f, 2f, 0f), new Vector3(-2f, 0f, 0f), new Vector3(-2f, -2f, 0f), new Vector3(0f, -2f, 0f), new Vector3(2f, -2f, 0f), new Vector3(2f, 0f, 0f), new Vector3(2f, 2f, 0f) };
    static float W = -2f;
    static float E = 2f;
    static float S = -2f;
    static float N = 2f;

    public static Controller controller = new Controller(); //An instance must exist
    public static Vector position = new Vector();
    public static int i = 0;
    public static int location = i;

    public static List<float> xLOC = new List<float>();
    public static List<float> yLOC = new List<float>();
    public static List<float> zLOC = new List<float>();
    //public static float[] xLOCMean = new float[9];
    //public static float[] yLOCMean = new float[9];
    //public static float[] zLOCMean = new float[9];
    public static double timing = new double();
    //public static UnityEngine.Transform[] Trans = new UnityEngine.Transform[3];
    //public static Leap.Matrix[] TransformMatrix = new Leap.Matrix[3];

    public static int[] LOCind = { 0 };
    public static int[] LOC = { 0 };
    public static float ZScreen;

    public static TextWriter data = null;

    void Start()
    {
        data = new StreamWriter(folder + @"\Data.txt");

        Cilinder.SetActive(true);

        data.WriteLine("{0,-7},{1,-13},{2,-17},{3,-17},{4,-17},{5,-17}", "Coder", "Timer", "FrameRate", "xFinger[1]Pos", "yFingerTip[1]Pos", "zFingerTip[1]Pos");

        QualitySettings.vSyncCount = 0; // Disabling vertical synchronization to update the frames faster (for mouse drag)

        StartCoroutine(Cali());
    }

    IEnumerator Cali()
    {
        for (i = 0; i < 9; i++)
        {
            Cilinder.transform.position = Location[i];
            location = i;
            //Trans[i] = Cilinder.transform;
            yield return new WaitForSeconds(5f);
        }

        Cilinder.SetActive(false);
        print("Targets inactive");

        StartCoroutine(SaveCoordinates());
    }

    IEnumerator SaveCoordinates()
    {
        using (StreamWriter xco = new StreamWriter(folder + @"\xLeap.txt"))
        {
            foreach (var x in xCo)
            {
                xco.WriteLine(x);
            }
        }
        using (StreamWriter yco = new StreamWriter(folder + @"\yLeap.txt"))
        {
            foreach (var y in yCo)
            {
                yco.WriteLine(y);
            }
        }
        using (StreamWriter zco = new StreamWriter(folder + @"\zLeap.txt"))
        {
            foreach (var z in zCo)
            {
                zco.WriteLine(z);
            }
        }
        using (StreamWriter coder = new StreamWriter(folder + @"\Coder.txt"))
        {
            foreach (var cod in Coder)
            {
                coder.WriteLine(cod);
            }
        }
        using (StreamWriter timer = new StreamWriter(folder + @"\Timer.txt"))
        {
            foreach (var time in tvec)
            {
                timer.WriteLine(time);
            }
        }

        print("Coordinates saved");

        yield return StartCoroutine(MatrixFormation());
    }


    IEnumerator MatrixFormation()
    {
        float[] xLOCMean = new float[9];
        float[] yLOCMean = new float[9];
        float[] zLOCMean = new float[9];

        for (int j = 0; j < 9; j++)                 // For each calibration point
        {
            LOCind = Coder.FindAllIndexof(j);       // Find indexes of location
            timing = tvec[LOCind[0]];               // Time point of first new location of calibration poins

            for (int i = 0; i < tvec.Count; i++)    // Go through all time points
            {
                if ((tvec[i] > (timing + 2)) && (tvec[i] < (timing + 4.5)))     // If time point is between 2 and 4.5 seconds after location change, condition is met and corresponding LeapMotion coordinate is added to list:
                {
                    xLOC.Add(xCo[i]);
                    yLOC.Add(yCo[i]);
                    zLOC.Add(zCo[i]);
                }
            }

            xLOCMean[j] = xLOC.Average();           // Take the mean of these x, y, and z-coordinates
            yLOCMean[j] = yLOC.Average();
            zLOCMean[j] = zLOC.Average();

            xLOC.Clear();           // Since coordinates are only added to the list, and not overwritten: Make sure you empty the lists!
            yLOC.Clear();
            zLOC.Clear();

            // This is my desperate try on 3D calibration:

            //Vector3 LOCLeap = new Vector3(xLOCLeap, yLOCLeap, zLOCLeap);        // FIXLeap is mean (x,y,z)position of hand.PalmPosition when finger is positioned at FIX target location
            //Vector3 TransRelative = Trans[j].InverseTransformPoint(LOCLeap);     // Position of hand.PalmPosition relative to the target position FIX (trans1)
            //Vector xBasis = new Vector(TransRelative.x, 0, 0);
            //Vector yBasis = new Vector(0, TransRelative.y, 0);
            //Vector zBasis = new Vector(0, 0, TransRelative.z);
            //TransformMatrix[j] = new Leap.Matrix(xBasis, yBasis, zBasis);
            //foreach (var value in TransformMatrix[j])
            //{
            //    print("TransformMatrix " + j + " : " + value);
            //}
            //yield return TransformMatrix;
        }

        // Save averages per location for x, y, z of Leap:
        using (StreamWriter xLoc = new StreamWriter(folder + @"\xLocAverage.txt"))
        {
            foreach (var item in xLOCMean)
            {
                xLoc.WriteLine(item);
            }
        }
        using (StreamWriter yLoc = new StreamWriter(folder + @"\yLocAverage.txt"))
        {
            foreach (var item in yLOCMean)
            {
                yLoc.WriteLine(item);
            }
        }
        using (StreamWriter zLoc = new StreamWriter(folder + @"\zLocAverage.txt"))
        {
            foreach (var item in zLOCMean)
            {
                zLoc.WriteLine(item);
            }
        }

        // To determine z-coordinate of the screen for GBYK
        var zscreen = new List<float> { zLOCMean[0], zLOCMean[1], zLOCMean[2], zLOCMean[3], zLOCMean[4], zLOCMean[5], zLOCMean[6], zLOCMean[7], zLOCMean[8] };
        ZScreen = zscreen.Average();
        using (StreamWriter zScreen = new StreamWriter(folder + @"\zScreen.txt"))
        {
            zScreen.WriteLine(ZScreen);
        }

        // Create lists of N, W, E, and S sides. Average those three averages and use it to feed the key calculation.
        var west = new List<float> { xLOCMean[2], xLOCMean[3], xLOCMean[4] };
        float XWestLeap = west.Average();
        var east = new List<float> { xLOCMean[6], xLOCMean[7], xLOCMean[8] };
        float XEastLeap = east.Average();
        var south = new List<float> { yLOCMean[4], yLOCMean[5], yLOCMean[6] };
        float YSouthLeap = south.Average();
        var north = new List<float> { yLOCMean[1], yLOCMean[2], yLOCMean[8] };
        float YNorthLeap = north.Average();

        yield return StartCoroutine(getTransform(W, E, S, N, XWestLeap, XEastLeap, YSouthLeap, YNorthLeap));
    }

    IEnumerator getTransform(float W, float E, float S, float N, float XWestLeap, float XEastLeap, float YSouthLeap, float YNorthLeap)
    {
        // function [XKey,YKey] = getTransform(WESN_app,WESN_leap)
        // WESN is [XWest XEast YSouth YNorth]
        float Xrange_app = E - W;
        float Xrange_leap = XEastLeap - XWestLeap;

        float Yrange_app = N - S;
        float Yrange_leap = YNorthLeap - YSouthLeap;

        // xS = (xL - WESN_leap(1)) * (Xrange_app / Xrange_leap) + WESN_app(1)
        float[] XKey = { XWestLeap, (Xrange_app / Xrange_leap), W };
        float[] YKey = { YSouthLeap, (Yrange_app / Yrange_leap), S };

        TextWriter xkey = new StreamWriter(folder + @"\XKey.txt");
        TextWriter ykey = new StreamWriter(folder + @"\YKey.txt");

        foreach (var value in XKey)
        {
            xkey.WriteLine(value);
        }
        xkey.Close();
        foreach (var value in YKey)
        {
            ykey.WriteLine(value);
        }
        ykey.Close();
        print("Keys Saved");

        yield return null;
        StopAllCoroutines();
        Application.Quit();
    }


    void Update()
    {
        using (StreamWriter AllCoder = new StreamWriter(folder + @"\AllCoder.txt"))
        {
            AllCoder.WriteLine(location);
        }
        using (StreamWriter AllTime = new StreamWriter(folder + @"\AllTime.txt"))
        {
            AllTime.WriteLine(Time.time);
        }

        Frame frame = controller.Frame();

        for (int h = 0; h < frame.Hands.Count; h++)
        {
            Coder.Add(location);
            tvec.Add(Time.time);

            float instantaneousFrameRate = frame.CurrentFramesPerSecond;

            Hand hand = frame.Hands[h];
            Finger indexfinger = hand.Fingers[1];
            Vector indexfingerposition = indexfinger.TipPosition;
            Vector palmposition = hand.PalmPosition;
            Vector stabilizedpalmposition = hand.StabilizedPalmPosition;

            if (Tracking == 0)
            {
                xCo.Add(indexfingerposition.x);
                yCo.Add(indexfingerposition.y);
                zCo.Add(indexfingerposition.z);
            }
            else if (Tracking == 1)
            {
                xCo.Add(palmposition.x);
                yCo.Add(palmposition.y);
                zCo.Add(palmposition.z);
            }
            else if (Tracking == 2)
            {
                xCo.Add(stabilizedpalmposition.x);
                yCo.Add(stabilizedpalmposition.y);
                zCo.Add(stabilizedpalmposition.z);
            }

            data.WriteLine("{0,-7},{1,-13},{2,-17},{3,-17},{4,-17},{5,-17}", location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), indexfingerposition.x.ToString(), indexfingerposition.y.ToString(), indexfingerposition.z.ToString());

        }
    }
}