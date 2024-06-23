using System;
using DG.Tweening;
using UnityEditor;
using UnityEngine;
using Utils;

namespace GameCore.CustomComponent.Role
{
    public class RoleController : MonoBehaviour
    {
        [SerializeField]
        private BaseRole model;
        [SerializeField]
        private RoleView view;

        public Sequence _sequence ;

        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.J))
            {
                OnHurt();
            }
        }
        
        public void OnHurt()
        {
            if (_sequence == null)
            {
                _sequence = DOTween.Sequence();
                
            }
            _sequence.Complete();
            _sequence.Append(view.transform.DOLocalMoveX(0.1f,0.2f)).SetRelative()
                .Join(view.avatar.DOColor(Color.red, 0.1f))
                .Append(view.avatar.DOColor(Color.white, 0.1f))
                .Append(view.transform.DOLocalMoveX(-0.1f, 0.2f)).SetRelative();
            _sequence.Play();
        }
    }
}