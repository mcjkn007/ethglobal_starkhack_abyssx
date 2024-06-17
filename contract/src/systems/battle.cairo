 
 
// define the interface
#[dojo::interface]
trait IBattle {
    fn start_game(game_mode:u32,role_category:u8);
    fn giveup_game(role_category: u8);
    fn check_e1_battle_result(opts:Array<u16>,role_category:u8,value:u32);
   // fn choose_event_bonus(opt:u64,value:Vec2);
}

// dojo decorator
#[dojo::contract]
mod battle {
    use core::array::ArrayTrait;
use core::traits::Destruct;
use core::traits::TryInto;
use core::traits::Into;
    use core::traits::Index;
    use core::option::OptionTrait;
    use core::serde::Serde;

  
    use starknet::{ContractAddress,SyscallResultTrait, syscalls,get_caller_address,get_contract_address,get_block_timestamp};
    use abyss_x::game::{
        //adventurer::{Adventurer,AdventurerTrait},
        explorer::{Explorer,ExplorerTrait,ExplorerCategory},
        attribute::{Attribute,AttributeTrait},
        enemy::{Enemy,EnemyTeam3,EnemyTrait},
    };
    use abyss_x::models::{
        user::{User,UserState},
        role::{Role,RoleCategory,RoleTrait}
    };


    use abyss_x::utils::{
        seed::{SeedTrait},
        random::{RandomTrait,RandomArrayTrait,RandomContainerTrait},
        math::{MathU32Trait,MathU16Trait,MathU8Trait},
        dict_map::{DictMap,DictMapTrait},
        constant::{MAX_STAGE,HAND_CARD_NUMBER_MAX,HAND_CARD_NUMBER_INIT,AttributeCategory,EventCode}
    };
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ActionEvent:ActionEvent,
    }
    #[derive(Drop, starknet::Event)]
    struct ActionEvent {
        player: ContractAddress,
        event: EventCode
    }

    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl BattleImpl of super::IBattle<ContractState> {
        fn start_game(world:IWorldDispatcher,game_mode:u32,role_category: u8) {
          
            let player = get_caller_address();

            let mut user:User = get!(world, player, (User));

            assert(user.state == UserState::FREE, 'user start game state is wrong');

            user.state = UserState::GAME_BATTLE;
        
            let seed = SeedTrait::create_seed(get_contract_address().into(),get_block_timestamp().into(),player.into());

            let mut role:Role = get!(world,(player,role_category), (Role));
      
            role.cur_stage = 1;
            role.seed = seed;
            role.cards = 0b00000010000000100000001000000010000000100000000100000001000000010000000100000001;
            role.hp = 100;
            role.gold = 100;
       

            set!(world,(user));
            set!(world,(role));
            emit!(world,ActionEvent { player:player, event:EventCode::StartGame});
        }

        fn giveup_game(world:IWorldDispatcher,role_category: u8){
           
            let player = get_caller_address();

            let mut user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME_EVENT || user.state.into() == UserState::GAME_BATTLE, 'user give up state is wrong');

            user.state == UserState::FREE;
 
            set!(world,(user));

            let mut role:Role = get!(world, (player,role_category), (Role));
            role.reset_role();

            set!(world,(role));
 
            emit!(world, ActionEvent { player:player, event:EventCode::GiveUpGame});
        }
 
        fn check_e1_battle_result(world:IWorldDispatcher,opts:Array<u16>,role_category:u8,value:u32){
             
            let player = get_caller_address();
        
            let mut user:User = get!(world, player, (User));
            assert(user.state == UserState::GAME_BATTLE, 'state is wrong');
        
            let mut role:Role = get!(world, (player,role_category), (Role));
        
            assert(role.cur_stage%2 == 1, 'stage category is wrong');
         
            let mut explorer:Explorer = ExplorerTrait::init_explorer(role_category.into());
            explorer.seed = role.seed;
             
            explorer.attr.hp = role.hp;
            explorer.attr.idols = role.idols;
    
           
          //  let mut seed = role.seed+role.hp.into()+role.cur_stage.into();
          explorer.seed = 123;

            let mut enemy:Enemy = EnemyTrait::get_enemy(role.cur_stage.into());

         
            explorer.role_cards = role.get_cards();
            explorer.left_cards = RandomArrayTrait::random_number(ref explorer.seed,explorer.role_cards.len().try_into().unwrap());
              
            explorer.round_begin();

            let round_len = opts.len();
            let mut i:u32 = 0_u32;
            let mut ii:u8 = 0_u8;
            loop{
                if(i == round_len){
                    break;
                }
                let opt:u16 = *opts.at(i);
                if(opt == 0_u16){
                    explorer.round_end();
                    //enemy action
                    enemy.enemy_action(ref explorer,ii);
                    ii.self_add_u8();
                    explorer.round_begin();
                }else{
                    //player action
                    explorer.explorer_e1_action(ref enemy,opt);
                }
                i.self_add_u32();
            }; 
            
           // println!("enemy.hp : {}", enemy.attr.hp);
            if (enemy.attr.hp == 0){
                user.state == UserState::GAME_EVENT;
        
                role.cur_stage.self_add_u8();
                role.gold.add_eq_u16(100);

            }else{
               // assert(false, 'opt error');
            }
            set!(world,(user));
            set!(world,(role));
            emit!(world,ActionEvent { player, event:EventCode::CheckBattleResult});
        }
    }
}
 