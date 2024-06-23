using System.Collections;
using System.Linq;
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
    public  class CardFactory :  GameFrameworkComponent
    {
        [SerializeField]
        private BaseCard _model;
        private static IObjectPool<BaseCard> _pool;
        private static int FactoryGUID = 0;
        public static long GUID = 0;
        
        private IObjectPool<BaseCard> pool
        {
            get
            {   
                if (_pool == null)
                {
                    _pool = new LinkedPool<BaseCard>(
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
        
        public  BaseCard GetCard(int cfgId, long guid, Transform parent = null)
        {
            var rtn = pool.Get();
            rtn.transform.SetParent(parent);
            rtn.transform.localScale = Vector3.one;
            rtn.gameObject.SetActive(false);
            rtn.Init(cfgId, guid );
            return rtn;
        }

        private  BaseCard CreateCallback()
        {
            var model = BaseCard.Instantiate(_model, null,false);
            model.transform.localScale = Vector3.one;
            
            model.gameObject.SetActive(false);
            return model;
        }


        private static void GetCallback(BaseCard card)
        {
            card?.gameObject.SetActive(true);
        }

        private static void ReleaseCallback(BaseCard card)
        {
            card?.gameObject.SetActive(false);
        }

        private static void DestroyCallback(BaseCard card)
        {
            
        }
    }
}