using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Abyss;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;
using Utils;

public class UIBattleForm : MonoBehaviour
{
    [Header("卡牌相关")]
    [SerializeField]
    public GameObject btn_hand;
    [SerializeField]
    public Button btn_draw;

    [SerializeField] public Button btn_discard;
        [SerializeField]
    public Button btn_consumed;
    [SerializeField]
    public SplinePointer splinePointer;
    
    [SerializeField]
    public Button btn_skipRound;

    [Header("Top Info")]
    [SerializeField]
    public Text txt_hp;
    [SerializeField]
    public Text txt_gold;


    
    [SerializeField]
    public Button btn_map;
    [SerializeField]
    public Button btn_allCard;
    [SerializeField]
    public Button btn_set;
    
    
    private void Awake()
    {
        splinePointer.GetComponentsInChildren<Transform>().Select(x=>x.transform.position).Print();
    }
}
