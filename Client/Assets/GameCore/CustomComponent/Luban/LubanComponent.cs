using System.Collections;
using Luban;
using UnityGameFramework.Runtime;
using System.IO;
using UnityEngine;

namespace Abyss
{
    /// <summary>
    /// 基础组件。
    /// </summary>
    [DisallowMultipleComponent]
    [AddComponentMenu("Game Framework/Luban")]
    public sealed class LubanComponent : GameFrameworkComponent
    {
        protected override void Awake()
        {
            base.Awake();
            LoadTable();
        }

        public cfg.Tables Tables; 
        public void LoadTable()
        {
            Tables = new cfg.Tables(LoadByteBuf);
            // var item = tables.TbItem.DataList[1];
            // UnityEngine.Debug.LogFormat("item[1]:{0}", item);
            //
            // var refv = tables.TbReward.DataList[0];
            // Debug.LogFormat("refv:{0}", refv.Name);
            
            Debug.LogFormat("== load succ==");
        }
        
        private static ByteBuf LoadByteBuf(string file)
        {
            var filePath = $"{Application.dataPath}/GenerateDatas/bytes/{file}.bytes";
            var bytes = File.ReadAllBytesAsync(filePath); 
            return new ByteBuf(File.ReadAllBytes($"{Application.dataPath}/GenerateDatas/bytes/{file}.bytes"));
        }
        // private IEnumerator LoadFileCoroutine(string file)
        // {
        //     byte[] fileData = null;
        //     var filePath = $"{Application.dataPath}/GenerateDatas/bytes/{file}.bytes";
        //
        //     // 在非阻塞的线程上运行文件读取
        //     yield return new WaitUntil(() =>
        //     {
        //         try
        //         {
        //             fileData = File.ReadAllBytes(filePath);
        //             return true;
        //         }
        //         catch (IOException)
        //         {
        //             Debug.LogError("Error reading file");
        //             return false; // Stop waiting if an error occurs
        //         }
        //     });
        //
        //     // 文件读取完成后的操作
        //     Debug.Log("File loaded, bytes count: " + fileData.Length);
        // }
        public void StartToLoadAllTables()
        {
            
        }
        
        public void GetNumbers(){}
    }
}