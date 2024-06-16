using GameCore.CustomComponent.Role;
using GameFramework.Event;

namespace Abyss
{
    public class OnArmorModified : GameEventArgs
    {
        public override void Clear()
        {
            this.role = null;
            this.value = 0;
        }

        public BaseRole role;
        public int value;
        private static int modelId = typeof(OnArmorModified).GetHashCode();
        public override int Id => modelId;

        public  OnArmorModified()
        {
        }

        public OnArmorModified(BaseRole role,  int destinationLayer)
        {
            this.role = role;
            this.value = destinationLayer;
        }
    }
}