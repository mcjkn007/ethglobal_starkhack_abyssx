using System;
using cfg;
using GameFramework.Resource;
using UnityEngine;
using UnityEngine.UI;

namespace GameCore.Stats
{
    public class GameBuffView : MonoBehaviour
    {   
        [SerializeField]
        private Text txt_buffName;
        [SerializeField]
        private Text txt_buffLayer;
        [SerializeField]
        private Image img_icon;
        
        private LoadAssetCallbacks LoacCallBack;
        public  void OnResourceLoadSuccessfully(string assetName,
            object asset,
            float duration,
            object userData)
        {
            Debug.LogWarning("资源读取成功！" + assetName + " 资源类型" + (asset).GetType() );
            this.img_icon.sprite = asset as Sprite;
        }
        public  void OnResourceLoadFailly(string assetName,
            LoadResourceStatus status,
            string errorMessage,
            object userData)
        {
            Debug.LogWarning("资源读取失败！" + assetName + " 资源失败原因" + (status));
        }

        private void Awake()
        {
            this.LoacCallBack = new LoadAssetCallbacks(OnResourceLoadSuccessfully, OnResourceLoadFailly);
        }

        public void RefreshUI(GameBuff cfg, in int layer)
        {
            this.txt_buffLayer.gameObject.SetActive(cfg.Stackable);
            if (layer <= 0)
            {
                //如果0层 就不显示
                gameObject.SetActive(false);
            }

            if (img_icon.sprite == null)
            {
                Entry.Resource.LoadAsset( cfg.Icon.ToString(), LoacCallBack );
            }
            this.txt_buffName.text = cfg.Name;
            this.txt_buffLayer.text = layer.ToString();
        }
    }
}