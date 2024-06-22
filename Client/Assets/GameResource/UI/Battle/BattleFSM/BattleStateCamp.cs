using GameFramework.Fsm;
using UnityEngine;

namespace Abyss.BattleFSM
{
    public class BattleStateCamp : BattleFSMState
    {
        public override RoadNode roadNodeType => RoadNode.Camp;

        public override void OnEnter(object data)
        {
            owner.FadeInAndOut(() =>
            {   
                owner.battleForm.campLogic.gameObject.SetActive(true);
                owner.battleForm.selectLogic.gameObject.SetActive(false);
                owner.battleForm.eventLogic.gameObject.SetActive(false);
                owner.battleForm.chestLogic?.gameObject.SetActive(false);
                owner.battleForm.battleSeverLogic.gameObject.SetActive(false);
            });
        }

        public override void OnLeave()
        {
            
        }

        public BattleStateCamp(UIBattleLogic battleLogic) : base(battleLogic)
        {
        }
    }
}