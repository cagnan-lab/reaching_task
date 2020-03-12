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

public class Calibration : MonoBehaviour
{
    // Create paths to save data/keys:
    static string filePath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
    static string ID = System.IO.File.ReadAllText(filePath + @"\OPM\SUBCODE.txt");
    static string folder = Path.Combine(filePath, "OPM", ID, ID + "_Calibration");
    static string subjectPath = Path.Combine(filePath, "OPM", ID);

    // Determine which LeapMotion data is used for calibration tracking:
    public static string tracking = System.IO.File.ReadAllText(subjectPath + @"\Configuration\TRACKING.txt");           // IndexFingerTip (0), PalmPosition (1), StabilizedPalmPosition (2)
    public static int Tracking = Int32.Parse(tracking);

    // Create lists to save the LeapMotion cali data in:
    public static List<float> xCo = new List<float>();
    public static List<float> yCo = new List<float>();
    public static List<float> zCo = new List<float>();
    public static List<int> Coder = new List<int>();
    public static List<double> tvec = new List<double>();

    // GameObjects to show in the game:
    public static GameObject player;
    public GameObject Cilinder;

    // Positions of the cilinder (= calibration points):
    Vector3[] Location = new[] { new Vector3(0f, 0f, 0f), new Vector3(0f, 2f, 0f), new Vector3(-2f, 2f, 0f), new Vector3(-2f, 0f, 0f), new Vector3(-2f, -2f, 0f), new Vector3(0f, -2f, 0f), new Vector3(2f, -2f, 0f), new Vector3(2f, 0f, 0f), new Vector3(2f, 2f, 0f) };
    static float W = -2f;
    static float E = 2f;
    static float S = -2f;
    static float N = 2f;

    // LeapMotion controller:
    public static Controller controller = new Controller(); //An instance must exist
    public static Vector position = new Vector();
    // Coder of calibration points:
    public static int i = 0;
    public static int location = i;

    // Lists to temporarly save LeapMotion data per calibration point:
    public static List<float> xLOC = new List<float>();
    public static List<float> yLOC = new List<float>();
    public static List<float> zLOC = new List<float>();
    public static double timing = new double();

    // Part of the desperate try to get 3D LeapMotion tracking: 
    //public static UnityEngine.Transform[] Trans = new UnityEngine.Transform[3];
    //public static Leap.Matrix[] TransformMatrix = new Leap.Matrix[3];

    // Indexes of coder that correspond to specific location of calibration points:
    public static int[] LOCind = { 0 };
    // Saves the LeapMotion z-coordinate of tracking item (fingertippos or palmpos):
    public static float ZScreen;

    // Create textfile for data:
    public static TextWriter data = null;

    void Start()
    {
        data = new StreamWriter(folder + @"\Data.txt");         // Open textfile for data

        Cilinder.SetActive(true);                               // Set cilinder gameobject to visible
         
        data.WriteLine("{0,-7},{1,-13},{2,-17},{3,-17},{4,-17},{5,-17}", "Coder", "Timer", "FrameRate", "xFinger[1]Pos", "yFingerTip[1]Pos", "zFingerTip[1]Pos");       // Write first line of data textfile (indicating column titles)

        QualitySettings.vSyncCount = 0; // Disabling vertical synchronization to update the frames faster (for mouse drag)

        StartCoroutine(Cali());         // Start the calibration coroutine
    }

    IEnumerator Cali()                                      // This is the cali coroutine
    {
        for (i = 0; i < 9; i++)                             // For locations 1 to 9...
        {
            Cilinder.transform.position = Location[i];      // Set cilinder position to location[i] 
            location = i;
            //Trans[i] = Cilinder.transform; // --> part of desperate 3D try
            yield return new WaitForSeconds(5f);            // Wait for 5 seconds before moving cilinder to next location[i+1]
        }

        Cilinder.SetActive(false);                  // After cilinder has moved to all 9 locations, deactivate cilinder gameobject
        print("Targets inactive");                  // Print that the target (= cilinder) is deactivated in console window (= debug window)

        StartCoroutine(SaveCoordinates());          // Start the next coroutine = savecoordinates
    }

    IEnumerator SaveCoordinates()                   // This is the next coroutine
    {
        using (StreamWriter xco = new StreamWriter(folder + @"\xLeap.txt"))
        {
            foreach (var x in xCo)
            {
                xco.WriteLine(x);                   // Write every item of the xCo list to textfile xco, which is called xLeap in pc folder
            }
        }
        using (StreamWriter yco = new StreamWriter(folder + @"\yLeap.txt"))
        {
            foreach (var y in yCo)
            {
                yco.WriteLine(y);                   // Write every item of the yCo list to textfile yco, which is called yLeap in pc folder
            }
        }
        using (StreamWriter zco = new StreamWriter(folder + @"\zLeap.txt"))
        {
            foreach (var z in zCo)
            {
                zco.WriteLine(z);                   // Write every item of the zCo list to textfile zco, which is called zLeap in pc folder
            }
        }
        using (StreamWriter coder = new StreamWriter(folder + @"\Coder.txt"))
        {
            foreach (var cod in Coder)
            {
                coder.WriteLine(cod);               // Write every item of the Coder list to textfile coder, which is called Coder in pc folder
            }
        }
        using (StreamWriter timer = new StreamWriter(folder + @"\Timer.txt"))
        {
            foreach (var time in tvec)
            {
                timer.WriteLine(time);              // Write every item of the tvec list to textfile timer, which is called Timer in pc folder
            }
        }

        print("Coordinates saved");                             // Print that the LeapMotion coordinates are saved in the textfiles in console window

        yield return StartCoroutine(MatrixFormation());         // Start the next coroutine = MatrixFormation
    }


