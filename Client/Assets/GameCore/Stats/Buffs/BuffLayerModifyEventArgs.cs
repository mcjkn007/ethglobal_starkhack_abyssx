using cfg.gameCard;
using GameCore.CustomComponent.Role;
using UnityEngine.EventSystems;

namespace GameFramework.Event
{
    public  class BuffLayerModifyEventArgs : BaseEventArgs
    {
        public override void Clear()
        {
            this.Owner = null;
            this.BuffId = default;
            this.DestinationLayer = default;
        }

        public BaseRole Owner;
        public int BuffId;
        public int DestinationLayer;
    
        public override int Id => EventId;
        public static int EventId => typeof(BuffLayerModifyEventArgs).GetHashCode();
        
        public static BuffLayerModifyEventArgs Create(BaseRole owner, int id, int destinationLayer)
        {
            var res = ReferencePool.Acquire<BuffLayerModifyEventArgs>();
            // BuffLayerModifyEventArgs res = null;
            res.BuffId = id;
            res.Owner = owner;
            res.DestinationLayer = destinationLayer;
            return res;
        }
    }
}