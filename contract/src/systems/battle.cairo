 
 
// define the interface
#[dojo::interface]
trait IBattle {
    fn start_game(game_mode:u32,role_category:u8);
    fn giveup_game(role_category: u8);
    fn check_e1_battle_result(opts:Array<u16>,role_category:u8,value:u8);
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
        adventurer::{Adventurer,AdventurerTrait},
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

            assert(user.state == UserState::FREE, ' state is wrong');

            user.state = UserState::GAME;
        
            let seed = SeedTrait::create_seed(get_contract_address().into(),get_block_timestamp().into(),player.into());

            let mut role:Role = get!(world,(player,role_category), (Role));
      
            role.cur_stage = 1;
            role.seed = seed;
            role.cards = 0b000000100000001000000010000000100000001_000000001_00000001_00000001_00000001_00000001;
            role.hp = 100;
            role.gold = 100;
       

            set!(world,(user));
            set!(world,(role));
            emit!(world,ActionEvent { player:player, event:EventCode::StartGame});
        }

        fn giveup_game(world:IWorldDispatcher,role_category: u8){
           
            let player = get_caller_address();

            let mut user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME, 'state is wrong');


            user.state = UserState::FREE;

            let mut role:Role = get!(world, (player,role_category), (Role));
            role.reset();

            set!(world,(role));
            set!(world,(user));

            emit!(world, ActionEvent { player:player, event:EventCode::GiveUpGame});
        }
 
        fn check_e1_battle_result(world:IWorldDispatcher,opts:Array<u16>,role_category:u8,value:u8){
             
            let player = get_caller_address();
        
            let mut user:User = get!(world, player, (User));
            assert(user.state == UserState::GAME, 'state is wrong');
        
            let mut role:Role = get!(world, (player,role_category), (Role));
        
            //assert(role.cur_stage%2 == 1, 'stage category is wrong');
         
            let mut adv:Adventurer = AdventurerTrait::new(role_category);
            adv.init(ref role);

            let mut enemy:Enemy = EnemyTrait::get_enemy(role.cur_stage.into());
 
            let mut round:u8 = 0_u8;
            adv.c_game_begin_e1(ref enemy);
            let mut opt_arr = opts;
            loop{
                match opt_arr.pop_front() {
                    Option::Some(r) => {
                        if(r.is_zero_u16()){
                            adv.c_round_end_e1(ref enemy);
                            //enemy action
                            enemy.e_round_begin(ref adv);
                            enemy.enemy_action(ref adv,round.self_add__u8());
                            enemy.e_round_end(ref adv);
                            
                            adv.c_round_begin_e1(ref enemy);
                        }else{
                            //player action
                            adv.explorer_e1_action(ref enemy,r);
                        }
                    },
                    Option::None => {
                        break;
                    },
                }
            }; 
            
           // println!("enemy.hp : {}", enemy.attr.hp);
            if (enemy.attr.hp.is_zero_u16()){
                role.cur_stage.self_add_u8();
                role.gold.add_eq_u16(100);

            }else{
                println!("enemy.hp : {}", enemy.attr.hp);
                assert(false, 'opt error');
            }
            set!(world,(user));
            set!(world,(role));

            emit!(world,ActionEvent { player, event:EventCode::CheckBattleResult});
        }
    }
}
 