using System;
using GameCore.CustomComponent.Role;
using GameFramework;

namespace Abyss
{
    public abstract class BaseGameAction:IReference
    {
        public abstract void Execute(BaseRole self, object targets, int value, DG.Tweening.Sequence sequence);
        public void Clear()
        {
            
        }
    }
}