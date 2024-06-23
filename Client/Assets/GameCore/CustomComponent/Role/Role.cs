using System;
using System.Text;
using Abyss;
using cfg;
using DG.Tweening;
using GameFramework;
using GameFramework.Event;
using GameCore.Stats;
using GameFramework.Resource;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.PlayerLoop;
using UnityGameFramework.Runtime;
using Utils;
using Stats = GameCore.Stats;

namespace GameCore.CustomComponent.Role
{
    public class BaseRole : MonoBehaviour, IRole
    {                   
        public Stats.Stats Stat;
        [SerializeField]    
        public RoleView roleView;
        [SerializeField]    
        public RoleBuffSet BuffSet;
        private int _maxHp;
        public int maxHp
        {
            get
            {
                return _maxHp;
            }
            set
            {
                if (_maxHp == value)
                {   
                    return;
                }   
                Debug.LogError("MaxHp Modified!");
                if (_maxHp > value)
                {
                    this.roleView.avatar.DOColor(Color.red, 0.1f).SetLoops(2, LoopType.Yoyo);
                    this.roleView.avatar.transform.DOShakePosition(0.2f, 2f, 12, 0.3f);
                }
                this._maxHp = Math.Max(value, 0);
                this.roleView.slider.value = (float)hp / maxHp;
                this.roleView.txt_slider.text = $"{hp}/{maxHp}";
            }
        }
        private int hp = 0;

        public long GUID;
        public bool isEnemy;
        public GameMonster model;

        public static float leftBornPos = -12;
        // public static float leftPos = -5;
        public static float leftPos = -3.5f;
        public static float rightBornPos = 12;
        // public static float rightPos = 5;
        public static float rightPos = 3.5f;

        public static float verticalPos = -0.5f;


        // public RegisterProperty<int> Hp;
        public int Hp
        {   
            set
            {   
                Debug.Log("Hp Log Set => " + value + " | " + hp);
                if (hp == value)
                {   
                    return;
                }   
                if (hp > value && hp != 0)
                {   
                    CameraShake.isshakeCamera = true;
                    this.roleView.jumpText.Jump((hp - value).ToString());
                    this.roleView.avatar.DOColor(Color.red, 0.1f).SetLoops(2, LoopType.Yoyo);
                    this.roleView.avatar.transform.
                        DOLocalMoveX(0.1f, 0.05f).
                        SetRelative().SetLoops(4, LoopType.Yoyo).OnComplete(() =>
                        {
                            transform.position = this.transform.position;
                        });
                    // this.roleView.avatar.transform.DOShakePosition(0.2f, 2f, 2, 0f,
                    //     true, false,ShakeRandomnessMode.Harmonic);
                }
                this.hp = Math.Max(value, 0);
                this.roleView.slider.value = (float)hp / maxHp;
                this.roleView.txt_slider.text = $"{hp}/{maxHp}";
                if (hp <= 0)
                {   
                    OnDeath();
                }   
            }   
            get => hp;
        }   
        private void Awake()
        {
            this.LoacCallBack = new LoadAssetCallbacks(OnResourceLoadSuccessfully, OnResourceLoadFailly);
        }
        private int armor;
        public int Armor
        {   
            set
            {   
                if (armor == value)
                {   
                    return;
                }   
                this.armor = value;
                if (value <= 0 )
                {   
                    this.roleView.Armor.gameObject.SetActive(false);
                }
                else
                {
                    if (value < armor)
                    {
                        (this.roleView.Armor.transform as RectTransform).DOAnchorPosX(0.1f,0.05f).SetRelative().SetLoops(8, LoopType.Yoyo);
                    }
                    this.roleView.txt_armor.text = value.ToString();
                    this.roleView.Armor.gameObject.SetActive(true);
                }

                var arg = ReferencePool.Acquire<OnArmorModified>();
                arg.value = this.armor;
                arg.role = this;
                    
                Entry.Event.Fire(this, arg);
            }   
            get => armor;
        }
        private LoadAssetCallbacks LoacCallBack;
        public  void OnResourceLoadSuccessfully(string assetName,
            object asset,
            float duration,
            object userData)
        {
            Debug.LogWarning("资源读取成功！" + assetName + " 资源类型" + (asset).GetType() );
            var tex = (asset as Texture2D);
            this.roleView.avatar.sprite = Sprite.Create (tex ,new Rect(0,0,tex.width, tex.height), Vector2.one * .5f );
            // this.roleView.avatar.sprite = asset as Texture2D;
            
        }
        public  void OnResourceLoadFailly(string assetName,
            LoadResourceStatus status,
            string errorMessage,
            object userData)
        {
            Debug.LogWarning("资源读取失败！" + assetName + " 资源失败原因" + (status));
        }
        
