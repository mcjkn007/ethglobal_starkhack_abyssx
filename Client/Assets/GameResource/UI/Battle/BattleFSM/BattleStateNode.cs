using GameFramework.Fsm;

namespace Abyss.BattleFSM
{
    public class BattleStateNode : BattleFSMState
    {
        public override RoadNode roadNodeType => RoadNode.None;

        public override void OnEnter(object data)
        {
            owner.FadeInAndOut(() =>
            {
                owner.battleForm.campLogic.gameObject.SetActive(false);
                owner.battleForm.selectLogic.gameObject.SetActive(true);
                owner.battleForm.eventLogic.gameObject.SetActive(false);
                owner.battleForm.chestLogic?.gameObject.SetActive(false);
                owner.battleForm.battleSeverLogic.gameObject.SetActive(false);
            });
        }

        public override void OnLeave()
        {
            
        }

        public BattleStateNode(UIBattleLogic battleLogic) : base(battleLogic)
        {
        }
    }
}