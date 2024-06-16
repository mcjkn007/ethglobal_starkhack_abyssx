using System.Diagnostics;
using UnityEngine;
using UnityGameFramework.Runtime;

namespace GameCore
{
    public  partial class Entry : MonoBehaviour
    {
        public static BaseComponent Base
        {
            private set;
            get;
        }
        
        public static DebuggerComponent Debugger
        {
            private set;
            get;
        }

        public static DownloadComponent Download
        {
            private set;
            get;
        }

        public static EntityComponent Entity
        {
            private set;
            get;
        }

        public static EventComponent Event
        {
            private set;
            get;
        }

        public static FileSystemComponent FileSystem
        {
            private set;
            get;
        }

        public static WebRequestComponent WebRequest
        {
            private set;
            get;
        }

        public static FsmComponent Fsm
        {
            private set;
            get;
        }

        public static LocalizationComponent Localization
        {

            private set;
            get;
        }

        public static NetworkComponent Network
        {
            private set;
            get;
        }

        public static ProcedureComponent Procedure
        {

            private set;
            get;
        }

        public static ObjectPoolComponent ObjectPool
        {
            private set;
            get;
        }

        public static ResourceComponent Resource
        {

            private set;
            get;
        }

        public static SettingComponent Setting
        {

            private set;
            get;
        }

        public static SoundComponent Sound
        {
            private set;
            get;
        }





        public static SceneComponent Scene
        {
            private set;
            get;
        }

        public static UIComponent UI
        {
            private set;
            get;
        }

        private static void InitBuiltinComponents()
        {
            Base = UnityGameFramework.Runtime.GameEntry.GetComponent<BaseComponent>();
            // Config = UnityGameFramework.Runtime.GameEntry.GetComponent<ConfigComponent>();
            // DataNode = UnityGameFramework.Runtime.GameEntry.GetComponent<DataNodeComponent>();
            // DataTable = UnityGameFramework.Runtime.GameEntry.GetComponent<DataTableComponent>();
            Debugger = UnityGameFramework.Runtime.GameEntry.GetComponent<DebuggerComponent>();
            Download = UnityGameFramework.Runtime.GameEntry.GetComponent<DownloadComponent>();
            Resource = UnityGameFramework.Runtime.GameEntry.GetComponent<ResourceComponent>();
            Entity = UnityGameFramework.Runtime.GameEntry.GetComponent<EntityComponent>();
            Event = UnityGameFramework.Runtime.GameEntry.GetComponent<EventComponent>();
            FileSystem = UnityGameFramework.Runtime.GameEntry.GetComponent<FileSystemComponent>();
            Fsm = UnityGameFramework.Runtime.GameEntry.GetComponent<FsmComponent>();
            Localization = UnityGameFramework.Runtime.GameEntry.GetComponent<LocalizationComponent>();
            Network = UnityGameFramework.Runtime.GameEntry.GetComponent<NetworkComponent>();
            ObjectPool = UnityGameFramework.Runtime.GameEntry.GetComponent<ObjectPoolComponent>();
            Procedure = UnityGameFramework.Runtime.GameEntry.GetComponent<ProcedureComponent>();
            Scene = UnityGameFramework.Runtime.GameEntry.GetComponent<SceneComponent>();
            Setting = UnityGameFramework.Runtime.GameEntry.GetComponent<SettingComponent>();
            Sound = UnityGameFramework.Runtime.GameEntry.GetComponent<SoundComponent>();
            UI = UnityGameFramework.Runtime.GameEntry.GetComponent<UIComponent>();
            WebRequest = UnityGameFramework.Runtime.GameEntry.GetComponent<WebRequestComponent>();
        }
    }
}