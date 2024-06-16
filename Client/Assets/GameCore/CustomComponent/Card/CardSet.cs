using System;
using System.Collections.Generic;
using System.Linq;
using cfg.gameCard;
using DG.Tweening;
using GameCore.Facade;
using GameFramework;
using Unity.VisualScripting;
using UnityEditor;
using UnityGameFramework.Runtime;
using UnityEngine;
using Utils;

namespace Abyss
{
    public class CardSet : MonoBehaviour, IReference
    {
        
        public static int drawCount = 6;
        public static int handcardMax = 10;
        public List<BaseCard> cardDeck = new List<BaseCard>();
        public List<BaseCard> drawPile = new List<BaseCard>();
        public List<BaseCard> discardPile = new List<BaseCard>();
        public List<BaseCard> ehterealPile = new List<BaseCard>();
        public List<BaseCard> handCard = new List<BaseCard>();
        
        private CardSetView _cardSetView;
        private CardSetController _cardSetController;

        public Transform discardPileTrans => _cardSetView.discardPile;
        public Transform handCardTrans => _cardSetView.handCard.transform;
        public Transform drawPileTrans => _cardSetView.drawPile;

        private void Awake()
        {
            this._cardSetView = GetComponent<CardSetView>();
            this._cardSetController = new CardSetController(this, _cardSetView);
        }

        public void PlaySequence()
        {
            this._cardSetController.PlaySequence();
        }

        public void AddCards(BaseCard card, int totalCount = -1)
        {
            this.handCard.Add(card);
            _cardSetController.CardFromDrawToHand(card, this.handCard.Count - 1, totalCount == -1 ? handCard.Count : totalCount);
        }

        public void AddDiscardCard(BaseCard baseCard)
        {
            this.discardPile.Add(baseCard);
        }

        public void AddDrawPileCard(BaseCard card)
        {
            this.drawPile.Add(card);
        }

        public void AddEhterCard()
        {
            
        }

        public void Update()
        {
            if (Input.GetKeyDown(KeyCode.U))
            {
                // Shuffle();
                for(int i = 0; i < 6; i ++)
                {
                    AddCards(drawPile[i]);
                }

            }
        }


        public void Shuffle()
        {
            int detainedCard = 0;
            for (int i = 0; i < handCard.Count; i++)
            {
                var card = handCard.ElementAt(i);
                if (card.CardInfo.FlagOperation.HasFlag(ExtraOperation.DETAIN))
                {
                    detainedCard++;
                    continue;
                }
                handCard.Remove(card);

                var newHandCardCount = handcardMax - detainedCard;
                GetNewHandCard(newHandCardCount);
            }
        }
            
        /// <summary>
        /// 获取新手牌
        /// </summary>
        public void GetNewHandCard(int newHandCardCount)
        {   
            var count = drawPile.Count;
            var offset = drawCount - count;
            if (offset > 0)
            {
                //如果当前抽牌堆数量不够多
                var set =  discardPile.GetRange(0, offset);
                drawPile.AddRange(discardPile);
                discardPile.Clear();
                handCard.AddRange(set);
            }
            else
            {
                //如果当前抽牌堆数量够了
                var cards = drawPile.GetRange(0, drawCount);
            }

            handCard.Print("我方回合 手牌是：");
        }

        public void CardFromHandToDiscardPile(BaseCard card)
        {
            
        }
        public void CardFromHandToDrawPile(BaseCard card)
        {
            
        }

        public void CardToEthereal(BaseCard card)
        {
            
        }

        public void GetNewRoundCards()
        {
            
        }

        public void Clear()
        {   
            cardDeck.Clear();
            drawPile.Clear();
            discardPile.Clear();
        }
    }
}