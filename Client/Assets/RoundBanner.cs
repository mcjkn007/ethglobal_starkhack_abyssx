using System;
using System.Collections;
using System.Collections.Generic;
using Abyss;
using DG.Tweening;
using Unity.VisualScripting;
using UnityEngine;

public class RoundBanner : MonoBehaviour
{
    public RoundBannerView view;

    private void Awake()
    {
        
    }

    private static string Self = "Your Round";
    private static string Enemy = "Enemy Round";
    public void ShowBanner(RoundOrder isSelf)
    {
        Debug.LogWarning("itsself + " + isSelf);
        var str = isSelf == RoundOrder.Self ? Self : Enemy;
        gameObject.SetActive(true);
        view.txt_owner.text = str;
        this.view.blackMask.SetLocalScaleY(0.01f);
        this.view.Text.SetLocalScaleY(0.01f);

         DOTween.Sequence().AppendInterval(0.2f).Append(this.view.blackMask.DOScaleY(1f, 0.2f))
            .Join(this.view.Text.DOScaleY(1f, 0.2f)).AppendInterval(0.5f).OnComplete(() =>
            {
                gameObject.SetActive(false);
            }).Play();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
