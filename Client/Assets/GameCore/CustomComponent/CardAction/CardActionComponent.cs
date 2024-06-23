using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Abyss.GameActions;
using UnityEngine;
using UnityGameFramework.Runtime;
using Utils;
using CustomAttributeExtensions = System.Reflection.CustomAttributeExtensions;


namespace Abyss
{
    public class CardActionComponent : GameFrameworkComponent
    {
        private Dictionary<int, BaseGameAction> _mapActions = new Dictionary<int, BaseGameAction>();
        private void InitCardActions()
        {
            _mapActions.Clear();
            var types = TypeExt.GetAllTypesInNamespace(("Abyss.GameActions"));
            
            foreach (var type in types)
            {
                var objs = type.GetCustomAttributes(typeof(CardActionAttribute), false);
                if (objs == null || objs.Length == 0)
                {
                    continue;
                }
                var k = (objs[0] as CardActionAttribute).Id;
                _mapActions[k] = Activator.CreateInstance(type) as BaseGameAction;
                // _mapActions.Add();
            }
            // _mapActions.Print("MapAction");
        }

        public BaseGameAction GetAction(int id)
        {
            return _mapActions[id];
        }

        protected override void Awake()
        {
            Debug.LogError("cardAction Awake");
            base.Awake();
            
            InitCardActions();
        }
    }
}