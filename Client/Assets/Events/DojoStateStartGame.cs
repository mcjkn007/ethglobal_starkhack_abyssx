using GameFramework.Event;

namespace System.Runtime.CompilerServices.Events
{
    public class DojoStateStartGame : GameEventArgs
    {
        public static int EventId = typeof(DojoStateStartGame).GetHashCode();
        public override int Id => EventId;

        public override void Clear()
        {
            
        }
    }
}