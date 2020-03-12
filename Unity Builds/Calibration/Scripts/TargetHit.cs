using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class TargetHit : MonoBehaviour
{
    public Color colorIni = Color.red;
    public Color colorFin = Color.green;
    public float duration = 5f;
    Color lerpedColor = Color.red;

    public static float t = 0;
    private bool flagcount;

    public static Renderer _renderer;
    
    void Start()
    {
        _renderer = GetComponent<Renderer>();
        flagcount = false;
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

            //Calibration.position 

        }
        if (flagcount && _renderer.material.color == colorFin)
        {
            print("Calibration Point Green");
            flagcount = false;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        flagcount = false;
    }


}



