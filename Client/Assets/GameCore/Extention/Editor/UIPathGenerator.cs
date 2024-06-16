using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;
using System.Linq;
using System.Text;
using Unity.VisualScripting;
using UnityEditor.VersionControl;
using FileMode = System.IO.FileMode;

/// <summary>
/// 动态生成文件路径
/// </summary>
public class UIPathGenerator
{

    private static string s_pattern =
        @"
using UnityEngine;        
using UnityEngine.UI;
using System;

namespace Abyss
{{
    public static class UIPath
    {{ 
        #region start
        {0}
        #endregion    
    }}
}}        
";
    
    private static string s_singleLine =
        @"
        public static string {0} = ""{1}"" ;
";

    private static string s_csOutputPath = System.IO.Path.Combine(Application.dataPath, "Generated", "UIPath.cs");
    private static string[] s_strSplited;

    [MenuItem("工具/UI/自动生成UI路径")]
    public static void GenerateUIPath()
    {
        var directoryPath = System.IO.Path.Combine(Application.dataPath, "Generated");
        if (!Directory.Exists(directoryPath))
        {
            Directory.CreateDirectory(directoryPath);
        }

        if (!File.Exists(s_csOutputPath))
        {
            File.Create(s_csOutputPath);
        }

        var searchResult = AssetDatabase.FindAssets("t:prefab", new[] { "Assets/GameResource/UI" });
        var sb = new StringBuilder();

        foreach (var guid in searchResult)
        {
            var singleLineCode = DealtSinglePrefab(guid);
            sb.AppendLine(singleLineCode);
        }

        // s_pattern
        var finalScript = string.Format(s_pattern, sb.ToString());
        // if (!System.IO.File.Exists(s_csOutputPath))
        // {
        //     // Directory.CreateDirectory(s_csOutputPath);
        //     File.Create(s_csOutputPath);
        // }
        File.WriteAllText(s_csOutputPath, finalScript);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    private static string DealtSinglePrefab(string guid)
    {
        var path = AssetDatabase.GUIDToAssetPath(guid);
        s_strSplited = path.Split('\\', '/');
        var varName = s_strSplited[^1].Split('.')[0];
        //首字母大写
        varName = varName.Substring(0,1).ToUpper()+varName.Substring(1); 

        var resourcePos = Array.IndexOf( s_strSplited, "UI") + 1;
        var varPath = string.Join( '/', s_strSplited[resourcePos..]).Split('.')[0];
        var res = string.Format(s_singleLine, varName, "Assets/GameResource/UI/" +  varPath + ".prefab");
        return res;

    }
}