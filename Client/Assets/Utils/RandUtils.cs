using System.Numerics;
using UnityEngine;

namespace Utils
{
    public enum StageSeed{
         Game = 1012,
         Relic = 324,
         Card = 1009,
         Enemy = 321,
         Event = 123
    }
    public static class RandUtils
    {
        private static long RANDOM = 1;
        
        static long RANDOM_P1 = 1103515245;
        static long RANDOM_P2 = 12345;
        static long RANDOM_P3 = 65536;
        static long RANDOM_P4 = 0x7fffffff;
        public static BigInteger standard_seed = 0;
        private static bool StandardSeedModified = false;

        public static BigInteger GerRandomByStage(StageSeed different, int curStage)
        {
            var newseed = standard_seed;
            newseed += (int)different;
            for (int i = 0; i < curStage; i++)
            {
                newseed = (RANDOM_P1 * newseed + RANDOM_P2)  & RANDOM_P4;
            }
            Debug.LogError("standard_seed => " + standard_seed + ", " + newseed);
            return newseed;
        }

        public static int Random(ref BigInteger seed, int min, int max)
        {
            
            Debug.LogWarning(" random .seed = " + seed);
            seed = (RANDOM_P1 * seed + RANDOM_P2)  & RANDOM_P4;
            var result = min + seed % (max - min);
            if (int.TryParse((result.ToString()), out var intValue))
            {
                return intValue;
            }
            return -1;
        }

        public static int Random(BigInteger seed, int min, int max)
        {
            seed = (RANDOM_P1 * seed + RANDOM_P2)  & RANDOM_P4;
            var result = min + seed % (max - min);
            if (int.TryParse((result.ToString()), out var intValue))
            {
                return intValue;
            }
            return -1;
        }

        public static long RandomPlusOne(ref long seed, int min, int max)
        {
            seed = (RANDOM_P1 * seed + RANDOM_P2) / RANDOM_P3 & RANDOM_P4;
            return min + seed % (max - min + 1);
        }
    }
}