using System.Collections.Generic;
using GameCore.BindProperty;
using GameFramework;

namespace Abyss
{
    /// <summary>
    /// Buff就是  任何会显示在人上面的东西
    /// </summary>
    public abstract class Buff : IBuff, IReference
    {
        public abstract bool isFadeWithRound { set; get; }

        public int layer { private set; get; }

        public IRole owner;

        public abstract void Apply();
        /// <summary>
        /// 每个回合开始时调用
        /// </summary>
        public virtual void OnRoundStart()
        {   
            
        }
        /// <summary>
        /// 每个回合结束时调用
        /// </summary>
        public virtual void OnRoundEnd()
        {
            if (this.isFadeWithRound)
            {
                if (this.layer > 0)
                {
                    this.RemoveLayer();
                }
            }
        }

        public void Clear()
        {
            this.layer = 0;
            this.owner = null;
        }

        public void Erase()
        {
            this.layer = 0;
        }

        private void AddLayer()
        {
            this.layer++;
        }

        private void RemoveLayer()
        {
            this.layer--;
        }

        public void DoubleLayer()
        {
            this.layer *= 2;
        }
    }
}