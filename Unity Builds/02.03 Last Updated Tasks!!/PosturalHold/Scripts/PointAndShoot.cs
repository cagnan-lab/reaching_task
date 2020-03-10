using System.Collections;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
using System;
using Leap;
using LabJack.LabJackUD;

public class PointAndShoot : MonoBehaviour
{
    public GameObject player;

    public GameObject PosturalHold;
    public GameObject reach;

    public GameObject arrow1;

    // IF OFFSET IS STILL NEEDED FOR MOUSE DRAG:
    //private Vector3 mOffset;
    //private Vector3 LeapScreen;

    public float dist;
    public float distance;

    // NEEDED FOR LABJACK:
    private U3 u3;
    double pinNum = 4;  //4 means the LJTick-DAC is connected to FIO4/FIO5.

    public static int[] condition = { 1, 1, 1, 1 };                                               // Deze aanpassen als je andere condition gaat builden!

    public static int numBlocks = 3;
    public static int repetition;

    static string filePath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
    static string taskPath = Path.Combine(filePath, "OPM");
    static string ID = System.IO.File.ReadAllText(taskPath + @"\SUBCODE.txt");
    public static string subjectPath = Path.Combine(taskPath, ID);
    static string CURRID = System.IO.File.ReadAllText(subjectPath + @"\Configuration\CURRID.txt");
    static string conditionPath = Path.Combine(subjectPath, CURRID + "_Rest");                                           // HIER
    static string caliPath = Path.Combine(subjectPath, ID + "_Calibration");
    string[] xkey = System.IO.File.ReadAllLines(caliPath + @"\XKey.txt");
    string[] ykey = System.IO.File.ReadAllLines(caliPath + @"\YKey.txt");
    float[] XKey = new float[3];
    float[] YKey = new float[3];

    // For configuration:
    public static string lj = System.IO.File.ReadAllText(subjectPath + @"\Configuration\LABJACK.txt");           // LabJack connected yes (1) or no (0)
    public static int LJ = Int32.Parse(lj);
    public static string tick = System.IO.File.ReadAllText(subjectPath + @"\Configuration\TICK.txt");            // Tick connected yes (1) or no (0)
    public static int Tick = Int32.Parse(tick);
    public static string visible = System.IO.File.ReadAllText(subjectPath + @"\Configuration\VISIBLE.txt");      // Pointer visible yes (1) or no (0)
    public static int Visible = Int32.Parse(visible);
    public static string posthold = System.IO.File.ReadAllText(subjectPath + @"\Configuration\POSTHOLD.txt");    // Seconds of first postural hold
    public static float PostHold = float.Parse(posthold);
    public static string rest = System.IO.File.ReadAllText(subjectPath + @"\Configuration\REST.txt");            // Seconds of first postural hold
    public static float Rest = float.Parse(rest);

    static double location = 0;
    static float newpositionx = 0f;
    static float newpositiony = 0f;
    static float newpositionz = 0f;

    // Table for documentation of the trials:
    public static string[,] InfoTable = new string[6, 5];

    TextWriter code = null;
    TextWriter time = null;
    TextWriter data = null;

    void Start()
    {

        for (int l = 0; l < 3; l++)
        {
            XKey[l] = float.Parse(xkey[l]);
            YKey[l] = float.Parse(ykey[l]);
        }

        if (LJ == 1)
        {
            //Open the first found LabJack U3.
            u3 = new U3(LJUD.CONNECTION.USB, "0", true); // Connection through USB
            u3.u3Config();

            //Start by using the pin_configuration_reset IOType so that all
            //pin assignments are in the factory default condition.
            LJUD.ePut(u3.ljhandle, LJUD.IO.PIN_CONFIGURATION_RESET, 0, 0, 0);

            if (Tick == 1)
            {
                //Specify where the LJTick-DAC is plugged in. pinNum = 4 means the LJTick-DAC is connected to FIO4/FIO5.
                LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_CONFIG, LJUD.CHANNEL.TDAC_SCL_PIN_NUM, pinNum, 0);
            }
        }

        InfoTable[0, 0] = "Condition";
        InfoTable[0, 1] = "Repetition";
        InfoTable[0, 2] = "Direction";
        InfoTable[0, 3] = "Balloon Appeared?";
        InfoTable[0, 4] = "Balloon Popped?";

        Directory.CreateDirectory(conditionPath);

        code = new StreamWriter(conditionPath + @"\Coder.txt");
        time = new StreamWriter(conditionPath + @"\Timer.txt");
        data = new StreamWriter(conditionPath + @"\Data.txt");
        data.WriteLine("{0,-7}.{1,-13}.{2,-17}.{3,-17}.{4,-17}.{5,-17}.{6,-17}.{7,-17}.{8,-17}.{9,-17}.{10,-17}.{11,-17}.{12,-17}.{13,-17}.{14,-17}.{15,-17}.{16,-17}", "Coder", "Timer", "FrameRate", "xFinger[1]Pos", "yFingerTip[1]Pos", "zFingerTip[1]Pos", "xFinger[1]Screen", "yFinger[1]Screen", "xPalmPos", "yPalmPos", "zPalmPos", "xPalmVelo", "yPalmVelo", "zPalmVelo", "xHandDir", "yHandDir", "zHandDir");

