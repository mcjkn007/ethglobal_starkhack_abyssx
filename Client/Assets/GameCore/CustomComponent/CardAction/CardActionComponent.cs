using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using UnityGameFramework.Runtime;
using Utils;
using CustomAttributeExtensions = System.Reflection.CustomAttributeExtensions;

namespace Abyss.GameAction
{
}

namespace Abyss
{
    public class CardActionComponent : GameFrameworkComponent
    {
        private Dictionary<int, BaseGameAction> _mapActions = new Dictionary<int, BaseGameAction>();
        private void InitCardActions()
        {
            _mapActions.Clear();
            var types = TypeExt.GetAllTypesInNamespace(nameof(Abyss.GameAction));
            
            foreach (var type in types)
            {
                var objs = type.GetCustomAttributes(typeof(CardActionAttribute), false);
                if (objs.Length == 0)
                {
                    continue;
                }
                // var k = (objs[0] as CardActionAttribute).
                // _mapActions.Add();
            }
        }
    }
}