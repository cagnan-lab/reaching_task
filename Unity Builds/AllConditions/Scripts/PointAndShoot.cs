using System.Collections;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
using System;
using System.Linq;
using Leap;
using LabJack.LabJackUD;

public class PointAndShoot : MonoBehaviour
{
    static string filePath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
    static string taskPath = Path.Combine(filePath, "OPM");
    static string ID = System.IO.File.ReadAllText(taskPath + @"\SUBCODE.txt");
    public static string subjectPath = Path.Combine(taskPath, ID);
    static string CURRID = System.IO.File.ReadAllText(subjectPath + @"\Configuration\CURRID.txt");
    static string conditionPath = Path.Combine(subjectPath, CURRID);
    static string caliPath = Path.Combine(subjectPath, ID + "_Calibration");
    string[] xkey = System.IO.File.ReadAllLines(caliPath + @"\XKey.txt");
    string[] ykey = System.IO.File.ReadAllLines(caliPath + @"\YKey.txt");
    float[] XKey = new float[3];
    float[] YKey = new float[3];

    // For configuration:
    public static string zscreen = System.IO.File.ReadAllText(caliPath + @"\zScreen.txt");                                      // z-Coordinate of screen from Cali for GBYK
    public static float zScreen = float.Parse(zscreen);
    public static string tracking = System.IO.File.ReadAllText(subjectPath + @"\Configuration\TRACKING.txt");                   // IndexFingerTip (0), PalmPosition (1), StabilizedPalmPosition (2)
    public static int Tracking = Int32.Parse(tracking);
    public static string lj = System.IO.File.ReadAllText(subjectPath + @"\Configuration\LABJACK.txt");                          // LabJack connected yes (1) or no (0)
    public static int LJ = Int32.Parse(lj);
    public static string tick = System.IO.File.ReadAllText(subjectPath + @"\Configuration\TICK.txt");                           // Tick connected yes (1) or no (0)
    public static int Tick = Int32.Parse(tick);
    public static string Cond = System.IO.File.ReadAllText(subjectPath + @"\Configuration\CONDITION.txt");                      // Which condition is on
    public static int cond = Int32.Parse(Cond);
    public static string visible = System.IO.File.ReadAllText(subjectPath + @"\Configuration\VISIBLE.txt");                     // Pointer visible yes (1) or no (0)
    public static int Visible = Int32.Parse(visible);
    public static string distancecm = System.IO.File.ReadAllText(subjectPath + @"\Configuration\DISTANCE.txt");                 // #cm hand has to move from camera before balloon shows GBYK
    public static float Distance = float.Parse(distancecm);
    public static string reaches = System.IO.File.ReadAllText(subjectPath + @"\Configuration\REACHES.txt");                     // Total amount of reaches
    public static int Reaches = Int32.Parse(reaches);
    //public static string uncertainty = System.IO.File.ReadAllText(subjectPath + @"\Configuration\UNCERTAINTY.txt");           // Total amount of arrows for uncertainty
    //public static int Uncertainty = Int32.Parse(uncertainty);
    public static string condinfo = System.IO.File.ReadAllText(subjectPath + @"\Configuration\CONDINFO.txt");                   // Seconds of first postural hold
    public static float CondInfo = float.Parse(condinfo);
    public static string posthold = System.IO.File.ReadAllText(subjectPath + @"\Configuration\POSTHOLD.txt");                   // Seconds of first postural hold
    public static float PostHold = float.Parse(posthold);
    public static string rest = System.IO.File.ReadAllText(subjectPath + @"\Configuration\REST.txt");                           // Seconds of first postural hold
    public static float Rest = float.Parse(rest);
    public static string breakreaches = System.IO.File.ReadAllText(subjectPath + @"\Configuration\BREAKREACHES.txt");           // Total amount of reaches
    public static int BreakReaches = Int32.Parse(breakreaches);
    public static string breakwait = System.IO.File.ReadAllText(subjectPath + @"\Configuration\BREAKWAIT.txt");                 // Seconds of break after 10 reaches
    public static float BreakWait = float.Parse(breakwait);
    public static string poststart = System.IO.File.ReadAllText(subjectPath + @"\Configuration\POSTSTART.txt");                 // Seconds of first postural hold
    public static float PostStart = float.Parse(poststart);
    public static string reachwait = System.IO.File.ReadAllText(subjectPath + @"\Configuration\REACHWAIT.txt");                 // Seconds of reach wait
    public static float ReachWait = float.Parse(reachwait);
    public static string prepwait = System.IO.File.ReadAllText(subjectPath + @"\Configuration\PREPWAIT.txt");                   // Seconds of motor prep wait
    public static float PrepWait = float.Parse(prepwait);
    public static string delaywait = System.IO.File.ReadAllText(subjectPath + @"\Configuration\DELAYWAIT.txt");                 // Seconds of motor delay wait (GBYK!)
    public static float DelayWait = float.Parse(delaywait);
    public static string holdwait = System.IO.File.ReadAllText(subjectPath + @"\Configuration\HOLDWAIT.txt");                   // Seconds of hold wait
    public static float HoldWait = float.Parse(holdwait);
    //public static string balloon = System.IO.File.ReadAllText(subjectPath + @"\Configuration\BALLOONSIZE.txt");               // Size of Balloon
    //public static float BalloonSize = float.Parse(balloon);

    public GameObject player;
    public GameObject Canvas;
    public GameObject countText;
    public GameObject countspark;
    public GameObject conditionText;
    public GameObject postureText;
    public GameObject restText;
    public GameObject pauseText;

    public GameObject breaktext;
    public GameObject reach;
    public GameObject firstpost;
    public GameObject endText;

    public GameObject arrow1;
    public GameObject arrow2;
    public GameObject arrow3;
    public GameObject arrow4;
    public GameObject arrow5;
    public GameObject arrow6;
    public GameObject arrow7;
    public GameObject arrow8;

    public GameObject balloonTOP1;
    public GameObject balloonTOP2;
    public GameObject balloonTOP3;
    public GameObject balloonTOP4;
    public GameObject balloonTOP5;
    public static Renderer _rendererScore;

    public GameObject balloonBIG;
    public GameObject balloonSMALL;
    public GameObject animBIG;
    public GameObject animSMALL;

    // IF OFFSET IS STILL NEEDED FOR MOUSE DRAG:
    //private Vector3 mOffset;
    //private Vector3 LeapScreen;

    public float dist;
    public float distance;

    // NEEDED FOR LABJACK:
    private U3 u3;
    double pinNum = 4;  //4 means the LJTick-DAC is connected to FIO4/FIO5.

    public static int[] condition = { cond, cond, cond, cond};
    // Random Array of Direction:
    public static int[] direction = new int[Reaches];
    public static int numBlocks = 3;
    public static int repetition;
    public static int part = 1;
    public static string gosign;
    public static string certainty;
    public static string precision;

    public static double[] arraylist = new double[8];
    public static double[] arrowlist = new double[8];
    public static double sigma = 0;

    private bool flagpost = true;
    private int delayflag = 0;
    private int pauseflag = 0;

    public static double location = 0;
    public static double labjackvalue = 0;
    static float trackingx = 0f;
    static float trackingy = 0f;
    static float trackingz = 0f;
    static float newpositionx = 0f;
    static float newpositiony = 0f;
    static float newpositionz = 0f;

    // Table for documentation of the trials:
    public static string[,] InfoTable = new string[Reaches+1, 6];

