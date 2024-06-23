using GameFramework.Fsm;

namespace Abyss.BattleFSM
{
    public class BattleStateEvent : BattleFSMState
    {
        public override RoadNode roadNodeType => RoadNode.Event;
        public override void OnEnter(object data)
        {
            owner.FadeInAndOut(() =>
            {
                (data as System.Action)?.Invoke();
                owner.battleForm.campLogic.gameObject.SetActive(false);
                owner.battleForm.selectLogic.gameObject.SetActive(false);
                owner.battleForm.eventLogic.gameObject.SetActive(true);
                owner.battleForm.chestLogic?.gameObject.SetActive(false);
                owner.battleForm.battleSeverLogic.gameObject.SetActive(false);
            });
        }

        public override void OnLeave()
        {
        }



        public BattleStateEvent(UIBattleLogic battleLogic) : base(battleLogic)
        {
        }
    }
}