using System;
using Abyss;
using GameFramework;
using GameFramework.Event;
using GameCore.Stats;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.PlayerLoop;
using Stats = GameCore.Stats;

namespace GameCore.CustomComponent.Role
{
    public class BaseRole : MonoBehaviour, IRole
    {
        public Stats.Stats Stat;
        private int maxHp = 80;

        private int hp;

        public int Hp
        {
            set
            {
                if (hp == value)
                {
                    return;
                }

                this.hp = value;
                var arg = ReferencePool.Acquire<OnHpModified>();
                arg.value = hp;
                arg.role = this;
                Entry.Event.Fire(this, arg);
            }
            get => hp;
        }

        private int armor;

        public int Armor
        {
            set
            {
                if (armor == value)
                {
                    return;
                }

                this.armor = value;
                var arg = ReferencePool.Acquire<OnArmorModified>();
                arg.value = this.armor;
                arg.role = this;
                Entry.Event.Fire(this, arg);
            }
            get => armor;
        }
        
        public void OnBorn()
        {
            GameCore.Entry.Event.Subscribe(BuffLayerModifyEventArgs.EventId, OnBuffLayerModified);
            this.Stat = ReferencePool.Acquire<GameCore.Stats.Stats>();
        }
        /// <summary>
        /// buff层级修改时，通知到父级对象
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="args"></param>
        private void OnBuffLayerModified(object sender, GameEventArgs args)
        {
            if ((object)args is BuffLayerModifyEventArgs arg)
            {
                if (!ReferenceEquals(this, arg.Owner)) return;
                if (arg.DestinationLayer == 0)
                {
                    this.Stat.RemoveBuff(arg.BuffId);  
                }
                else
                {   
                    this.Stat.ModifyBuffLayer(arg.BuffId, arg.DestinationLayer);
                }
            }
        }

        public void OnDeath()
        {
            GameCore.Entry.Event.Unsubscribe(BuffLayerModifyEventArgs.EventId, OnBuffLayerModified);    
        }
    }
}