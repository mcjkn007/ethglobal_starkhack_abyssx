
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using UnityEngine;        
using UnityEngine.UI;
using System;
using DG.Tweening;
using GameCore.Stats;
using GameCore.CustomComponent.Role;
using GameCore;

namespace Abyss.Stat
{
    /// <summary>
    /// 免疫下 1 次使用卡牌受到的伤害。
    /// </summary>
    [GameBuff(30006)]
    public class Buff_DmgControl : BaseGameBuff
    {
        public override void OnRoundStart()
        {
            base.OnRoundStart();

        }
        
        public override void OnRoundEnd()
        {
            base.OnRoundEnd();

        }

        public override void OnApply()
        {
            base.OnApply();

        }
        public override void Calculate(ref int originalValue)
        {
            originalValue = 0;
        }

        public Buff_DmgControl(BaseRole owner, GameBuffView view) : base(owner, view)
        {
            this.cfg = Entry.Luban.Tables.TbGameBuff.DataMap[30006];
        }
    }
}        
