using System;
using System.Linq;
using System.Security.Cryptography;
using DG.Tweening;
using GameCore;
using GameCore.Facade;
using GameFramework.Event;
using UnityEditor.AssetImporters;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Abyss
{
    public class BattleFormController
    {
        private Sequence _sequence = DOTween.Sequence();
        private UIBattleLogic battleLogic;
        private UIBattleForm battleView;

        public BattleFormController(UIBattleLogic battlelogic, UIBattleForm battleForm)
        {
            this.battleLogic = battleLogic;
            this.battleView = battleForm;
        }

        public void DrawCard(object sender, GameEventArgs args)
        {
            battleLogic.GiveCard(Entry.Core.protag.GetInstanceID(), CardPlace.Draw, CardPlace.Hand);
        }

        public void OnPropertyChange(object sender, GameEventArgs args)
        {
            if (args is not OnBuffLayerModified arg)
            {
                return;
            }
            
            if (arg.role != Entry.Core.protag)
            {
                return;
            }
            // if(Entry.Luban.Tables.TbGameBuff[arg.buffId])
        }
        
       
    }
}