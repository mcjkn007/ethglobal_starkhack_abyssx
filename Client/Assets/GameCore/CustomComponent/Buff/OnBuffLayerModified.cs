using GameCore.CustomComponent.Role;
using GameFramework.Event;

namespace Abyss
{
    public class OnBuffLayerModified : GameEventArgs
    {
        public override void Clear()
        {
            this.role = null;
            this.buffId = -1;
            this.destinationLayer = 0;
        }

        public BaseRole role;
        public int buffId;
        public int destinationLayer;
        private static int modelId = typeof(OnBuffLayerModified).GetHashCode();
        public override int Id => modelId;

        public OnBuffLayerModified(BaseRole role, int buffId, int destinationLayer)
        {
            this.role = role;
            this.buffId = buffId;
            this.destinationLayer = destinationLayer;
        }
    }
}