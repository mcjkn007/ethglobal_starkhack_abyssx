using System.Runtime.CompilerServices.Events;
using GameCore;
using Unity.VisualScripting;
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

        public static void AnylyseOpt(this Opt source)
        {
            if (source.code == new EventCode.Login())
            {
                Debug.LogError("opt.code =>  Login");
            }
            else if (source.code == new EventCode.StartGame())
            {
                Debug.LogError("opt.code =>  startGame");
            }
            else if (source.code == new EventCode.GiveUpGame())
            {
                Debug.LogError("opt.code =>  GiveUpGame");
            }
        }
        public static void InformOpt(this Opt source)
        {
            if (source.code == new EventCode.Login())
            {
                Entry.Event.Fire(DojoStateLogin.EventId, null);
                Debug.LogError("opt.code =>  Login");
            }
            else if (source.code == new EventCode.StartGame())
            {
                Entry.Event.Fire(DojoStateStartGame.EventId, null);
                Debug.LogError("opt.code =>  startGame");
            }
            else if (source.code == new EventCode.GiveUpGame())
            {
                Entry.Event.Fire(DojoStateGiveUpGame.EventId, null);
                Debug.LogError("opt.code =>  GiveUpGame");
            }
        }

    }
}