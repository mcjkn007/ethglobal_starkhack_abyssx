using UnityEngine;
using UnityEngine.UI;

namespace Utils
{
    public static class UnityExt
    {
        public static RectTransform GetRectTransform(this MonoBehaviour mono)
        {
            return mono.transform as RectTransform;
        }

        public static Vector2 ScreenToMidAnchoredPosition(this Vector2 screenPos)
        {
            Vector2 vector2 = new Vector2();
            vector2.x = (screenPos.x - Screen.width / 2f);
            vector2.y = (screenPos.y - Screen.height / 2f);
            return vector2;
        }

        //获取UI的屏幕坐标【0,1】
        public static Vector2 GetUIScreenPosition(this RectTransform ui)
        {
            //获取到UI所处的canvas
            Canvas canvas = ui.GetComponentInParent<Canvas>();

            //Overlay模式 或者 ScreenSpaceCamera模式没有关联UI相机的情况
            if (canvas.renderMode == RenderMode.ScreenSpaceOverlay || 
                canvas.renderMode == RenderMode.ScreenSpaceCamera && canvas.worldCamera == null)
            {
                float x = ui.transform.position.x / Screen.width;
                float y = ui.transform.position.y / Screen.height;
                return new Vector2(x, y);
            }
            //ScreenSpaceCamera 和 WorldSpace模式  注意WorldSpace没有关联UI相机获取到的就会有问题
            else
            {
                Vector2 screenPos = RectTransformUtility.WorldToScreenPoint(canvas.worldCamera, ui.transform.position);
                float x = screenPos.x / Screen.width;
                float y = screenPos.y / Screen.height;
                return new Vector2(x, y);
            }
        }

    }
}