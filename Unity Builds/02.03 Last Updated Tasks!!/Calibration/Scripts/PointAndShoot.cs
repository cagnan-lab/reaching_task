using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using System;
//using MathNet.Numerics.Random;
using Leap;
//using LabJack.LabJackUD;

public class PointAndShoot : MonoBehaviour
{
    public GameObject player;
    public GameObject CountText;
    public Text countText;

    public GameObject PosturalHold;
    public GameObject reach;

    public GameObject arrow1;
    public GameObject arrow2;
    public GameObject arrow3;
    public GameObject arrow4;
    public GameObject arrow5;
    public GameObject arrow6;
    public GameObject arrow7;
    public GameObject arrow8;

    public GameObject balloonBIG;
    public GameObject balloonSMALL;

    public float dist;
    public float distance;

    private Vector3 target; // Stores our target position, which in this case is mouse position.
    //private U3 u3;
    // double pinNum = 4;  //4 means the LJTick-DAC is connected to FIO4/FIO5.

    private double[] arraylist = new double[8];
    private double[] arrowlist = new double[8];

    private int[] condition = { 1, 2, 3, 4 }; // condition[0] = 1, condition[1] = 2, condition[2] = 3; condition[3] = 4;
    // Random Array of Direction:
    private int[] direction = new int[5];
    public static int numBlocks = 0; 
    public static int repetition;

    private bool flagpost = true;
    private int delayflag = 0;

