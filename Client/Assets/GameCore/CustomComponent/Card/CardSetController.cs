using System;
using DG.Tweening;
using UnityEngine;
using System.Linq;
using dojo_bindings;
using GameCore.Facade;
using UnityGameFramework.Runtime;
using Utils;
using Debug = System.Diagnostics.Debug;

namespace Abyss
{
    public class CardSetController
    {
        private CardSetView _cardSetView;
        private CardSet _cardSet;

        private Sequence _sequence = DOTween.Sequence();
        private static float biggestOffset = 100f;
        public void CardFromDrawToHand(DG.Tweening.Sequence sequence ,BaseCard card, int idx, int totalCount = -1)
        {
            if (idx < 0)
            {
                return;
            }
            totalCount = totalCount == -1 ? _cardSet.handCard.Count + 1 : totalCount;

            var destination = Facade.GetCardPositions(totalCount)[idx];
            card.gameObject.SetActive(true);
            card.transform.SetParent(_cardSetView.drawPile.transform);
            card.transform.localPosition = Vector2.zero;
            card.transform.localScale = Vector3.one * 0.01f;
            card.transform.SetParent(_cardSetView.handCard.transform);
            // if (_sequence == null || !_sequence.IsActive() )
            // {
            //     _sequence = DOTween.Sequence();
            // } 
            
            sequence.PrependInterval(0.5f);
            // sequence.Insert(0.2f * idx, card.transform.DOScale(Vector3.one ,0.5f));
            // sequence.Insert(0.2f * idx, card.transform.DOScale(Vector3.one ,0.5f));
            sequence.Insert(0.2f * idx, card.transform.DOScaleX(1 ,0.5f))
                    .Insert(0.2f * idx, card.transform.DOScaleY(1 ,0.5f))
                    .Insert(0.2f * idx, card.GetRectTransform().DOAnchorPos(
                new Vector3(destination, Facade.CardHeight / 2f), 0.5f)).OnComplete(() =>
            {
                card.isLocking = false;
            });
            sequence.OnComplete(() =>
            {
                _sequence = null;
            });
        }
        
        public void CardFromHandToDiscardAll(BaseCard card, int idx)
        {
            
            _cardSet.handCard.Remove(card);
            _cardSet.discardPile.Add(card);
            
             
            card.transform.SetParent(_cardSetView.discardPile);
            card.isLocking = true;
            var destination = _cardSetView.discardPile.transform.position;
           // card.transform.DOScale(Vector3.one * 0.01f, 0.5f);
           Sequence seq = DOTween.Sequence();
            seq.AppendInterval(idx * 0.1f);
            seq.Append( card.transform.DOScaleX(0.01f, 0.3f))
                .Join( card.transform.DOScaleY(0.01f, 0.3f))
                .Join( card.transform.DOMove(destination, 0.3f));
            seq.AppendCallback(() =>
            {
                // card.gameObject.SetActive(false);
                card.isLocking = false;
            });
            seq.Play();
        }

        // public void CardFromHandToDiscard(BaseCard card)
        // {
        //     _cardSet.handCard.Remove(card);
        //     _cardSet.discardPile.Add(card);
        //     card.transform.SetParent(_cardSetView.discardPile);
        //     card.isLocking = true;  
        //
        //     var _sequence = DOTween.Sequence();
        //     var destination = _cardSetView.discardPile.transform.position;
        //     _sequence.Append(card.transform.DOMove(destination, 0.5f)).Join()
        //     _sequence.Insert(0.2f * idx, card.GetRectTransform().DOScale(0.01f, 0.5f));
        //     _sequence.InsertCallback(0.2f * idx,() =>
        //     {
        //         card.gameObject.SetActive(false);
        //     });
        // }

        public void PlaySequence()
        {
            this._sequence?.Play();
        }

        public CardSetController(CardSet cardSet,CardSetView cardSetView)
        {
            _cardSetView = cardSetView;
            _cardSet = cardSet;
            _sequence = DOTween.Sequence();
        }
        public void HandCardReposition(long baseCardId)
        {   
            // var card = Entry.CardFactory.GetCard(baseCardId, battleView.go_hand.transform);
        }

        /// <summary>
        /// 获取水平方向的手牌的X轴重新排布后的坐标位置
        /// </summary>
        public float[] HorizontalHandCardReposition(BaseCard card)
        {
            var idx = _cardSet.handCard.IndexOf(card);
            if (idx == -1)
            {
                Log.Error("Card Not Exist");
                return null;
            }
            Log.Info("reposition => Second ");

            var rtn = new float[_cardSet.handCard.Count];
            _cardSet.handCard.Print("现在玩家手牌总数量为");
            var standardPosition = Facade.GetCardPositions(_cardSet.handCard.Count); 
            for (int i = 0; i < _cardSet.handCard.Count; i++)
            {
                var idxOffset = i - idx;
                if (idxOffset == 0)
                {
                    continue;
                }
                //反比例函数
                var horizontalOffset = standardPosition[i] + biggestOffset / idxOffset;
                _cardSet.handCard[i].GetRectTransform().DOAnchorPosX(horizontalOffset, 0.2f);
                // rtn[i] = horizontalOffset;
            }
            rtn.Print("reposition => ");
            return rtn;
        }
        
        /// <summary>
        /// 水平方向手牌X轴重新排列，没有那个啥
        /// </summary>
        public void HorizontalHandCardRepositionDefault()
        {
            var standardPosition = Facade.GetCardPositions(_cardSet.handCard.Count); 
            for (int i = 0; i < _cardSet.handCard.Count; i++)
            {
                _cardSet.handCard[i].DOKill();
                var pos = standardPosition[i];
                _cardSet.handCard[i].GetRectTransform().DOAnchorPosX(pos, 0.2f);
            }
            standardPosition.Print("标准站位为 ");
        }
    }
}