        public void AcceptAtkDmg(int dmgValue)
        {
            CameraShake.isshakeCamera = true;
            var offset = dmgValue - this.Armor;
            if (offset > 0)
            {
                this.Armor = 0;
                this.Hp -= offset;
            }
            else
            {
                this.Armor -= dmgValue;
            }
        }

        /// <summary>
        /// 角色从画幅两侧登场
        /// </summary>
        public void UpStage()
        {
            
            OnBorn();
            
        }

        private int commandOrder = 0;
        public void ExecuteCommandChain(DG.Tweening.Sequence seq, int value)
        {
            // var commandChain = model.Behaviour[commandOrder];
            commandOrder++;
            seq.AppendInterval(2f);
            // foreach (var beha in Entry.Luban.Tables.TbCardModel[commandChain].Behaviour)
            // {
            //     Entry.CardAction.GetAction(beha.Key).Execute(this, Entry.Core.protag, beha.Value, seq);
            // }
            Entry.CardAction.GetAction(10440).Execute(this, Entry.Core.protag,value == 0 ? 5 : value , seq);
            
        }


        public void OnBorn()
        {       
            GameCore.Entry.Event.Subscribe(BuffLayerModifyEventArgs.EventId, OnBuffLayerModified);
            this.Stat = ReferencePool.Acquire<GameCore.Stats.Stats>();
        }

        public void Init(long GUID, int cfgId, bool isEnemy = true)
        {
            this.GUID = GUID;
            this.isEnemy = isEnemy;
            this.roleView.ShowEffect(1);
            Debug.Log("Hp Check " + this.Hp + ", maxHp = "+ model?.MaxHp );
            if (cfgId != 0)
            {
                this.model = Entry.Luban.Tables.TbGameMonster[cfgId];
                this.Hp = model.MaxHp;
                this.maxHp = this.hp;   
                this.roleView.txt_name.text = model.Name.ToString();
                Entry.Resource.LoadAsset($"Assets/GameResource/UI/Role/enemy_{model.Id}.png", this.LoacCallBack);
                this.roleView.ShowEffect(0);
            }
            this.Armor = 0;
            // this.roleView.ShowEffect(1);
            this.BuffSet.Clear();
            this.roleView.ShowArmor(0);
            OnBorn();
        }

        public void SetInitState(int maxHp)
        {
            if (this.model != null)
            {
                return;
            }

            this.maxHp = maxHp;
            this.Hp = this.maxHp;
        }

        /// <summary>
        /// buff层级修改时，通知到父级对象   
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="args"></param>
        private void OnBuffLayerModified(object sender, GameEventArgs args)
        {
            if ((object)args is BuffLayerModifyEventArgs arg)
            {
                if (!ReferenceEquals(this, arg.Owner)) return;
                if (arg.DestinationLayer == 0)
                {
                    this.Stat.RemoveBuff(arg.BuffId);  
                }
                else
                {   
                    this.Stat.ModifyBuffLayer(arg.BuffId, arg.DestinationLayer);
                }
            }
        }
                    
        public void OnDeath()
        {
            // Entry.Core.GetRecorder().Print(" Recorder ");
            // Entry.Dojo.CheckE1Battle();
            if (isEnemy)
            {
                Debug.LogError(" choose Choose");
                DOTween.Sequence().AppendInterval(0.5f).AppendCallback(
                    () =>
                    {
                        Debug.LogError(" cardSelect Choose");
                        Entry.Core.battleLogic.cardSelect.Open(null);
                    }).Play();
            }

            GameCore.Entry.Event.Unsubscribe(BuffLayerModifyEventArgs.EventId, OnBuffLayerModified);

            this.GetComponent<Collider2D>().enabled = false;
            this.GetComponent<SpriteRenderer>().DOFade(0, 0.2f).OnComplete(() =>
            {
                gameObject.SetActive(false);
            });
        }
                
        public void ModifyBuff(int buffId, int layer)
        {   
            this.BuffSet.ModifyBuff(buffId, layer);
        }   
    }           
}   