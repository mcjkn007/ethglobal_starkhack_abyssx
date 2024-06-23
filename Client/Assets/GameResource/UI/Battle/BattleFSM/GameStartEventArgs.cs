using System.Security.Claims;
using GameFramework.Event;

namespace Abyss.BattleFSM
{
    public class GameStartEventArgs : GameEventArgs
    {
        public static int EventId = typeof(GameEventArgs).GetHashCode();
        public override int Id => EventId;
        
        public override void Clear()
        {
            
        }
    }
}