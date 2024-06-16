using Abyss;
using Unity.Mathematics;
using UnityEngine;
using Utils;

namespace GameCore.Facade
{
    public static class Facade
    {
        public static float CardWidth = 272;            
        public static float CardHeight = 324;            


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
            var battleForm = Entry.UI.GetUIForm(UIPath.Battle).GetComponent<UIBattleLogic>();
            battleForm.battleForm.splinePointer.SetSpline(splinePoints);
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
            return positions;
            var battleForm = Entry.UI.GetUIForm(UIPath.Battle).GetComponent<UIBattleLogic>();
        }
    }
}