using UnityEngine;
using UnityGameFramework.Runtime;

namespace Utils
{
    public static class MathUtils
    {
        public static bool Have(this int original, int target)
        {
            return (original & (1 << target)) == 0;
        }

        public static Vector2[] GetBezierCurveTwice(Vector2 startPos, Vector2 endPos, int count = 15)
        {
            
            
            return default;
        }
        /// <summary>
        /// 获得定点数为15的三次贝塞尔曲线
        /// </summary>
        /// <param name="startPos"></param>
        /// <param name="controlPoint1"></param>
        /// <param name="endPos"></param>
        /// <param name="controlPoint2"></param>
        /// <param name="rtn"></param>
        public static void GetBezierCurveThreeTimesByQuantityOf18(Vector2 startPos,
            Vector2 controlPoint1,
            Vector2 endPos,
            Vector2 controlPoint2,
            Vector2[] rtn)

        {
            int count = rtn.Length;
            if (rtn == null )
            {
                Log.Error("请检查返回数组");
                return;
            }

            rtn[0] = startPos;
            for (int i = 1; i < count - 1; i++)
            {
                float t = i / (float)(count - 3); // t值从0到1均匀分布
                rtn[i] = Mathf.Pow(1 - t, 3) * startPos +
                         3 * Mathf.Pow(1 - t, 2) * t * controlPoint1 +
                         3 * (1 - t) * Mathf.Pow(t, 2) * controlPoint2 +
                         Mathf.Pow(t, 3) * endPos;
            }

            rtn[count - 1] = endPos;
        }
    }
}