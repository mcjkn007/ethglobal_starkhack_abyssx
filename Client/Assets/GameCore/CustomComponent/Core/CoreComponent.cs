using System;
using System.Collections;
using System.Collections.Generic;
using GameCore;
using GameCore.CustomComponent.Role;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
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
        public BaseRole Protag;
        [SerializeField]
        public Camera MainCamera;
        [SerializeField]
        public Camera UICamera;
        private RoundOrder m_CurrentRoundOrder = RoundOrder.Self;
        public UIBattleLogic battleLogic;
        public List<int> CardDeck = new ();
        
        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                BeginGame();
            }
        }

        public void BeginGame()
        {
            this.battleLogic = Entry.UI.GetUIForm(UIPath.Battle).GetComponent<UIBattleLogic>();
            Debug.LogError("BeginGame");
            CardDeck = new List<int>()
            {
                20007,
                20010,
                20016,
                20015,
                20010,
                20003,
                20011,
                20025,
                20028,
                20035,
                20035,
                20036,
                20036,
                20035,
                20036
            };
            CardDeck.Print();
            
            battleLogic.Shuffle();
            battleLogic.StartGame();
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
                battleLogic.Shuffle();
            }
        }

        private void OnRoundStart()
        {
            
        }

        private void OnRoundEnd()
        {
            
        }


    }
}