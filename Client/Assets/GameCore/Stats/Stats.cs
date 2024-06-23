using System.Collections.Generic;
using Abyss.Stat;
using GameFramework;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;

namespace GameCore.Stats
{
    public class Stats : IReference
    {
        private Dictionary<int, BaseGameBuff> _buffs = new Dictionary<int, BaseGameBuff>();

        public void Clear()
        {
            _buffs.Clear();
        }

        public void AddBuff(BaseGameBuff buff)
        {
            _buffs[buff.cfg.Id] = buff;
        }

        public void ModifyBuffLayer(int buffId, int destinationLayer)
        {
            if (_buffs.TryGetValue(buffId, out var value))
            {
                value.Layer = destinationLayer;
            }
        }

        public void RemoveBuff(int id)
        {
            if (_buffs.ContainsKey(id))
            {
                _buffs[id].GetHashCode();
                _buffs.Remove(id);
                //TODO 显示一些额外的UI动效
            }
        }

        public int QueryNormalAttack(in int originalValue, bool apply = true)
        {
            int returnValue = originalValue;
            foreach (var i in _buffs)
            {
                if (i.Key == (int)EnumGameBuff.Bleeding)
                {
                    //如果现在角色身上有流血buff
                    returnValue += i.Value.Layer;
                    if (apply)
                    {
                        i.Value.Layer = 0;
                    }
                }
            }
            return returnValue;
        }

        public int QueryArmorFromOther( int originValue, bool apply = true)
        {
            int rtn = originValue;
            foreach (var _buff in _buffs)
            {
                if (_buff.Key == (int)EnumGameBuff.Wounded)
                {
                    _buff.Value.Calculate(ref rtn);
                }
            }

            return rtn;
        }

        public void QueryArmorFromCard(ref int originValue, bool apply = true)
        {
            int rtn = originValue;
            foreach (var i in _buffs)
            {
                if (i.Key == (int)EnumGameBuff.Fragile)
                {
                    rtn = (int)( rtn * 0.75);
                }
            }
        }
        
        /// <summary>
        /// 当角色收到伤害时
        /// </summary>
        public int QueryDmged(in int originValue, bool apply = true)
        {
            foreach (var i in _buffs)
            {
                if (i.Key == (int)EnumGameBuff.DmgControl)
                {
                    
                    if (apply)
                    {
                        i.Value.Layer--;
                    }
                }

            }

            return 1;
        }

        public Stats()
        {
            
        }
    }
}