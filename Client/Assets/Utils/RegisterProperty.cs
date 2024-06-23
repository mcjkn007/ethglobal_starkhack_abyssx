using System;
using GameCore.CustomComponent.Role;
using GameFramework;

namespace Utils
{
    public delegate void OnValueChanged<T>( T value) where T : struct, IComparable<T>;
    public class RegisterProperty<T> : IReference  where T :  struct , IComparable<T>, IEquatable<T>
    {
        private BaseRole owner;
        private OnValueChanged<T> _regist = null;
        private T val;

        public T Val
        {
            set
            {
                if (!value.Equals(this.val) )
                {
                    InvokeAllRegist(value);
                }
                this.val = value;
            }
            get => val;
        }

        public void Register(OnValueChanged<T> evt)
        {
            _regist += evt;
        }

        public void UnRegister(OnValueChanged<T> evt)
        {
            _regist -= evt;
        }

        private void InvokeAllRegist(T value)
        {
            _regist?.Invoke(value);
        }

        public void Clear()
        {
            this._regist = null;
        }

        public RegisterProperty(T val)
        {
            this.val = val;
        }

    }
}