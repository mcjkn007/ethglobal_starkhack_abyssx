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

        public void HideUI()
        {
            (battleView.bottomFlyIn.transform as RectTransform).anchoredPosition -=  Vector2.up * 500f;
            (battleView.leftFlyIn.transform as RectTransform).anchoredPosition  -=  Vector2.right * 500f;
            (battleView.rightFlyIn.transform as RectTransform).anchoredPosition -=  Vector2.left * 500f;
        }

        /// <summary>
        /// UI飞入动画
        /// </summary>
        public void UIFlyIn()
        {
            float time = 0.5f;
            
           var seq = DOTween.Sequence().AppendInterval(0.4f).Append((battleView.bottomFlyIn as RectTransform).DOAnchorPosY(500f, time).SetRelative())
                .Join(( battleView.leftFlyIn as RectTransform).DOAnchorPosX(500f, time).SetRelative())
                .Join((battleView.rightFlyIn as RectTransform).DOAnchorPosX(-500f, time).SetRelative());
           seq.Play();
        }


    }
}