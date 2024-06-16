using cfg;
using UnityEngine;
using UnityEngine.UI;

namespace GameCore.Stats
{
    public class GameBuffView : MonoBehaviour
    {
        [SerializeField]
        private Text txt_buffName;
        [SerializeField]
        private Text txt_buffLayer;

        public void RefreshUI(GameBuff cfg, in int layer)
        {
            if (layer <= 0)
            {
                //如果0层 就不现实
                gameObject.SetActive(false);
            }

            this.txt_buffName.text = cfg.Name;
            this.txt_buffLayer.text = layer.ToString();
        }
    }
}