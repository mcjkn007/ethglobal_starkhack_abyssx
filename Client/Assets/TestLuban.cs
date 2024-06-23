// using System.Collections;
// using System.Collections.Generic;
// using Luban;
// using System.IO;
// using UnityEngine;
// using UnityGameFramework.Runtime;
//
// public class TestLuban : MonoBehaviour
// {
//     // Start is called before the first frame update
//     void Start()
//     {
//         var tables = new cfg.Tables(LoadByteBuf);
//         var item = tables.TbItem.DataList[1];
//         UnityEngine.Debug.LogFormat("item[1]:{0}", item);
//
//         var refv = tables..DataList[0];
//         Debug.LogFormat("refv:{0}", refv.Name);
//         
//         Debug.LogFormat("== load succ==");
//     }
//
//     private static ByteBuf LoadByteBuf(string file)
//     {
//         return new ByteBuf(File.ReadAllBytes($"{Application.dataPath}/GenerateDatas/bytes/{file}.bytes"));
//     }
// }
