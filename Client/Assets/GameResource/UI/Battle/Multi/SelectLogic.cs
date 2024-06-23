using System.Collections.Generic;
using GameCore;
using UnityEngine;
using UnityEngine.UI;
using Utils;

namespace Abyss.Multi
{
    public class SelectLogic : MonoBehaviour
    {
        public SelectForm form;

        private IList<RoadNode> currentNodes;
        public void GetDisplayInfo()
        {
            currentNodes = new List<RoadNode>();
            var node = Entry.Core.curRoadNode;
            if (node == RoadNode.None)
            {
                var seed = RandUtils.standard_seed;
                var result = RandUtils.GerRandomByStage(0, Entry.Core.Stage.Val);
                var random = RandUtils.Random(ref result, 0,100);
                
                if (Entry.Core.Stage.Val == 6)
                {
                    currentNodes.Add(RoadNode.Chest);              
                }
                else
                {
                    currentNodes.Add(RoadNode.Normal);              
                }

                if (Entry.Core.Stage.Val == 12  || Entry.Core.Stage.Val == 2|| random < 20)
                {
                    currentNodes.Add(RoadNode.Camp);              
                }
                else if (random < 40)
                {
                    currentNodes.Add(RoadNode.Event);              
                }
            }

            RefreshUI();
        }

        private void RefreshUI()
        {
            for (int i = 0; i < currentNodes.Count; i++)
            {
                if (i >= form.select.Length)
                {
                    return;
                }
                form.select[i].Init(currentNodes[i]);
            }
        }
    }
}