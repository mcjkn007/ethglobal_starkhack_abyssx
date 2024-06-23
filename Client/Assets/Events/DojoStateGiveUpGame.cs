using GameFramework.Event;

namespace System.Runtime.CompilerServices.Events
{
    public class DojoStateGiveUpGame : GameEventArgs
    {
        public static int EventId = typeof(DojoStateGiveUpGame).GetHashCode();
        public override int Id => EventId;

        
        public override void Clear()
        {
            throw new System.NotImplementedException();
        }
    }
}