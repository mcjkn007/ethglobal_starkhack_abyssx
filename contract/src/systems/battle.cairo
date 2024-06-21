 
 
// define the interface
#[dojo::interface]
trait IBattle {
    fn start_game(game_mode:u32,role_category:u8);
    fn giveup_game();
    fn check_e1_battle_result(opts:Array<u16>);
    fn check_e2_battle_result(opts:Array<u16>);
   // fn choose_event_bonus(opt:u64,value:Vec2);
}

// dojo decorator
#[dojo::contract]
mod battle {

    use starknet::{ContractAddress,SyscallResultTrait, syscalls,get_caller_address,get_contract_address,get_block_timestamp};
    use abyss_x::game::{
        adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait},
        attribute::{Attribute,AttributeState,AttributeTrait},
        enemy::{Enemy,EnemyTeam2,EnemyTrait},
    };
    use abyss_x::models::{
        user::{User,UserState,UserTrait},
        role::{Role,RoleCategory,RoleTrait},
        card::{Card,CardTrait}
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
     
        fn start_game(world:@IWorldDispatcher,game_mode:u32,role_category:u8) {
          
            let player = get_caller_address();

            let mut user:User = get!(world, player, (User));

            assert(user.state == UserState::FREE, ' state is wrong');

           
            user.state = UserState::GAME;
            user.role_category = role_category;

            let mut role:Role = get!(world,(player), (Role));
            role.cur_stage = 1;
            role.seed = SeedTrait::create_seed(get_contract_address().into(),get_block_timestamp().into(),player.into());
 
            let mut card:Card = get!(world,(player), (Card));
            card.cards =  0b000000100000001000000010000000100000001_000000001_00000001_00000001_00000001_00000001;

            set!(world,(user));
            set!(world,(role));
            set!(world,(card));
            emit!(world,ActionEvent { player:player, event:EventCode::StartGame});
        }

        fn giveup_game(world:@IWorldDispatcher){
           
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
 
        fn check_e1_battle_result(world:@IWorldDispatcher,opts:Array<u16>){
             
            let player = get_caller_address();
        
            let mut user:User = get!(world, player, (User));
            assert(user.state == UserState::GAME, 'state is wrong');
        
            let mut role:Role = get!(world, (player), (Role));
            let mut card:Card = get!(world,(player), (Card));
         
            //assert(role.cur_stage%2 == 1, 'stage category is wrong');
         
            let mut adv:Adventurer = AdventurerCommonTrait::new(user.role_category);
            adv.init(ref role,ref card);

            let mut enemy:Enemy = EnemyTrait::get_stage_1_enemey();
 
            adv.c_game_begin(ref enemy);
            enemy.e_game_begin(ref adv);
            let mut opt_arr = opts;
            loop{
                match opt_arr.pop_front() {
                    Option::Some(r) => {
                        if(r == 0){
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
                        adv.c_game_end(ref enemy);
                        break;
                    },
                }
            }; 
            
           // println!("enemy.hp : {}", enemy.attr.hp);
            if (enemy.attr.state == AttributeState::Death
                && adv.attr.state == AttributeState::Live
                ){

                role.cur_stage.self_add_u8();
                role.hp = adv.attr.hp;
                role.max_hp = adv.attr.max_hp;

            }else{
                println!("enemy.hp : {}", enemy.attr.hp);
               //assert(false, 'opt error');
            }
            
            set!(world,(role));
            set!(world,(card));
            
            emit!(world,ActionEvent { player, event:EventCode::CheckBattleResult});
        }
        fn check_e2_battle_result(world:@IWorldDispatcher,opts:Array<u16>){
            let player = get_caller_address();
        
            let mut user:User = get!(world, player, (User));
            assert(user.state == UserState::GAME, 'state is wrong');
        
            let mut role:Role = get!(world, (player), (Role));
            let mut card:Card = get!(world,(player), (Card));
         
            //assert(role.cur_stage%2 == 1, 'stage category is wrong');
         
            let mut adv:Adventurer = AdventurerCommonTrait::new(user.role_category);
            adv.init(ref role,ref card);

            let mut enemy_team:EnemyTeam2 = EnemyTrait::get_stage_2_enemey();
 
            adv.c_game_begin(ref enemy_team);
            enemy_team.e1.e_game_begin(ref adv);
            enemy_team.e2.e_game_begin(ref adv);
            let mut opt_arr = opts;
            loop{
                match opt_arr.pop_front() {
                    Option::Some(r) => {
                        if(r == 0){
                            adv.c_round_end(ref enemy_team);
                            //enemy action
                            enemy_team.e1.e_round_begin(ref adv);
                            enemy_team.e2.e_round_begin(ref adv);

                            enemy_team.e1.enemy_action(ref adv,1);
                            enemy_team.e2.enemy_action(ref adv,1);

                            enemy_team.e1.e_round_end(ref adv);
                            enemy_team.e2.e_round_end(ref adv);
                            
                            adv.c_round_begin(ref enemy_team);
                        }else{
                            //player action
                            adv.c_adv_action(ref enemy_team,r);
                        }
                    },
                    Option::None => {
                        adv.c_game_end(ref enemy_team);
                        break;
                    },
                }
            }; 
            
           // println!("enemy.hp : {}", enemy.attr.hp);
            if (enemy_team.e1.attr.state == AttributeState::Death 
                && enemy_team.e2.attr.state == AttributeState::Death
                && adv.attr.state == AttributeState::Live
            ){
               
                role.cur_stage.self_add_u8();
                role.hp = adv.attr.hp;
                role.max_hp = adv.attr.max_hp;
            }else{
              
               //assert(false, 'opt error');
            }
            
            set!(world,(role));
            set!(world,(card));
            
            emit!(world,ActionEvent { player, event:EventCode::CheckBattleResult});
        }
    }
}
 