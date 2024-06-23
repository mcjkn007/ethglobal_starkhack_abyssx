using cfg;
using GameCore;
using GameFramework.Resource;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Abyss.DisplayCard
{
    public class DisplayCardController : MonoBehaviour,IPointerEnterHandler, IPointerExitHandler, IPointerClickHandler
    {
        public static DisplayCardController s_currentSelectCard;
        public BaseCardView view;
        public DisplayCard model;
        [HideInInspector]
        public System.Action<int> onClickCallBack;
        public void OnPointerEnter(PointerEventData eventData)
        {
            view.go_outline.SetActive(true);
            s_currentSelectCard = this;
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            view.go_outline.SetActive(false);
        }

        public void OnPointerClick(PointerEventData eventData)
        {
            model.OnClick();
        }
    }
}