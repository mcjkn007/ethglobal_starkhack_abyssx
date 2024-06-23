using Abyss;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

namespace GameCore.CustomComponent.Role
{
    public class RoleView : MonoBehaviour
    {
        public BaseRole Role;
        public SpriteRenderer avatar;
        public Text txt_name;
        public Text txt_armor;
        public GameObject Armor;
        public Slider slider;
        public Text txt_slider;
        public Image img_attention;
        public Transform trans_buffParent;
        public JumpText jumpText;
        public void ShowEffect(int effect = 0)
        {
            img_attention.gameObject.SetActive(effect == 0);
        }

        public void ShowArmor(int armor = 0)
        {
            Armor.gameObject.SetActive(false);
        }
    }

}