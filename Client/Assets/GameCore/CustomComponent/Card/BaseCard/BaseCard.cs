using System;
using System.ComponentModel;
using cfg;
using cfg.demo;
using cfg.gameCard;
using Dojo.Torii;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityGameFramework.Runtime;

namespace Abyss
{
    /// <summary>
    /// 与主逻辑解耦，负责动画表现的内容
    /// </summary>
    [RequireComponent(typeof(BaseCardController))]
    public class BaseCard : EntityLogic, IObjectPool<BaseCard>
    {
        public long GUID { private set; get; }
        public CardModel CardInfo {  get; private set; }

        [SerializeField]
        private BaseCardView view { get; set; }

        private BaseCardController controller
        {
            get;
            set;
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
            
            this.view.txt_name.text = CardInfo.Name;
            this.view.txt_cost.text =  CardInfo.Cost.ToString();
            this.view.txt_desc.text = CardInfo.Desc;
        }

        public void Awake()
        {
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
    }
}