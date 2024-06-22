using System;
using System.Collections;
using System.Collections.Generic;
using Abyss.BattleFSM;
using cfg.gameCard;
using DG.Tweening;
using GameCore;
using GameCore.CustomComponent.Role;
using GameCore.Facade;
using GameFramework.Event;
using GameFramework.Fsm;
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

    public enum RoadNode
    {
        /// <summary>
        /// 如果是0 则在3选一的地方；
        /// </summary>
         None = 0,
         Normal = 1,
         Epic = 2,
         Boss = 3,

         Event = 4,
         Shop = 5,
         Camp = 6,
         Chest = 7,
    }

    public enum GameState
    {
        Login = 0,
        Battle = 1,
        Elite = 2,
        Two = 3,
        Three = 4,
        Four = 5
    }

    public class UIBattleLogic : UIFormLogic
    {

        public static int SerialId;
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

        private IFsm<UIBattleLogic> _fsm;

        private BattleStateNormalBattle normalState;
        private BattleStateEpicBattle epicState;
        private BattleStateBossBattle bossState;
        private BattleStateCamp campState;
        private BattleStateNode nodeState;
        private BattleStateEvent eventState;
        private BattleStateChest chestState;

        private BattleFSMState Current;
        private void Awake()
        {
            battleFormController = new BattleFormController(this,battleForm);
            normalState = new BattleStateNormalBattle(this);
            epicState = new BattleStateEpicBattle(this);
            bossState = new BattleStateBossBattle(this);
            campState = new BattleStateCamp(this);
            nodeState = new BattleStateNode(this);
            eventState = new BattleStateEvent(this);
            chestState = new BattleStateChest(this);
            // battleForm.btn_discard.onClick.AddListener();
        }

        private void OnHpChange(int val)
        {
    
        }

        public void FadeInAndOut(Action mid, Action end = null)
        {
            battleForm.img_mask.gameObject.SetActive(true);
            var seq = DOTween.Sequence().Append(battleForm.img_mask.DOFade(1f, 0.3f)).AppendInterval(0.1f)
                .AppendCallback(() =>
                {
                    mid?.Invoke();
                }).AppendInterval(0.1f).Append((battleForm.img_mask.DOFade(0f, 0.3f))).AppendCallback(() =>
                {
                    battleForm.img_mask.gameObject.SetActive(false);
                }).AppendCallback(
                    () =>
                    {
                        end?.Invoke();
                    });
           seq.Play();
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

        public void StartGame(int cfg = 0, RoadNode node = RoadNode.None)
        {
            SetCurrentState(node);
            battleFormController.UIFlyIn();
            antag = Entry.RoleFactory.GetRole(1);
            // cardPanelLogic.Init();
            for (int i = 0; i < 5; i++)
            {
                var card = Entry.CardFactory.GetCard(Entry.Core.CardDeck[i], cardSet.handCardTrans);
                cardSet.AddCards(card, 5);
            }
            cardSet.PlaySequence();

            for (int i = 5; i < Entry.Core.CardDeck.Count; i++)
            {
                var card = Entry.CardFactory.GetCard(Entry.Core.CardDeck[i], cardSet.drawPileTrans);
                card.transform.localPosition = Vector2.zero;
                card.GetRectTransform().anchoredPosition = Vector2.zero;
                card.gameObject.SetActive(false);
                cardSet.AddDrawPileCard(card);
            }
        }
        
        private void SetCurrentState(RoadNode node)
        {
            switch (node)
            {
                case RoadNode.None:
                    this.Current = nodeState;
                    break;
                case RoadNode.Epic:
                    this.Current = epicState;
                    break;
                case RoadNode.Normal:
                    this.Current = normalState;
                    break;
                case RoadNode.Event:
                    this.Current = eventState;
                    break;
                case RoadNode.Shop:
                    this.Current = null;
                    break;
                case RoadNode.Camp:
                    this.Current = campState;
                    break;
                case RoadNode.Chest:
                    this.Current = chestState;
                    break;
            }
            this.Current.OnEnter(null);
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
        }

        public void ShowCardPanel()
        {
            
        }
    }
}

