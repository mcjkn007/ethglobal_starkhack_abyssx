using Dojo;
using Dojo.Torii;
using Dojo.Starknet;
using System;
using System.Collections;
using System.Numerics;
using System.Text;
using dojo_bindings;
using System.Threading.Tasks;
using GameCore;
using GameFramework.Resource;
using Unity.Collections;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityGameFramework.Runtime;
using Utils;

namespace Abyss
{
    [DisallowMultipleComponent]
    [AddComponentMenu("Game Framework/Dojo")]
    public class DojoComponent : GameFrameworkComponent
    {
        [SerializeField]
        private WorldManagerData dojoConfig;

        private WorldManager worldManager;

        [SerializeField]
        private Button btn;
        
        [SerializeField]
        private Button btn_startGame;
        
        [SerializeField]
        private Button btn_checkBattleGame;
        
        private Home home;
        private Battle battle;
        private Account account;
        protected override void Awake()
        {
            base.Awake();
            worldManager = GetComponent<WorldManager>();
            btn.onClick.AddListener(() =>
            {
                try
                {
                    Debug.LogError("clicked");
                    // home.login(account);
                    // Debug.LogError("法减肥咖啡就困了".ToHex());

                    // var name = new FieldElement("法减肥咖啡就困了".ToHex());
                    // home.set_name(account, name);
                    // StartCoroutine(Routine());
                    home.login(account);
                }
                catch (Exception e)
                {
                    Debug.LogWarning("Exception = " + e.Message);
                }
                
                //  var bytes = Encoding.UTF8.GetBytes("dafasff");
              //  var element = new FieldElement;
              //  element.data = bytes;
               // home.set_name(account, "dafasff");
            });
            
            btn_startGame.onClick.AddListener(
                () =>
                {
                    battle.start_game(account,1,1);
                });
            btn_checkBattleGame.onClick.AddListener(
                () =>
                {
                    battle.check_e2_battle_result(account,
                        new UInt32[]
                        {
                            257,
                            1280,
                            2048,
                            0,
                            1,
                            513,
                            1536,
                            0,
                            1
                        });
                });
        }

        async void Start()
        {
            
            var privateKey = "0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a";
            var masterAddress = "0xb3ff441a68610b30fd5e2abbf3a1548eb6ba6f3559f2862bf2dc757e5828ca";
            
            battle = GetComponent<Battle>();
            var provider = new JsonRpcClient(dojoConfig.rpcUrl);
            var signer = new SigningKey (privateKey);
            home = GetComponent<Home>();
             account = new Account(provider, signer, new FieldElement(masterAddress));
            worldManager.synchronizationMaster.OnEntitySpawned.AddListener(InitEntity);
             foreach (var entity in worldManager.Entities())
             {
                 InitEntity(entity);
             }
             // Account burner = await CreateBurnerAccount(dojoConfig.rpcUrl, masterAddress, privateKey);
        }

        IEnumerator Routine()
        {
            yield return home.login(account);
            yield return battle.start_game(account, 1, 1);
            yield return battle.check_e1_battle_result(account, new ushort[]
            {
                257,
                1280,
                2048,
                0,
                1,
                513,
                1536,
                0, 1
            });
        }

        public void OnResourceLoadSuccessfully(string assetName,
            object asset,
            float duration,
            object userData)
        {
            Debug.LogWarning("资源读取成功！" + assetName + " 资源类型" + (asset).GetType() );
        }
        public void OnResourceLoadFailly(string assetName,
            LoadResourceStatus status,
            string errorMessage,
            object userData)
        {
            Debug.LogWarning("资源读取失败！" + assetName + " 资源失败原因" + (status));
        }

        public  void Update()
        {
            if (Input.GetKey(KeyCode.M))
            {
                home.login(account);
                // battle.start_game(account, 1,1);
            }
            
            
            if (Input.GetKey(KeyCode.L))
            {
                // battle.start_game(account, 1,1);
                #region test
                var succ = new LoadAssetCallbacks(OnResourceLoadSuccessfully, OnResourceLoadFailly);
                Debug.LogWarning("Entry .Resource == null" + Entry.Resource);
                Entry.Resource.LoadAsset("Assets/GameResource/Texture/test.png", succ);
                #endregion
            }
            
        }

        private async Task<Account> CreateBurnerAccount(string rpcUrl, string masterAddress, string masterPrivateKey )
        {
            var provider = new JsonRpcClient(rpcUrl);
            var signer = new SigningKey(masterPrivateKey);
            var account = new Account(provider, signer, new FieldElement(masterAddress));
            
            BurnerManager burnerManager = new BurnerManager(provider, account);
            return await burnerManager.DeployBurner();
        }
         private void InitEntity(GameObject entity)
         {
             var capsule = GameObject.CreatePrimitive(PrimitiveType.Capsule);
             // change color of capsule to a random color
             capsule.transform.parent = entity.transform;
            
             // foreach (var account in spawnedAccounts)
             // {
             //     if (account.Value == null)
             //     {
             //         spawnedAccounts[account.Key] = entity.name;
             //         break;
             //     }
             // }
         }
    }
}


