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
    // Create paths to save data and get the currid and keys:
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

    // Get variables that were set at Matlab configuration:
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

    // GameObjects to show in the game:
    public GameObject player;               // This is the red small pointer
    public GameObject Canvas;               // This is the canvas in which all text is shown 
    public GameObject countText;            // This is the counter at top left                                                              --> set in collision script    
    public GameObject countspark;           // This is the spark when counter changes value
    public GameObject conditionText;        // This is the text shown at the beginning which provides information about the condition       --> set in this script below
    public GameObject postureText;          // This is the text shown when 60 seconds postural hold has to be performed                     --> set in unity interface
    public GameObject restText;             // This is the text shown when 60 seconds of rest has to be performed                           --> set in unity interface
    public GameObject pauseText;            // This is the test shown when the game is paused by pressing space bar                         --> set in unity interface

    public GameObject breaktext;            // This is the text shown when a small break is happening between reaches                       --> set in unity interface
    public GameObject reach;                // This is the text shown when subjects have to go back to posture and prepare for next reach   --> set in unity interface
    public GameObject firstpost;            // This is the text shown when the first posture after the 60 seconds of rest has to be performed--> set in unity interface
    public GameObject endText;              // This is the text shown when the trial is finished                                            --> set in unity interface

    public GameObject arrow1;               // These are all the 8 arrows. This is the reason why it's not possible to change the amount of directions ....to be continued at all the voids that determine the lengths of the arrows....
    public GameObject arrow2;
    public GameObject arrow3;
    public GameObject arrow4;
    public GameObject arrow5;
    public GameObject arrow6;
    public GameObject arrow7;
    public GameObject arrow8;

    public GameObject balloonBIG;           // This is the big balloon gameobject (LOW precision)
    public GameObject balloonSMALL;         // This is the small balloon gameobject (HIGH precision)
    public GameObject animBIG;              // This is the animation (spark) when big balloon is popped
    public GameObject animSMALL;            // This is the animation (spark) when small balloon is popped

    // These balloons are NOT used!! (Where the 5 balloons at the top that showed how many reaches were done still yet to come and whether they were succesfully popped or not etc)
    public GameObject balloonTOP1;
    public GameObject balloonTOP2;
    public GameObject balloonTOP3;
    public GameObject balloonTOP4;
    public GameObject balloonTOP5;
    public static Renderer _rendererScore;      // Was used to adjust the colour of the topballoon as much as the balloon changed colour during the reach 

    // IF OFFSET IS STILL NEEDED FOR MOUSE DRAG:
    //private Vector3 mOffset;
    //private Vector3 LeapScreen;

    // Create variables for GBYK: 
    public float dist;              // This is the current LeapMotion z-coordinate of the tracking item
    public float distance;          // This is the value of z-coordinate that the tracking item has to exceed before the balloon is showed

    // LABJACK:
    private U3 u3;      // Create an LabJack instance
    double pinNum = 4;  // 4 means the LJTick-DAC is connected to FIO4/FIO5.
    
    public static int[] condition = { cond, cond, cond, cond};  // This integer array used to store the conditions that were randomly determined (4 conditions over 4 blocks). Now it stores the same condition (as allocated in configuration file) 4 times. It was easier to do it like this, than to change the variable to a normal int in stead of an array int. WEAK SPOT
    public static int[] direction = new int[Reaches];           // Create array that will store at which (random) direction the balloon will appear and is therefore of equal size as the total amount of reaches 
    public static int numBlocks = 3;                            // Like I said at 'condition', I used to have 4 blocks, and inumerate through them. Now I set number of blocks to 3, so that only 1 block is performed until task finishes
    public static int repetition;                               // Variable that will store at which repetition (which reach number) the subject is
    public static int part = 1;                                 // Variable that controls when a multiply of 'breakreaches' is reached, so that a new break will be introduced
    public static string gosign;                                // String that will show whether the condition will be a GBYK or GAYK
    public static string certainty;                             // String that will show whether the condition contains HIGH or LOW certainty
    public static string precision;                             // String that will show whether the condition requires HIGH or LOW precision

    // Create lists needed for determining the lengths of the arrows later. 8 directions, so 8 arrows, so arrays of size 8:                 WEAK SPOT
    public static double[] arraylist = new double[8];
    public static double[] arrowlist = new double[8];
    public static double sigma = 0;

    private bool flagpost = true;           // Needed to make sure postural hold is only done once at start of new set of reaches
    private int delayflag = 0;              // Needed to apply GBYK
    private int pauseflag = 0;              // Needed to give coder 0 when game is paused

    public static double location = 0;      // Initiate coder on 0. Maybe not so clear, but location is used to control what value (coder) goes into the LabJack!
    public static double labjackvalue = 0;  // Initiate at 0, but used to set coder back to the value it was before pausing the game
    static float trackingx = 0f;            // Initiate value of LeapMotion x-coordinate at 0
    static float trackingy = 0f;            // Initiate value of LeapMotion y-coordinate at 0
    static float trackingz = 0f;            // Initiate value of LeapMotion z-coordinate at 0
    static float newpositionx = 0f;         // Initiate value of Screen x-coordinate at 0
    static float newpositiony = 0f;         // Initiate value of Screen y-coordinate at 0
    static float newpositionz = 0f;         // Initiate value of Screen z-coordinate at 0

    // Table for documentation of information about the reaches. Six information things, and length of amount of reaches + 1 for the titles of the columns:
    public static string[,] InfoTable = new string[Reaches+1, 6];

    // Create textfile for data:
    public static TextWriter infotable = null;
    public static TextWriter code = null;
    public static TextWriter time = null;
    public static TextWriter data = null;
    public static TextWriter extradata = null;

    // Everything located in Start void happens when the game is started:
    void Start()
    {
        // The z-coordinate that the hand has to exceed for the GBYK conditions:
        distance = Distance;

        // For if we would like to adjust the size of the balloons to correct for how difficult every subject separately perceives the task:
        //balloonBIG.transform.localScale = new Vector3(BalloonSize, BalloonSize, BalloonSize);      // 20 is BIG, 10 is SMALL

        // Get the three values of the key text files into an key-array
        for (int l = 0; l < 3; l++)
        {
            XKey[l] = float.Parse(xkey[l]);
            YKey[l] = float.Parse(ykey[l]);
        }

        if (LJ == 1)        // As stated in configuration (LabJack attached or not)
        {
            //Open the first found LabJack U3.
            u3 = new U3(LJUD.CONNECTION.USB, "0", true); // Connection through USB
            u3.u3Config();

            //Start by using the pin_configuration_reset IOType so that all
            //pin assignments are in the factory default condition.
            LJUD.ePut(u3.ljhandle, LJUD.IO.PIN_CONFIGURATION_RESET, 0, 0, 0);

            if (Tick == 1)      // As stated in configuration (tick attached or not)
            {
                //Specify where the LJTick-DAC is plugged in. pinNum = 4 means the LJTick-DAC is connected to FIO4/FIO5.
                LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_CONFIG, LJUD.CHANNEL.TDAC_SCL_PIN_NUM, pinNum, 0);
            }
        }

        // For when the conditions still had to be shuffled in this script (and was not already done in Matlab):
        ShuffleArray(condition);        

        // Give the first row of the information table the titles of the columns:
        InfoTable[0, 0] = "Condition";
        InfoTable[0, 1] = "Repetition";
        InfoTable[0, 2] = "Direction";
        InfoTable[0, 3] = "Balloon Appeared?";
        InfoTable[0, 4] = "Balloon Popped?";
        InfoTable[0, 5] = "Time of Popping";

        // Create a path for this specific condition (using currid):
        Directory.CreateDirectory(conditionPath);

        // Open the text files:
        infotable = new StreamWriter(conditionPath + @"\InfoTable.txt");
        code = new StreamWriter(conditionPath + @"\Coder.txt");
        time = new StreamWriter(conditionPath + @"\Timer.txt");
        data = new StreamWriter(conditionPath + @"\Data.txt");
        extradata = new StreamWriter(conditionPath + @"\ExtraData.txt");

        // Write the first line to the text files (titles of the columns):
        data.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17}", "Coder", "Timer", "FrameRate", "FrameID", "HandID", "xScreenPosition", "yScreenPosition", "xElbowPos", "yElbowPos", "zElbowPos", "xArmCenter", "yArmCenter", "zArmCenter", "xWristArmPos", "yWristArmPos", "zWristArmPos", "xWristHandPos", "yWristHandPos", "zWristHandPos", "PalmWidth", "xPalmPos", "yPalmPos", "zPalmPos", "xPalmVelo", "yPalmVelo", "zPalmVelo", "xHandDir", "yHandDir", "zHandDir", "xStabilizedPalmPos", "yStabilizedPalmPos", "zStabilizedPalmPos", "IndexID", "xIndexTipPos", "yIndexTipPos", "zIndexTipPos");
        extradata.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17},{36,-17},{37,-17},{38,-17},{39,-17},{40,-17},{41,-17},{42,-17},{43,-17},{44,-17},{45,-17},{46,-17},{47,-17},{48,-17},{49,-17},{50,-17},{51,-17},{52,-17},{53,-17},{54,-17},{55,-17},{56,-17},{57,-17},{58,-17},{59,-17},{60,-17},{61,-17},{62,-17},{63,-17},{64,-17},{65,-17},{66,-17},{67,-17},{68,-17},{69,-17},{70,-17},{71,-17},{72,-17},{73,-17}","Coder", "Timer", "FrameRate", "FrameID", "HandID", "HandConfidence", "LeftHand", "HandVisible", "xArmDirection", "yArmDirection", "zArmDirection", "xArmOrientation", "yArmOrientation", "zArmOrientation", "ArmLength", "ArmWidth", "xPalmNormal", "yPalmNormal", "zPalmNormal", "xPalmOrientation", " yPalmOrientation ", " zPalmOrientation ", "ThumbID", "ThumbVisible", "ThumbExtended", "ThumbLength", "ThumbWidth", "xThumbTipPos", "yThumbTipPos", "zThumbTipPos", "xThumbDir", "yThumbDir", "zThumbDir", "IndexID", "IndexVisible", "IndexExtended", "IndexLength", "IndexWidth", "xIndexDir", "yIndexDir", "zIndexDir", "MiddleID", "MiddleVisible", "MiddleExtended", "MiddleLength", "MiddleWidth", "xMiddleTipPos", "yMiddleTipPos", "zMiddleTipPos", "xMiddleDir", "yMiddleDir", "zMiddleDir", "RingID", "RingVisible", "RingExtended", "RingLength", "RingWidth", "xRingTipPos", "yRingTipPos", "zRingTipPos", "xRingDir", "yRingDir", "zRingDir", "PinkyID", "PinkyVisible", "PinkyExtended", "PinkyLength", "PinkyWidth", "xPinkyTipPos", "yPinkyTipPos", "zPinkyTipPos", "xPinkyDir", "yPinkyDir", "zPinkyDir");

        QualitySettings.vSyncCount = 0; // Disabling vertical synchronization to update the frames faster (for mouse drag)

        StartCoroutine(ConditionText(condition));       // Start the first coroutine = ConditionText
    }

    IEnumerator ConditionText(int[] condition)          // This is the first coroutine that determines which information about the condition will be provided before the trial starts
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
            
        conditionText.SetActive(true);                      // Set conditionText gameobject active
        LabJack(LJ, 1, 0.0);                                // CODER CONDINFO: 0.0                                                                                                                     
        location = 0.0; 
        conditionText.GetComponent<UnityEngine.UI.Text>().text = "This is a " + gosign + " trial \n that contains " + certainty + " \n and requires " + precision;      // Set text of conditionText gameobject
        yield return StartCoroutine(Wait(CondInfo));        // Wait for 'CondInfo' amount of seconds determined in configuration
        conditionText.SetActive(false);                     // Set conditionText gameobject inactive

        yield return StartCoroutine(PosturalHold());        // Start next coroutine = PosturalHold
    }

    IEnumerator PosturalHold()                              // This coroutine is to perform the first 60 seconds of postural hold
    {
        player.SetActive(false);                            // Make sure pointer is still inactive
        postureText.SetActive(true);                        // Set postureText gameobject active
        LabJack(LJ, 1, 0.5);                                // CODER POSTURE: 0.5                                                                                                                     
        location = 0.5;                                                                                                                 
        yield return StartCoroutine(Wait(PostHold));        // Wait for 'PostHold' amount of seconds determined in configuration                 
        postureText.SetActive(false);                       // Set postureText gameobject inactive
        yield return StartCoroutine(RestHold());            // Start next coroutine = RestHold
    }

    IEnumerator RestHold()                                  // This coroutine is to perform the 60 seconds of rest
    {
        player.SetActive(false);                            // Make sure pointer is still inactive
        restText.SetActive(true);                           // Set restText gameobject active
        LabJack(LJ, 1, 0.2);                                // CODER REST: 0.2                                                                                                                   
        location = 0.2;                                                                                                                 
        yield return StartCoroutine(Wait(Rest));            // Wait for 'Rest' amount of seconds determined in configuration                          
        restText.SetActive(false);                          // Set restText gameobject inactive
        yield return StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));      // Start next coroutine = Posture
    }

    IEnumerator Posture(int numBlocks, bool flagpost, int repetition, int[] condition, int[] direction, double[] arraylist, double[] arrowlist)     // This is the coroutine that performs posture before starting the reaches
    {
        player.SetActive(false);                            // Make sure pointer is still inactive
        //balloonTOP1.SetActive(false);                     // This was used for the 5 balloons at the top.. NOT used
        //balloonTOP2.SetActive(false);
        //balloonTOP3.SetActive(false);
        //balloonTOP4.SetActive(false);
        //balloonTOP5.SetActive(false);
        Randomize(direction, arraylist); // "Condition: .. Direction .. .."     // This is a function that creates array containing the directions where the balloons will appear (you can find this function below)

        if (flagpost && numBlocks < 4)                      // Again, for when we still had 4 blocks
        {
            postureText.SetActive(true);                    // Set postureText gameobject active
            LabJack(LJ, 1, 0.5);                            // CODER POSTURE: 0.5
            location = 0.5;
            yield return StartCoroutine(Wait(PostStart));   // Wait for 'PostStart' amount of seconds determined in configuration   
            postureText.SetActive(false);                   // Set postureText gameobject inactive
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));         // Start next coroutine = Reach
        }
        else if (numBlocks == 4)                            // If numblocks is reaches, that means this is the end of this trial, therefore:
        {
            for (int j = 0; j < Reaches+1; j++)
            {
                for (int i = 0; i < 6; i++)
                {
                    infotable.Write(InfoTable[j, i] + " "); // All the information gathered throughout the trial about the reaches will be written in infotable textfile
                }
                infotable.WriteLine();
            }
            infotable.Close();

            LabJack(LJ, 1, 0.0);                            // SET CODER BACK AT 0.
            location = 0.0;

            countText.SetActive(false);                     // CountText gameobject inactive
            endText.SetActive(true);                        // Show end of trial text for 3 seconds.
            yield return StartCoroutine(Wait(3));   
            endText.SetActive(false);                       // Set endText gameobject to inactive

            StopAllCoroutines();                            // This is the end of all coroutines
            //UnityEditor.EditorApplication.isPlaying = false;      // Stops the application from running in Unity 
            Application.Quit();                             // Close the application when build
        }
    }

    IEnumerator Reach(int repetition, int[] condition, int[] direction, double[] arraylist, double[] arrowlist)     // This coroutine performs the Reach stage of each repetition (reach)
    {
        countText.SetActive(true);                          // Make sure the countText (including count balloon - see Unity interface) is active
        //balloonTOP1.SetActive(true);                      // NOT used
        //balloonTOP2.SetActive(true);
        //balloonTOP3.SetActive(true);
        //balloonTOP4.SetActive(true);
        //balloonTOP5.SetActive(true);

        if (repetition == 0)                                // Different text for first reach (= firstpost) than for rest of the reaches (= reach)
        {
            flagpost = false;                               // To make sure the next round of coroutine skips the first 15 seconds of postural hold (in if-statement of Posture coroutine)
            player.SetActive(false);                        // Pointer is still not visible
            firstpost.SetActive(true);                      // Set FirstPost gameobject active (= HOLD this posture)
            LabJack(LJ, 1, 1.0);                            // CODER REACH: 1.0        
            location = 1;
            yield return StartCoroutine(Wait(ReachWait));   // Wait for 'ReachWait' amount of seconds determined in configuration 
            firstpost.SetActive(false);                     // Set firstpost gameobject to inactive
            yield return StartCoroutine(MotorPrep(condition, direction, arraylist, arrowlist));     // Start the next coroutine = MotorPrep
        }
        else if (repetition == ( part * BreakReaches) && repetition != Reaches)      // Have a small break of *breakwait* seconds after every *breakreaches* number of reaches, as determined in configuration
        { // I know this is ugly coding, but it works.
            part++;                                         // If a multiply of BreakReaches is reached, define this by adding 1 value to 'part'
            flagpost = false;                               // To make sure the next round of coroutine skips the first 15 seconds of postural hold (in if-statement of Posture coroutine) 
            player.SetActive(false);                        // Pointer is still not visible
            breaktext.SetActive(true);                      // Set BreakText gameobject to active
            LabJack(LJ, 1, 0.0);                            // CODER BREAK: 0.0        
            location = 0.0;
            yield return StartCoroutine(Wait(BreakWait));   // Wait for 'BreakWait' amount of seconds determined in configuration 
            breaktext.SetActive(false);                     
            postureText.SetActive(true);                    // Do another posturestart to make sure tremor really occurs before reaches resume!
            LabJack(LJ, 1, 0.5);                            // CODER POSTURE: 0.5
            location = 0.5;
            yield return StartCoroutine(Wait(PostStart));   // Wait for 'PostStart' amount of seconds determined in configuration 
            postureText.SetActive(false);
            firstpost.SetActive(true);                      // Set FirstPost gameobject active (= HOLD this posture)
            LabJack(LJ, 1, 1.0);                            // CODER REACH: 1.0        
            location = 1;
            yield return StartCoroutine(Wait(ReachWait));   // Wait for 'ReachWait' amount of seconds determined in configuration 
            firstpost.SetActive(false);                     // Set firstpost gameobject inactive
            yield return StartCoroutine(MotorPrep(condition, direction, arraylist, arrowlist)); yield return StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));     // Start the next coroutine = MotorPrep
        }
        else if (repetition < Reaches)                      // If repetition is less than 'Reaches' as set in configuration, show
        {
            flagpost = false;                               // To make sure the next round of coroutine skips the first 15 seconds of postural hold (in if-statement of Posture coroutine) 
            player.SetActive(false);                        // Pointer is still not visible
            reach.SetActive(true);                          // Set reach gameobject active (= GO BACK to posture)
            LabJack(LJ, 1, 1.0);                            // CODER REACH: 1.0        
            location = 1;
            yield return StartCoroutine(Wait(ReachWait));   // Wait for 'ReachWait' amount of seconds determined in configuration
            reach.SetActive(false);                         // Set reach gameobject inactive
            yield return StartCoroutine(MotorPrep(condition, direction, arraylist, arrowlist));     // Start the next coroutine = MotorPrep
        }
        else if (repetition == Reaches)
        {
            flagpost = true;                                // Set flagpost to true so that... I don't even know why. Could probably be gone but it works like this. 
            print("Block: " + numBlocks + ", Amount of Popped Balloons: " + Collision.count + " out of 5");     // Print this in console window in Unity
            Collision.count = 0;                            // Set count of collision script back to 0 for next block
            countText.GetComponent<TMPro.TextMeshPro>().text = Collision.count.ToString();  // Set text of counter of popped balloons according to this new collision.count number at the end of trial
            numBlocks++;                                    // Add one to the number of blocks
            repetition = 0;                                 // Set repetition back to 0
            yield return StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));  // Start the Posture coroutine to finish
        }
    }

    IEnumerator MotorPrep(int[] condition, int[] direction, double[] arraylist, double[] arrowlist) // This is the next coroutine that performs the motor preparation stage of the reach (= black arrows appear)
    {
        // Print in which direction the balloon will appear in console window in unity
        print("Block: " + numBlocks + ", Condition: " + condition[numBlocks] + ". Direction of Repetition #" + repetition + ": " + direction[repetition]);

        // Set some of the variables of the information table
        InfoTable[repetition + 1, 0] = condition[numBlocks].ToString();
        InfoTable[repetition + 1, 1] = repetition.ToString();
        InfoTable[repetition + 1, 2] = direction[repetition].ToString();
        InfoTable[repetition + 1, 3] = "No";            // Default of balloon appeared: No
        InfoTable[repetition + 1, 4] = "No";            // Default of balloon popped:   No
        InfoTable[repetition + 1, 5] = 0.ToString();    // Default popping time:        0

        // Function that determines the initial lengths of the arrow 
        Arrowlist(condition, arraylist, sigma);

        // Function that allocate the different lengths to different arrows, according to which direction is determined for this particular reach
        ArrowAssigning(direction, arraylist, arrowlist);

        // Function that adds a bit of variance to the length of arrows so that the arrows change a little bit in length, so that the longest arrow not always points to the direction that is chosen
        DirectionVariance(condition, arrowlist, arraylist);

        // Function that sets arrow gameobjects active and rescales the lengths of the arrows according to the functions above
        SetArrowLength(arrowlist);                      // CODER MOTORPREP: 1.5

        yield return StartCoroutine(Wait(PrepWait));    // Wait for 'PrepWait' amount of seconds determined in configuration

        // Function that sets colour of arrow to green (1 = green, 2 = black and inactive) = go sign
        ArrowColor(1);                                  // CODER MOTOREXEC: 2.0                                             

        // Capture the current time needed for GBYK:
        float currenttime = Time.time;

        if (condition[numBlocks] < 5)                   // GO AFTER YOU KNOW
        {
            delayflag = 1;
        }
        else if (condition[numBlocks] > 4)              // GO BEFORE YOU KNOW
        {
            yield return StartCoroutine(MotorDelay(currenttime));   // In GBYK case, coroutine used to delay the appearance of the balloons until subjects moves
        }

        if (delayflag == 1)                             // If delayflag == 1, balloon appears immediately because coroutine MotorExec is started straight away here:
        {
            delayflag = 0;                              // Set delayflag back to a value that is meaningless
            InfoTable[repetition + 1, 3] = "Yes";       // Set information that balloon is appeared
            yield return StartCoroutine(MotorExec(condition, direction, arraylist, arrowlist)); // Start of next coroutine = MotorExec
        }
        if (delayflag == 2)
        {
            delayflag = 0;
            InfoTable[repetition + 1, 3] = "No";        // Set information that balloon never appeared
            ArrowColor(2);                              // Function that sets arrows back to black and inactives them
            repetition++;                               // Add one to repetition 
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));     // And start Reach coroutine again (without balloon appearance)
        }
    }

    IEnumerator MotorDelay(float currenttime)           // This coroutine tracks whether the subject has moved enough to show the balloon in GBYK
    {
        if (dist < distance)                            // dist (= z-coordinate of current LeapMotion tracking (captured in Update Void below)) needs to be less than distance (= in cm from camera as set in configuration, depending on location of the camera), because that means arm is moving towards the LeapMotion camera.
        {
            delayflag = 1;                              // The 'Yield Return' in MotorPrep means that when this next coroutine is finished, it will return to where it was in the previous coroutine. Therefore now it will go back to the if-statement of MotorPrep and sees that delayflag == 1, so proceeds executing MotorExec
        }
        else if (dist > distance && Time.time < currenttime + DelayWait)    // As long as the dist is still bigger than distance, and the current time.time is less than the currenttime + 'DelayWait' as set in configuration, it will repeat this coroutine
        {
            yield return null;
            yield return StartCoroutine(MotorDelay(currenttime));
        }
        else if (dist > distance && Time.time >= currenttime + DelayWait)   // If the dist is never less than distance, but the current time has exceeded the time allowed for this 'DelayWait', it will set delayflag to 2, and reaches back to the if-statement in MotorPrep
        {
            delayflag = 2;                              // Set delayflag back to a value that is meaningless
        }
    }

    IEnumerator MotorExec(int[] condition, int[] direction, double[] arraylist, double[] arrowlist) // This is the next coroutine that activates the balloon at the specific location 
    {
        player.SetActive(true);                         // In this stage of the task, the pointer can be visible
        if (Visible == 0)                               // However, if 'Visible' is set to 0 in matlab configuration, the pointer becomes invisible again (only SpriteRenderer disabled, because we still need the collision feature of the pointer to change the balloon color when it's hit)
        {
            player.GetComponent<SpriteRenderer>().enabled = false;              
        }

        // The following is all a repetition of the same, exept for the location where the balloon is appearing - that depends on the chosen direction for this reach

        // BIG BALLOONS: condition 1/2/5/6 = LOW PRECISION required
        if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 1))
        {
            balloonBIG.SetActive(true);                                         // Set the Balloon gameobject active
            balloonBIG.GetComponent<Collider>().enabled = true;                 // Set the Balloon gameobject collider active (the collider feature of the balloon is disabled in the collider script (which is attached to the balloon) to make sure the counter doesn't add every time the balloon is hit when it has a green color
            animBIG.SetActive(false);                                           // Make sure the POOF animation is inactive
            countspark.SetActive(false);                                        // Make sure the spark animation of the counter is inactive
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
            location = 2.5;
            Collision.t = 0;                                                    // Set the time it takes to change the color of the balloon to green back to 0
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;     // Set the color of the balloon back to red
            balloonBIG.transform.position = new Vector2(2f, -0.15f);            // Set the location of the balloon accordingly
            yield return StartCoroutine(Wait(HoldWait));                        // Wait for 'HoldWait' amount of seconds determined in configuration. During this the collision script attached to the balloon will act!!
            balloonBIG.SetActive(false);                                        // Set balloon gameobject to inactive
            ArrowColor(2);                                                      // setting arrow color back to black and inactivate arrows
            repetition++;                                                       // Add one to repetition (reach completed)
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));     // Start coroutine Reach again for start of new reach!
        }
        else if ((condition[numBlocks] == 1 || condition[numBlocks] == 2 || condition[numBlocks] == 5 || condition[numBlocks] == 6) && (direction[repetition] == 2))
        {
            balloonBIG.SetActive(true);
            balloonBIG.GetComponent<Collider>().enabled = true;
            animBIG.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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

        // Here starts the same, but then for small balloons (high precision)

        // SMALL BALLOONS: condition 3/4/7/8 = HIGH PRECISION required
        if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 1))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
            location = 2.5;
            Collision.t = 0;
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            balloonSMALL.transform.position = new Vector2(2f, -0.15f);
            yield return StartCoroutine(Wait(HoldWait));                                
            balloonSMALL.SetActive(false);
            ArrowColor(2);                                                         
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if ((condition[numBlocks] == 3 || condition[numBlocks] == 4 || condition[numBlocks] == 7 || condition[numBlocks] == 8) && (direction[repetition] == 2))
        {
            balloonSMALL.SetActive(true);
            balloonSMALL.GetComponent<Collider>().enabled = true;
            animSMALL.SetActive(false);
            countspark.SetActive(false);
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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
            LabJack(LJ, 1, 2.5);                                                // CODER HOLD: 2.5
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

    // This is a function that allows us to set the configurations of the timings in Matlab!
    IEnumerator Wait(float seconds)
    {
        yield return new WaitForSeconds(seconds);
    }

    // Everything that in located in the Update void, updates every Unity sample
    void Update()
    {
        // These two files are to determine what the delay of LeapMotion frame rate is:
        code.WriteLine(location);                   // Adds coder (= location) to file every frame (corresponds the input of LabJack)
        time.WriteLine(Time.time);                  // Adds current time to file every frame

        Controller controller = new Controller();   // An instance of LeapMotion controller must exist

        Frame frame = controller.Frame();           // Create a frame from the LeapMotion controller

        for (int h = 0; h < frame.Hands.Count; h++) // For infinite amount of LeapMotion frames
        {
            // both      = added to both data as well as extradata text files
            // data      = added to data text file
            // extradata = added to extradata text files

            float instantaneousFrameRate = frame.CurrentFramesPerSecond;    // both

            Hand hand = frame.Hands[h];             // Get hand model from LeapMotion

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
            long frameID = hand.FrameId;                        // both
            int handID = hand.Id;                               // both                
            float handconfidence = hand.Confidence;             // extradata
            float palmwidth = hand.PalmWidth;                   // data
            bool lefthand = hand.IsLeft;                        // extradata
            float handvisible = hand.TimeVisible;               // extradata
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

            // Depending on the tracking configuration, use different LeapMotion data to track the hand: 
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
                // Tracking stabilizedpalmposition for task, is NOT working..:
                trackingx = stabilizedpalmposition.x;
                trackingy = stabilizedpalmposition.y;
                trackingz = stabilizedpalmposition.z;
            }

            // Transform the LeapMotion coordinates using the keys and the following equation: xS = (xL - WESN_leap(1)) * (Xrange_app / Xrange_leap) + WESN_app(1)
            newpositionx = ((trackingx - XKey[0]) * XKey[1]) + XKey[2];
            newpositiony = ((trackingy - YKey[0]) * YKey[1]) + YKey[2];

            // Set the position of the player (= red pointer) according to the position of the tracked LeapMotion data              WEAK SPOT 
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

            // Only if the configuration stated that the tick is attached, send LeapMotion tracking data as LabJack output:
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

            // Only if the LeapMotion is valid (as LeapMotion software determines..), save the data in the textfiles:
            Vector tracking = new Vector(trackingx, trackingy, trackingz);
            if (tracking.IsValid())
            {
                data.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17}",location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), frameID.ToString(), handID.ToString(), newpositionx.ToString(), newpositiony.ToString(), elbow.x.ToString(), elbow.y.ToString(), elbow.z.ToString(), armcenter.x.ToString(), armcenter.y.ToString(), armcenter.z.ToString(), wrist.x.ToString(), wrist.y.ToString(), wrist.z.ToString(), wristposition.x.ToString(), wristposition.y.ToString(), wristposition.z.ToString(), palmwidth.ToString(), palmposition.x.ToString(), palmposition.y.ToString(), palmposition.z.ToString(), palmvelocity.x.ToString(), palmvelocity.y.ToString(), palmvelocity.z.ToString(), handdirection.x.ToString(), handdirection.y.ToString(), handdirection.z.ToString(), stabilizedpalmposition.x.ToString(), stabilizedpalmposition.y.ToString(), stabilizedpalmposition.z.ToString(), indexId.ToString(), indextipposition.x.ToString(), indextipposition.y.ToString(), indextipposition.z.ToString());
                extradata.WriteLine("{0,-7},{1,-12},{2,-17},{3,-17},{4,-17},{5,-17},{6,-17},{7,-17},{8,-17},{9,-17},{10,-17},{11,-17},{12,-17},{13,-17},{14,-17},{15,-17},{16,-17},{17,-17},{18,-17},{19,-17},{20,-17},{21,-17},{22,-17},{23,-17},{24,-17},{25,-17},{26,-17},{26,-17},{27,-17},{28,-17},{29,-17},{30,-17},{31,-17},{32,-17},{33,-17},{34,-17},{35,-17},{36,-17},{37,-17},{38,-17},{39,-17},{40,-17},{41,-17},{42,-17},{43,-17},{44,-17},{45,-17},{46,-17},{47,-17},{48,-17},{49,-17},{50,-17},{51,-17},{52,-17},{53,-17},{54,-17},{55,-17},{56,-17},{57,-17},{58,-17},{59,-17},{60,-17},{61,-17},{62,-17},{63,-17},{64,-17},{65,-17},{66,-17},{67,-17},{68,-17},{69,-17},{70,-17},{71,-17},{72,-17},{73,-17}", location.ToString(), Time.time.ToString(), instantaneousFrameRate.ToString(), frameID.ToString(), handID.ToString(), handconfidence.ToString(), lefthand.ToString(), handvisible.ToString(), armdirection.x.ToString(), armdirection.y.ToString(), armdirection.z.ToString(), armorientation.x.ToString(), armorientation.y.ToString(), armorientation.z.ToString(), armlength.ToString(), armwidth.ToString(), palmnormal.x.ToString(), palmnormal.y.ToString(), palmnormal.z.ToString(), palmorientation.x.ToString(), palmorientation.y.ToString(), palmorientation.z.ToString(), thumbId.ToString(), thumbvisible.ToString(), thumbextended.ToString(), thumblength.ToString(), thumbwidth.ToString(), thumbtipposition.x.ToString(), thumbtipposition.y.ToString(), thumbtipposition.z.ToString(), thumbdirection.x.ToString(), thumbdirection.y.ToString(), thumbdirection.z.ToString(), indexId.ToString(), indexvisible.ToString(), indexextended.ToString(), indexlength.ToString(), indexwidth.ToString(), indexdirection.x.ToString(), indexdirection.y.ToString(), indexdirection.z.ToString(), middleId.ToString(), middlevisible.ToString(), middleextended.ToString(), middlelength.ToString(), middlewidth.ToString(), middletipposition.x.ToString(), middletipposition.y.ToString(), middletipposition.z.ToString(), middledirection.x.ToString(), middledirection.y.ToString(), middledirection.z.ToString(), ringId.ToString(), ringvisible.ToString(), ringextended.ToString(), ringlength.ToString(), ringwidth.ToString(), ringtipposition.x.ToString(), ringtipposition.y.ToString(), ringtipposition.z.ToString(), ringdirection.x.ToString(), ringdirection.y.ToString(), ringdirection.z.ToString(), pinkyId.ToString(), pinkyvisible.ToString(), pinkyextended.ToString(), pinkylength.ToString(), pinkywidth.ToString(), pinkytipposition.x.ToString(), pinkytipposition.y.ToString(), pinkytipposition.z.ToString(), pinkydirection.x.ToString(), pinkydirection.y.ToString(), pinkydirection.z.ToString());

            }
        }

        // Make sure reptition is set to 0 after all reaches of this trial are finished:
        if (repetition == Reaches)
        {
            repetition = 0;
        }

        // Pause button, when SpaceBar is pressed, game is paused and CODER PAUSE = 0.0
        if (Input.GetKeyDown(KeyCode.Space))                // Whenever SpaceBar is pressed..
        {
            if (Time.timeScale == 1)                        // If game is running
            {
                labjackvalue = location;                    // Capture the current coder
                Time.timeScale = 0;                         // Stop game from running
                pauseText.SetActive(true);                  // Set pauseText gameobject active
                if (pauseflag == 0)
                {
                    LabJack(LJ, 1, 0);                      // CODER PAUSE = 0.0
                    location = 0.0;
                    pauseflag = 1;
                }
            }
            else if (Time.timeScale == 0)                   // If game is not running
            {
                Time.timeScale = 1;                         // Resume game
                pauseText.SetActive(false);                 // Set pauseText gameobject back to inactive
                if (pauseflag == 1)
                {
                    LabJack(LJ, 1, labjackvalue);          // CODER RESUME = value it was before pausing game
                    location = labjackvalue;
                    pauseflag = 0;
                }
            }
        }

        // Balloons at the top NOT USED:
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

    // From here voids (= functions without output) to feed the coroutines:

    // This function is used to control for when LabJack and/or Tick are not attached
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

    // Void for Randomizing Conditions
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
    void Swap(int[] arr, int a, int b) // This void is part of ShuffleArray void
    {
        int temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }

    // Void for picking a random number between 1 and 8 to determine direction of balloon 
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

    // Function that determines the initial lengths of the arrow 
    void Arrowlist(int[] condition, double[] arraylist, double sigma)           // WEAK SPOT
    {
        double min = 0.40;              // Set minimum lenght of an arrow
        double max = 1.60;              // Set maximum length of an arrow
        double total = 9.0;             // Set the sum of all lengths of the arrows
        double currentsum = 0;          // Empty variable for the sum of arrow lengths
        double low, high, calc;         // Empty variables for calculations 

        if (condition[numBlocks] == 1 || condition[numBlocks] == 3 || condition[numBlocks] == 5 || condition[numBlocks] == 7)                     // LOW UNCERTAINTY in variance of arrow length
        {
            sigma = 1;                  // Not used. I thought having bigger variance in lengths would make it more obvious where the balloon will show up (one big arrow, 7 smaller arrows), but this feature doesn't work like I want it to..
        }
        else if (condition[numBlocks] == 2 || condition[numBlocks] == 4 || condition[numBlocks] == 6 || condition[numBlocks] == 8)                // HIGH UNCERTAINTY in variance of arrow length
        {
            sigma = 1;                  // Not used.
        }

        System.Random rand = new System.Random();
        for (int index = 0; index < arraylist.Length; index++)                          // Loop through the arraylist variable
        {
            calc = (total - currentsum) - (max * (arraylist.Length - 1 - index));       // To be honest, I got this from the internet. Not sure what happens here when it comes to the maths. 
            low = calc < min ? min : calc;
            calc = (total - currentsum) - (min * (arraylist.Length - 1 - index));
            high = calc > max ? max : calc;

            // These values add up to 9 but are not normally distributed AND I can't control for variance.. mweeehhh
            arraylist[index] = Math.Abs(rand.NextDouble()) * (high - low) + low;
            // This would be another option, but can't get that working..:
            // "(abs(random() - random()) * (1 + max - min) + min) --> Gives you a random number between min and max, with outputs closer to min being more common, falling off linearly toward the max."

            currentsum += arraylist[index];
        }
        Array.Sort(arraylist);                  // Sort list so that smallest value is at position [0] in the list and the highest value at position [7]
    }

    // This was the Arrowlist function used during the pilot on 03.03.2020:
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

    // Function that allocate the different lengths to different arrows, according to which direction is determined for this particular reach
    void ArrowAssigning(int[] direction, double[] arraylist, double[] arrowlist)        // WEAK SPOT
    {
        if (direction[repetition] == 1)         // If current direction is 1, make sure arrow
        {
            arrowlist[0] = arraylist[7];        // Highest value of arraylist (at position [7]) is assigned to arrow [0]
            arrowlist[1] = arraylist[6];        // Second highest value of arraylist (at position [6]) is assigned to arrow [1]
            arrowlist[2] = arraylist[4];    
            arrowlist[3] = arraylist[2];
            arrowlist[4] = arraylist[0];
            arrowlist[5] = arraylist[1];
            arrowlist[6] = arraylist[3];
            arrowlist[7] = arraylist[5];        // Third highest value of arraylist (at position [5]) is assigned to arrow [7], because this arrow is next to position [0] at the other side (circular)
        }
        if (direction[repetition] == 2)         // Etc...
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
            arrowlist[3] = arraylist[7];        // Direction 4 = Arraynumber 3
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

    // Function that adds a bit of variance to the length of arrows so that the arrows change a little bit in length, so that the longest arrow not always points to the direction that is chosen
    void DirectionVariance(int[] condition, double[] arrowlist, double[] arraylist)     // WEAK SPOT - because I'm uncertain about the maths behind it
    {
        System.Random rand = new System.Random();
        if (condition[numBlocks] == 1 || condition[numBlocks] == 3 || condition[numBlocks] == 5 || condition[numBlocks] == 7)                 // LOW UNCERTAINTY of variance in direction
        {
            double std = 0.2;                           // Change this value to control for the added variance
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
            double std = 0.55;                           // Change this value to control for the added variance
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

    // Function that sets arrow gameobjects active and rescales the lengths of the arrows according to the functions above
    void SetArrowLength(double[] arrowlist)
    {
        // Set arrows gameobject active
        arrow1.SetActive(true);
        arrow2.SetActive(true);
        arrow3.SetActive(true);
        arrow4.SetActive(true);
        arrow5.SetActive(true);
        arrow6.SetActive(true);
        arrow7.SetActive(true);
        arrow8.SetActive(true);

        LabJack(LJ, 1, 1.5);                                        // Black arrow appearance, CODER MOTORPREP: 1.5
        location = 1.5;

        // Rescale the lengths of the arrows (y-scale) according to the arrow length functions
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

    // Function that allows to control the color of the arrows
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
            MeshRenderer arrow8Renderer = arrow8.GetComponentsInChildren<MeshRenderer>()[0];        // The arrows consist out of two parts, therefore needed to call the renderer of both parts for each arrow..
            MeshRenderer arrow1Renderer1 = arrow1.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow2Renderer1 = arrow2.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow3Renderer1 = arrow3.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow4Renderer1 = arrow4.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow5Renderer1 = arrow5.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow6Renderer1 = arrow6.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow7Renderer1 = arrow7.GetComponentsInChildren<MeshRenderer>()[1];
            MeshRenderer arrow8Renderer1 = arrow8.GetComponentsInChildren<MeshRenderer>()[1];
            arrow1Renderer.material.color = Color.green;                                            // Set both parts of the arrow to green: Go sign!
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
            player.SetActive(true);                             // Make sure player is still active
            LabJack(LJ, 1, 2.0);                                // CODER MOTOREXEC: 2.0
            location = 2;
        }

        if (stage == 2)
        {
            // I probably could've assign this at the top to make it 'static' variables, but I found out too late so I'm just defining these variables twice.. Ugly coding I know
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
            arrow1Renderer.material.color = Color.black;                                            // Set both parts of the arrow to black: resetting gameobjects to prepare for next reach
            arrow2Renderer.material.color = Color.black;                                            // It's only possible to manage gameobject when they're still active
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
            arrow1.SetActive(false);                                                                // Set arrow gameobjects inactive
            arrow2.SetActive(false);
            arrow3.SetActive(false);
            arrow4.SetActive(false);
            arrow5.SetActive(false);
            arrow6.SetActive(false);
            arrow7.SetActive(false);
            arrow8.SetActive(false);

            player.SetActive(false);                                                                // Set player inactive to prepare for next reach
        }
    }
}
