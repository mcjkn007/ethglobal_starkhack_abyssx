using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

public class ConfirReader
{
    [MenuItem("Luban/LubanLoadTable")]
    public static void ParseTables()
    {
        var tempPath = "";
        var procFile = "";
#if UNITY_EDITOR_WIN
        tempPath = Application.dataPath + "/../gen.bat";
         procFile = "cmd.exe";
#else
         tempPath = Application.dataPath + "/../gen.sh";
        procFile = "/bin/bash";

#endif
        // var tempPath = "/Users/aaaaa/Downloads/luban_examples-main/Projects/Csharp_Unity_bin/gen.sh";
        var process = new System.Diagnostics.Process();
        //调用一个外部的shell文件
        ProcessStartInfo procStartInfo = new ProcessStartInfo(procFile,tempPath )
        {
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false, // 必须禁用shell执行，以便重定向
            CreateNoWindow = true // 防止创建新窗口
        };

        using (Process proc = new Process())
        {
            proc.StartInfo = procStartInfo;
            // proc.StartInfo.WorkingDirectory = ;
            // proc.StartInfo.EnvironmentVariables["DOTNET_ROOT"] = "/path/to/dotnet";
            proc.StartInfo.EnvironmentVariables["LANG"] = "en_US.UTF-8";
            proc.StartInfo.EnvironmentVariables["LC_ALL"] = "en_US.UTF-8";
            proc.Start();
            
            // 读取标准输出流
            string result = proc.StandardOutput.ReadToEnd();
            Debug.Log("Shell Script Output: " + result);

            // 读取错误流
            string error = proc.StandardError.ReadToEnd();
            if (!string.IsNullOrEmpty(error))
            {
                Debug.LogError("Shell Script Error: " + error);
            }
        }
    }
}
