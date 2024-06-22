using GameFramework.Fsm;

namespace Abyss.BattleFSM
{
    public class BattleStateEpicBattle : BattleFSMState
    {
        public override RoadNode roadNodeType => RoadNode.Epic;
        public override void OnEnter(object data)
        {
            owner.FadeInAndOut(() =>
            {
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


        public BattleStateEpicBattle(UIBattleLogic battleLogic) : base(battleLogic)
        {
        }
    }
}