using System;
using System.Collections.Generic;
using System.Numerics;
using cfg.gameCard;
using DG.Tweening;
using GameFramework;
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

        public static BigInteger s_seed;
        
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

        public void AddCardsToHand(BaseCard card, int idx = -1, int totalCount = -1)
        {   
            this.handCard.Add(card);
            if (idx == -1)
            {
                idx = this.handCard.Count - 1;
            }
            // Debug.LogWarning("Add Card To Hand =>  idx = " + idx + " | totalCount = " + totalCount);
            var seq = DOTween.Sequence();
            _cardSetController.CardFromDrawToHand(seq,card, idx ,totalCount == -1 ? handCard.Count : totalCount);
            seq.Play();
        }

        public void AddCardsToHand(ICollection<BaseCard> cards)
        {
            int idx = 0;
            int totalCount = cards.Count +  handCard.Count;
            var seq = DOTween.Sequence();
            foreach (var card in cards)
            {
                this.handCard.Add(card);
                Debug.LogError("手牌添加一张牌 => " + cards.Count);
                // _cardSetController.CardFromDrawToHand(card, this.handCard.Count + idx, totalCount);
                _cardSetController.CardFromDrawToHand(seq,card,  idx, totalCount);
                idx++;
            }

            seq.Play();
        }
        public void DrawCardFromLeft(int draw_card_number)
        {
            var left_cards = drawPile;
            var mid_cards = handCard;
            var right_cards = discardPile;
            Debug.Log("Handcard count = " + mid_cards.Count);
            Log.Info("draw_card_number = " + draw_card_number);
            if (mid_cards.Count == 10)
            {
                return;
            }
            
            if (draw_card_number <= left_cards.Count)
            {      
                //够抽不洗牌
                for (int i = 0; i < draw_card_number; i++)
                {
                    BaseCard card = left_cards[i];
                    AddCardsToHand(card,i, draw_card_number);
                    if (mid_cards.Count == 10)
                    {
                        return;
                    }
                }
                left_cards.RemoveRange(0, draw_card_number);
            }
            else
            {
                //不够抽先抽完在洗
                for (int i = 0; i < left_cards.Count; i++)
                {
                    BaseCard card = left_cards[i];
                    AddCardsToHand(card,i, draw_card_number);
                    if (mid_cards.Count == 10) {
                        return;
                    }
                }
                
                draw_card_number -= left_cards.Count;
                left_cards.Clear();
                foreach (var v in right_cards)
                {
                    left_cards.Add(v);
                }
                right_cards .Clear();
                string drawCardPile = " left cards = ";
                foreach (var card in left_cards)
                {
                    drawCardPile += card.GUID + ",";
                }
                Debug.LogWarning("drarCardPile => " + drawCardPile);
                FisherYatesShuffle.Shuffle(left_cards, ref s_seed);
                var newRange = Math.Min(draw_card_number, left_cards.Count);
                for (int i = 0; i <  newRange; i++)
                {
                    BaseCard card = left_cards[i];
                    AddCardsToHand(card, i, draw_card_number );
                    if (mid_cards.Count == 10) {
                        return;
                    }
                }
                left_cards.RemoveRange(0, newRange);
            }
        }

        public void AddDiscardCard(BaseCard baseCard)
        {
            this.discardPile.Add(baseCard);
        }

        public void AddDrawPileCard(BaseCard card)
        {
            this.drawPile.Add(card);
        }

        public void Update()
        {
            if (Input.GetKeyDown(KeyCode.U))
            {
                // Shuffle();
                for(int i = 0; i < 6; i ++)
                {
                    // AddCardsToHand(drawPile[i]);
                }

            }
        }

        public void CardFromHandToDiscardPile(BaseCard card, int idx)
        {
           // var seq = DOTween.Sequence();
          //  _cardSetController.CardFromHandToDiscardAll(seq,card, idx);
          //  seq.Play();
          _cardSetController.CardFromHandToDiscardAll(card, 0);
        }
    
        public void CardFromHandToDiscardPileAll()
        {
            int flag = 0;
         //   Sequence seq = DOTween.Sequence();
         // for (int i = handCard.Count - 1; i >= 0; i--)
         for (int i = 0; i < handCard.Count; i++)
            {
                if (handCard[i].CardInfo.FlagOperation.HasFlag(ExtraOperation.DETAIN))
                {
                    continue;
                }
                else
                {
                    _cardSetController.CardFromHandToDiscardAll(handCard[i], flag);
                    i--;
                    flag++;
                }
            }

          //  seq.Play();
            // PlaySequence();
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

        public void HorizontalHandcardReposition(BaseCard card = null)
        {
            if (card == null)
            {
                _cardSetController.HorizontalHandCardRepositionDefault();
            }
            else
            {
                _cardSetController.HorizontalHandCardReposition(card);
            }
        }
        

        public void Clear()
        {   
            cardDeck.Clear();
            drawPile.Clear();
            discardPile.Clear();
        }
    }
}