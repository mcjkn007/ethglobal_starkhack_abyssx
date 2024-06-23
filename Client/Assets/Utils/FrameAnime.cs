using System;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace Utils
{
    [ExecuteAlways]
    public class FrameAnime : MonoBehaviour
    {
        public Sprite[] sprites;
        private Image img;
        private void Awake()
        {
            img = GetComponent<Image>();
            length = sprites.Length;
        }

        private int flag = 0;
        private int length;
        IEnumerator  Start()
        {
            while (true)
            {
                Debug.LogWarning("One Frame Passed" + flag);
                flag++;
                img.sprite = sprites[flag % length];
                yield return null;
            }
            yield break;
        }
    }
}