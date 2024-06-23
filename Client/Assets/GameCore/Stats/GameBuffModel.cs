using System;
using cfg;
using GameFramework.Resource;
using UnityEngine;
using UnityEngine.UI;

namespace GameCore.Stats
{
    public class GameBuffModel : MonoBehaviour
    {
        [SerializeField]
        public GameBuffView _view;

        private GameBuff _buff;
        private int layer = Int32.MinValue;
        private int Layer
        {
            get
            {
                return layer;
            }
            set
            {
                if (layer != value)
                {
                    _view.RefreshUI(_buff, value);
                }
                this.layer = value;
            }
        }

        public void Init(int cfgId, int layer = 1)
        {
            this._buff = Entry.Luban.Tables.TbGameBuff[cfgId];
            this.Layer = layer;
        }

        public void Modify(int layer)
        {
            this.Layer = layer;
        }
    }
}