
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
    /// 目标造成的攻击伤害减少 25%。
    /// </summary>
    [GameBuff(30002)]
    public class Buff_Weak : BaseGameBuff
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

        }

        public Buff_Weak(BaseRole owner, GameBuffView view) : base(owner, view)
        {
            this.cfg = Entry.Luban.Tables.TbGameBuff.DataMap[30002];
        }
    }
}        