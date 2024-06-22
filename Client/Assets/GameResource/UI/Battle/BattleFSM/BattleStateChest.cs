using GameFramework.Fsm;

namespace Abyss.BattleFSM
{
    public class BattleStateChest : BattleFSMState
    {
        public override RoadNode roadNodeType => RoadNode.Chest;
        public override void OnEnter(object data)
        {
            owner.FadeInAndOut(() =>
            {
                owner.battleForm.campLogic.gameObject.SetActive(false);
                owner.battleForm.selectLogic.gameObject.SetActive(false);
                owner.battleForm.eventLogic.gameObject.SetActive(false);
                owner.battleForm.chestLogic?.gameObject.SetActive(true);
                owner.battleForm.battleSeverLogic.gameObject.SetActive(false);
            });
        }

        public override void OnLeave()
        {
        }


        public BattleStateChest(UIBattleLogic battleLogic) : base(battleLogic)
        {
        }
    }
}