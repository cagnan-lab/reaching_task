using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Collision : MonoBehaviour
{
    public Text countText;
    public static int count;

    public Color colorIni = Color.red;
    public Color colorFin = Color.green;
    public float duration = 3.5f;
    Color lerpedColor = Color.red;

    public static float t = 0;
    private bool flagcount;

    Renderer _renderer;

    void Start()
    {
        _renderer = GetComponent<Renderer>();
        count = 0;
        SetCountText();
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
            t += Time.deltaTime / duration;
            _renderer.material.color = lerpedColor;
        }
        if (flagcount && _renderer.material.color == colorFin)
        {
            count++;
            SetCountText();
            print("Block: " + PointAndShoot.numBlocks + ", Repetition #" + PointAndShoot.repetition + ": Balloon Popped");
            flagcount = false;
        }
    }

    void SetCountText()
    {
        countText.text = "Count: " + count.ToString();
    }
}



