using System;
using GameFramework.Fsm;
using UnityEngine.Events;

namespace Abyss.BattleFSM
{
    public class BattleStateNormalBattle : BattleFSMState
    {
        public override RoadNode roadNodeType => RoadNode.Normal;
        public override void OnEnter(object data)
        {
            owner.FadeInAndOut(() =>
            {
                (data as Action)?.Invoke();
                owner.battleForm.campLogic.gameObject.SetActive(false);
                owner.battleForm.selectLogic.gameObject.SetActive(false);
                owner.battleForm.eventLogic.gameObject.SetActive(false);
                owner.battleForm.chestLogic?.gameObject.SetActive(false);
                owner.battleForm.battleSeverLogic.gameObject.SetActive(true);
            });
        }

        public override void OnLeave()
        {
            
        }

        public BattleStateNormalBattle(UIBattleLogic battleLogic) : base(battleLogic)
        {
        }
    }
}