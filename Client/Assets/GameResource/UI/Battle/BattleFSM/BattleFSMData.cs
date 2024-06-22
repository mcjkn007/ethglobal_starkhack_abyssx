using System;
using GameFramework;

namespace Abyss.BattleFSM
{
    public class BattleFSMData : Variable<int>
    {
        private int value;
        public override object GetValue()
        {
            return value as object;
        }

        public override void SetValue(object value)
        {
            this.value = (int)value;
        }

        public override void Clear()
        {
            this.value = 0;
        }

        public override Type Type => typeof(int);
    }
}