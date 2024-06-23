using System.Collections.Generic;
using System.Runtime.CompilerServices.Events;
using Abyss.BattleFSM;
using cfg.gameCard;
using DG.Tweening;
using GameCore;
using GameCore.CustomComponent.Dojo;
using GameCore.CustomComponent.Role;
using UnityEngine;
using UnityGameFramework.Runtime;
using Utils;

namespace Abyss
{
    public enum RoundOrder
    {
        Self,
        Enemy
    }

    public class CoreComponent : GameFrameworkComponent
    {
        [SerializeField] public CameraShake shakescript;
        [SerializeField] public Camera MainCamera;
        [SerializeField] public Camera UICamera;
        private RoundOrder m_CurrentRoundOrder = RoundOrder.Self;
        public UIBattleLogic battleLogic;
        public IList<BaseCard> CardDeck;
        
        public bool isLogedIn = false;
        [SerializeField] public BaseRole protag;
        [SerializeField] public BaseRole antag;

        public RegisterProperty<int> MaxHp = new(80);
        public RegisterProperty<int> Hp = new(-1);
        public int MaxStage = 13;
        public RegisterProperty<int> Stage = new(-1);
        public RegisterProperty<int> Energy = new(-1);
        public RegisterProperty<int> MaxEnergy = new(1);

        private void Start()
        {
            Energy.Register(this.battleLogic.SyncEnergy);
            Hp.Register(this.battleLogic.SyncHp);
            MaxEnergy.Register(this.battleLogic.SyncMaxEnergy);
            Stage.Register(this.battleLogic.SyncStage);
            
            MaxEnergy.Val = 3;
            Stage.Val = 1;
            Hp.Val = 80;

            Entry.Event.Subscribe(GameStartEventArgs.EventId, (a, b) =>
            {
                if (b is GameStartEventArgs arg)
                {
                    var loginPanel = Entry.UI.GetUIForm(UIPath.Login);
                    if (loginPanel != null && loginPanel.isActiveAndEnabled)
                    {
                        Entry.UI.CloseUIForm(loginPanel);
                    }
                }
            });
            
            Entry.Event.Subscribe(DojoRoleUpdate.EventId, (a, b) =>
            {
                if (b is DojoRoleUpdate arg)
                {
                    if (this.Stage.Val != arg.cur_stage)
                    {
                        OnStageChange(arg.cur_stage);
                    }
                    if (this.curRoadNode != (RoadNode)arg.selected_road)
                    {
                        OnRoadNodeChange(arg.selected_road);
                    }
                }
            });
        }
        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                BeginGame();
            }

