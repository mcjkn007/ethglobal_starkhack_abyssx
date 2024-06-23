using System.Collections;
using System.Collections.Generic;
using System.Net.Mime;
using Abyss;
using UnityEngine;
using UnityEngine.UI;

public class DrawCountListener : MonoBehaviour
{
    public UIBattleLogic logic;

    private UnityEngine.UI.Text txt;
    // Start is called before the first frame update
    void Start()
    {
        txt = GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {
        this.txt.text = logic?.cardSet?.drawPile.Count.ToString();
    }
}
