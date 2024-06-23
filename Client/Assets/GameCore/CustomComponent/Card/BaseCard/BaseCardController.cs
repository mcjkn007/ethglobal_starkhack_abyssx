using System;
using System.Collections;
using System.Linq;
using System.Threading;
using cfg.gameCard;
using Coffee.UIExtensions;
using UnityEngine;
using UnityEngine.EventSystems;
using DG.Tweening;
using GameCore;
using GameCore.CustomComponent.Role;
using GameCore.Facade;
using UnityEditorInternal.Profiling.Memory.Experimental.FileFormat;
using UnityEngine.UI;
using Utils;
using Sequence = DG.Tweening.Sequence;

namespace Abyss
{
    public class BaseCardController : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler,
        IPointerEnterHandler, IPointerExitHandler
    {
        private float _verticalDistanceOffset = 0f;
        private float _verticalOriginalPosY = 0f;
        BaseCard _model;
        BaseCardView _view;
        private Operation operation;
        private Func<object> FuncNoSelection;
        private Func<object> FuncSelectEnemy;
        public bool isOnMiddle = false;
        
        [SerializeField]
        private UIDissolve[] _uiDissolve;
        
        private static bool DragingMode = false;
        private float _dissolveLocation = 0f;
        public float location
        {
            get => _dissolveLocation;
            set
            {
                _dissolveLocation = value;
                foreach (var singleDissolve in _uiDissolve)
                {
                    singleDissolve.location = value;
                }
            }
        }
        
        public static BaseCard s_currentSelectCard;
        public static BaseCard s_lastSelectCard;
        public static BaseCard s_currentDragCard;

        private static WaitForSeconds wfs = new WaitForSeconds(0.02f);
        
        private static Vector2[] _MouseMovementPoints = new Vector2[18];

        public bool isLocking = false;
        
        private static float standardHeight = 162f;
        private static float heightLightHeight = 262f;

        private void Awake()
        {
            this._model = GetComponent<BaseCard>();
            this._view = GetComponent<BaseCardView>();
            this.location = 0f;
        }

        [SerializeField] [Tooltip("单次放大或缩小所需时间")]
        private float _scaleModifyDuration = 0.1f;

        private Sequence _sequence;

        public void Init(Operation operation)
        {
            this.operation = operation;
        }
        
        private object OnSelect()
        {
            return null;
        }

        private Vector2 mousePos;
        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.R))
            {
                OnConsume();
                // Entry.Entity.ShowEntity<BaseCard>(12, "Assets/GameResource/UI/BaseCard/BaseCard.prefab", "this");
            }

            if (Input.GetMouseButton(0))
            {
                if (isOnMiddle)
                {
                    return;
                }

                // Log.Info("Input.getButtonDown " + Input.mousePosition.y);
                if (s_currentDragCard != this._model)
                {
                    return;
                }

                // Log.Info("CurrentDragCard pos.y => " + Input.mousePosition.y);
                    if (Input.mousePosition.y >= 300f)
                    {
                        
                        //如果鼠标已经足够靠上
                        if (s_currentSelectCard == this._model)
                        {
                            
                            ToMiddle();
                            if (this._model.CardInfo.Operation == Operation.SELECT_ENEMY)
                            {
                                //如果卡片是需要选中目标的 
                                shouldShowSpline = true;
                            }
                            else
                            {
                                //如果卡片是直接脱手的
                                
                            }
                        }
                    }
                    else
                    {
                        shouldShowSpline = true;
                        //不够靠上
                        transform.position = new Vector3(Entry.Core.UICamera.ScreenToWorldPoint(Input.mousePosition).x,Entry.Core.UICamera.ScreenToWorldPoint(Input.mousePosition) .y , transform.position.z);
                    }
            }
        }  

        private void OnEnable()
        {
            _verticalOriginalPosY = transform.position.y;
        }

        public void OnBeginDrag(PointerEventData eventData)
        {
            if (isLocking)
            {
                return;
            }
            s_currentDragCard = _model;
            Debug.LogError("OnBeginDrag");
        }

        private  Image img;

        public  Image Img
        {
            get
            {
                if (img == null)
                {
                    img = new GameObject().AddComponent<Image>();
                    img.transform.parent = transform;
                    img.transform.localScale = Vector3.one;
                    img.GetRectTransform().sizeDelta = Vector2.one * 100;
                }
                return img;
            }
        }

        public void ShowSpine(Vector2 destinationScreenPos)
        {
            // destinationScreenPos = destinationScreenPos / 2f - new Vector2(Screen.width, Screen.height) / 4f;
            destinationScreenPos = destinationScreenPos  - new Vector2(Screen.width, Screen.height) / 2f ;
            var startPos =  (GetComponentInParent<UIBattleLogic>().transform.TransformPoint(transform.position).ToVector2() - new Vector2(0, 300f) + 
                             new Vector2(this.GetRectTransform().anchoredPosition.x, 0));
            // var startControlPoint = startPos + Vector2.up * 300;
            var startControlPoint = new Vector2(startPos.x, destinationScreenPos.y + 10);
            // var endControlPoint = destinationScreenPos + Vector2.left * 500;
            var tempEndControlPoint = new Vector2(startPos.x, destinationScreenPos.y);
            var endControlPoint = destinationScreenPos + Vector2.left * 300;
            MathUtils.GetBezierCurveThreeTimesByQuantityOf18(
                startPos,
                startControlPoint,
                destinationScreenPos,
                tempEndControlPoint,
                _MouseMovementPoints);
            Facade.OnBaseCardDrag(_MouseMovementPoints);
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            s_currentDragCard = null;
            isOnMiddle = false;
            shouldShowSpline = false;

            // if (isLocking)
            // {
            //     return;
            // }

            OnRecover();
            _verticalDistanceOffset = 0f;

            if (_model.CardInfo.Operation == Operation.NONE)
            {
                OnEndDragNoneSelect(eventData);
            }
            else
            {
                OnEndDragSelect(eventData);
            }

            this.transform.SetSiblingIndex(originalOrderIndex);
            Facade.HideSplinePointer();
            Facade.HandCardReposition();
        }

        private void OnEndDragSelect(PointerEventData eventData)
        {
            
            Collider2D[] hits  = Physics2D.OverlapPointAll(Entry.Core.UICamera.ScreenToWorldPoint(Input.mousePosition) );
            for (int i = 0; i < hits.Length; i++)
            {   
                var baseRole = hits[i].transform.GetComponent<BaseRole>();
                if (baseRole != null)
                {
                    ExecuteCard(baseRole);
                }
                else
                {
                }
            }
        }

        private void OnEndDragNoneSelect(PointerEventData eventData)
        {
            if (eventData.position.y >= 300f)
            {
                ExecuteCard(null);
            }
        }

        private void ExecuteCard(BaseRole target)
        {
            if (target != null && !target.isEnemy)
            {
                return;
            }
            
            if (Entry.Core.Energy.Val < _model.CardInfo.Cost)
            {
                return;
            }

            if (_model.CardInfo.Operation == Operation.SELECT_ENEMY && target == null)
            {
                return;
            }
            Debug.Log("card out  guid = " + _model.GUID);
            Entry.Core.Record( 1, (ushort)_model.GUID );
            //如果有接触
            foreach (var keyValuePair in this._model.CardInfo.Behaviour)
            {
                var action = Entry.CardAction.GetAction(keyValuePair.Key);
                action.Execute(Entry.Core.protag, target, keyValuePair.Value,null);
            }
            if (_model.CardInfo.FlagOperation.HasFlag(ExtraOperation.ETHEREAL))
            {
                //卡牌被消耗掉
                _model.Consume();
            }
            else
            {
                //卡牌进弃牌堆
                Facade.HandToDiscard(_model);
            }

            Entry.Core.Energy.Val -= _model.CardInfo.Cost;
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            if (isLocking)
            {
                return;
            }
            OnBig();
        }
            
        public void OnPointerExit(PointerEventData eventData)
        {
            if (isLocking)
            {
                return;
            }
            OnRecover();
        }

        private void OnBig()
        {
            if (s_currentDragCard == this._model)
            {
                return;
            }

            _sequence.Complete();
            _view.go_outline.SetActive(true);
            s_currentSelectCard = this._model;
            s_currentSelectCard.transform.DOScale(1.1f, _scaleModifyDuration);
            s_currentSelectCard.GetRectTransform().DOAnchorPosY(heightLightHeight, _scaleModifyDuration);
            Facade.HandCardReposition(s_currentSelectCard);
            //开海
        }
        
        private void OnRecover()
        {   
            if (s_currentDragCard == this._model)
            {
                return;
            }

            _sequence.Complete();
            _view.go_outline.SetActive(false);
            s_lastSelectCard = this._model;
            s_lastSelectCard.transform.DOScale(1f, _scaleModifyDuration);
            s_lastSelectCard.GetRectTransform().DOAnchorPosY(standardHeight, _scaleModifyDuration);
            if (s_currentSelectCard)
            {    
                //如果当前没有选中的卡牌
                Facade.HandCardReposition();
            }
        }

        private bool shouldShowSpline = false;
        private int originalOrderIndex = 0;
        public void OnDrag(PointerEventData eventData)
        {
            Debug.LogError("OnDrag ");
            if (isLocking)
            {
                return;
            }

            if (shouldShowSpline && _model.CardInfo.Operation == Operation.SELECT_ENEMY)
            {
                ShowSpine(eventData.position);
            }

        }
        /// <summary>
        /// 消耗掉的卡片
        /// </summary>
        public void OnConsume()
        {   
            this.transform.DOMove(Vector2.zero, 0.3f).OnComplete(() =>
            {
                StartCoroutine(StartConsume());
            });
        }

        IEnumerator StartConsume()
        {
            while (location <= 1)
            {
                location += 0.02f;
                yield return wfs;
            }
            
            location = 1;
            gameObject.SetActive(false);
        }

        public void ToMiddle()
        {
            if (isOnMiddle)
            {
                return;
            }
            
            this.isOnMiddle = true;
            var _sequence = DOTween.Sequence();
            originalOrderIndex = transform.GetSiblingIndex();
            transform.SetAsLastSibling();
            _sequence.Append(this.GetRectTransform().DOAnchorPos(new Vector2(0, heightLightHeight), 0.2f));
            _sequence.Play();
        }
    }
}