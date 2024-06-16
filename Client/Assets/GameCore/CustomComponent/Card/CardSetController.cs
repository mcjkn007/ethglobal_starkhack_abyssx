using System;
using DG.Tweening;
using UnityEngine;
using System.Linq;
using GameCore.Facade;
using UnityGameFramework.Runtime;
using Utils;

namespace Abyss
{
    public class CardSetController
    {
        private CardSetView _cardSetView;
        private CardSet _cardSet;

        private Sequence _sequence = DOTween.Sequence();

        public void CardFromDrawToHand(BaseCard card, int idx, int totalCount = -1)
        {
            totalCount = totalCount == -1 ? _cardSet.handCard.Count + 1 : totalCount;
            var destination = Facade.GetCardPositions(totalCount)[idx];
            card.gameObject.SetActive(true);
            card.transform.SetParent(_cardSetView.drawPile.transform);
            card.transform.localPosition = Vector2.zero;
            card.transform.localScale = Vector3.one * 0.01f;
            card.transform.SetParent(_cardSetView.handCard.transform);
            if (_sequence == null)
            {
                _sequence = DOTween.Sequence();
            }
            
            _sequence.Insert(0.2f * idx, card.transform.DOScale(Vector3.one ,0.5f));
            _sequence.Insert(0.2f * idx, card.GetRectTransform().DOAnchorPos(
                new Vector3(destination, Facade.CardHeight / 2f), 0.5f));
            // _sequence.Join(card.transform.DOScale(Vector3.one, 0.3f))
            //     .Join((card.transform as RectTransform).DOAnchorPos(
            //         new Vector3(destination, Facade.CardHeight / 2f), 0.3f)).AppendInterval(0.1f);

        }

        public void PlaySequence()
        {
            Log.Info("Sequence Have Been Played "+ (_sequence == null));
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
    }
}