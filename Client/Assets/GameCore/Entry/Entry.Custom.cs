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
        public static RoleFactory RoleFactory
        {
            private set;
            get;
        }

        public static SequenceFactory SequenceFactory
        {
            private set;
            get;
        }


        public static CardActionComponent CardAction
        {
            private set;
            get;
        }

        public static DojoComponent Dojo
        {
            private set;
            get;
        }

        public static void InitCustomComponent()
        {
            Luban = UnityGameFramework.Runtime.GameEntry.GetComponent<LubanComponent>();
            Core = UnityGameFramework.Runtime.GameEntry.GetComponent<CoreComponent>();
            CardFactory = UnityGameFramework.Runtime.GameEntry.GetComponent<CardFactory>();
            RoleFactory = UnityGameFramework.Runtime.GameEntry.GetComponent<RoleFactory>();
            CardAction = UnityGameFramework.Runtime.GameEntry.GetComponent<CardActionComponent>();
            Dojo = UnityGameFramework.Runtime.GameEntry.GetComponent<DojoComponent>();
            SequenceFactory = UnityGameFramework.Runtime.GameEntry.GetComponent<SequenceFactory>();
        }
    }
}