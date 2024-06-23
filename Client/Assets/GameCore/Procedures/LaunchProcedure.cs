using System.Collections;
using System.Collections.Generic;
using GameCore;
using GameFramework.Fsm;
using GameFramework.Procedure;
using UnityEngine;

namespace Abyss
{
    public class LaunchProcedure : ProcedureBase
    {
        protected override void OnInit(IFsm<IProcedureManager> procedureOwner)
        {
            base.OnInit(procedureOwner);
            // Entry.Core.BeginGame();
            Entry.UI.OpenUIForm(UIPath.Login, "first");
        }
    }
}


