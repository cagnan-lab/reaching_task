using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Collision : MonoBehaviour
{
    public GameObject countspark;
    public GameObject countText;
    public static int count;

    public Color colorIni = Color.red;
    public Color colorFin = Color.green;
    Color lerpedColor = Color.red;

    public static float t = 0;
    private bool flagcount;

    Renderer _renderer;
    public GameObject anim;

    public static string duration = System.IO.File.ReadAllText(PointAndShoot.subjectPath + @"\Configuration\COLORDURATION.txt");           // Total amount of reaches
    public static float Duration = float.Parse(duration);

    void Start()
    {
        _renderer = GetComponent<Renderer>();
        count = 0;
    }

    private void OnTriggerEnter(Collider other)
    {
        flagcount = true;
    }

    private void OnTriggerStay(Collider other)
    {
        if (flagcount)
        {
            lerpedColor = Color.Lerp(colorIni, colorFin, t);
            t += Time.deltaTime / Duration;
            _renderer.material.color = lerpedColor;
        }
        if (flagcount && _renderer.material.color == colorFin)
        {
            //PointAndShoot._rendererScore.material.color = colorFin;
            SetCountText();
            PointAndShoot.InfoTable[PointAndShoot.repetition + 1, 4] = "Yes";
            PointAndShoot.InfoTable[PointAndShoot.repetition + 1, 5] = Time.time.ToString("n4");
            print("Block: " + PointAndShoot.numBlocks + ", Repetition #" + PointAndShoot.repetition + ": Balloon Popped");            
            flagcount = false;
        }
    }

    void SetCountText()
    {
        anim.SetActive(true);
        countspark.SetActive(true);
        count++;
        //countText.text = "Count: " + count.ToString();
        countText.GetComponent<TMPro.TextMeshPro>().text = count.ToString();
    }
}