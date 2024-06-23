using System.Collections;
using System.Linq;
using DG.Tweening;
using GameCore;
using GameFramework.Resource;
using GameFramework.UI;
using UnityEditor.Timeline.Actions;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.Pool;
using UnityGameFramework.Runtime;

namespace Abyss
{
    public  class SequenceFactory :  GameFrameworkComponent
    {
        private static IObjectPool<Sequence> _pool;
        private static int FactoryGUID = 0;
        public static long GUID = 0;
        
        private IObjectPool<Sequence> pool
        {
            get
            {   
                if (_pool == null)
                {
                    _pool = new LinkedPool<Sequence>(
                        CreateCallback,
                        GetCallback,
                        ReleaseCallback,
                        DestroyCallback,
                        collectionCheck : true,
                        maxSize : 10000);
                }
                return _pool;
            }
        }
        
        public Sequence GetCard(int cfgId, Transform parent = null)
        {
            var rtn = pool.Get();
            rtn.Complete();
            return rtn;
        }

        private  Sequence CreateCallback()
        {
            var model = DOTween.Sequence();
            return model;
        }


        private static void GetCallback(Sequence seq)
        {
        }

        private static void ReleaseCallback(Sequence seq)
        {
        }

        private static void DestroyCallback(Sequence seq)
        {
            
        }
    }
}