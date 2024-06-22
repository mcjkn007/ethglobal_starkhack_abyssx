using GameFramework.Fsm;

namespace Abyss.BattleFSM
{
    public abstract class BattleFSMState
    {
        protected UIBattleLogic owner;
        public abstract RoadNode roadNodeType
        {
            get;
        }

        public abstract void OnEnter(object data);
        public abstract void OnLeave();

        public BattleFSMState(UIBattleLogic battleLogic)
        {
            this.owner = battleLogic;
        }
    }
}