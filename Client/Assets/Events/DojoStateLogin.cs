using GameFramework.Event;

namespace System.Runtime.CompilerServices.Events
{
    public class DojoStateLogin : GameEventArgs
    {
        public static int EventId = typeof(DojoStateLogin).GetHashCode();
        public override int Id => EventId;

        public override void Clear()
        {
            
        }
    }
}