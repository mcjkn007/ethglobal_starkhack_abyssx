using System;
using GameFramework;
using Unity.VisualScripting;

namespace GameCore.BindProperty
{

    public class BindProperty<T> : IReference   where T : struct, IEquatable<T>
    {
        public delegate void OnBindPropertyChange(T prev, T after);

        private OnBindPropertyChange _onBindPropertyChangeEvt;
        private T val;
        public T Value
        {
            get => val;
            set
            {
                if (!value.Equals(val))
                {
                    _onBindPropertyChangeEvt?.Invoke(val, value);
                    val = value;
                }
            }
        }

        public void AddEvent(OnBindPropertyChange action)
        {
            _onBindPropertyChangeEvt += action;
        }

        public void RemoveEvent(OnBindPropertyChange action)
        {
            _onBindPropertyChangeEvt -= action;
        }
        
        public void Clear()
        {
            val = default;
            _onBindPropertyChangeEvt = null;
        }
    }
}