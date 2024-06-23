using GameFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Abyss
{
    public class BaseCardView :MonoBehaviour, IReference
    {
        public Text txt_cost;
        public Text txt_name;
        public Text txt_desc;
        public Image img_face;
        public Image img_quality;
        public GameObject go_outline;
        public Text txt_guid;
        
        public Sprite[] img_typeList;
        public Image cardType;

        public Sprite[] img_qualityList;
        public void Clear()
        {
            txt_cost = null;
            txt_name = null;
            txt_desc = null;
            img_face = null;
            img_quality = null;
            go_outline = null;

        }
    }
}