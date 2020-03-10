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

    public static List<float> xCo = new List<float>();
    public static List<float> yCo = new List<float>();
    public static List<float> zCo = new List<float>();
    public static List<int> coder = new List<int>();
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

    public static float[] xLOCLeap = new float[9];
    public static float[] yLOCLeap = new float[9];
    public static float[] zLOCLeap = new float[9];
    //public static UnityEngine.Transform[] Trans = new UnityEngine.Transform[3];
    //public static Leap.Matrix[] TransformMatrix = new Leap.Matrix[3];

    public static int[] LOCind = { 0 };

    public static TextWriter Coder = null;
    public static TextWriter time = null;
    public static TextWriter data = null;
    public static TextWriter xco = null;
    public static TextWriter yco = null;
    public static TextWriter zco = null;
    public static TextWriter code = null;
    public static TextWriter timer = null;

    void Start()
    {
        xco = new StreamWriter(folder + @"\xIndexFinger.txt");
        yco = new StreamWriter(folder + @"\yIndexFinger.txt");
        zco = new StreamWriter(folder + @"\zIndexFinger.txt");
        code = new StreamWriter(folder + @"\Coder.txt");
        timer = new StreamWriter(folder + @"\TimeVector.txt");
        Coder = new StreamWriter(folder + @"\Code.txt");
        time = new StreamWriter(folder + @"\Timer.txt");
        data = new StreamWriter(folder + @"\Data.txt");

        Cilinder.SetActive(true);

        data.WriteLine("{0,-7},{1,-13},{2,-17},{3,-17},{4,-17},{5,-17}", "Coder", "Timer", "FrameRate", "xFinger[1]Pos", "yFingerTip[1]Pos", "zFingerTip[1]Pos");

        QualitySettings.vSyncCount = 0; // Disabling vertical synchronization to update the frames faster (for mouse drag)

        StartCoroutine(Cali(xco, yco, zco, code, timer));
    }

    IEnumerator Cali(TextWriter xco, TextWriter yco, TextWriter zco, TextWriter code, TextWriter timer)
    {
        for (i = 0; i < 9; i++)
        {
            Cilinder.transform.position = Location[i];
            location = i;
            //Trans[i] = Cilinder.transform;
            yield return new WaitForSeconds(5f);
            TargetHit.t = 0;
            TargetHit._renderer.material.color = Color.red;
        }

        Cilinder.SetActive(false);
        print("Targets inactive");

        StartCoroutine(SaveCoordinates(xco, yco, zco, code, timer));
    }

    IEnumerator SaveCoordinates(TextWriter xco, TextWriter yco, TextWriter zco, TextWriter code, TextWriter timer)
    {
        foreach (var x in xCo)
        {
            xco.WriteLine(x);
        }
        xco.Close();
        foreach (var y in yCo)
        {
            yco.WriteLine(y);
        }
        yco.Close();
        foreach (var z in zCo)
        {
            zco.WriteLine(z);
        }
        zco.Close();
        foreach (var cod in coder)
        {
            code.WriteLine(cod);
        }
        code.Close();
        foreach (var time in tvec)
        {
            timer.WriteLine(time);
        }
        timer.Close();

        print("Coordinates saved");

        yield return StartCoroutine(MatrixFormation(xCo, yCo, zCo, coder));
    }


    IEnumerator MatrixFormation(List<float> xCo, List<float> yCo, List<float> zCo, List<int> coder)
    {
        for (int j = 0; j < 9; j++)
        {
            // Find indexes of location
            LOCind = coder.FindAllIndexof(j);

            List<float> xLOC = xCo.GetRange(LOCind[40], LOCind.Length - 41);    // Save all x-coordinates for that location
            List<float> yLOC = yCo.GetRange(LOCind[40], LOCind.Length - 41);    // Save all y-coordinates for that location
            List<float> zLOC = zCo.GetRange(LOCind[40], LOCind.Length - 41);    // Save all z-coordinates for that location

            xLOCLeap[j] = xLOC.Average();                                    // Take the mean of these x-coordinates
            yLOCLeap[j] = yLOC.Average();                                    // Take the mean of these y-coordinates
            zLOCLeap[j] = zLOC.Average();                                    // Take the mean of these z-coordinates


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

        var west = new List<float> { xLOCLeap[2], xLOCLeap[3], xLOCLeap[4] };
        float XWestLeap = west.Average();
        var east = new List<float> { xLOCLeap[6], xLOCLeap[7], xLOCLeap[8] };
        float XEastLeap = east.Average();
        var south = new List<float> { yLOCLeap[4], yLOCLeap[5], yLOCLeap[6] };
        float YSouthLeap = south.Average();
        var north = new List<float> { yLOCLeap[1], yLOCLeap[2], yLOCLeap[8] };
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

        yield return null;
        StopAllCoroutines();
        Application.Quit();
    }


    void Update()
    {
        Coder.WriteLine(location);
        time.WriteLine(Time.time);

        Frame frame = controller.Frame();

        for (int h = 0; h < frame.Hands.Count; h++)
        {
            coder.Add(location);
            tvec.Add(Time.time);

            float instantaneousFrameRate = frame.CurrentFramesPerSecond;

            Hand hand = frame.Hands[h];
            //position = hand.PalmPosition;
            Finger indexfinger = hand.Fingers[1];
            Vector indexfingerposition = indexfinger.TipPosition;

            xCo.Add(indexfingerposition.x);
            foreach (var x in xCo)
            {
                print(x);
            }
            yCo.Add(indexfingerposition.y);
            zCo.Add(indexfingerposition.z);

            data.WriteLine("{0,-7},{1,-13},{2,-17},{3,-17},{4,-17},{5,-17}", location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), indexfingerposition.x.ToString(), indexfingerposition.y.ToString(), indexfingerposition.z.ToString());


        }
    }
}