        QualitySettings.vSyncCount = 0; // Disabling vertical synchronization to update the frames faster (for mouse drag)

        StartCoroutine(Posture());
    }

    IEnumerator Posture()
    {
        player.SetActive(true);
        if (Visible == 0)
        {
            player.GetComponent<SpriteRenderer>().enabled = false;              // To make pointer invisible!
        }
        PosturalHold.SetActive(true);
        LabJack(LJ, 1, 0.2);                    // CODER POSTURE: 0.5                                                                       // HIER                                                                      
        location = 0.2;                                                                                                                     // HIER
        yield return StartCoroutine(Wait(Rest));                            // CONTROL 60 SECONDS OF POSTURAL HOLD                          // HIER
        PosturalHold.SetActive(false);
        LabJack(LJ, 1, 0.0);                    // CODER BACK TO 0.0
        StopAllCoroutines();
        //UnityEditor.EditorApplication.isPlaying = false;
        Application.Quit();
    }

    IEnumerator Wait(float seconds)
    {
        yield return new WaitForSeconds(seconds);
    }

    // Void for updating HandPosition every frame:
    void Update()
    {
        code.WriteLine(location);
        time.WriteLine(Time.time);

        Controller controller = new Controller(); //An instance must exist

        Frame frame = controller.Frame();

        for (int h = 0; h < frame.Hands.Count; h++)
        {

            float instantaneousFrameRate = frame.CurrentFramesPerSecond;
            Hand hand = frame.Hands[h];
            Finger indexfinger = hand.Fingers[1];
            Vector indexfingerposition = indexfinger.TipPosition;
            Vector palmposition = hand.PalmPosition;
            Vector palmvelocity = hand.PalmVelocity;
            Vector handdirection = hand.Direction;

            newpositionx = ((indexfingerposition.x - XKey[0]) * XKey[1]) + XKey[2];
            newpositiony = ((indexfingerposition.y - YKey[0]) * YKey[1]) + YKey[2];

            player.transform.position = new Vector2(newpositionx, newpositiony);

            // IF OFFSET IS STILL NEEDED FOR MOUSE DRAG:
            //LeapScreen = new Vector3(newpositionx, newpositiony, newpositionz);
            //mOffset = player.transform.position - LeapScreen;
            //player.transform.position = new Vector2(newpositionx, newpositiony) + new Vector2(LeapScreen.x, LeapScreen.y);

            //Calculate the distance between the Arrow1 and the player
            dist = Vector2.Distance(player.transform.position, arrow1.transform.position);

            // Rescale LeapMotion to Volt-compatable for LabJack:
            float V2 = ((indexfingerposition.x + 600) / (600 + 600)) * 3;
            float V3 = ((indexfingerposition.y - 0) / (900 - 0)) * 3;
            float V4 = ((indexfingerposition.y + 550) / (650 + 550)) * 3;

            // FOR THE LABJACK Tick:
            if (Tick == 1)
            {
                ////// DAC1 = LeapX : 
                LabJack(LJ, 2, V2);
                ////// DACA = LeapY :
                LabJack(LJ, 3, V3);
                ////// DACB = LeapZ :
                LabJack(LJ, 4, V4);
            }

            //if (controller.IsConnected == false)
            //{
            //    xleap.WriteLine("NaN");
            //    yleap.WriteLine("NaN");
            //    zleap.WriteLine("Nan");
            //}

            data.WriteLine("{0,-7},{1,-13},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17}", location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), indexfingerposition.x.ToString(), indexfingerposition.y.ToString(), indexfingerposition.z.ToString(), newpositionx.ToString(), newpositiony.ToString(), palmposition.x.ToString(), palmposition.y.ToString(), palmposition.z.ToString(), palmvelocity.x.ToString(), palmvelocity.y.ToString(), palmvelocity.z.ToString(), handdirection.x.ToString(), handdirection.y.ToString(), handdirection.z.ToString());

        }


    }
    void LabJack(int LJ, int channel, double voltage)
    {
        if (LJ == 1)
        {
            if (channel == 1)
            {
                LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, voltage, 0);
            }
            else if (channel == 2)
            {
                LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)1, voltage, 0);
            }
            else if (channel == 3)
            {
                LJUD.ePut(u3.ljhandle, LJUD.IO.TDAC_COMMUNICATION, LJUD.CHANNEL.TDAC_UPDATE_DACA, voltage, 0);
            }
            else if (channel == 4)
            {
                LJUD.ePut(u3.ljhandle, LJUD.IO.TDAC_COMMUNICATION, LJUD.CHANNEL.TDAC_UPDATE_DACB, voltage, 0);
            }
        }
    }
}
