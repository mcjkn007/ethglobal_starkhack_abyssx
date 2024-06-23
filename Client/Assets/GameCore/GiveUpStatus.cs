using GameFramework.Event;

namespace Abyss
{
    public class GiveupStatus : GameEventArgs
    {
        public override void Clear()
        {
            bool isSuccessful = false;
            string errMsg = "";
        }

        public bool isSuccessful = false;
        public string errMsg = "";
        public override int Id => EventId;
        public static int EventId = typeof(GiveupStatus).GetHashCode();

        public static GiveupStatus Create(bool isSuccessful, string errMsg = "")
        {
            var res = new GiveupStatus();
            res.isSuccessful = isSuccessful;
            res.errMsg = errMsg;
            return res;
        }
    }
}