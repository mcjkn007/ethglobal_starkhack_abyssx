using System;
using System.ComponentModel;
using cfg;
using cfg.gameCard;
using Dojo.Torii;
using GameCore;
using GameFramework.Resource;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityGameFramework.Runtime;
using Utils;

namespace Abyss
{
    /// <summary>
    /// 与主逻辑解耦，负责动画表现的内容
    /// </summary>
    public class BaseCard : EntityLogic, IObjectPool<BaseCard>
    {
        public long GUID { private set; get; }
        public CardModel CardInfo {  get; private set; }

        [SerializeField]
        private BaseCardView view { get; set; }

        [SerializeField]
        private BaseCardController controller;

        [SerializeField]
        private Sprite[] sprite_qualities;
        public bool isLocking
        {
            get => controller.isLocking;
            set
            {
                controller.isLocking = value;
            }
        }

        // public abstract CardModel CardInfo {  set; get; }
        public void BeginDrag()
        {
            switch (CardInfo.Operation)
            {
                case Operation.NONE:
                    //打出即可
                    break;
                case Operation.SELECT_ENEMY:
                    //选择一个敌人
                    break;
            }
        }
        private void Awake()
        {
            this.LoacCallBack = new LoadAssetCallbacks(OnResourceLoadSuccessfully, OnResourceLoadFailly);
        }
        public void Init(int modelId, long GUID)
        {
            this.GUID = GUID;
            this.CardInfo = GameCore.Entry.Luban.Tables.TbCardModel[modelId];
            if (CardInfo == null)
            {
                return;
            }

            if (this.view == null)
            {
                this.view = GetComponent<BaseCardView>();
            }
            Entry.Resource.LoadAsset($"Assets/GameResource/UI/Card/card_{modelId}.png", this.LoacCallBack);;
            this.view.txt_name.text = CardInfo.Name;
            this.view.txt_guid.text = GUID.ToString();
            this.view.txt_cost.text =  CardInfo.Cost.ToString();
            this.view.txt_desc.text = CardInfo.Desc;
            this.view.img_quality.sprite = view.img_qualityList[this.CardInfo.Quality];
            // this.view.cardType.sprite = this.view.img_typeList[CardInfo.Cardtype + 1];
        }
        private LoadAssetCallbacks LoacCallBack;
        public  void OnResourceLoadSuccessfully(string assetName,
            object asset,
            float duration,
            object userData)
        {
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

        /// <summary>
        /// 防止自定义派生
        /// </summary>
        private BaseCard()
        {
        }
        /// <summary>
        /// 卡牌飞向弃牌堆
        /// </summary>
        private void ToDiscard()
        {
            
        }

        public BaseCard Get()
        {
            return this;
        }

        public PooledObject<BaseCard> Get(out BaseCard v)
        {
            v = this;
            return default;
        }

        public void Release(BaseCard element)
        {
            
        }

        public void Clear()
        {
            
        }

        public int CountInactive { get; }

        public void Consume()
        {
            this.controller.OnConsume();
        }

    }
}