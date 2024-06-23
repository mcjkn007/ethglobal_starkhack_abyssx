using System.Collections;
using System.Data;
using System.Linq;
using GameCore;
using GameCore.CustomComponent.Role;
using GameFramework.Resource;
using GameFramework.UI;
using UnityEditor.Timeline.Actions;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.Pool;
using UnityGameFramework.Runtime;

namespace Abyss
{
    public  class RoleFactory :  GameFrameworkComponent
    {
        [SerializeField]
        private BaseRole _model;
        [SerializeField]
        private BaseRole _enemy1;
        [SerializeField]
        private BaseRole _enemy2;
        private static IObjectPool<BaseRole> _pool;
        private static int FactoryGUID = 0;
        public static long GUID = 0;

        private IObjectPool<BaseRole> Pool
        {
            get
            {   
                if (_pool == null)
                {
                    _pool = new LinkedPool<BaseRole>(
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
        //
        // private IObjectPool<BaseRole> EnemyPool
        // {
        //     get
        //     {   
        //         if (_pool == null)
        //         {
        //             _pool = new LinkedPool<BaseRole>(
        //                 CreateCallback,
        //                 GetCallback,
        //                 ReleaseCallback,
        //                 DestroyCallback,
        //                 collectionCheck : true,
        //                 maxSize : 10000);
        //         }
        //         return _pool;
        //     }
        // }

        public  BaseRole GetRole(int cfgId, Transform parent = null, bool isEnemy = true)
        {
            var rtn = Pool.Get();
            rtn.transform.SetParent(parent);
            rtn.transform.localScale = Vector3.one;
            rtn.gameObject.SetActive(true);
            rtn.transform.position = new Vector2(isEnemy ? BaseRole.rightPos : BaseRole.leftPos, BaseRole.verticalPos);
            rtn.Init(  rtn.GUID, cfgId );
            return rtn;
        }

        public BaseRole GetRole(int cfgId, int MaxHp, Transform parent = null, bool isEnemy = true)
        {
            var rtn = Pool.Get();
            rtn.transform.SetParent(parent);
            rtn.transform.localScale = Vector3.one;
            rtn.gameObject.SetActive(true);
            rtn.transform.position = new Vector2(isEnemy ? BaseRole.rightPos : BaseRole.leftPos, BaseRole.verticalPos);
            rtn.Init( rtn.GUID, cfgId );
            rtn.SetInitState(MaxHp);
            return rtn;
        }

        public void GetEnemy(int cfgId , int maxHp, Transform parent = null)
        {
            // BaseRole baseRole;
            // if (roleId == 1)
            // {
            //     baseRole = Instantiate(_enemy1);
            // }
            // else
            // {
            //     baseRole = Instantiate(_enemy2);
            // }
            // baseRole.Init(21,cfgId );
            // baseRole.gameObject.SetActive(true);
            // baseRole.transform.position = new Vector2(BaseRole.rightPos, baseRole.transform.position.y);
            // baseRole.SetInitState(maxHp);
            // return baseRole;
        }


        private  BaseRole CreateCallback()
        {
            var model = BaseCard.Instantiate(_model, null,false);
            model.transform.localScale = Vector3.one;
            
            model.gameObject.SetActive(false);
            return model;
        }


        private static void GetCallback(BaseRole role)
        {
            role?.gameObject.SetActive(true);
        }

        private static void ReleaseCallback(BaseRole role)
        {
            role?.gameObject.SetActive(false);
        }

        private static void DestroyCallback(BaseRole card)
        {
            
        }

        public void CreateEnemyByStage(int stage)
        {
            var role = GetRole(12);
            //1 异教徒
            //5 精英怪
            //13 boss
        }
    }
}