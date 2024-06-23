using System;
using System.Net.Mime;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using DG.Tweening.Core;
using GameCore.Facade;
using Utils;
using Random = UnityEngine.Random;

namespace Abyss
{
    public class JumpText : MonoBehaviour
    {
        public Text txt_value;

        public Graphic graphic;

        private void Awake()
        {
            this.graphic = GetComponent<Graphic>();
        }

        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.P))
            {
                Jump("12");
            }
        }

        public void Jump(string value)
        {
            Debug.LogError("Dmg delt" + value);
            gameObject.SetActive(true);
            this.txt_value.text = value;
            var currentScale = transform.localScale;
            
            graphic.color = Color.red;
            var multiplier = Random.Range(0, 2) == 0 ? -1 : 1;
            RectTransform rt = this.GetRectTransform();
            Color c = graphic.color;
            // c.a = 0;
            graphic.color = c;
            Sequence mySequence = DOTween.Sequence();
            this.GetRectTransform().DOKill(); 
            var startPos = this.GetRectTransform().anchoredPosition;
            var endPos = startPos + new Vector2(0.2f * multiplier, startPos.y - 0.2f);
            
            mySequence.Append(this.GetRectTransform().DOAnchorPosX(0.8f * multiplier, 0.6f).SetEase(Ease.Linear).SetRelative());
            mySequence.Insert(0, this.GetRectTransform().DOAnchorPosY(0.2f, 0.25f).SetEase(Ease.OutCirc).SetRelative());
            mySequence.Insert(0.4f, graphic.DOFade(0.0f, 0.1f));
            //下落
            mySequence.Insert(0.25f, this.GetRectTransform().DOAnchorPosY(-0.6f, 0.25f).SetEase(Ease.InCirc).SetRelative());
            mySequence.AppendCallback(() =>
            {
                this.GetRectTransform().anchoredPosition = startPos;
                gameObject.SetActive(false);
            });
            mySequence.Play();
        }
    }
}