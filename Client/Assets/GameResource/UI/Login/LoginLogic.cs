using System;
using System.Runtime.CompilerServices.Events;
using Dojo.Torii;
using GameCore;
using UnityEngine;
using UnityGameFramework.Runtime;
using Dojo.Starknet;
using GameFramework.Event;
using Unity.VisualScripting;
using UnityEditorInternal;
using UnityEngine.EventSystems;
using UnityEngine.UIElements;

namespace Abyss
{
    public class LoginLogic : UIFormLogic
    {
        [SerializeField]
        private LoginForm loginForm;
        private void Awake()
        {
            loginForm.btn_login?.onClick.AddListener(Login);
            // loginForm.btn_login.onClick.AddListener(Login);
            loginForm.btn_start.onClick.AddListener(GameStart);
            loginForm.btn_continue.onClick.AddListener(ContinueGame);
            loginForm.btn_giveup.onClick.AddListener(Giveup);
        }

        protected override void OnOpen(object userData)
        {
            base.OnOpen(userData);
            Entry.Event.Subscribe(AccountLoginStatus.EventId, OnLoginSuccessful);
            Entry.Event.Subscribe(DojoStateGiveUpGame.EventId, OnGiveUp);
        }
        

        private void OnLoginSuccessful(object sender, GameEventArgs args)
        {
            if (args is AccountLoginStatus arg)
            {
                loginForm.txt_tip.text = "";
                if (!arg.isSuccessful)
                {
                    // loginForm.btn_login.gameObject.SetActive(true);
                    loginForm.txt_tip.text = arg.errMsg;
                    return;
                }

                Entry.Core.isLogedIn = true;
                switch (Entry.Dojo.GetValue<User>().state)
                {   
                    case 1 :
                        //新游戏   只需显示新游戏即可  
                        loginForm.btn_start.gameObject.SetActive(true);
                        loginForm.btn_continue.gameObject.SetActive(false);
                        loginForm.btn_giveup.gameObject.SetActive(false);
                        break;
                    case 2 :
                        //正在游戏中 需要显示是否继续游戏
                        loginForm.btn_start.gameObject.SetActive(false);
                        loginForm.btn_continue.gameObject.SetActive(true);
                        loginForm.btn_giveup.gameObject.SetActive(true);
                        break;
                    default:
                        break;
                }
                // loginForm.btn_login.gameObject.SetActive(false);
                // loginForm.btn_start.gameObject.SetActive(true);
            }
        }

        protected override void OnClose(bool isShutdown, object userData)
        {
            base.OnClose(isShutdown, userData);
            // Entry.Event.Unsubscribe(AccountLoginStatus.EventId, OnLoginSuccessful);
            // Entry.Event.Unsubscribe(GiveupStatus.EventId, OnGiveUp);
        }

        private void OnGiveUp(object sender, GameEventArgs args)
        {
            if (args is not GiveupStatus arg)
            {
                return;
            }

            if (!arg.isSuccessful)
            {
                return;
            }
            loginForm.btn_start.gameObject.SetActive(true);
            loginForm.btn_continue.gameObject.SetActive(false);
            loginForm.btn_giveup.gameObject.SetActive(false);
        }
        
        private void Login()
        {
            loginForm.btn_login.gameObject.SetActive(false);
            loginForm.txt_tip.text = "Loading please wait...";
            Entry.Dojo.OnLoginReturn();
        }

        private void Giveup()
        {
            Entry.Dojo.Giveup();
        }

        private  void GameStart()
        {
            Entry.Dojo.StartGame(() =>
            {
                MainProcedure.ChangeState();
            });
        }

        private void ContinueGame()
        {
            //不需要经过服务器这一步
            // Entry.Core.TriiggeredStartGame();
            MainProcedure.ChangeState();
        }
    }
    
}