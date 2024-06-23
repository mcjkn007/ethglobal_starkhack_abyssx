using GameFramework.Event;

namespace Abyss
{
    public class AccountLoginStatus : GameEventArgs
    {
        public override void Clear()
        {
            bool isSuccessful = false;
            string errMsg = "";
        }

        public bool isSuccessful = false;
        public string errMsg = "";
        public override int Id => EventId;
        public static int EventId = typeof(AccountLoginStatus).GetHashCode();

        public static AccountLoginStatus Create(bool isSuccessful, string errMsg = "")
        {
            var res = new AccountLoginStatus();
            res.isSuccessful = isSuccessful;
            res.errMsg = errMsg;
            return res;
        }
    }
}