            if (Input.GetKeyDown(KeyCode.Escape))
            {
                EndPlayerRound();
            }
        }

        public void InitGame()
        {
            
        }

        private void OnStageChange(byte stage)
        {
            this.Stage.Val = stage;
            
        }

        private void OnRoadNodeChange(byte bye)
        {
            this.curRoadNode = (RoadNode)bye;
            battleLogic.StartGame( 0, curRoadNode);
        }

        private IList<ushort> recorder; 

        private void RefreshRecorder()
        {
            recorder = new List<ushort>();
        }

        public IList<ushort> GetRecorder()
        {
            return recorder;
        }        
        

        /// <summary>
        /// 打牌
        /// </summary>
        /// <param name="target"></param>
        /// <param name="value"></param>
        public void Record(ushort target ,ushort value)
        {
            if (recorder == null)
            {
                recorder = new List<ushort>();
            }
            int val = (value << 8) + target;
            Debug.LogError($"recorder 添加元素 {target}, {value} => {val}" );
            recorder.Add((ushort)val);
        }

        /// <summary>
        /// 回合结束
        /// </summary>
        public void Record()
        {
            Debug.LogError($"recorder 回合结束");
                       if (recorder == null)
            {
                recorder = new List<ushort>();
            }
            recorder.Add(0);
        }

        public void BeginGame(UIBattleLogic battleLoogic = null, int playerhp = 0, int maxPlayerHp = 0, int enemyMaxHp = 0, int stage = 0)
        {
            RefreshRecorder();
            battleLogic.StartGame(1, (RoadNode)Entry.Dojo.GetValue<Role>().selected_road);
        }

        private void SyncCardDeck()
        {
            var card = Entry.Dojo.GetValue<Card>().slot_1;
        }

        public void EndPlayerRound()
        {
            if (m_CurrentRoundOrder == RoundOrder.Self)
            {
                Record();
                SwitchRound();
            }
        }

        public void SwitchRound()
        {
            OnRoundEnd();
            if (m_CurrentRoundOrder == RoundOrder.Self)
            {
                m_CurrentRoundOrder = RoundOrder.Enemy;
            }
            else
            {   
                m_CurrentRoundOrder = RoundOrder.Self;
            }
            OnRoundSwitch();
        }

        private void OnRoundSwitch()
        {
            OnRoundStart();
            if (m_CurrentRoundOrder == RoundOrder.Self)
            {
                
            }
            else
            {
                battleLogic.OnEnemyRound();
            }
        }

        private void OnRoundStart()
        {
            if (curRoadNode != RoadNode.Boss && curRoadNode != RoadNode.Epic && curRoadNode != RoadNode.Normal)
            {
                return;
            }

            battleLogic.battleForm.banner.ShowBanner(m_CurrentRoundOrder);
            if (m_CurrentRoundOrder == RoundOrder.Self )
            {   
                // //玩家回合结束
                this.Energy.Val = MaxEnergy.Val;
                Debug.LogError("energy.val = " + this.Energy.Val);
                DOTween.Sequence().AppendInterval(0.5f)
                    .AppendCallback(() =>
                    {
                        // Entry.Core.shakescript.enabled = true;
                        battleLogic.cardSet.DrawCardFromLeft(5);
                    }).Play();

            }
            else
            {
                //敌人回合结束
            }
        }

        private void OnRoundEnd()
        {
            if (m_CurrentRoundOrder == RoundOrder.Self)
            {
                Debug.LogError("Player ROund End");
                //玩家回合结束
                battleLogic.cardSet.CardFromHandToDiscardPileAll();
            }
            else
            {
  
            }
            
        }


        public void DrawCard(int cardNumber)
        {
            //抽牌
            var list = GetRandomCard();
            battleLogic.cardSet.AddCardsToHand(list);
        }

        public void AllCardsToDiscard()
        {
            for (int i = battleLogic.cardSet.handCard.Count; i >= 0; i--)
            {
                var card = battleLogic.cardSet.handCard[i];
                if (card.CardInfo.FlagOperation.HasFlag(ExtraOperation.DETAIN))
                {
                    continue;
                }
                
            }

            foreach (var i in battleLogic.cardSet.handCard)
            {
                if (i.CardInfo.FlagOperation.HasFlag(ExtraOperation.DETAIN))
                {
                    continue;
                }
                
            }
            
        }

        public void CardToDiscard(ICollection<BaseCard> cardsToDiscard)
        {
            foreach (var card in cardsToDiscard)
            {
                battleLogic.cardSet.handCard.Remove(card);
            }
            battleLogic.cardSet.discardPile.AddRange(cardsToDiscard);
        }

        public void CardToDiscard(BaseCard singleCardToDiscard)
        {
            battleLogic.cardSet.discardPile.Add(singleCardToDiscard);
        }

        public ICollection<BaseCard> GetRandomCard()
        {
            return null;
        }
        
        /// <summary>
        /// 被通知开始游戏
        /// </summary>
        public void TriiggeredStartGame()
        {
            CardSet.s_seed = RandUtils.GerRandomByStage(StageSeed.Game, Entry.Core.Stage.Val);
            GetInitHandCard();
            GetRoleState();
            protag = Entry.RoleFactory.GetRole(0,80,null,false);
            antag = Entry.RoleFactory.GetRole(60001,34);
            curRoadNode = GetCurrentStage();
            battleLogic.StartGame(0, curRoadNode);
            OnRoundStart();
        }
        
        public RoadNode curRoadNode;
        private void GetInitHandCard()
        {
            this.CardDeck = DojoHelper.CardSlotToCardID();
            FisherYatesShuffle.Shuffle(CardDeck, ref CardSet.s_seed);
            CardDeck.Print("Card Deck Inited");
        }

        private int curStage;
        private int curHp;
        private int maxHp;
        
        private void GetRoleState()
        {
            var role = Entry.Dojo.GetValue<Role>();
            this.curStage = role.cur_stage;
            this.curHp = role.hp;
            this.maxHp = role.max_hp;
        }
        private RoadNode GetCurrentStage()
        {
            return (RoadNode)Entry.Dojo.GetValue<Role>().selected_road;
        }

    }
}