    IEnumerator MatrixFormation()               // This is the next coroutine
    {
        // Create new arrays of type 'float' to save the mean of the x, y, and z-coordinates per location of calibration point (= 9 locations)
        float[] xLOCMean = new float[9]; 
        float[] yLOCMean = new float[9];
        float[] zLOCMean = new float[9];

        for (int j = 0; j < 9; j++)                 // For each calibration point
        {
            LOCind = Coder.FindAllIndexof(j);       // Find indexes of location with the function FindAllIndexof of the class EM stated above
            timing = tvec[LOCind[0]];               // Time point of first new location of calibration poins

            for (int i = 0; i < tvec.Count; i++)    // Go through all time points
            {
                if ((tvec[i] > (timing + 2)) && (tvec[i] < (timing + 4.5)))     // If time point is between 2 and 4.5 seconds after location change (so after 'timing'), condition is met and corresponding LeapMotion coordinate is added to list:
                {
                    xLOC.Add(xCo[i]);
                    yLOC.Add(yCo[i]);
                    zLOC.Add(zCo[i]);
                }
            }

            xLOCMean[j] = xLOC.Average();           // Take the mean of these x, y, and z-coordinates that met the condition above
            yLOCMean[j] = yLOC.Average();
            zLOCMean[j] = zLOC.Average();

            xLOC.Clear();           // Since coordinates are only added to the list, and not overwritten: Make sure you empty the lists before looping to next location of calibration point!
            yLOC.Clear();
            zLOC.Clear();

            // This is my desperate try on 3D calibration..:

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

        // To determine z-coordinate of the screen for GBYK and save it in zScreen text file:
        var zscreen = new List<float> { zLOCMean[0], zLOCMean[1], zLOCMean[2], zLOCMean[3], zLOCMean[4], zLOCMean[5], zLOCMean[6], zLOCMean[7], zLOCMean[8] };
        ZScreen = zscreen.Average();
        using (StreamWriter zScreen = new StreamWriter(folder + @"\zScreen.txt"))
        {
            zScreen.WriteLine(ZScreen);
        }

        // Create lists of N, W, E, and S sides. Average those three averages and use it to feed the calculation of the keys:
        var west = new List<float> { xLOCMean[2], xLOCMean[3], xLOCMean[4] };
        float XWestLeap = west.Average();
        var east = new List<float> { xLOCMean[6], xLOCMean[7], xLOCMean[8] };
        float XEastLeap = east.Average();
        var south = new List<float> { yLOCMean[4], yLOCMean[5], yLOCMean[6] };
        float YSouthLeap = south.Average();
        var north = new List<float> { yLOCMean[1], yLOCMean[2], yLOCMean[8] };
        float YNorthLeap = north.Average();

        yield return StartCoroutine(getTransform(W, E, S, N, XWestLeap, XEastLeap, YSouthLeap, YNorthLeap));        // Here starts the last coroutine = getTransform (the same as in Matlab function getTransform)
    }

    IEnumerator getTransform(float W, float E, float S, float N, float XWestLeap, float XEastLeap, float YSouthLeap, float YNorthLeap)  // Here starts the last coroutine
    {
        // Determine the Screen and according LeapMotion ranges for X- and Y-directions:
        float Xrange_app = E - W;
        float Xrange_leap = XEastLeap - XWestLeap;

        float Yrange_app = N - S;
        float Yrange_leap = YNorthLeap - YSouthLeap;

        // Save the keys as arrays containing three values to use in other script:
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
        print("Keys Saved");            // Print that the keys are saved in the text files

        yield return null;              // This means the end of this coroutine, without giving other outputs
        StopAllCoroutines();            // Stop all coroutines
        Application.Quit();             // Close the application (when it is build)
    }

    // Everything that in located in the Update void, updates every Unity sample
    void Update()
    {
        using (StreamWriter AllCoder = new StreamWriter(folder + @"\AllCoder.txt"))
        {
            AllCoder.WriteLine(location);               // Every Unity frame, save the coder that correspond to the location of the calibration point to the AllCoder text file
        }
        using (StreamWriter AllTime = new StreamWriter(folder + @"\AllTime.txt"))
        {
            AllTime.WriteLine(Time.time);               // Every Unity frame, save the current time (after game started running) to the AllTime text file
        }

        Frame frame = controller.Frame();               // Create a frame from the LeapMotion controller

        for (int h = 0; h < frame.Hands.Count; h++)     // For infinite amount of LeapMotion frames
        {
            Coder.Add(location);                        // Add the coder that correspond to the location of the calibration point to the Coder list
            tvec.Add(Time.time);                        // Add the current time (after game started running) to the tvec list

            float instantaneousFrameRate = frame.CurrentFramesPerSecond;        // LeapMotion data of CurrentFramesPerSecond

            Hand hand = frame.Hands[h];                                     // Get hand model from LeapMotion
            Finger indexfinger = hand.Fingers[1];                           // Get the fingers from the hand model of LeapMotion
            Vector indexfingerposition = indexfinger.TipPosition;           // Get the position of the tip of the indexfinger from the hand model of LeapMotion
            Vector palmposition = hand.PalmPosition;                        // Get the position of the palm from the hand model of LeapMotion
            Vector stabilizedpalmposition = hand.StabilizedPalmPosition;    // !! DOESN'T WORK... !! Get the stabilized position of the palm from the hand model of LeapMotion 

            // Depending on the tracking configuration, use different LeapMotion data to do the calibration: 
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

            // Write all data in one go to the text file data:
            data.WriteLine("{0,-7},{1,-13},{2,-17},{3,-17},{4,-17},{5,-17}", location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), indexfingerposition.x.ToString(), indexfingerposition.y.ToString(), indexfingerposition.z.ToString());

        }
    }
}