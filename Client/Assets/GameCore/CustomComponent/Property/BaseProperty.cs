// using System;
// using Abyss;
// using cfg;
// using GameCore.CustomComponent.Role;
// using UnityEngine;
//
// namespace GameCore.Stats
// {
//     public abstract class BaseGameProperty
//     {
//         private int layer;
//
//         public int Layer
//         {
//             set
//             {
//                 if (this.layer != value)
//                 {
//                     OnLayerChange();
//                 }
//
//                 this.layer = value;
//             }
//             get => layer;
//         }
//
//         public BaseRole owner;
//         public GameBuff cfg { get; protected set; }
//
//         public GameBuffView view;
//
//         public void SetView(GameBuffView view)
//         {
//             this.view = view;
//         }
//
//         public virtual void Calculate(ref int originalValue)
//         {
//             z
//         }
//
//         public virtual void OnRoundStart()
//         {
//             
//         }
//         
//         public virtual void OnRoundEnd()
//         {
//             if (this.cfg.Stackable  && this.layer > 0 && this.cfg.Loss)
//             {
//                 this.layer--;
//             }
//         }
//
//         public virtual void OnApply()
//         {
//             
//         }
//
//         public bool IsActive()
//         {
//             return this.layer >= 1;
//         }
//         
//         protected virtual void OnLayerChange()
//         {
//         }
//         
//         public BaseGameProperty(BaseRole owner)
//         {
//             this.cfg = null;
//         }
//
//     }
// }