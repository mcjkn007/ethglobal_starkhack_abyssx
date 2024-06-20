using System.Collections.Generic;
using GameCore;
using UnityEngine;

namespace Abyss
{
    public class CardPanelLogic : MonoBehaviour
    {
        public CardPanelForm form;
    
        public LinkedList<BaseCard> cardDeck;
        public LinkedList<BaseCard> contianer;  
        
        public void Open(CardPosition position)
        {
            switch (position)
            {
                
            }
        }

        public void Init()
        {
            foreach (var card in cardDeck)
            {
                Destroy(card);
            }
            this.cardDeck.Clear();
            foreach (var cardId in Entry.Core.CardDeck)
            {
                var newCard = Entry.CardFactory.GetCard(cardId, form.root);
                this.cardDeck.AddLast(newCard);
            }

            
        }
    }
}