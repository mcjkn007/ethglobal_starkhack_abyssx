using System;
using System.Collections;
using System.Collections.Generic;
using Abyss;
using Abyss.DisplayCard;
using GameCore;
using UnityEngine;
using Utils;

public class SelectCardPanel : MonoBehaviour
{
    public UnityEngine.UI.Button btn_skip;
    public DisplayCard[] Cards;

    public int selectedIndex = -1;  
    
    private Action<byte> onCallBack;
    private void InitPanel(int[] cardsToSelect)
    {
        // this.onCallBack = OnBackCallBack;
        for (int i = 0; i < Cards.Length; i++)
        {
            Cards[i].Init(cardsToSelect[i] + 20000, OnCardSelected);
        }
    }

    public void Start()
    {
        this.btn_skip.onClick.AddListener(OnClose);
    }
    
    public void Open(Action OnBackCallBack)
    {
        gameObject.SetActive(true);
        var tempSeq = FisherYatesShuffle.GetRandomFourCards();
        var cardSequence = new[]
        {
            tempSeq[^1],
            tempSeq[^2],
            tempSeq[^3],
            tempSeq[^4],
        };
        InitPanel(cardSequence);
    }
    public void OnClose()
    {   
        Submit(0);
        this.gameObject.SetActive(false);
    }

    public void OnCardSelected(int index)
    {
        Submit((byte)index);
        // onCallBack?.Invoke();
        selectedIndex = index;
        gameObject.SetActive(false);
    }

    public void Submit(byte value)
    {
        Entry.Dojo.CheckE1Battle(value);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
