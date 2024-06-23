using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
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

        public SelectCardPanel cardSelect;
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
            Debug.LogError("event binded");
        }

        private void Start()
        {
            battleForm.btn_draw.onClick.AddListener(() =>
            {
                this.cardPanelLogic.Init(0);
            });
            battleForm.btn_discard.onClick.AddListener(() =>
            {
                this.cardPanelLogic.Init(1);
            });
            battleForm.btn_allCard.onClick.AddListener(() =>
            {
                this.cardPanelLogic.Init(2);
            });
            battleForm.btn_skipRound.onClick.AddListener(EndPlayerRound);
            Entry.Event.Subscribe(GameStartEventArgs.EventId, (a, b) =>
            {
                if (b is GameStartEventArgs arg)
                {
                    battleFormController.UIFlyIn();
                }
            });

        }

        public void Update()
        {
            if (Input.GetKeyDown(KeyCode.Z))
            {
                this.battleForm.selectLogic.gameObject.SetActive(true);
                this.battleForm.battleSeverLogic.gameObject.SetActive(false);
                this.battleFormController.HideUI();
                this.cardSet.gameObject.SetActive(false);
                this.battleForm.txt_stage .text= "2/13";
            }
        }

        public void ShowCardSelectPanel()
        {
            
        }

        private void EndPlayerRound()
        {
            Entry.Core.EndPlayerRound();
        }

        public void FadeInAndOut(Action mid, Action end = null)
        {
            this.battleFormController.HideUI();
            battleForm.img_mask.gameObject.SetActive(true);
            var seq = DOTween.Sequence().Append(battleForm.img_mask.DOFade(1f, 0.3f))
                .AppendCallback(() =>
                {
                    var loginPanel = Entry.UI.GetUIForm(UIPath.Login);
                    if (loginPanel != null && loginPanel.isActiveAndEnabled)
                    {
                        Entry.UI.CloseUIForm(loginPanel);
                    }
                })
                .AppendInterval(0.2f)
                .AppendCallback(() =>
                {
                    
                    mid?.Invoke();
                }).AppendInterval(0.3f)
                .Append((battleForm.img_mask.DOFade(0f, 0.3f))).
                AppendCallback(() =>
                {
                    battleForm.img_mask.gameObject.SetActive(false);
                }).AppendCallback(
                    () =>
                    {
                        if (Entry.Core.curRoadNode == RoadNode.Boss || Entry.Core.curRoadNode == RoadNode.Epic ||
                            Entry.Core.curRoadNode == RoadNode.Normal)
                        {
                            Entry.Event.Fire(GameStartEventArgs.EventId, new GameStartEventArgs());
                        }
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
            
        public void OpenCardDisplay()
        {
            
        }

        public void StartGame(int maxHp = 34, RoadNode node = RoadNode.None)
        {
            InitCardPiles();
            SetCurrentState(node);
            // cardSet.PlaySequence();
        }

        public void InitCardPiles()
        {
            cardSet.handCard = new List<BaseCard>();
            cardSet.discardPile = new List<BaseCard>();
            cardSet.drawPile = new List<BaseCard>();
            
            foreach (var card in Entry.Core.CardDeck)
            {
                var baseCard = Entry.CardFactory.GetCard(card.CardInfo.Id, card.GUID, cardSet.drawPileTrans);
                cardSet.drawPile.Add(baseCard);
            }
            //
            // DOTween.Sequence().AppendInterval(2f).AppendCallback(
            //     () =>
            //     {
            //         cardSet.DrawCardFromLeft(5);
            //     }).Play();
            // DrawHandCard();
        }

        public void SyncEnergy(int newValue)
        {
            this.battleForm.txt_energy.text = newValue.ToString();
        }

        public void SyncHp(int hp)
        {
            this.battleForm.txt_hp.text = hp.ToString();
        }

        public void SyncStage(int stage)
        {
            this.battleForm.txt_stage.text =$"{stage}/{13}" ;
        }

        public void SyncMaxEnergy(int newValue)
        {
            this.battleForm.txt_maxEnergy.text = newValue.ToString();
        }

        public void DrawHandCard(int count = 5)
        {
            var cardRange = cardSet.drawPile.GetRange(cardSet.drawPile.Count - 6, 5);
            cardSet.drawPile.RemoveRange(cardSet.drawPile.Count - 6, 5);
            cardSet.AddCardsToHand(cardRange);
            cardSet.PlaySequence();
        }

        private void GetDeepCopyOfCardDeck()
        {
            
        }
        
        private void Draw()
        {
            
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
            var loginPanel = Entry.UI.GetUIForm(UIPath.Login);
            Entry.UI.CloseUIForm(loginPanel);
            Debug.LogError("normal State = " + Current.ToSafeString());
            this.Current.OnEnter(null);
        }
        
        int val = 6;
        public void OnEnemyRound()
        {
            var seq = DOTween.Sequence();
            
            Entry.Core.antag.ExecuteCommandChain(seq, val += 3);
            seq.AppendCallback(() =>
            {
                Entry.Core.SwitchRound();
            });
            seq.Play();
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
            this.temp.Clear();
            for (int i = 0; i < cardSet.handCard.Count; i++)
            {
                if (cardSet.handCard[i].CardInfo.FlagOperation.HasFlag(ExtraOperation.DETAIN))
                {
                    //如果这张卡片有保留词条
                    continue;
                }
                this.temp.Add(cardSet.handCard[i]);
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
    }
}

