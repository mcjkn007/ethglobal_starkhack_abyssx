using GameFramework.Fsm;

namespace Abyss.BattleFSM
{
    public class BattleStateBossBattle : BattleFSMState
    {
        public override RoadNode roadNodeType => RoadNode.Boss;
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

        public BattleStateBossBattle(UIBattleLogic battleLogic) : base(battleLogic)
        {
        }
    }
}