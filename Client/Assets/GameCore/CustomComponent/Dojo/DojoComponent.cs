using Dojo;
using Dojo.Starknet;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using GameCore;
using UnityEngine;
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
        private Dictionary<FieldElement, string> spawnedAccounts = new();
        private WorldManager worldManager;
        private BurnerManager burnerManager;
        public Account masterAccount;
        
        [SerializeField]
        public Button btn;
        
        [SerializeField]
        public Button btn_startGame;
        
        [SerializeField]
        public Button btn_checkBattleGame;

        [SerializeField]
        public Button btn_loginAsGuest;
        [SerializeField]
        public Button btn_loginNormally;
        
        private Home home;
        private Battle battle;
        private Event evet;
        private Chest chest;
        private Camp camp;
        
        private Role dojoInfo_role;
        private User dojoInfo_user;
        private Opt dojoInfo_opt;
        private Card dojoInfo_card;
     
        protected override void Awake()
        {
            base.Awake();
            worldManager = GetComponent<WorldManager>();
            btn.onClick.AddListener(OnLoginReturn);
            
            btn_startGame.onClick.AddListener(
                () =>
                {
                    battle.start_game(GetAccount(),1,1);
                });
            btn_checkBattleGame.onClick.AddListener(
                () =>
                {
                    
                });
            btn_loginAsGuest.onClick.AddListener(LoginAsGuest);
            btn_loginAsGuest.onClick.AddListener(LoginNormally);
        }

        public void CheckE1Battle(byte selectCardIndex)
        {
             battle.check_e1_battle_result(
                masterAccount, Entry.Core.GetRecorder().ToArray(), selectCardIndex
                );
                Entry.Core.GetRecorder().Clear();
        }

        public async void StartGame(System.Action callBack)
        {
            await  battle.start_game(masterAccount, 1, 1);
            callBack?.Invoke();
        }

        public T GetValue<T>() where T  : ModelInstance
        {
            var entity = worldManager.Entity(spawnedAccounts[GetAddress()]);
            return entity.TryGetComponent<T>(out var res) ? res : null;
        }

        public async void OnLoginReturn()
        {
            await home.login(GetAccount());
            FinishLogin();
            var entity = worldManager.Entity(spawnedAccounts[GetAddress()]);
            if (entity.GetComponent<Opt>().code == new EventCode.Login())
            {
                SyncPrint.Enqueue("Code Equals !");
            }
            else
            {
                var code = GetComponentInChildren<Opt>().code;
                SyncPrint.Enqueue("Code InEquals !" + code);
            }
        }

        public void Giveup()
        {
            battle.giveup_game(masterAccount);
        }

        private async void LoginAsGuest()
        {
            var privateKey = "0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a";
            var masterAddress = "0xb3ff441a68610b30fd5e2abbf3a1548eb6ba6f3559f2862bf2dc757e5828ca";

            privateKey = "0x04148a8d4606c75b7b5734e0940aeb21f7909ffa7cce256aabe91e17b7e0191d";
            masterAddress = "0x06E5a0Ee3A81d3E45e76c730393F568461D78A60ccc23D4f94813399F153F73C";
            // var provider = new JsonRpcClient(dojoConfig.rpcUrl);
            // var signer = new SigningKey(privateKey);
            // this.masterAccount = new Account(provider, signer, new FieldElement(masterAddress));
            var burner = await burnerManager.DeployBurner();
            spawnedAccounts[burner.Address] = null;
        }

        public void LoginNormally()
        {
            spawnedAccounts[this.masterAccount.Address] = null;
        }
    
        async void Start()
        {
            var privateKey = "0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a";
            var masterAddress = "0xb3ff441a68610b30fd5e2abbf3a1548eb6ba6f3559f2862bf2dc757e5828ca";
            
            // privateKey = "0x04148a8d4606c75b7b5734e0940aeb21f7909ffa7cce256aabe91e17b7e0191d";
            // masterAddress = "0x06E5a0Ee3A81d3E45e76c730393F568461D78A60ccc23D4f94813399F153F73C";
            var provider = new JsonRpcClient(dojoConfig.rpcUrl);
            var signer = new SigningKey(privateKey);
            this.masterAccount = new Account(provider, signer, new FieldElement(masterAddress));
            // this.burnerManager =  new BurnerManager(provider, this.masterAccount);
            
            spawnedAccounts[this.masterAccount.Address] = null;
            //  
            // if (false)
            // {
            //     this.burnerManager =  new BurnerManager(provider, this.masterAccount);
            //     var burner = await burnerManager.DeployBurner();
            //     spawnedAccounts[burner.Address] = null;
            // }
            // else{
            //     spawnedAccounts[this.masterAccount.Address] = null;
            // }

            battle = GetComponent<Battle>();
            home = GetComponent<Home>();
            evet = GetComponent<Event>();
            camp = GetComponent<Camp>();
            chest = GetComponent<Chest>();
            
            worldManager.synchronizationMaster.OnEventMessage.AddListener(OnMessageEvent);
            worldManager.synchronizationMaster.OnEntitySpawned.AddListener(InitEntity);
            worldManager.synchronizationMaster.OnSynchronized.AddListener(OnSync);
            foreach (var entity in worldManager.Entities())
            {
                InitEntity(entity);
            }

            OnLoginReturn();
            // LoginAsGuest();
        }

        public  void Update()
        {
            
           
        }
        private async Task<Account> CreateBurnerAccount(string rpcUrl, string masterAddress, string masterPrivateKey )
        {
            var provider = new JsonRpcClient(rpcUrl);
            var signer = new SigningKey(masterPrivateKey);
            var account = new Account(provider, signer, new FieldElement(masterAddress));
            
            BurnerManager burnerManager =  new BurnerManager(provider, account);
            return await burnerManager.DeployBurner();
        }
        private Account GetAccount()
        {
            
            return this.burnerManager?.CurrentBurner ?? this.masterAccount;
        }
        private FieldElement GetAddress()
        {
            return this.burnerManager?.CurrentBurner.Address ?? this.masterAccount.Address;
        }
         private void InitEntity(GameObject entity)
         {
             SyncPrint.Enqueue("OnInitEntity => " + entity.name);
             // var capsule = GameObject.CreatePrimitive(PrimitiveType.Capsule);
             // // change color of capsule to a random color
             // capsule.transform.parent = entity.transform;
             foreach (var account in spawnedAccounts) {
                if (account.Value == null){
                    Debug.LogWarning($" entity .key = {entity.name} , accountKey = {account.Key}");
                    spawnedAccounts[account.Key] = entity.name;
                    break;
                }
             }

             FinishLogin();
         }

         public void OnMessageEvent(ModelInstance instance)
         {
             SyncPrint.Enqueue("OnMessageEvent => " );
         }

         
         public void OnSync(List<GameObject> go)
         {
             dojoInfo_role = GetValue<Role>();
             dojoInfo_user = GetValue<User>();
             dojoInfo_card = GetValue<Card>();
             dojoInfo_opt = GetValue<Opt>();

             RandUtils.standard_seed = dojoInfo_role.seed;
             Entry.Core.Stage.Val = dojoInfo_role.cur_stage;
         }

         private void FinishLogin()
         {
             var evt = AccountLoginStatus.Create(true);
             Entry.Event.Fire(this, evt);
         }
    }
}


