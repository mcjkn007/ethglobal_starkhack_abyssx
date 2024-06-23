using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using Abyss;
using dojo_bindings;
using GameCore;
using UnityEngine;
using UnityGameFramework.Runtime;

namespace Utils
{
    public static class TypeExt
    {
        public static ICollection<Type> GetAllTypesInNamespace(string @namespace)
        {
            return Assembly.GetExecutingAssembly().GetTypes().Where(x =>

                String.Equals(x.Namespace, @namespace, StringComparison.Ordinal)).ToArray();
        }

        public static void Print(this IList<BaseCard> original, string append = "")
        {
            for (int i = 0; i < original.Count; i++)
            {
                append += $"第{i}张卡片： {original[i].CardInfo.Name} \n";
            }
            Log.Info(append);
        }

        public static void Print(this IList<int> original, string append = "")
        {
            if (original == null)
            {
                Debug.LogWarning("Original = null" + "");
            }

            for (int i = 0; i < original.Count; i++)
            {
                append += $"第{i}张卡片是 ： {Entry.Luban.Tables.TbCardModel[original[i]].Name}";
            }
            Log.Info(append);

        }
        public static string ToHex(this string input)
        {
            StringBuilder hex = new StringBuilder(input.Length * 2);
            foreach (char c in input)
            {
                hex.AppendFormat("{0:x2}", (int)c);
            }
            return "0x" + hex.ToString();
        }


        public static void Print(this IEnumerable arr, string extraHead = "")
        {
            extraHead += $"\n{nameof(arr)} 内容遍历： \n";
            int idx = 0;
            var enu = arr.GetEnumerator();
            while (enu.MoveNext())
            {
                extraHead += $"第{idx ++}个元素是 {enu.Current} \n";
            }
            Debug.Log(extraHead);
        }

        public static void Print(this object obj, string extraHead = "")
        {
            var type = obj.GetType();
            extraHead += $" \n {nameof(obj)} 类遍历： \n";
            foreach (var property in type.GetProperties())
            {
                if (property.PropertyType.IsNotPublic)
                {
                    continue;
                }

                var value = property.GetValue(obj);
                extraHead += ($"{property.Name} = {value} \n");
            }
        }

        public static void Dump(this  IEnumerable<dojo.FieldElement> Elements)
        {
            string header = " FieldElement 打印：\n";
            int idx = 0;
            foreach (var ele in Elements)
            {
                header += $"第{idx++}个元素： ";
                foreach (var data in ele.data)
                {
                    header += data.ToString() + ",";
                }

                header += "\n";
            }
        }
    }
}