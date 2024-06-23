using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Numerics;
using Abyss;
using GameCore;
using Unity.VisualScripting;
using UnityEngine;

namespace Utils
{
    public static class FisherYatesShuffle
    {
        public static void Shuffle<T>(T[] array )
        {
            int n = array.Length;
            for (int i = n - 1; i > 0; i--)
            {
                BigInteger j = RandUtils.Random(ref RandUtils.standard_seed, 0, i + 1); // 生成一个0到i之间的随机数
              Debug.LogWarning($"swap {i} ,{j}");
                Swap(ref array[i], ref array[int.Parse(j.ToString())]);
            }

    
        }

        public static int[] GetRandomFourCards()
        {
            var arr = new int[51];
            for (int i = 0; i < 51; i++)
            {
                arr[i] = i + 1;
            }
            var newSeed = RandUtils.GerRandomByStage( StageSeed.Card, Entry.Core.Stage.Val);
            for (int i = arr.Length - 1; i > 0; i--)
            {
                BigInteger j = RandUtils.Random(ref newSeed, 0, i ); // 生成一个0到i之间的随机数
                Debug.LogWarning($"swap {i} ,{j}");
                Swap(ref arr[i], ref arr[int.Parse(j.ToString())]);
            }
            var head = "Array ranged ";
            foreach(var i in arr)
            {
                head += ", " + i;
            }
            Debug.LogWarning(head);
            return arr;
        }

        public static void Shuffle<T>(IList<T> array, ref BigInteger newSeed)
        {
            int n = array.Count;
            Debug.LogError(" swap once n = "  + n);
            IList<int> arr = new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
            for (int i = n - 1; i > 0; i--)
            {
                var j = RandUtils.Random(ref newSeed, 0, i ); // 生成一个0到i之间的随机数
                Debug.LogError(" swap once"  + j);
                array.SwapByIndex(i, j);
                arr.SwapByIndex(i, j);
            }
            
            Debug.LogError(" ==== ");
            (array as List<BaseCard>).ForEach(x=>Debug.LogError(x.GUID));

            for (int j = 0; j < n/2; j++)
            {
                array.SwapByIndex(j,n-j-1);
            }
        }

        private static void Swap<T>(ref T a, ref T b)
        {
            (a, b) = (b, a);
        }

        private static void SwapByIndex<T>(this IList<T> source, int a, int b) 
        {
            (source[a], source[b]) = (source[b], source[a]);
        }
    }
}