    void Start()
    {
        //LJMError = LabJack.LJM.Close(u3.ljhandle);
        //LabJack.LJM.Close(u3.ljhandle);

        //Open the first found LabJack U3.
        //u3 = new U3(LJUD.CONNECTION.USB, "0", true); // Connection through USB
        //u3.u3Config();

        //Start by using the pin_configuration_reset IOType so that all
        //pin assignments are in the factory default condition.
        //LJUD.ePut(u3.ljhandle, LJUD.IO.PIN_CONFIGURATION_RESET, 0, 0, 0);

        //Specify where the LJTick-DAC is plugged in. pinNum = 4 means the LJTick-DAC is connected to FIO4/FIO5.
        //This is just setting a parameter in the driver, and not actually talking
        //to the hardware, and thus executes very fast.
        //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_CONFIG, LJUD.CHANNEL.TDAC_SCL_PIN_NUM, pinNum, 0);

        // DAC0 = coder : LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 1.3, 0); (1.3 Volts e.g.)
        // DAC1 = LeapX : LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)1, 1.7, 0); (1.7 Volts e.g.)
        // DACA = LeapY : LJUD.ePut(u3.ljhandle, LJUD.IO.TDAC_COMMUNICATION, LJUD.CHANNEL.TDAC_UPDATE_DACA, 1.2, 0); (1.2 Volts e.g.) --> place this in Update and use LeapY-coordinates as Volts!
        // DACB = LeapZ : LJUD.ePut(u3.ljhandle, LJUD.IO.TDAC_COMMUNICATION, LJUD.CHANNEL.TDAC_UPDATE_DACB, 1.4, 0); (1.4 Volts e.g.) --> place this in Update and use LeapZ-coordinates as Volts!

        //If the driver has not previously talked to an LJTDAC
        //on the specified pins, it will first retrieve and store the cal constants.  
        //The low-level I2C command can only update 1 DAC channel at a time, so there
        //is no advantage to doing two updates within a single add-go-get block.

        // Shuffle Array of Condition:
        ShuffleArray(condition);

        StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));
    }

    IEnumerator Posture(int numBlocks, bool flagpost, int repetition, int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
        player.SetActive(false);
        CountText.SetActive(false);

        Randomize(direction); // "Condition: .. Direction .. .."

        if (flagpost && numBlocks < 4)
        {
            PosturalHold.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 1, 0);         // CODER POSTURE: 1
            yield return new WaitForSeconds(2f);                                    // CONTROL 5 SECONDS OF POSTURE         // AANGEPAST!!
            PosturalHold.SetActive(false);
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (numBlocks == 4)
        {
            StopAllCoroutines();
        }
    }

    IEnumerator Reach(int repetition, int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
        CountText.SetActive(true);

        if (repetition < 5)
        {
            flagpost = false;
            player.SetActive(true);
            reach.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 1.5, 0);       // CODER REACH: 1.5
            yield return new WaitForSeconds(2.5f);                                  // CONTROL 2.5 SECONDS OF REACH
            reach.SetActive(false);
            yield return StartCoroutine(MotorPrep(condition, direction, arraylist, arrowlist));
        }
        else if (repetition == 5)
        {
            flagpost = true;
            print("Block: " + numBlocks + ", Amount of Popped Balloons: " + Collision.count + " out of 5");
            Collision.count = 0;
            countText.text = "Count: " + Collision.count.ToString();
            numBlocks++;
            repetition = 0;
            yield return StartCoroutine(Posture(numBlocks, flagpost, repetition, condition, direction, arraylist, arrowlist));
        }
    }

    IEnumerator MotorPrep(int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
        print("Block: " + numBlocks + ", Condition: "+ condition[numBlocks] + ". Direction of Repetition #" + repetition + ": " + direction[repetition]);

        Arrowlist(condition, arraylist);
        //foreach(var values in arraylist)
        //{
        //    Debug.Log("Random generated arrowlengths: " + values);
        //}

        ArrowAssigning(direction, arraylist, arrowlist);
        //foreach (var values in arrowlist)
        //{
        //    Debug.Log("Generated list according to the direction: " + values);
        //}

        DirectionVariance(condition, arrowlist);
        //foreach (var values in arrowlist)
        //{
        //    Debug.Log("Arrowlist with added noise/variance: " + values);
        //}

        SetArrowLength(arrowlist);   // SetActive Arrows and Sends LJ trigger of 2V!!

        yield return new WaitForSeconds(2.5f);                                  // CONTROL 2.5 SECONDS OF MOTORPREP

        ArrowColor(1);      // DO WE WANT A CODER FOR WHEN THE ARROW SHOW GREEN?!                                                

        float currenttime = Time.time;

        if (condition[numBlocks] == 1 || condition[numBlocks] == 2)         // GO AFTER YOU KNOW
        {
            delayflag = 1;       
        }
        else if (condition[numBlocks] == 3 || condition[numBlocks] == 4)         // GO AFTER YOU KNOW()
        {
            yield return StartCoroutine(MotorDelay(currenttime));
        }

        if (delayflag == 1)
        {
            delayflag = 0;
            //print("Delayflag is false");
            yield return StartCoroutine(MotorExec(condition, direction, arraylist, arrowlist));
        }
        if (delayflag == 2)
        {
            delayflag = 0;
            //print("Delayflag is false");
            ArrowColor(2);                                                          // setting arrow color back to black and SetActive false
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
    }

    IEnumerator MotorDelay(float currenttime)
    {
        if (dist > distance)
        {
            delayflag = 1;      // DO WE WANT A CODER FOR WHEN THEY ACTUALLY STARTED MOVING? IN CONDITION 3/4 THIS MOMENT IS PRACTICALLY THE SAME AS WHEN THE BALLOON APPEARS. IN CONDITION 1/2 NOT, BC BALLOON APPEARS BEFORE THEY START MOVING. 
            //print("Delayflag is true bc distance");
        }
        else if (dist < distance && Time.time < currenttime + 4f)
        {
            //print("Delayflag still false bc no distance nor time");
            yield return null;
            yield return StartCoroutine(MotorDelay(currenttime));
        }
        else if (dist < distance && Time.time >= currenttime + 4f)
        {
            delayflag = 2;
            //print("Delayflag is true bc time");
        }
    }

    IEnumerator MotorExec(int[] condition, int[] direction, double[] arraylist, double[] arrowlist)
    {
    // BIG BALLOONS: condition 1/2
        if (condition[numBlocks] < 3 && direction[repetition] == 1)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER FOR BALLOON APPEARANCE: 2.5
            Collision.t = 0;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            balloonBIG.transform.position = new Vector2(2f, -0.15f);
            yield return new WaitForSeconds(4f);                                    // CONTROL 4 SECONDS OF MOTOREXEC
            balloonBIG.SetActive(false);
            ArrowColor(2);                                                          // setting arrow color back to black and SetActive false
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] < 3 && direction[repetition] == 2)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            Collision.t = 0;
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            balloonBIG.transform.position = new Vector2(1.5f, 1.35f);
            yield return new WaitForSeconds(4f);
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] < 3 && direction[repetition] == 3)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(0f, 2f);
            yield return new WaitForSeconds(4f);
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] < 3 && direction[repetition] == 4)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(-1.5f, 1.35f);
            yield return new WaitForSeconds(4f);
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] < 3 && direction[repetition] == 5)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(-2f, -0.15f);
            yield return new WaitForSeconds(4f);
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] < 3 && direction[repetition] == 6)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(-1.5f, -1.65f);
            yield return new WaitForSeconds(4f);
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] < 3 && direction[repetition] == 7)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(0f, -2f);
            yield return new WaitForSeconds(4f);
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] < 3 && direction[repetition] == 8)
        {
            balloonBIG.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonBIG.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonBIG.transform.position = new Vector2(1.5f, -1.65f);
            yield return new WaitForSeconds(4f);
            balloonBIG.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }

    // SMALL BALLOONS: condition 3/4
        if (condition[numBlocks] > 2 && direction[repetition] == 1)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(2f, -0.075f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] > 2 && direction[repetition] == 2)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(1.5f, 1.425f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] > 2 && direction[repetition] == 3)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(0f, 2.075f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] > 2 && direction[repetition] == 4)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(-1.5f, 1.425f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] > 2 && direction[repetition] == 5)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(-2f, -0.075f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] > 2 && direction[repetition] == 6)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(-1.5f, -1.575f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] > 2 && direction[repetition] == 7)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(0f, -1.925f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
        else if (condition[numBlocks] > 2 && direction[repetition] == 8)
        {
            balloonSMALL.SetActive(true);
            //LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2.5, 0);       // CODER MOTOREXEC: 2.5
            balloonSMALL.GetComponent<Renderer>().material.color = Color.red;
            Collision.t = 0;
            balloonSMALL.transform.position = new Vector2(1.5f, -1.575f);
            yield return new WaitForSeconds(4f);
            balloonSMALL.SetActive(false);
            ArrowColor(2);
            repetition++;
            yield return StartCoroutine(Reach(repetition, condition, direction, arraylist, arrowlist));
        }
    }

    // Void for updating HandPosition every frame:
    private void Update()
    {
        //target = transform.GetComponent<Camera>().ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, transform.position.z));
        //player.transform.position = new Vector2(target.x, target.y);

        //Calculate the distance between the Arrow1 and the player
        //dist = Vector2.Distance(player.transform.position, arrow1.transform.position);

        //    Frame frame = controller.Frame();
        //    for (int h = 0; h < frame.Hands.Count; h++)
        //    {
        //        Hand leapHand = frame.Hands[h];

        //        Vector handXBasis = leapHand.PalmNormal.Cross(leapHand.Direction).Normalized;
        //        Vector handYBasis = -leapHand.PalmNormal;
        //        Vector handZBasis = -leapHand.Direction;
        //        Vector handOrigin = leapHand.PalmPosition;
        //        Matrix handTransform = new Matrix(handXBasis, handYBasis, handZBasis, handOrigin);
        //        handTransform = handTransform.RigidInverse();

        //        for (int f = 0; f < leapHand.Fingers.Count; f++)
        //        {
        //            Finger leapFinger = leapHand.Fingers[f];
        //            Vector transformedPosition = handTransform.TransformPoint(leapFinger.TipPosition);
        //            Vector transformedDirection = handTransform.TransformDirection(leapFinger.Direction);
        //            // Do something with the transformed fingers
        //        }
        //    }


        Controller controller = new Controller(); //An instance must exist

        Frame frame = controller.Frame();
        for (int h = 0; h < frame.Hands.Count; h++)
        {
            Hand hand = frame.Hands[h];
            Vector position = hand.PalmPosition;
            Vector velocity = hand.PalmVelocity;
            Vector direction = hand.Direction;

            //Calibration[]
            //Vector newPosition = Calibration.TransformMatrix[1].TransformPoint(position);

            //target = transform.GetComponent<Camera>().ScreenToWorldPoint(new Vector3(newPosition.x, newPosition.y, newPosition.z));
            //player.transform.position = new Vector2(target.x + 3f, target.y);
            // player.transform.position *= 2f;

            // FOR THE LABJACK:
            // DAC1 = LeapX : LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)1, 1.7, 0); (1.7 Volts e.g.)
            // DACA = LeapY : LJUD.ePut(u3.ljhandle, LJUD.IO.TDAC_COMMUNICATION, LJUD.CHANNEL.TDAC_UPDATE_DACA, 1.2, 0); (1.2 Volts e.g.) --> place this in Update and use LeapY-coordinates as Volts!
            // DACB = LeapZ : LJUD.ePut(u3.ljhandle, LJUD.IO.TDAC_COMMUNICATION, LJUD.CHANNEL.TDAC_UPDATE_DACB, 1.4, 0); (1.4 Volts e.g.) --> place this in Update and use LeapZ-coordinates as Volts!

            //If the driver has not previously talked to an LJTDAC
            //on the specified pins, it will first retrieve and store the cal constants.  
            //The low-level I2C command can only update 1 DAC channel at a time, so there
            //is no advantage to doing two updates within a single add-go-get block.
        }

        if (repetition == 5)
        {
            repetition = 0;
        }

    }

    // FROM HERE VOIDS FOR THE COROUTINES:

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
    void Randomize(int[] direction)
    {
        print("Directions of Block " + numBlocks + ":");
        System.Random randNum = new System.Random();
        for (int i = 0; i < direction.Length; i++)
        {
            int number = randNum.Next(1, 8);
            direction[i] = number;
            print(" " + direction[i]);
        }
    }

    // Generate arrowlength array at which arrowlist[0] = longest + direction 1!
    void Arrowlist(int[] condition, double[] arraylist)
    {
        System.Random rand = new System.Random();
        if (condition[numBlocks] == 1 || condition[numBlocks] == 3)                     // HIGH PRECISION in variance of arrow length
        {
            double sigma = 0.5;                             
            for (int i = 0; i < arraylist.Length; i++)
            {
                double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
                double u2 = 1.0 - rand.NextDouble();
                double randSigmaNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
                             Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
                double randSigNormal =
                             1.1 + sigma * randSigmaNormal; //random normal(mean,stdDev^2)
                arraylist[i] = Math.Abs(randSigNormal);
            }
        }
        else if (condition[numBlocks] == 2 || condition[numBlocks] == 4)                // LOW PRECISION in variance of arrow length
        {
            double sigma = 0.3;
            for (int i = 0; i < arraylist.Length; i++)
            {
                double u1 = 1.0 - rand.NextDouble(); //uniform(0,1] random doubles
                double u2 = 1.0 - rand.NextDouble();
                double randSigmaNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
                             Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
                double randSigNormal =
                             1 + sigma * randSigmaNormal; //random normal(mean,stdDev^2)
                arraylist[i] = Math.Abs(randSigNormal);
            }
        }
        Array.Sort(arraylist);
    }

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

    void DirectionVariance(int[] condition, double[] arrowlist)     
    {
        System.Random rand = new System.Random();
        if (condition[numBlocks] == 1 || condition[numBlocks] == 3)                 // HIGH PRECISION of variance in direction
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
        if (condition[numBlocks] == 2 || condition[numBlocks] == 4)                 // LOW PRECISION of variance in direction
        {
            double std = 0.6;
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

       // LJUD.ePut(u3.ljhandle, LJUD.IO.PUT_DAC, (LJUD.CHANNEL)0, 2, 0);         // CODER MOTORPREP, BLACK ARROW APPEARANCE: 2

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
        }
    }
}
