 
 
// define the interface
#[dojo::interface]
trait IBattle {
    fn start_game(game_mode:u32,role_category:u8);
    fn giveup_game();
    fn check_e1_battle_result(opts:Array<u16>,value:u8);
   // fn choose_event_bonus(opt:u64,value:Vec2);
}

// dojo decorator
#[dojo::contract]
mod battle {

    use starknet::{ContractAddress,SyscallResultTrait, syscalls,get_caller_address,get_contract_address,get_block_timestamp};
    use abyss_x::game::{
        adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait},
        attribute::{Attribute,AttributeTrait},
        enemy::{Enemy,EnemyTeam3,EnemyTrait},
    };
    use abyss_x::models::{
        user::{User,UserState,UserTrait},
        role::{Role,RoleCategory,RoleTrait},
        card::{Card,CardTrait},
        idol::{Idol}
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
        fn start_game(world:IWorldDispatcher,game_mode:u32,role_category:u8) {
          
            let player = get_caller_address();

            let mut user:User = get!(world, player, (User));

            assert(user.state == UserState::FREE, ' state is wrong');

            let seed = SeedTrait::create_seed(get_contract_address().into(),get_block_timestamp().into(),player.into());

            user.state = UserState::GAME;
            user.cur_stage = 1;
            user.seed = seed;
            user.role_category = role_category;

            let mut role:Role = get!(world,(player), (Role));
            role.hp = 100;
            role.gold = 100;

            let mut card:Card = get!(world,(player), (Card));
             
            card.cards = 0b000000100000001000000010000000100000001_000000001_00000001_00000001_00000001_00000001;

            set!(world,(user));
            set!(world,(role));
            set!(world,(card));
            emit!(world,ActionEvent { player:player, event:EventCode::StartGame});
        }

        fn giveup_game(world:IWorldDispatcher){
           
            let player = get_caller_address();

            let mut user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME, 'state is wrong');

            user.reset();
    
            let mut role:Role = get!(world, (player), (Role));
            role.reset();

            set!(world,(role));
            set!(world,(user));

            emit!(world, ActionEvent { player:player, event:EventCode::GiveUpGame});
        }
 
        fn check_e1_battle_result(world:IWorldDispatcher,opts:Array<u16>,value:u8){
             
            let player = get_caller_address();
        
            let mut user:User = get!(world, player, (User));
            assert(user.state == UserState::GAME, 'state is wrong');
        
            let mut role:Role = get!(world, (player), (Role));
            let mut card:Card = get!(world,(player), (Card));
            let mut idol:Idol = get!(world,(player), (Idol));
            //assert(role.cur_stage%2 == 1, 'stage category is wrong');
         
            let mut adv:Adventurer = AdventurerCommonTrait::new(user.role_category);
            adv.init(user.seed,idol.idols,ref role,ref card);

            let mut enemy:Enemy = EnemyTrait::get_stage_1_enemey();
 
            adv.c_game_begin(ref enemy);
            enemy.e_game_begin(ref adv);
            let mut opt_arr = opts;
            loop{
                match opt_arr.pop_front() {
                    Option::Some(r) => {
                        if(r.is_zero_u16()){
                            adv.c_round_end(ref enemy);
                            //enemy action
                            enemy.e_round_begin(ref adv);
                            enemy.enemy_action(ref adv,1);
                            enemy.e_round_end(ref adv);
                            
                            adv.c_round_begin(ref enemy);
                        }else{
                            //player action
                            adv.c_adv_action(ref enemy,r);
                        }
                    },
                    Option::None => {
                        break;
                    },
                }
            }; 
            
           // println!("enemy.hp : {}", enemy.attr.hp);
            if (enemy.attr.hp.is_zero_u16() && adv.attr.hp.is_no_zero_u16()){
                user.cur_stage.self_add_u8();
                role.gold.add_eq_u16(100);

            }else{
                println!("enemy.hp : {}", enemy.attr.hp);
               //assert(false, 'opt error');
            }
            
            set!(world,(role));
            set!(world,(user));
            set!(world,(card));
            
            emit!(world,ActionEvent { player, event:EventCode::CheckBattleResult});
        }
    }
}
 