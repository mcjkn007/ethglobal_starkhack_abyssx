using UnityEngine;
using UnityGameFramework.Runtime;

using Abyss;
using Unity.VisualScripting;

namespace GameCore
{
    public partial class Entry : MonoBehaviour
    {
        public static LubanComponent Luban { private set; get; }

        public static CoreComponent Core
        {
            private set;
            get;
        }

        public static CardFactory CardFactory
        {
            private set;
            get;
        }


        public static void InitCustomComponent()
        {
            Luban = UnityGameFramework.Runtime.GameEntry.GetComponent<LubanComponent>();
            Core = UnityGameFramework.Runtime.GameEntry.GetComponent<CoreComponent>();
            CardFactory = UnityGameFramework.Runtime.GameEntry.GetComponent<CardFactory>();
        }
    }
}