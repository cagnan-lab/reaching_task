using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Collision : MonoBehaviour
{
    // GameObjects to manage in this script:
    public GameObject countspark;
    public GameObject countText;
    public static int count;

    public Color colorIni = Color.red;      // Define the initial color of the balloons
    public Color colorFin = Color.green;    // Define the end color of the balloons
    Color lerpedColor = Color.red;          // Define the color from which the balloon will change

    public static float t = 0;              // Variable to determine speed of color lerping of balloon
    private bool flagcount;                 // Flag to allow the counter to go up

    // Define renderer and collider components of the gameobject this script is attached to
    Renderer _renderer;
    Collider _collider;
    public GameObject anim;                 // Define the animation that will be shown when the object to which this script is attached to is meets the condition of being green (see later)

    // Variable set in configuration that determine how quick the balloon changes color
    public static string duration = System.IO.File.ReadAllText(PointAndShoot.subjectPath + @"\Configuration\COLORDURATION.txt");           // Total amount of reaches
    public static float Duration = float.Parse(duration);

    // All things stated in Start void (of all scripts) will be executed at start of the game
    void Start()
    {
        // Get renderer and collider components of gameobject this script is attached to
        _renderer = GetComponent<Renderer>();
        _collider = GetComponent<Collider>(); 
        count = 0;                                                                  // Set count at 0 at the start of the game
    }

    // If the gameobject this script is attached to contains a collider component, this void is called whenever the gameobject collides with another gameobject (that contains a collider component) in the scene
    private void OnTriggerEnter(Collider other)
    {
        flagcount = true;                                                           // Set flag for counter active
    }

    // If the gameobject this script is attached to contains a collider component, this void is called every frame during which the gameobject collides with another gameobject (that contains a collider component) in the scene
    private void OnTriggerStay(Collider other)
    {
        if (flagcount)                                                              // If the flagcount is active after collision and objects are still colliding
        {
            lerpedColor = Color.Lerp(colorIni, colorFin, t);                        // Lerp the color of this gameobject from red to green
            t += Time.deltaTime / Duration;                                         // This determines the speed of the lerping 
            _renderer.material.color = lerpedColor;                                 // This sets the actual color of the gameobject according to the lerpedcolor variable
        }
        if (flagcount && _renderer.material.color == colorFin)                      // If the flagcount is active after collision and the renderer of the gameobject reaches green...
        {
            SetCountText();                                                         // Start function to perform all actions done when balloon reaches the green color
            PointAndShoot.InfoTable[PointAndShoot.repetition + 1, 4] = "Yes";       // Set item of information table that says whether the balloon is popped to "yes"
            PointAndShoot.InfoTable[PointAndShoot.repetition + 1, 5] = Time.time.ToString("n4");    // Set item of information table that says at what time the balloon is popped to the current game time
            print("Block: " + PointAndShoot.numBlocks + ", Repetition #" + PointAndShoot.repetition + ": Balloon Popped");      // Print information about this in the console window in Unity
            _collider.enabled = false;                                              // Disable the collider component of this gameobject to prevent the counter to add everytime the gameobject hits another collider
            flagcount = false;                                                      // Set flagcount inactive when color green is reached
        }
    }

    // This function performs all the actions needed when the gameobject this script is attached to reaches the color green
    void SetCountText()
    {
        anim.SetActive(true);                                                       // Set animation gameobject active
        countspark.SetActive(true);                                                 // Set spark behind count text active
        count++;                                                                    // Add one to the counter variable   
        countText.GetComponent<TMPro.TextMeshPro>().text = count.ToString();        // Set the count text to the new value of the count variable
    }
}