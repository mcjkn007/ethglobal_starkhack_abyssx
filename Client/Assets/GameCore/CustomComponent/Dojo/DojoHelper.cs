using UnityEngine;
using System.Collections.Generic;
using Abyss;
using Utils;

namespace GameCore.CustomComponent.Dojo
{
    public static class DojoHelper
    {

        public static IList<BaseCard> CardSlotToCardID()
        {
            var cardComponenet = Entry.Dojo.GetValue<Card>();
            IList<BaseCard> _cardList = new List<BaseCard>();
            var slot1 = cardComponenet.slot_1;
            for (int i = 0; i < 8; i++)
            {
                ulong card_id = (slot1 >> i * 8) % 256 ;
                if (card_id != 0)
                {
                    int cfgId = (int)card_id + 20000;
                    _cardList.Add(Entry.CardFactory.GetCard(cfgId, i));
                }
            }

            var slot2 = cardComponenet.slot_2;
            for (int i = 0; i < 8; i++)
            {
                ulong card_id = (slot2 >> i * 8) % 256;
                if (card_id != 0)
                {
                    int cfgId = (int)card_id + 20000;
                    _cardList.Add(Entry.CardFactory.GetCard(cfgId, i + 8));
                }
            }
            
            return _cardList;
        }
        //
        // public static IList<BaseCard> CardSlotToEstateCard()
        // {
        //     var cardComponenet = Entry.Dojo.GetValue<Card>();
        //     IList<BaseCard> _cardList = new List<BaseCard>();
        //     var slot1 = cardComponenet.slot_1;
        //     for (int i = 0; i < 8; i++)
        //     {
        //         ulong card_id = (slot1 >> i * 8) % 256 ;
        //         if (card_id != 0)
        //         {
        //             int cfgId = (int)card_id + 20000;
        //             _cardList.Add(Entry.CardFactory.GetCard(cfgId));
        //         }
        //     }
        //
        //     var slot2 = cardComponenet.slot_2;
        //     for (int i = 0; i < 8; i++)
        //     {
        //         ulong card_id = (slot2 >> i * 8) % 256;
        //         if (card_id != 0)
        //         {
        //             int cfgId = (int)card_id + 20000;
        //             _cardList.Add(Entry.CardFactory.GetCard(cfgId));
        //         }
        //     }
        //     
        //     return _cardList;
        // }
    }
}