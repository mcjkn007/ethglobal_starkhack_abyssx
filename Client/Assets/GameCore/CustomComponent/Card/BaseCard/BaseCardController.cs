using System;
using System.Threading;
using cfg.gameCard;
using UnityEngine;
using UnityEngine.EventSystems;
using DG.Tweening;
using GameCore;
using GameCore.Facade;
using UnityEditor.PackageManager;
using UnityEngine.UI;
using UnityGameFramework.Runtime;
using Utils;
using Sequence = DG.Tweening.Sequence;

namespace Abyss
{
    public class BaseCardController : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler,
        IPointerEnterHandler, IPointerExitHandler
    {
        private float _verticalDistanceOffset = 0f;
        private float _verticalOriginalPosY = 0f;
        BaseCard model;
        BaseCardView _view;
        private Operation operation;
        private Func<object> FuncNoSelection;
        private Func<object> FuncSelectEnemy;

        public static BaseCard s_currentSelectCard;
        public static BaseCard s_lastSelectCard;
        
        private static Vector2[] _MouseMovementPoints = new Vector2[18];

        private void Awake()
        {
            this._view = GetComponent< BaseCardView > ();
        }
        
            
        [SerializeField]
        [Tooltip("单次放大或缩小所需时间")]
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
        
        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                // Entry.Entity.ShowEntity<BaseCard>(12, "Assets/GameResource/UI/BaseCard/BaseCard.prefab", "this");
            }
        }

        private void OnEnable()
        {
            _verticalOriginalPosY = transform.position.y;
        }
        
        public void Init(BaseCard model, Func<object> FuncNoSelection, Func<object> FuncSelectEnemy)
        {   
            _sequence ??= DOTween.Sequence();
            this.model = model;
        }
        
        public void OnBeginDrag(PointerEventData eventData)
        {
            var pos = eventData.position;
            Debug.LogError("OnBeginDrag");
        }
            
        public void ShowSpine(Vector2 destinationScreenPos)
        {
            // var startPos =((RectTransform)transform).anchoredPosition - new Vector2(Screen.width, Screen.height) / 2 ;
            var startPos =(transform.position * 100).ToVector2();
            Log.Info("startPos = " + startPos + ", transform.position = " + transform.position );
            var startControlPoint = startPos + Vector2.up * 500;
            var endControlPoint = destinationScreenPos + Vector2.left * 500;
            MathUtils.GetBezierCurveThreeTimesByQuantityOf18(
                startPos,
                startControlPoint,
                destinationScreenPos,
                // destinationScreenPos+ Vector2.left * 200,
                endControlPoint,
                _MouseMovementPoints);
            Facade.OnBaseCardDrag(_MouseMovementPoints);
        }
        

        public void OnEndDrag(PointerEventData eventData)
        {
            //reset vertical counter
            _verticalDistanceOffset = 0f;
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            OnBig();
        }

        public void OnPointerExit(PointerEventData eventData)
        {     
            OnRecover();
        }
        private void OnBig()
        {
            _sequence.Kill();
            _view.go_outline.SetActive(true);
            s_currentSelectCard = this.model;
            // _sequence.Append(transform.DOScale(1.1f, _scaleModifyDuration));
        }

        private void OnRecover()
        {
            _sequence.Kill();
            _view.go_outline.SetActive(false);
            s_lastSelectCard = this.model;
            // _sequence.Append(transform.DOScale(1f, _scaleModifyDuration));
        }

        public void OnDrag(PointerEventData eventData)
        {
            Debug.LogError("OnDrag");
            ShowSpine( eventData.position - new Vector2(Screen.width, Screen.height) / 2);
        }
    }
}