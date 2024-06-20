using System;
using System.Collections;
using System.Collections.Generic;
using cfg.gameCard;
using GameCore;
using GameCore.CustomComponent.Role;
using GameCore.Facade;
using GameFramework.Event;
using Unity.VisualScripting;
using UnityEngine;
using UnityGameFramework.Runtime;
using Utils;
namespace  Abyss
{
    public enum CardPosition
    {
        handcard = 0,
        discard = 1,
        draw = 2,
        totalDeck = 3
    }

    public class UIBattleLogic : UIFormLogic
    {
        
        [SerializeField]
        public CardSet cardSet;
        public UIBattleForm battleForm;
        public BattleFormController battleFormController;
        public CardPanelForm cardPanelForm;
        public CardPanelLogic cardPanelLogic;
        private List<BaseCard> temp = new List<BaseCard>();
        

        [SerializeField]
        private BaseRole protag;
        [SerializeField]
        private BaseRole antag;
        private void Awake()
        {
            battleFormController = new BattleFormController(this,battleForm);
            
            // battleForm.btn_discard.onClick.AddListener();
        }

        public void GiveCard(long guid, CardPlace from, CardPlace to)
        {
            if (from == CardPlace.Hand && to == CardPlace.Discard)
            {
                var card = cardSet.handCard.Find(x => x.GUID == guid);
                cardSet.CardFromHandToDiscardPile(card, 1);
            }
            else if (from == CardPlace.Hand && to == CardPlace.Draw)
            {   
                var card = cardSet.handCard.Find(x => x.GUID == guid);
                cardSet.CardFromHandToDrawPile(card);
            }
            else if (from == CardPlace.Hand && to == CardPlace.Ethereal)
            {
                var card = cardSet.handCard.Find(x => x.GUID == guid);
                cardSet.CardToEthereal(card);
            }
        }
            
        public void Shuffle()
        {
            cardSet.Shuffle();
        }

        public void OpenCardDisplay()
        {
            
        }

        public void StartGame()
        {
            cardPanelLogic.Init();
            for (int i = 0; i < 6; i++)
            {
                var card = Entry.CardFactory.GetCard(Entry.Core.CardDeck[i], cardSet.handCardTrans);
                cardSet.AddCards(card, 6);
            }
            cardSet.PlaySequence();

            for (int i = 6; i < Entry.Core.CardDeck.Count; i++)
            {
                var card = Entry.CardFactory.GetCard(Entry.Core.CardDeck[i], cardSet.drawPileTrans);
                card.transform.localPosition = Vector2.zero;
                card.GetRectTransform().anchoredPosition = Vector2.zero;
                card.gameObject.SetActive(false);
                cardSet.AddDrawPileCard(card);
            }
        }

        public void DrawCard(int count)
        {
            var offset = 10 - count;
        }

        public void DiscardCard(BaseCard baseCard)
        {
            if (cardSet.handCard.Contains(baseCard))
            {
                cardSet.handCard.Remove(baseCard);
            }
            cardSet.discardPile.Add(baseCard);
            cardSet.CardFromHandToDiscardPile(baseCard, cardSet.handCard.Count - 1);
        }

        public void EndRound()
        {
            temp.Clear();
            for (int i = 0; i < cardSet.handCard.Count; i++)
            {
                if (cardSet.handCard[i].CardInfo.FlagOperation.HasFlag(ExtraOperation.DETAIN))
                {
                    //如果这张卡片有保留词条
                    continue;
                }
                temp.Add(cardSet.handCard[i]);
            }

            foreach (var baseCard in temp)
            {
                cardSet.handCard.Remove(baseCard);
                cardSet.drawPile.Add(baseCard);
            }
            
            for (int i = 0; i < temp.Count; i++)
            {
                cardSet.CardFromHandToDiscardPile(temp[i], i);
            }

            cardSet.HorizontalHandcardReposition();
        }

        protected override void OnOpen(object userData)
        {
            base.OnOpen(userData);
            Entry.Event.Subscribe(CardOutEventArg.EventId, OnCardOut);

        }

        private void OnCardOut(object sender, GameEventArgs e)
        {
            if (e is not CardOutEventArg arg)
            {
                return;
            }
            //卡片打出
        }

        public void ShowCardPanel()
        {
            
        }
    }
}