    public static TextWriter infotable = null;
    public static TextWriter code = null;
    public static TextWriter time = null;
    public static TextWriter data = null;
    public static TextWriter extradata = null;

    void Start()
    {
        distance = Distance;
        //balloonBIG.transform.localScale = new Vector3(BalloonSize, BalloonSize, BalloonSize);      // 20 is BIG, 10 is SMALL

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

        // Shuffle Array of Condition:
        ShuffleArray(condition);

        InfoTable[0, 0] = "Condition";
        InfoTable[0, 1] = "Repetition";
        InfoTable[0, 2] = "Direction";
        InfoTable[0, 3] = "Balloon Appeared?";
        InfoTable[0, 4] = "Balloon Popped?";
        InfoTable[0, 5] = "Time of Popping";

        Directory.CreateDirectory(conditionPath);

        infotable = new StreamWriter(conditionPath + @"\InfoTable.txt");
        code = new StreamWriter(conditionPath + @"\Coder.txt");
        time = new StreamWriter(conditionPath + @"\Timer.txt");
        data = new StreamWriter(conditionPath + @"\Data.txt");
        extradata = new StreamWriter(conditionPath + @"\ExtraData.txt");

        data.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17}", "Coder", "Timer", "FrameRate", "FrameID", "HandID", "xScreenPosition", "yScreenPosition", "xElbowPos", "yElbowPos", "zElbowPos", "xArmCenter", "yArmCenter", "zArmCenter", "xWristArmPos", "yWristArmPos", "zWristArmPos", "xWristHandPos", "yWristHandPos", "zWristHandPos", "PalmWidth", "xPalmPos", "yPalmPos", "zPalmPos", "xPalmVelo", "yPalmVelo", "zPalmVelo", "xHandDir", "yHandDir", "zHandDir", "xStabilizedPalmPos", "yStabilizedPalmPos", "zStabilizedPalmPos", "IndexID", "xIndexTipPos", "yIndexTipPos", "zIndexTipPos");
        extradata.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17},{36,-17},{37,-17},{38,-17},{39,-17},{40,-17},{41,-17},{42,-17},{43,-17},{44,-17},{45,-17},{46,-17},{47,-17},{48,-17},{49,-17},{50,-17},{51,-17},{52,-17},{53,-17},{54,-17},{55,-17},{56,-17},{57,-17},{58,-17},{59,-17},{60,-17},{61,-17},{62,-17},{63,-17},{64,-17},{65,-17},{66,-17},{67,-17},{68,-17},{69,-17},{70,-17},{71,-17},{72,-17},{73,-17}","Coder", "Timer", "FrameRate", "FrameID", "HandID", "HandConfidence", "LeftHand", "HandVisible", "xArmDirection", "yArmDirection", "zArmDirection", "xArmOrientation", "yArmOrientation", "zArmOrientation", "ArmLength", "ArmWidth", "xPalmNormal", "yPalmNormal", "zPalmNormal", "xPalmOrientation", " yPalmOrientation ", " zPalmOrientation ", "ThumbID", "ThumbVisible", "ThumbExtended", "ThumbLength", "ThumbWidth", "xThumbTipPos", "yThumbTipPos", "zThumbTipPos", "xThumbDir", "yThumbDir", "zThumbDir", "IndexID", "IndexVisible", "IndexExtended", "IndexLength", "IndexWidth", "xIndexDir", "yIndexDir", "zIndexDir", "MiddleID", "MiddleVisible", "MiddleExtended", "MiddleLength", "MiddleWidth", "xMiddleTipPos", "yMiddleTipPos", "zMiddleTipPos", "xMiddleDir", "yMiddleDir", "zMiddleDir", "RingID", "RingVisible", "RingExtended", "RingLength", "RingWidth", "xRingTipPos", "yRingTipPos", "zRingTipPos", "xRingDir", "yRingDir", "zRingDir", "PinkyID", "PinkyVisible", "PinkyExtended", "PinkyLength", "PinkyWidth", "xPinkyTipPos", "yPinkyTipPos", "zPinkyTipPos", "xPinkyDir", "yPinkyDir", "zPinkyDir");

        QualitySettings.vSyncCount = 0; // Disabling vertical synchronization to update the frames faster (for mouse drag)

        StartCoroutine(ConditionText(condition));
    }

    IEnumerator ConditionText(int[] condition)
    {
        // GBYK or GAYK
        if (condition[numBlocks] < 5)
        {
            gosign = "GO AFTER YOU KNOW";
        }
        else if (condition[numBlocks] > 4)
        {
            gosign = "GO BEFORE YOU KNOW";
        }

        // Level of Uncertainty = ARROWS
        if (condition[numBlocks] == 1 || condition[numBlocks] == 3 || condition[numBlocks] == 5 || condition[numBlocks] == 7)
        {
            certainty = "LOW UNCERTAINTY";
        }
        else if (condition[numBlocks] == 2 || condition[numBlocks] == 4 || condition[numBlocks] == 6 || condition[numBlocks] == 8)
        {
            certainty = "HIGH UNCERTAINTY";
        }

        // Level of Precision required = BALLOONS
        if (condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6)
        {
            precision = "LOW PRECISION";
        }
        else if (condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8)
        {
            precision = "HIGH PRECISION";
        }

        conditionText.SetActive(true);
        LabJack(LJ, 1, 0.0);                    // CODER CONDINFO: 0.0                                                                                                                     
        location = 0.0;
        conditionText.GetComponent<UnityEngine.UI.Text>().text = "This is a " + gosign + " trial \n that contains " + certainty + " \n and requires " + precision;
        yield return StartCoroutine(Wait(CondInfo));
        conditionText.SetActive(false);

        yield return StartCoroutine(PosturalHold());
    }

    IEnumerator PosturalHold()
    {
        player.SetActive(false);
        postureText.SetActive(true);
        LabJack(LJ, 1, 0.5);                    // CODER POSTURE: 0.5                                                                                                                     
        location = 0.5;                                                                                                                 
        yield return StartCoroutine(Wait(PostHold));                            // Control *PostHold* seconds for postural hold                  
        postureText.SetActive(false);
        yield return StartCoroutine(RestHold());
    }

    IEnumerator RestHold()
    {
        player.SetActive(false);
        restText.SetActive(true);
        LabJack(LJ, 1, 0.2);                    // CODER REST: 0.2                                                                                                                   
        location = 0.2;                                                                                                                 
        yield return StartCoroutine(Wait(Rest));                            // Control *PostHold* seconds for rest                          
        restText.SetActive(false);
        yield return StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));
    }

    IEnumerator Posture(int numBlocks, bool flagpost, int repetition, int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
        player.SetActive(false);
        //balloonTOP1.SetActive(false);
        //balloonTOP2.SetActive(false);
        //balloonTOP3.SetActive(false);
        //balloonTOP4.SetActive(false);
        //balloonTOP5.SetActive(false);
        Randomize(direction, arraylist); // "Condition: .. Direction .. .."

        if (flagpost && numBlocks < 4)
        {
            postureText.SetActive(true);
            LabJack(LJ, 1, 0.5);                    // CODER POSTURE: 0.5
            location = 0.5;
            yield return StartCoroutine(Wait(PostStart));                             // Control *PostStart* seconds of posture
            postureText.SetActive(false);
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (numBlocks == 4)
        {
            for (int j = 0; j < Reaches+1; j++)
            {
                for (int i = 0; i < 6; i++)
                {
                    infotable.Write(InfoTable[j, i] + " ");
                }
                infotable.WriteLine();
            }
            infotable.Close();

            LabJack(LJ, 1, 0.0);                    // CODER BACK AT 0.
            location = 0.0;

            countText.SetActive(false);
            endText.SetActive(true);
            yield return StartCoroutine(Wait(3));   // Show end of trial text for 3 seconds.
            endText.SetActive(false);

            StopAllCoroutines();
            //UnityEditor.EditorApplication.isPlaying = false;
            Application.Quit();
        }
    }

    IEnumerator Reach(int repetition, int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
        countText.SetActive(true);
        //balloonTOP1.SetActive(true);
        //balloonTOP2.SetActive(true);
        //balloonTOP3.SetActive(true);
        //balloonTOP4.SetActive(true);
        //balloonTOP5.SetActive(true);

        if (repetition == 0)            // Different text for first reach than for rest of the reaches
        {
            flagpost = false;
            player.SetActive(false);
            firstpost.SetActive(true);          // FistPost = Hold this posture
            LabJack(LJ, 1, 1.0);                              // CODER REACH: 1.0        
            location = 1;
            yield return StartCoroutine(Wait(ReachWait));                           // Control 2.5 seconds of reach
            firstpost.SetActive(false);
            yield return StartCoroutine(MotorPrep(condition, direction, arraylist, arrowlist));
        }
        else if (repetition == ( part * BreakReaches) && repetition != Reaches)      // Have a small break of *breakwait* seconds after every *breakreaches* number of reaches
        {
            part++;
            flagpost = false;
            player.SetActive(false);
            breaktext.SetActive(true);
            LabJack(LJ, 1, 0.0);                              // CODER BREAK: 0.0        
            location = 0.0;
            yield return StartCoroutine(Wait(BreakWait));                   // This is the line that waits for 'breakwait' seconds
            breaktext.SetActive(false);                                     // Do another posturestart to make sure tremor really occurs before reaches resume!
            postureText.SetActive(true);
            LabJack(LJ, 1, 0.5);                              // CODER POSTURE: 0.5
            location = 0.5;
            yield return StartCoroutine(Wait(PostStart));                             // Control *PostStart* seconds of posture
            postureText.SetActive(false);
            firstpost.SetActive(true);              // FirstPost = Hold this posture
            LabJack(LJ, 1, 1.0);                              // CODER REACH: 1.0        
            location = 1;
            yield return StartCoroutine(Wait(ReachWait));                           // Control 2.5 seconds of reach
            firstpost.SetActive(false);
            yield return StartCoroutine(MotorPrep(condition, direction, arraylist, arrowlist)); yield return StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));
        }
        else if (repetition < Reaches)
        {
            flagpost = false;
            player.SetActive(false);
            reach.SetActive(true);              // Reach = BacktoPost
            LabJack(LJ, 1, 1.0);                              // CODER REACH: 1.0        
            location = 1;
            yield return StartCoroutine(Wait(ReachWait));                           // Control 2.5 seconds of reach
            reach.SetActive(false);
            yield return StartCoroutine(MotorPrep(condition, direction, arraylist, arrowlist));
        }
        else if (repetition == Reaches)
        {
            flagpost = true;
            print("Block: " + numBlocks + ", Amount of Popped Balloons: " + Collision.count + " out of 5");
            Collision.count = 0;
            countText.GetComponent<TMPro.TextMeshPro>().text = Collision.count.ToString();
            numBlocks++;
            repetition = 0;
            yield return StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));
        }
    }

    IEnumerator MotorPrep(int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
        print("Block: " + numBlocks + ", Condition: " + condition[numBlocks] + ". Direction of Repetition #" + repetition + ": " + direction[repetition]);

        InfoTable[repetition + 1, 0] = condition[numBlocks].ToString();
        InfoTable[repetition + 1, 1] = repetition.ToString();
        InfoTable[repetition + 1, 2] = direction[repetition].ToString();
        InfoTable[repetition + 1, 3] = "No";            // Default of balloon appeared: No
        InfoTable[repetition + 1, 4] = "No";            // Default of balloon popped:   No
        InfoTable[repetition + 1, 5] = 0.ToString();    // Default popping time:        0

        Arrowlist(condition, arraylist, sigma);

        ArrowAssigning(direction, arraylist, arrowlist);

        DirectionVariance(condition, arrowlist, arraylist);

        SetArrowLength(arrowlist);   // SetActive Arrows MOTORPREP and Sends LJ trigger of 1.5V!!

        yield return StartCoroutine(Wait(PrepWait));        // CONTROL 2.5 SECONDS OF MOTORPREP

        ArrowColor(1);              // ArrowColor set Arrows Green MOTOREXEC and Sends LJ trigger of 2.0V!!                                                

        float currenttime = Time.time;

        if (condition[numBlocks] < 5)           // GO AFTER YOU KNOW
        {
            delayflag = 1;
        }
        else if (condition[numBlocks] > 4)     // GO BEFORE YOU KNOW
        {
            yield return StartCoroutine(MotorDelay(currenttime));
        }

        if (delayflag == 1)
        {
            delayflag = 0;
            InfoTable[repetition + 1, 3] = "Yes";
            yield return StartCoroutine(MotorExec(condition, direction, arraylist, arrowlist));
        }
        if (delayflag == 2)
        {
            delayflag = 0;
            InfoTable[repetition + 1, 3] = "No";
            ArrowColor(2);                                                          // Setting arrow color back to black and SetActive false
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
    }

    IEnumerator MotorDelay(float currenttime)
    {
        if (dist < distance)    // dist (= z-coordinate of tracking) needs to be less than distance (= #cm from camera as set in Unity interface), because that means arm is moving towards the LeapMotion camera.
        {
            delayflag = 1;      // DO WE WANT A CODER FOR WHEN THEY ACTUALLY STARTED MOVING? IN CONDITION 3/4 THIS MOMENT IS PRACTICALLY THE SAME AS WHEN THE BALLOON APPEARS. IN CONDITION 1/2 NOT, BC BALLOON APPEARS BEFORE THEY START MOVING. 
        }
        else if (dist > distance && Time.time < currenttime + DelayWait)
        {
            yield return null;
            yield return StartCoroutine(MotorDelay(currenttime));
        }
        else if (dist > distance && Time.time >= currenttime + DelayWait)
        {
            delayflag = 2;
        }
    }

    IEnumerator MotorExec(int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
        player.SetActive(true);
        if (Visible == 0)
        {
            player.GetComponent<SpriteRenderer>().enabled = false;              // To make pointer invisible! -- Wait you never want pointer to be visible in reach right?! When going back to posture at least..
        }
        // BIG BALLOONS: condition 1/2/5/6 = LOW PRECISION required
        if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 1))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER FOR BALLOON APPEARANCE = START HOLD: 2.5
            location = 2.5;
            Collision.t = 0;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            balloonBIG.transform.position = new Vector2(2f, -0.15f);
            yield return StartCoroutine(Wait(HoldWait));                                    // CONTROL 4 SECONDS OF HOLD
            balloonBIG.SetActive(false);
            ArrowColor(2);                                                          // setting arrow color back to black and SetActive false
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 2))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            Collision.t = 0;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            balloonBIG.transform.position = new Vector2(1.5f, 1.35f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 3))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(0f, 2f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 4))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(-1.5f, 1.35f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 5))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(-2f, -0.15f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 6))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(-1.5f, -1.65f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 7))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(0f, -2f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 8))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(1.5f, -1.65f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }

        // SMALL BALLOONS: condition 3/4/7/8 = HIGH PRECISION required
        if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 1))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER FOR BALLOON APPEARANCE = START HOLD: 2.5
            location = 2.5;
            Collision.t = 0;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            balloonSMALL.transform.position = new Vector2(2f, -0.15f);
            yield return StartCoroutine(Wait(HoldWait));                                // CONTROL 4 SECONDS OF HOLD
            balloonSMALL.SetActive(false);
            ArrowColor(2);                                                          // setting arrow color back to black and SetActive false
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 2))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            Collision.t = 0;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            balloonSMALL.transform.position = new Vector2(1.5f, 1.35f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 3))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(0f, 2f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 4))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(-1.5f, 1.35f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 5))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(-2f, -0.15f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 6))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(-1.5f, -1.65f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 7))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(0f, -2f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 8))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                        // CODER HOLD: 2.5
            location = 2.5;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(1.5f, -1.65f);
            yield return StartCoroutine(Wait(HoldWait));
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
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
            float instantaneousFrameRate = frame.CurrentFramesPerSecond;    // both

            Hand hand = frame.Hands[h];

            // ARM DATA:
            Arm arm = hand.Arm;
            String armdescription = arm.ToString();
            Vector elbow = arm.ElbowPosition;               // data
            Vector wrist = arm.WristPosition;               // data
            Vector armcenter = arm.Center;                  // data
            Vector armdirection = arm.Direction;            // extradata
            LeapQuaternion armorientation = arm.Rotation;   // extradata
            float armlength = arm.Length;                   // extradata
            float armwidth = arm.Width;                     // extradata
            Vector armEnd = arm.NextJoint;
            Vector armStart = arm.PrevJoint;
            Bone.BoneType armtype = arm.Type;

            // HAND DATA:
            long frameID = hand.FrameId;                                    // both
            int handID = hand.Id;                                           // both                
            float handconfidence = hand.Confidence;                 // extradata
            float palmwidth = hand.PalmWidth;                   // data
            bool lefthand = hand.IsLeft;                            // extradata
            float handvisible = hand.TimeVisible;                   // extradata
            Vector wristposition = hand.WristPosition;          // data
            Vector palmposition = hand.PalmPosition;            // data
            Vector palmvelocity = hand.PalmVelocity;            // data
            Vector handdirection = hand.Direction;              // data
            Vector stabilizedpalmposition = hand.StabilizedPalmPosition; // data
            Vector palmnormal = hand.PalmNormal;                // extradata
            LeapQuaternion palmorientation = hand.Rotation;     // extradata

            // FINGER DATA:
            Finger thumb = hand.Fingers[0];
            int thumbId = thumb.Id;                          // extradata
            float thumbvisible = thumb.TimeVisible;          // extradata
            bool thumbextended = thumb.IsExtended;           // extradata
            float thumblength = thumb.Length;                // extradata
            float thumbwidth = thumb.Width;                  // extradata
            Vector thumbtipposition = thumb.TipPosition;     // extradata
            Vector thumbdirection = thumb.Direction;         // extradata

            Finger index = hand.Fingers[1];
            int indexId = index.Id;                         // both
            float indexvisible = index.TimeVisible;         // extradata
            bool indexextended = index.IsExtended;          // extradata    
            float indexlength = index.Length;               // extradata
            float indexwidth = index.Width;                 // extradata
            Vector indextipposition = index.TipPosition;    // data
            Vector indexdirection = index.Direction;        // extradata

            Finger middle = hand.Fingers[2];
            int middleId = middle.Id;                       // extradata
            float middlevisible = middle.TimeVisible;       // extradata
            bool middleextended = middle.IsExtended;        // extradata
            float middlelength = middle.Length;             // extradata
            float middlewidth = middle.Width;               // extradata
            Vector middletipposition = middle.TipPosition;  // extradata
            Vector middledirection = middle.Direction;      // extradata

            Finger ring = hand.Fingers[3];
            int ringId = ring.Id;                           // extradata
            float ringvisible = ring.TimeVisible;           // extradata
            bool ringextended = ring.IsExtended;            // extradata
            float ringlength = ring.Length;                 // extradata
            float ringwidth = ring.Width;                   // extradata
            Vector ringtipposition = ring.TipPosition;      // extradata
            Vector ringdirection = ring.Direction;          // extradata

            Finger pinky = hand.Fingers[4];
            int pinkyId = pinky.Id;                         // extradata
            float pinkyvisible = pinky.TimeVisible;         // extradata
            bool pinkyextended = pinky.IsExtended;          // extradata
            float pinkylength = pinky.Length;               // extradata
            float pinkywidth = pinky.Width;                 // extradata
            Vector pinkytipposition = pinky.TipPosition;    // extradata
            Vector pinkydirection = pinky.Direction;        // extradata


            // FINGERBONES: 
            Vector indexmetacarpal = index.bones[0].Center;
            Vector indexmetacarpaldirection = index.bones[0].Direction;
            Vector indexmetacarpalend = index.bones[0].NextJoint;
            Vector indexmetacarpalstart = index.bones[0].PrevJoint;
            LeapQuaternion indexmetacarpalrotation = index.bones[0].Rotation;
            float indexmetacarpallength = index.bones[0].Length;
            float indexmetacarpalwidth = index.bones[0].Width;
            Vector indexproximal = index.bones[1].Center;
            Vector indexproximaldirection = index.bones[1].Direction;
            Vector indexproximalend = index.bones[1].NextJoint;
            Vector indexproximalstart = index.bones[1].PrevJoint;
            LeapQuaternion indexproximalrotation = index.bones[1].Rotation;
            float indexproximallength = index.bones[1].Length;
            float indexproximalwidth = index.bones[1].Width;
            Vector indexintermediate = index.bones[2].Center;
            Vector indexintermediatedirection = index.bones[2].Direction;
            Vector indexintermediateend = index.bones[2].NextJoint;
            Vector indexintermediatestart = index.bones[2].PrevJoint;
            LeapQuaternion indexintermediaterotation = index.bones[2].Rotation;
            float indexintermediatelength = index.bones[2].Length;
            float indexintermediatewidth = index.bones[2].Width;
            Vector indexdistal = index.bones[3].Center;
            Vector indexdistaldirection = index.bones[3].Direction;
            Vector indexdistalend = index.bones[3].NextJoint;
            Vector indexdistalstart = index.bones[3].PrevJoint;
            LeapQuaternion indexdistalrotation = index.bones[3].Rotation;
            float indexdistallength = index.bones[3].Length;
            float indexdistalwidth = index.bones[3].Width;

            Vector middlemetacarpal = middle.bones[0].Center;
            Vector middlemetacarpaldirection = middle.bones[0].Direction;
            Vector middlemetacarpalend = middle.bones[0].NextJoint;
            Vector middlemetacarpalstart = middle.bones[0].PrevJoint;
            LeapQuaternion middlemetacarpalrotation = middle.bones[0].Rotation;
            float middlemetacarpallength = middle.bones[0].Length;
            float middlemetacarpalwidth = middle.bones[0].Width;
            Vector middleproximal = middle.bones[1].Center;
            Vector middleproximaldirection = middle.bones[1].Direction;
            Vector middleproximalend = middle.bones[1].NextJoint;
            Vector middleproximalstart = middle.bones[1].PrevJoint;
            LeapQuaternion middleproximalrotation = middle.bones[1].Rotation;
            float middleproximallength = middle.bones[1].Length;
            float middleproximalwidth = middle.bones[1].Width;
            Vector middleintermediate = middle.bones[2].Center;
            Vector middleintermediatedirection = middle.bones[2].Direction;
            Vector middleintermediateend = middle.bones[2].NextJoint;
            Vector middleintermediatestart = middle.bones[2].PrevJoint;
            LeapQuaternion middleintermediaterotation = middle.bones[2].Rotation;
            float middleintermediatelength = middle.bones[2].Length;
            float middleintermediatewidth = middle.bones[2].Width;
            Vector middledistal = middle.bones[3].Center;
            Vector middledistaldirection = middle.bones[3].Direction;
            Vector middledistalend = middle.bones[3].NextJoint;
            Vector middledistalstart = middle.bones[3].PrevJoint;
            LeapQuaternion middledistalrotation = middle.bones[3].Rotation;
            float middledistallength = middle.bones[3].Length;
            float middledistalwidth = middle.bones[3].Width;

            Vector ringmetacarpal = ring.bones[0].Center;
            Vector ringmetacarpaldirection = ring.bones[0].Direction;
            Vector ringmetacarpalend = ring.bones[0].NextJoint;
            Vector ringmetacarpalstart = ring.bones[0].PrevJoint;
            LeapQuaternion ringmetacarpalrotation = ring.bones[0].Rotation;
            float ringmetacarpallength = ring.bones[0].Length;
            float ringmetacarpalwidth = ring.bones[0].Width;
            Vector ringproximal = ring.bones[1].Center;
            Vector ringproximaldirection = ring.bones[1].Direction;
            Vector ringproximalend = ring.bones[1].NextJoint;
            Vector ringproximalstart = ring.bones[1].PrevJoint;
            LeapQuaternion ringproximalrotation = ring.bones[1].Rotation;
            float ringproximallength = ring.bones[1].Length;
            float ringproximalwidth = ring.bones[1].Width;
            Vector ringintermediate = ring.bones[2].Center;
            Vector ringintermediatedirection = ring.bones[2].Direction;
            Vector ringintermediateend = ring.bones[2].NextJoint;
            Vector ringintermediatestart = ring.bones[2].PrevJoint;
            LeapQuaternion ringintermediaterotation = ring.bones[2].Rotation;
            float ringintermediatelength = ring.bones[2].Length;
            float ringintermediatewidth = ring.bones[2].Width;
            Vector ringdistal = ring.bones[3].Center;
            Vector ringdistaldirection = ring.bones[3].Direction;
            Vector ringdistalend = ring.bones[3].NextJoint;
            Vector ringdistalstart = ring.bones[3].PrevJoint;
            LeapQuaternion ringdistalrotation = ring.bones[3].Rotation;
            float ringdistallength = ring.bones[3].Length;
            float ringdistalwidth = ring.bones[3].Width;

            Vector pinkymetacarpal = pinky.bones[0].Center;
            Vector pinkymetacarpaldirection = pinky.bones[0].Direction;
            Vector pinkymetacarpalend = pinky.bones[0].NextJoint;
            Vector pinkymetacarpalstart = pinky.bones[0].PrevJoint;
            LeapQuaternion pinkymetacarpalrotation = pinky.bones[0].Rotation;
            float pinkymetacarpallength = pinky.bones[0].Length;
            float pinkymetacarpalwidth = pinky.bones[0].Width;
            Vector pinkyproximal = pinky.bones[1].Center;
            Vector pinkyproximaldirection = pinky.bones[1].Direction;
            Vector pinkyproximalend = pinky.bones[1].NextJoint;
            Vector pinkyproximalstart = pinky.bones[1].PrevJoint;
            LeapQuaternion pinkyproximalrotation = pinky.bones[1].Rotation;
            float pinkyproximallength = pinky.bones[1].Length;
            float pinkyproximalwidth = pinky.bones[1].Width;
            Vector pinkyintermediate = pinky.bones[2].Center;
            Vector pinkyintermediatedirection = pinky.bones[2].Direction;
            Vector pinkyintermediateend = pinky.bones[2].NextJoint;
            Vector pinkyintermediatestart = pinky.bones[2].PrevJoint;
            LeapQuaternion pinkyintermediaterotation = pinky.bones[2].Rotation;
            float pinkyintermediatelength = pinky.bones[2].Length;
            float pinkyintermediatewidth = pinky.bones[2].Width;
            Vector pinkydistal = pinky.bones[3].Center;
            Vector pinkydistaldirection = pinky.bones[3].Direction;
            Vector pinkydistalend = pinky.bones[3].NextJoint;
            Vector pinkydistalstart = pinky.bones[3].PrevJoint;
            LeapQuaternion pinkydistalrotation = pinky.bones[3].Rotation;
            float pinkydistallength = pinky.bones[3].Length;
            float pinkydistalwidth = pinky.bones[3].Width;

            Vector thumbmetacarpal = thumb.bones[0].Center;
            Vector thumbmetacarpaldirection = thumb.bones[0].Direction;
            Vector thumbmetacarpalend = thumb.bones[0].NextJoint;
            Vector thumbmetacarpalstart = thumb.bones[0].PrevJoint;
            LeapQuaternion thumbmetacarpalrotation = thumb.bones[0].Rotation;
            float thumbmetacarpallength = thumb.bones[0].Length;
            float thumbmetacarpalwidth = thumb.bones[0].Width;
            Vector thumbproximal = thumb.bones[1].Center;
            Vector thumbproximaldirection = thumb.bones[1].Direction;
            Vector thumbproximalend = thumb.bones[1].NextJoint;
            Vector thumbproximalstart = thumb.bones[1].PrevJoint;
            LeapQuaternion thumbproximalrotation = thumb.bones[1].Rotation;
            float thumbproximallength = thumb.bones[1].Length;
            float thumbproximalwidth = thumb.bones[1].Width;
            Vector thumbintermediate = thumb.bones[2].Center;
            Vector thumbintermediatedirection = thumb.bones[2].Direction;
            Vector thumbintermediateend = thumb.bones[2].NextJoint;
            Vector thumbintermediatestart = thumb.bones[2].PrevJoint;
            LeapQuaternion thumbintermediaterotation = thumb.bones[2].Rotation;
            float thumbintermediatelength = thumb.bones[2].Length;
            float thumbintermediatewidth = thumb.bones[2].Width;
            Vector thumbdistal = thumb.bones[3].Center;
            Vector thumbdistaldirection = thumb.bones[3].Direction;
            Vector thumbdistalend = thumb.bones[3].NextJoint;
            Vector thumbdistalstart = thumb.bones[3].PrevJoint;
            LeapQuaternion thumbdistalrotation = thumb.bones[3].Rotation;
            float thumbdistallength = thumb.bones[3].Length;
            float thumbdistalwidth = thumb.bones[3].Width;

            if (Tracking == 0)
            {
                // Tracking finger for task:
                trackingx = indextipposition.x;
                trackingy = indextipposition.y;
                trackingz = indextipposition.z;
            }
            else if (Tracking == 1)
            {
                // Tracking palmposition for task:
                trackingx = palmposition.x;
                trackingy = palmposition.y;
                trackingz = palmposition.z;
            }
            else if (Tracking == 2)
            {
                // Tracking stabilizedpalmposition for task:
                trackingx = stabilizedpalmposition.x;
                trackingy = stabilizedpalmposition.y;
                trackingz = stabilizedpalmposition.z;
            }

            newpositionx = ((trackingx - XKey[0]) * XKey[1]) + XKey[2];
            newpositiony = ((trackingy - YKey[0]) * YKey[1]) + YKey[2];

            player.transform.position = new Vector2(newpositionx, newpositiony);

            // IF OFFSET IS STILL NEEDED FOR MOUSE DRAG:
            //LeapScreen = new Vector3(newpositionx, newpositiony, newpositionz);
            //mOffset = player.transform.position - LeapScreen;
            //player.transform.position = new Vector2(newpositionx, newpositiony) + new Vector2(LeapScreen.x, LeapScreen.y);

            //Calculate the z-distance between the hand and LeapMotion camera for GBYK-conditions:
            dist = trackingz;

            // Rescale LeapMotion to Volt-compatable for LabJack:
            double V2 = ((trackingx + 600) / (600 + 600)) * 3;
            double V3 = ((trackingy - 0) / (900 - 0)) * 3;
            double V4 = ((trackingz + 550) / (650 + 550)) * 3;

            if (Tick == 1)
            {
                // FOR THE LABJACK TICK:
                //// DAC1 = LeapX : 
                LabJack(LJ, 2, V2);
                ////// DACA = LeapY :
                LabJack(LJ, 3, V3);
                ////// DACB = LeapZ :
                LabJack(LJ, 4, V4);
            }

            Vector tracking = new Vector(trackingx, trackingy, trackingz);
            if (tracking.IsValid())
            {
                data.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17}",location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), frameID.ToString(), handID.ToString(), newpositionx.ToString(), newpositiony.ToString(), elbow.x.ToString(), elbow.y.ToString(), elbow.z.ToString(), armcenter.x.ToString(), armcenter.y.ToString(), armcenter.z.ToString(), wrist.x.ToString(), wrist.y.ToString(), wrist.z.ToString(), wristposition.x.ToString(), wristposition.y.ToString(), wristposition.z.ToString(), palmwidth.ToString(), palmposition.x.ToString(), palmposition.y.ToString(), palmposition.z.ToString(), palmvelocity.x.ToString(), palmvelocity.y.ToString(), palmvelocity.z.ToString(), handdirection.x.ToString(), handdirection.y.ToString(), handdirection.z.ToString(), stabilizedpalmposition.x.ToString(), stabilizedpalmposition.y.ToString(), stabilizedpalmposition.z.ToString(), indexId.ToString(), indextipposition.x.ToString(), indextipposition.y.ToString(), indextipposition.z.ToString());
                extradata.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17},{36,-17},{37,-17},{38,-17},{39,-17},{40,-17},{41,-17},{42,-17},{43,-17},{44,-17},{45,-17},{46,-17},{47,-17},{48,-17},{49,-17},{50,-17},{51,-17},{52,-17},{53,-17},{54,-17},{55,-17},{56,-17},{57,-17},{58,-17},{59,-17},{60,-17},{61,-17},{62,-17},{63,-17},{64,-17},{65,-17},{66,-17},{67,-17},{68,-17},{69,-17},{70,-17},{71,-17},{72,-17},{73,-17}", location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), frameID.ToString(), handID.ToString(), handconfidence.ToString(), lefthand.ToString(), handvisible.ToString(), armdirection.x.ToString(), armdirection.y.ToString(), armdirection.z.ToString(), armorientation.x.ToString(), armorientation.y.ToString(), armorientation.z.ToString(), armlength.ToString(), armwidth.ToString(), palmnormal.x.ToString(), palmnormal.y.ToString(), palmnormal.z.ToString(), palmorientation.x.ToString(), palmorientation.y.ToString(), palmorientation.z.ToString(), thumbId.ToString(), thumbvisible.ToString(), thumbextended.ToString(), thumblength.ToString(), thumbwidth.ToString(), thumbtipposition.x.ToString(), thumbtipposition.y.ToString(), thumbtipposition.z.ToString(), thumbdirection.x.ToString(), thumbdirection.y.ToString(), thumbdirection.z.ToString(), indexId.ToString(), indexvisible.ToString(), indexextended.ToString(), indexlength.ToString(), indexwidth.ToString(), indexdirection.x.ToString(), indexdirection.y.ToString(), indexdirection.z.ToString(), middleId.ToString(), middlevisible.ToString(), middleextended.ToString(), middlelength.ToString(), middlewidth.ToString(), middletipposition.x.ToString(), middletipposition.y.ToString(), middletipposition.z.ToString(), middledirection.x.ToString(), middledirection.y.ToString(), middledirection.z.ToString(), ringId.ToString(), ringvisible.ToString(), ringextended.ToString(), ringlength.ToString(), ringwidth.ToString(), ringtipposition.x.ToString(), ringtipposition.y.ToString(), ringtipposition.z.ToString(), ringdirection.x.ToString(), ringdirection.y.ToString(), ringdirection.z.ToString(), pinkyId.ToString(), pinkyvisible.ToString(), pinkyextended.ToString(), pinkylength.ToString(), pinkywidth.ToString(), pinkytipposition.x.ToString(), pinkytipposition.y.ToString(), pinkytipposition.z.ToString(), pinkydirection.x.ToString(), pinkydirection.y.ToString(), pinkydirection.z.ToString());

            }
        }

        if (repetition == Reaches)
        {
            repetition = 0;
        }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (Time.timeScale == 1)
            {
                labjackvalue = location;
                Time.timeScale = 0;
                pauseText.SetActive(true);
                if (pauseflag == 0)
                {
                    LabJack(LJ, 1, 0);
                    location = 0.0;
                    pauseflag = 1;
                }
            }
            else if (Time.timeScale == 0)
            {
                Time.timeScale = 1;
                pauseText.SetActive(false);
                if (pauseflag == 1)
                {
                    LabJack(LJ, 1, labjackvalue);
                    location = labjackvalue;
                    pauseflag = 0;
                }
            }
        }

        //if (repetition == 0)
        //{
        //    _rendererScore = balloonTOP1.GetComponent<Renderer>();
        //}
        //else if (repetition == 1)
        //{
        //    _rendererScore = balloonTOP2.GetComponent<Renderer>();
        //}
        //else if (repetition == 2)
        //{
        //    _rendererScore = balloonTOP3.GetComponent<Renderer>();
        //}
        //else if (repetition == 3)
        //{
        //    _rendererScore = balloonTOP4.GetComponent<Renderer>();
        //}
        //else if (repetition == 4)
        //{
        //    _rendererScore = balloonTOP5.GetComponent<Renderer>();
        //}

    }

    // FROM HERE VOIDS FOR THE COROUTINES:
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

    // Void for Randomizing Condition 
    void ShuffleArray(int[] a)
    {
        print("Order of Conditions: ");
        System.Random randNum = new System.Random();
        for (int i = 0; i < a.Length; i++)
        {
            Swap(a, i, i + randNum.Next(a.Length - i));
            print(" " + a[i]);
        }
    }
    void Swap(int[] arr, int a, int b)
    {
        int temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }

    // Void to Randomize direction 
    void Randomize(int[] direction, double[] arraylist)
    {
        print("Directions of Block " + numBlocks + ":");
        System.Random randNum = new System.Random();
        for (int i = 0; i < direction.Length; i++)
        {
            int number = randNum.Next(1, arraylist.Length);
            direction[i] = number;
            print(" " + direction[i]);
        }
    }

    // NEW ONE:
    void Arrowlist(int[] condition, double[] arraylist, double sigma)
    {
        double min = 0.40;
        double max = 1.60;
        double total = 9.0;
        double currentsum = 0;
        double low, high, calc;

        if (condition[numBlocks] == 1 || condition[numBlocks] == 3 || condition[numBlocks] == 5 || condition[numBlocks] == 7)                     // LOW UNCERTAINTY in variance of arrow length
        {
            sigma = 1;
        }
        else if (condition[numBlocks] == 2 || condition[numBlocks] == 4 || condition[numBlocks] == 6 || condition[numBlocks] == 8)                // HIGH UNCERTAINTY in variance of arrow length
        {
            sigma = 1;
        }

        System.Random rand = new System.Random();
        for (int index = 0; index < arraylist.Length; index++)
        {
            calc = (total - currentsum) - (max * (arraylist.Length - 1 - index));
            low = calc < min ? min : calc;
            calc = (total - currentsum) - (min * (arraylist.Length - 1 - index));
            high = calc > max ? max : calc;

            // These values add up to 9 but are not normally distributed AND I can't control for variance.. mweeehhh
            arraylist[index] = Math.Abs(rand.NextDouble()) * (high - low) + low;
            // This would be another option, but can't get that working..:
            // "(abs(random() - random()) * (1 + max - min) + min) --> Gives you a random number between min and max, with outputs closer to min being more common, falling off linearly toward the max."

            currentsum += arraylist[index];
        }
        Array.Sort(arraylist);
    }

    // ORIGINAL ONE:
    //void Arrowlist(int[] condition, double[] arraylist)
    //{
    //    System.Random rand = new System.Random();
    //    if (condition[numBlocks] == 1 || condition[numBlocks] == 3 || condition[numBlocks] == 5 || condition[numBlocks] == 7)                     // LOW UNCERTAINTY in variance of arrow length
    //    {
    //        double sigma = 0.5;
    //        for (int i = 0; i < arraylist.Length; i++)
    //        {
    //            double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
    //            double u2 = 1.0 - rand.NextDouble();
    //            double randSigmaNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
    //                         Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
    //            double randSigNormal =
    //                         1.1 + sigma * randSigmaNormal; //random normal(mean,stdDev^2)
    //            arraylist[i] = Math.Abs(randSigNormal);
    //        }
    //    }
    //    else if (condition[numBlocks] == 2 || condition[numBlocks] == 4 || condition[numBlocks] == 6 || condition[numBlocks] == 8)                // HIGH UNCERTAINTY in variance of arrow length
    //    {
    //        double sigma = 0.3;
    //        for (int i = 0; i < arraylist.Length; i++)
    //        {
    //            double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
    //            double u2 = 1.0 - rand.NextDouble();
    //            double randSigmaNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
    //                         Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
    //            double randSigNormal =
    //                         1 + sigma * randSigmaNormal; //random normal(mean,stdDev^2)
    //            arraylist[i] = Math.Abs(randSigNormal);
    //        }
    //    }
    //    Array.Sort(arraylist);
    //    using (StreamWriter array = new StreamWriter(conditionPath + @"\Arraylist.txt"))
    //    {
    //        foreach (var x in arraylist)
    //        {
    //            array.WriteLine(x);
    //        }
    //    }
    //    print("arraylist saved");
    //}

    // COMBINATION NOT WORKING:
    //void Arrowlist(int[] condition, double[] arraylist, double sigma)
    //{
    //    double min = 0.35;
    //    double max = 1.75;
    //    double total = 8.5;
    //    double currentsum = 0;
    //    double low, high, calc;

    //    if (condition[numBlocks] == 1 || condition[numBlocks] == 3 || condition[numBlocks] == 5 || condition[numBlocks] == 7)                     // LOW UNCERTAINTY in variance of arrow length
    //    {
    //        sigma = 0.5;
    //    }
    //    else if (condition[numBlocks] == 2 || condition[numBlocks] == 4 || condition[numBlocks] == 6 || condition[numBlocks] == 8)                // HIGH UNCERTAINTY in variance of arrow length
    //    {
    //        sigma = 0.3;
    //    }

    //    System.Random rand = new System.Random();

    //    for (int i = 0; i < arraylist.Length; i++)
    //    {
    //        double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
    //        double u2 = 1.0 - rand.NextDouble();
    //        double randSigmaNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
    //                     Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
    //        double randSigNormal =
    //                     1.1 + sigma * randSigmaNormal; //random normal(mean,stdDev^2)

    //        calc = (total - currentsum) - (max * (arraylist.Length - 1 - i));
    //        low = calc < min ? min : calc;
    //        calc = (total - currentsum) - (min * (arraylist.Length - 1 - i));
    //        high = calc > max ? max : calc;

    //        //arraylist[i] = Math.Abs(randSigNormal * (1 + high - low) + low);
    //        arraylist[i] = Math.Abs(randSigNormal * (high - low) + high);

    //        currentsum += arraylist[i];
    //    }

    //    Array.Sort(arraylist);
    //    print(currentsum);
    //    using (StreamWriter array = new StreamWriter(conditionPath + @"\Arraylist.txt"))
    //    {
    //        foreach (var x in arraylist)
    //        {
    //            array.WriteLine(x);
    //        }
    //    }
    //    print("arraylist saved");
    //}

    void ArrowAssigning(int[] direction, double[] arraylist, double[] arrowlist)
    {
        if (direction[repetition] == 1)
        {
            arrowlist[0] = arraylist[7];
            arrowlist[1] = arraylist[6];
            arrowlist[2] = arraylist[4];
            arrowlist[3] = arraylist[2];
            arrowlist[4] = arraylist[0];
            arrowlist[5] = arraylist[1];
            arrowlist[6] = arraylist[3];
            arrowlist[7] = arraylist[5];
        }
        if (direction[repetition] == 2)
        {
            arrowlist[1] = arraylist[7];
            arrowlist[2] = arraylist[6];
            arrowlist[3] = arraylist[4];
            arrowlist[4] = arraylist[2];
            arrowlist[5] = arraylist[0];
            arrowlist[6] = arraylist[1];
            arrowlist[7] = arraylist[3];
            arrowlist[0] = arraylist[5];
        }
        if (direction[repetition] == 3)
        {
            arrowlist[2] = arraylist[7];
            arrowlist[3] = arraylist[6];
            arrowlist[4] = arraylist[4];
            arrowlist[5] = arraylist[2];
            arrowlist[6] = arraylist[0];
            arrowlist[7] = arraylist[1];
            arrowlist[0] = arraylist[3];
            arrowlist[1] = arraylist[5];
        }
        if (direction[repetition] == 4)
        {
            arrowlist[3] = arraylist[7];  // direction 4 = arraynumber 3
            arrowlist[4] = arraylist[6];
            arrowlist[5] = arraylist[4];
            arrowlist[6] = arraylist[2];
            arrowlist[7] = arraylist[0];
            arrowlist[0] = arraylist[1];
            arrowlist[1] = arraylist[3];
            arrowlist[2] = arraylist[5];
        }
        if (direction[repetition] == 5)
        {
            arrowlist[4] = arraylist[7];
            arrowlist[5] = arraylist[6];
            arrowlist[6] = arraylist[4];
            arrowlist[7] = arraylist[2];
            arrowlist[0] = arraylist[0];
            arrowlist[1] = arraylist[1];
            arrowlist[2] = arraylist[3];
            arrowlist[3] = arraylist[5];
        }
        if (direction[repetition] == 6)
        {
            arrowlist[5] = arraylist[7];
            arrowlist[6] = arraylist[6];
            arrowlist[7] = arraylist[4];
            arrowlist[0] = arraylist[2];
            arrowlist[1] = arraylist[0];
            arrowlist[2] = arraylist[1];
            arrowlist[3] = arraylist[3];
            arrowlist[4] = arraylist[5];
        }
        if (direction[repetition] == 7)
        {
            arrowlist[6] = arraylist[7];
            arrowlist[7] = arraylist[6];
            arrowlist[0] = arraylist[4];
            arrowlist[1] = arraylist[2];
            arrowlist[2] = arraylist[0];
            arrowlist[3] = arraylist[1];
            arrowlist[4] = arraylist[3];
            arrowlist[5] = arraylist[5];
        }
        if (direction[repetition] == 8)
        {
            arrowlist[7] = arraylist[7];
            arrowlist[6] = arraylist[6];
            arrowlist[5] = arraylist[4];
            arrowlist[4] = arraylist[2];
            arrowlist[3] = arraylist[0];
            arrowlist[2] = arraylist[1];
            arrowlist[2] = arraylist[3];
            arrowlist[1] = arraylist[5];
        }
    }

    void DirectionVariance(int[] condition, double[] arrowlist, double[] arraylist)
    {
        System.Random rand = new System.Random();
        if (condition[numBlocks] == 1 || condition[numBlocks] == 3 || condition[numBlocks] == 5 || condition[numBlocks] == 7)                 // LOW UNCERTAINTY of variance in direction
        {
            double std = 0.2;
            for (int i = 0; i < arrowlist.Length; i++)
            {
                double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
                double u2 = 1.0 - rand.NextDouble();
                double randSigmaNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
                             Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
                arrowlist[i] =
                             Math.Abs(arrowlist[i] + std * randSigmaNormal); //random normal(mean,stdDev^2)
            }
        }
        if (condition[numBlocks] == 2 || condition[numBlocks] == 4 || condition[numBlocks] == 6 || condition[numBlocks] == 8)                 // HIGH UNCERTAINTY of variance in direction
        {
            double std = 0.55;
            for (int i = 0; i < arrowlist.Length; i++)
            {
                double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
                double u2 = 1.0 - rand.NextDouble();
                double randSigmaNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
                             Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
                arrowlist[i] =
                             Math.Abs(arrowlist[i] + std * randSigmaNormal); //random normal(mean,stdDev^2)
            }
        }
    }

    void SetArrowLength(double[] arrowlist)
    {
        arrow1.SetActive(true);
        arrow2.SetActive(true);
        arrow3.SetActive(true);
        arrow4.SetActive(true);
        arrow5.SetActive(true);
        arrow6.SetActive(true);
        arrow7.SetActive(true);
        arrow8.SetActive(true);

        LabJack(LJ, 1, 1.5);                                        // CODER MOTORPREP, BLACK ARROW APPEARANCE: 1.5
        location = 1.5;

        float arrowlist0 = Convert.ToSingle(arrowlist[0]);
        arrow1.transform.localScale = new Vector3(1, arrowlist0, 1);

        float arrowlist1 = Convert.ToSingle(arrowlist[1]);
        arrow2.transform.localScale = new Vector3(1, arrowlist1, 1);

        float arrowlist2 = Convert.ToSingle(arrowlist[2]);
        arrow3.transform.localScale = new Vector3(1, arrowlist2, 1);

        float arrowlist3 = Convert.ToSingle(arrowlist[3]);
        arrow4.transform.localScale = new Vector3(1, arrowlist3, 1);

        float arrowlist4 = Convert.ToSingle(arrowlist[4]);
        arrow5.transform.localScale = new Vector3(1, arrowlist4, 1);

        float arrowlist5 = Convert.ToSingle(arrowlist[5]);
        arrow6.transform.localScale = new Vector3(1, arrowlist5, 1);

        float arrowlist6 = Convert.ToSingle(arrowlist[6]);
        arrow7.transform.localScale = new Vector3(1, arrowlist6, 1);

        float arrowlist7 = Convert.ToSingle(arrowlist[7]);
        arrow8.transform.localScale = new Vector3(1, arrowlist7, 1);
    }

    void ArrowColor(int stage)      // Stage 1 = Go Signal // Stage 2 = Back to Black and disappear to Reach
    {
        if (stage == 1)
        {
            MeshRenderer arrow1Renderer = arrow1.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow2Renderer = arrow2.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow3Renderer = arrow3.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow4Renderer = arrow4.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow5Renderer = arrow5.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow6Renderer = arrow6.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow7Renderer = arrow7.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow8Renderer = arrow8.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow1Renderer1 = arrow1.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow2Renderer1 = arrow2.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow3Renderer1 = arrow3.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow4Renderer1 = arrow4.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow5Renderer1 = arrow5.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow6Renderer1 = arrow6.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow7Renderer1 = arrow7.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow8Renderer1 = arrow8.GetComponentsInChildren<MeshRenderer>()[1];
            arrow1Renderer.material.color = Color.green;
            arrow2Renderer.material.color = Color.green;
            arrow3Renderer.material.color = Color.green;
            arrow4Renderer.material.color = Color.green;
            arrow5Renderer.material.color = Color.green;
            arrow6Renderer.material.color = Color.green;
            arrow7Renderer.material.color = Color.green;
            arrow8Renderer.material.color = Color.green;
            arrow1Renderer1.material.color = Color.green;
            arrow2Renderer1.material.color = Color.green;
            arrow3Renderer1.material.color = Color.green;
            arrow4Renderer1.material.color = Color.green;
            arrow5Renderer1.material.color = Color.green;
            arrow6Renderer1.material.color = Color.green;
            arrow7Renderer1.material.color = Color.green;
            arrow8Renderer1.material.color = Color.green;
            player.SetActive(true);
            LabJack(LJ, 1, 2.0);                                // CODER MOTOREXEC: 2.0
            location = 2;
        }

        if (stage == 2)
        {
            MeshRenderer arrow1Renderer = arrow1.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow2Renderer = arrow2.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow3Renderer = arrow3.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow4Renderer = arrow4.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow5Renderer = arrow5.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow6Renderer = arrow6.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow7Renderer = arrow7.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow8Renderer = arrow8.GetComponentsInChildren<MeshRenderer>()[0];
            MeshRenderer arrow1Renderer1 = arrow1.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow2Renderer1 = arrow2.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow3Renderer1 = arrow3.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow4Renderer1 = arrow4.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow5Renderer1 = arrow5.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow6Renderer1 = arrow6.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow7Renderer1 = arrow7.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow8Renderer1 = arrow8.GetComponentsInChildren<MeshRenderer>()[1];
            arrow1Renderer.material.color = Color.black;
            arrow2Renderer.material.color = Color.black;
            arrow3Renderer.material.color = Color.black;
            arrow4Renderer.material.color = Color.black;
            arrow5Renderer.material.color = Color.black;
            arrow6Renderer.material.color = Color.black;
            arrow7Renderer.material.color = Color.black;
            arrow8Renderer.material.color = Color.black;
            arrow1Renderer1.material.color = Color.black;
            arrow2Renderer1.material.color = Color.black;
            arrow3Renderer1.material.color = Color.black;
            arrow4Renderer1.material.color = Color.black;
            arrow5Renderer1.material.color = Color.black;
            arrow6Renderer1.material.color = Color.black;
            arrow7Renderer1.material.color = Color.black;
            arrow8Renderer1.material.color = Color.black;
            arrow1.SetActive(false);
            arrow2.SetActive(false);
            arrow3.SetActive(false);
            arrow4.SetActive(false);
            arrow5.SetActive(false);
            arrow6.SetActive(false);
            arrow7.SetActive(false);
            arrow8.SetActive(false);

            player.SetActive(false);
        }
    }
}
