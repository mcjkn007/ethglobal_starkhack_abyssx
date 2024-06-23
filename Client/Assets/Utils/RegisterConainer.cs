// using System;
// using System.Collections.Generic;
// using GameCore.CustomComponent.Role;
// using GameFramework;
//
// namespace Utils
// {
//     public class RegisterContainer<T> : IReference  where T : ICollection<T> , IComparable<T>, IEquatable<T>
//     {
//         private BaseRole owner;
//         private OnValueChanged<T> _regist = null;
//         private T val;
//
//         public T Val
//         {
//             set
//             {
//                 if (!value.Equals(this.val) )
//                 {
//                     InvokeAllRegist(val);
//                 }
//                 this.val = value;
//             }
//             get => val;
//         }
//
//         public void Register(OnValueChanged<T> evt)
//         {
//             _regist += evt;
//         }
//
//         public void UnRegister(OnValueChanged<T> evt)
//         {
//             _regist -= evt;
//         }
//
//         private void InvokeAllRegist(T value)
//         {
//             _regist?.Invoke(value);
//         }
//
//         public void Clear()
//         {
//             this._regist = null;
//         }
//
//         public RegisterProperty(T val)
//         {
//             this.val = val;
//         }
//
//     }
// }