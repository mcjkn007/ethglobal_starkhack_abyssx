using GameCore;
using GameFramework.Fsm;
using GameFramework.Procedure;

namespace Abyss
{
    public class MainProcedure : ProcedureBase
    {   
        protected override void OnEnter(IFsm<IProcedureManager> procedureOwner)
        {
            base.OnEnter(procedureOwner);
            var loginPanel = Entry.UI.GetUIForm(UIPath.Login);
            Entry.UI.CloseUIForm(loginPanel);
            // Entry.UI.OpenUIForm(UIPath.Battle, "first");
            // var battlelogic = Entry.UI.GetUIForm(UIPath.Battle).GetComponent<UIBattleLogic>();
            Entry.Core.BeginGame(null);
        }
        
        public static void ChangeState()
        {
            var loginPanel = Entry.UI.GetUIForm(UIPath.Login);
            Entry.Core.TriiggeredStartGame();
        }
    }
}