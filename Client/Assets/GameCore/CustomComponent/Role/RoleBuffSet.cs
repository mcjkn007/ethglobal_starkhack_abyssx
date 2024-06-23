using Unity.VisualScripting;
using UnityEngine;
using System.Collections.Generic;
using cfg;
using GameCore.Stats;

namespace GameCore.CustomComponent.Role
{
    public class RoleBuffSet : MonoBehaviour
    {
        private Dictionary<int, GameBuffModel> _buffModels = new Dictionary<int, GameBuffModel>();

        private GameBuffModel _modelItem;

        public void Clear()
        {
            foreach (var _buff in _buffModels)
            {
                Destroy(_buff.Value);
            }
            _buffModels.Clear();
        }

        public GameBuffModel CreateNewBuff(int cfgId, int layer)
        {
            var newModel = Instantiate(_modelItem, transform);
            newModel.Init(cfgId, layer);
            return newModel;
        }
        public void ModifyBuff(int cfgId, int targetLayer)
        {   
            var model = Entry.Luban.Tables.TbGameBuff[cfgId];
            if (model == null)
            {
                return;
            }   
            
            if (_buffModels.ContainsKey(cfgId))
            {
                _buffModels[cfgId].Modify(targetLayer);
            }
            else
            {
                _buffModels.Add(cfgId, CreateNewBuff(cfgId, targetLayer));
            }
        }
    }
}