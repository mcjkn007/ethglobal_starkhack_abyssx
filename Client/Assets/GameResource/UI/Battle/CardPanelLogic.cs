using System;
using System.Collections.Generic;
using GameCore;
using Unity.VisualScripting;
using UnityEngine;

namespace Abyss
{
    public class CardPanelLogic : MonoBehaviour
    {
        public CardPanelForm form;
    
        public LinkedList<BaseCard> cardDeck = new LinkedList<BaseCard>();
        public LinkedList<BaseCard> contianer = new LinkedList<BaseCard>();  
        
        public void Open(CardPosition position)
        {
            switch (position)
            {
            }
        }

        private void Start()
        {
            this.form.btn_close.onClick.AddListener(OnClose);
        }

        private void OnClose()
        {
            foreach (var card in cardDeck)
            {
                if (card == null)
                {
                    continue;
                }
                Destroy(card);
            }
            this.cardDeck.Clear();
            gameObject.SetActive(false);
        }

        /// <summary>
        /// 0抽牌堆 、 1 弃牌堆 、 2 所有卡组
        /// </summary>
        /// <param name="part"></param>
        public void Init(int part = 0)
        {
            if (this.gameObject.activeSelf)
            {
                OnClose();
                return;
            }

            gameObject.SetActive(true);
            foreach (var card in cardDeck)
            {
                if (card == null)
                {
                    continue;
                }
                Destroy(card);
            }
            this.cardDeck.Clear();

            switch (part)
            {
                case 1:
                    LoaAllDiscardCard();
                    break;
                case 2:
                    LoadAllCards();
                    break;
                case 0:
                    LoaAllDrawCard();
                    break;
            }
        }

        public void LoadAllCards()
        {
            foreach (var singleCard in Entry.Core.CardDeck)
            {
                var newCard = Entry.CardFactory.GetCard(singleCard.CardInfo.Id, 0, form.root);
                newCard.gameObject.SetActive(true);
                Destroy(newCard.GetComponent<BaseCardController>());
                this.cardDeck.AddLast(newCard);
            }
        }

        public void LoaAllDrawCard()
        {
            foreach (var singleCard in Entry.Core.battleLogic.cardSet.drawPile)
            {
                var newCard = Entry.CardFactory.GetCard(singleCard.CardInfo.Id, 0, form.root);
                newCard.gameObject.SetActive(true);
                Destroy(newCard.GetComponent<BaseCardController>());
                this.cardDeck.AddLast(newCard);
            }
        }
        public void LoaAllDiscardCard()
        {
            foreach (var singleCard in Entry.Core.battleLogic.cardSet.discardPile)
            {
                var newCard = Entry.CardFactory.GetCard(singleCard.CardInfo.Id, 0, form.root);
                newCard.gameObject.SetActive(true);
                Destroy(newCard.GetComponent<BaseCardController>());
                this.cardDeck.AddLast(newCard);
            }
        }
    }
}