using System.Collections.Generic;

namespace GameCore.Stats
{
    public class StatMediator
    {
        private ICollection<BaseGameBuff> _stats;
        public StatMediator(ICollection<BaseGameBuff> stats)
        {
            this._stats = stats;
        }

        public int OnAttack(int originalValue)
        {
            return originalValue;
        }
        
    }
}