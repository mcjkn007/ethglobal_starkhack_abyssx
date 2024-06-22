using System;
using System.Collections.Generic;
using GameCore;
using GameFramework;
using GameFramework.Fsm;
using UnityGameFramework.Runtime;

namespace Abyss
{
    public class BattleState : IFsm<UIFormLogic>
    {
        private IFsm<UIFormLogic> _fsmImplementation = Entry.Fsm.GetFsm<UIFormLogic>();
        public void Start<TState>() where TState : FsmState<UIFormLogic>
        {
            _fsmImplementation.Start<TState>();
        }

        public void Start(Type stateType)
        {
            _fsmImplementation.Start(stateType);
        }

        public bool HasState<TState>() where TState : FsmState<UIFormLogic>
        {
            return _fsmImplementation.HasState<TState>();
        }

        public bool HasState(Type stateType)
        {
            return _fsmImplementation.HasState(stateType);
        }

        public TState GetState<TState>() where TState : FsmState<UIFormLogic>
        {
            return _fsmImplementation.GetState<TState>();
        }

        public FsmState<UIFormLogic> GetState(Type stateType)
        {
            return _fsmImplementation.GetState(stateType);
        }

        public FsmState<UIFormLogic>[] GetAllStates()
        {
            return _fsmImplementation.GetAllStates();
        }

        public void GetAllStates(List<FsmState<UIFormLogic>> results)
        {
            _fsmImplementation.GetAllStates(results);
        }

        public bool HasData(string name)
        {
            return _fsmImplementation.HasData(name);
        }

        public TData GetData<TData>(string name) where TData : Variable
        {
            return _fsmImplementation.GetData<TData>(name);
        }

        public Variable GetData(string name)
        {
            return _fsmImplementation.GetData(name);
        }

        public void SetData<TData>(string name, TData data) where TData : Variable
        {
            _fsmImplementation.SetData(name, data);
        }

        public void SetData(string name, Variable data)
        {
            _fsmImplementation.SetData(name, data);
        }

        public bool RemoveData(string name)
        {
            return _fsmImplementation.RemoveData(name);
        }

        public string Name => _fsmImplementation.Name;

        public string FullName => _fsmImplementation.FullName;

        public UIFormLogic Owner => _fsmImplementation.Owner;

        public int FsmStateCount => _fsmImplementation.FsmStateCount;

        public bool IsRunning => _fsmImplementation.IsRunning;

        public bool IsDestroyed => _fsmImplementation.IsDestroyed;

        public FsmState<UIFormLogic> CurrentState => _fsmImplementation.CurrentState;

        public float CurrentStateTime => _fsmImplementation.CurrentStateTime;
    }
}