using System.Linq;
using Abyss;
using GameFramework.Resource;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityGameFramework.Runtime;
using Utils;

namespace GameCore.Facade
{
    public static class Facade
    {
        public static float CardWidth = 272;            
        public static float CardHeight = 324;            

        public static LoadAssetCallbacks LoadCallback =  new LoadAssetCallbacks(OnResourceLoadSuccessfully, OnResourceLoadFailly);
        public static void OnResourceLoadSuccessfully(string assetName,
            object asset,
            float duration,
            object userData)
        {
            Debug.LogWarning("资源读取成功！" + assetName + " 资源类型" + (asset).GetType() );
        }
        public static void OnResourceLoadFailly(string assetName,
            LoadResourceStatus status,
            string errorMessage,
            object userData)
        {
            Debug.LogWarning("资源读取失败！" + assetName + " 资源失败原因" + (status));
        }
        public static Vector3 ScreenToWorld(Vector3 screenPoint)
        {
            return GameCore.Entry.Core.UICamera.ScreenToWorldPoint(screenPoint);
        }

        public static Vector3 WorldToScreen(Vector3 worldPoint)
        {
            return GameCore.Entry.Core.UICamera.WorldToScreenPoint(worldPoint);
        }

        public static void OnBaseCardDrag(Vector2[] splinePoints)
        {
            var battleForm = Entry.Core.battleLogic;
            battleForm.battleForm.splinePointer.SetSpline(splinePoints);
        }

        public static void HideSplinePointer()
        {
            // var battleForm = Entry.UI.GetUIForm(UIPath.Battle).GetComponent<UIBattleLogic>();
            var battleForm = Entry.Core.battleLogic;
            battleForm.battleForm.splinePointer.TransferSpline();
        }

        /// <summary>
        /// 手牌X轴重新排列；如果传参，则会围绕这传进来的card左右侧做分海操作；如果不传参则调整至默认位置
        /// </summary>
        /// <param name="baseCard"></param>
        public static void HandCardReposition(BaseCard baseCard = null)
        {
            var battleForm = Entry.Core.battleLogic;
            var cardSet = battleForm.cardSet;
            cardSet.HorizontalHandcardReposition(baseCard);
        }
        
        public static void HandToDiscard(BaseCard baseCard )
        {
            Log.Warning("Hand To Discard");
            var battleForm = Entry.Core.battleLogic;
            var cardSet = battleForm.cardSet;
            cardSet.CardFromHandToDiscardPile(baseCard,cardSet.handCard.Count - 1);
        }

        public static float[] GetCardPositions(int cardQuantity)
        {   
            float[] positions = new float[cardQuantity];
            float centerInterval = cardQuantity % 2 == 0 ? CardWidth / 4f : 0;
            float interval =  CardWidth / 2f;
            for (int i = 0; i < positions.Length; i++)
            {   
                positions[i] = interval *  (i - cardQuantity / 2) + centerInterval;
            }  
            positions.Print($"This positions => total len = {positions.Length}");
            return positions;
            var battleForm = Entry.UI.GetUIForm(UIPath.Battle).GetComponent<UIBattleLogic>();
        }
        public static Vector2 Parabola(Vector2 start, Vector2 end, float height, float t)
        {
            float Func(float x) => 4 * (-height * x * x + height * x);

            var mid = Vector2.Lerp(start, end, t);

            return new Vector2(mid.x, Func(t) + Mathf.Lerp(start.y, end.y, t));
        }
    }
}