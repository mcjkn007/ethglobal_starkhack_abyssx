using System.Linq;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.PlayerLoop;
using Utils;

namespace Abyss
{
    public class SplinePointer : MonoBehaviour
    {
        
        [SerializeField]
        private Image[] imgs;
        [SerializeField]
        private Image endImg;
        
        public void SetSpline(Vector2[] positions)
        {


            if (positions == null || positions.Length != (imgs.Length + 1))
            {
                return;
            }

            if (!gameObject.activeSelf)
            {
                gameObject.SetActive(true);
            }
            
            for (int i = 0; i < positions.Length; i++)
            {
                if (i != positions.Length - 1)
                {
                    //如果不是最后一个元素
                    (imgs[i].transform as RectTransform).anchoredPosition = positions[i];
                    (imgs[i].transform as RectTransform).LookAtUI(positions[i + 1]);
                }
                else
                {   
                    //如果当前是最后一个元素 需要额外特殊处理
                    (endImg.transform as RectTransform).anchoredPosition = positions[i];
                    var offset =  positions[i - 1] - positions[i];
                    (endImg.transform as RectTransform).LookAtUI(positions[i] + offset); 
                }
                
            }
        }

        public void ShowSpline()
        {
            gameObject.SetActive(true);
        }

        public void HideSpline()
        {
            gameObject.SetActive(false);
        }

    }
}