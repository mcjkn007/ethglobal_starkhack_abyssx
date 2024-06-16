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
            Debug.LogWarning("Procedure Base Launched!");
            base.OnInit(procedureOwner);
            // Entry.Core.BeginGame();
            Entry.UI.OpenUIForm(UIPath.Battle, "first");
        }
    }
}


