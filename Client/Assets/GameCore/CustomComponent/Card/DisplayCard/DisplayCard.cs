using System;
using cfg;
using GameCore;
using GameFramework.Resource;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Abyss.DisplayCard
{
    public class DisplayCard : MonoBehaviour
    {
        public int index;
        public CardModel CardInfo;
        public BaseCardView view;
        private LoadAssetCallbacks LoacCallBack;
        public  void OnResourceLoadSuccessfully(string assetName,
            object asset,
            float duration,
            object userData)
        {
            Debug.LogWarning("this.index = " + this.index);
            Debug.LogWarning("资源读取成功！" + assetName + " 资源类型" + (asset).GetType() );
            var tex = (asset as Texture2D);
            this.view.img_face.sprite = Sprite.Create (tex ,new Rect(0,0,tex.width, tex.height), Vector2.one * .5f );
            // this.roleView.avatar.sprite = asset as Texture2D;
            
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

        private System.Action<int> onClickCallBack;
        public void Init(int modelId, Action<int> OnClickCallBack)
        {
            this.CardInfo = GameCore.Entry.Luban.Tables.TbCardModel[modelId];
            if (CardInfo == null)
            {
                return;
            }
            Debug.LogError("Display Card Inited" + modelId);

            this.onClickCallBack = OnClickCallBack;
            Entry.Resource.LoadAsset($"Assets/GameResource/UI/Card/card_{modelId}.png", this.LoacCallBack);;
            this.view.txt_name.text = CardInfo.Name;
            this.view.txt_guid.gameObject.SetActive(false);
            this.view.txt_cost.text =  CardInfo.Cost.ToString();
            this.view.txt_desc.text = CardInfo.Desc;
            this.view.img_quality.sprite = view.img_qualityList[this.CardInfo.Quality];
            // this.view.cardType.sprite = this.view.img_typeList[CardInfo.Cardtype + 1];
        }

        public void OnClick()
        {
            onClickCallBack?.Invoke(this.index + 1);
        }
    }
}