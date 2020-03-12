using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseScript : MonoBehaviour
{
    public GameObject PauseText;
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (Time.timeScale == 1)
            {
                Time.timeScale = 0;
                PauseText.SetActive(true);
            }
            else if (Time.timeScale == 0)
            {
                Time.timeScale = 1;
                PauseText.SetActive(false);
            }
        }
    }
}
