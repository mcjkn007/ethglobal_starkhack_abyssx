using System;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

namespace Abyss.Multi
{
    public class SelectLogicItem : MonoBehaviour
    {
        public Text txt_title;
        public Text txt_desc;

        public Image img_type;
        
        public Action<int> actCallback;
        private Button btn_self;
        private int index = -1;
        public Sprite[] Icons;

        public RoadNode selfNode;
        private void Awake()
        {
            this.btn_self = GetComponent<Button>();
        }
        
        public void Init(int idx, string title, string desc, Action<int> callBack)
        {
            this.gameObject.SetActive(true);
            this.txt_title.text = title;
            this.txt_desc.text = desc;
            this.index = idx;
            this.btn_self.onClick.RemoveAllListeners();
            this.btn_self.onClick.AddListener(() =>
            {
                callBack?.Invoke(this.index);
            });
        }

        public void Init(RoadNode roadNode)
        {
            selfNode = roadNode;
            gameObject.SetActive(true);
            switch (roadNode)
            {
                case RoadNode.Normal:
                    this.img_type.sprite = Icons[0];
                    // this.txt_title.text = "";
                    break;
                case RoadNode.Epic:
                    this.img_type.sprite = Icons[1];
                    break;
                case RoadNode.Boss:
                    this.img_type.sprite = Icons[2];
                    break;
                case RoadNode.Chest:
                    this.img_type.sprite = Icons[3];
                    break;
                case RoadNode.Event:
                    this.img_type.sprite = Icons[4];
                    break;
                case RoadNode.Shop:
                    this.img_type.sprite = Icons[5];
                    break;
                case RoadNode.Camp:
                    this.img_type.sprite = Icons[6];
                    break;
            }
        }
    }
}