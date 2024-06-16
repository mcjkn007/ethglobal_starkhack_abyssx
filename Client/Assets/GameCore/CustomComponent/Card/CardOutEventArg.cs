using GameFramework;
using GameFramework.Event;

namespace Abyss
{
    /// <summary>
    /// 卡牌去向
    /// </summary>
    public enum CardPlace
    {
        Hand,
        Draw,
        Discard,
        Ethereal
    }

    public class CardOutEventArg : GameEventArgs
    {
        /// <summary>
        /// 获取打牌事件Id。
        /// </summary>
        public override int Id => EventId;

        public static readonly int EventId = typeof(CardOutEventArg).GetHashCode();
            
        public long GUID { get; set; }
        public object Target { set; get; }

        public CardPlace Place;

        public CardOutEventArg(long guid, CardPlace place,  object target)
        {
            this.Place = place;
            GUID = guid;
            Target = target;
        }

        public override void Clear()
        {
            this.GUID = -1;
            this.Target = null;
        }
    }
}