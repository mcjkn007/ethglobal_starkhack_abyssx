 
// define the interface
use starknet::{ContractAddress};
#[dojo::interface]
trait IEvent{
   fn event_action(select:u8,value:Array<u8>);
}

// dojo decorator
#[dojo::contract]
mod event {
   use core::traits::Index;
   use core::option::OptionTrait;
   use core::serde::Serde;

   //use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
   use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
   use abyss_x::models::{
       user::{User,UserState,UserTrait},
       role::{Role,RoadCategory},
       card::{Card,CardTrait},
       message::{Message},
       opt::{Opt}
   };

    use abyss_x::game::charactor::c1::{C1Action1Impl,C1Action2Impl,C1EntityImpl,C1DamageImpl,C1CardInfoImpl};
    use abyss_x::game::charactor::c2::{C2ActionImpl,C2EntityImpl,C2DamageImpl,C2CardInfoImpl};

   use abyss_x::utils::{
        constant::{EventCode,SeedDiff,CurseCard},
        math::{MathU64Trait,MathU32Trait,MathU16Trait,MathU8Trait},
        random::{RandomTrait,RandomContainerTrait},
        bit::{Bit64Trait}
   };


   // impl: implement functions specified in trait
   #[abi(embed_v0)]
   impl EventImpl of super::IEvent<ContractState> {
    fn event_action(world: @IWorldDispatcher,select:u8,value:Array<u8>){
            let player = get_caller_address();

            //UserTrait::read_user(world,player.into());
         
            let user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME, 'state is wrong');

            let mut role:Role = get!(world,(player), (Role));

            assert(role.cur_stage > 1, 'stage is wrong');

            let mut card:Card = get!(world,(player), (Card));
         
            assert(role.hp > 0,'hp error');
            assert(role.selected_road == RoadCategory::Event, 'stage is wrong');
           
            let mut save_flag = false;
            //assert(role.cur_stage%2 == 1, 'stage category is wrong');
            let mut seed = MathU64Trait::add_u64(role.seed,SeedDiff::Event);
            RandomTrait::random_u64_loop(ref seed,role.cur_stage);
            let mut value_arr = value;
            match RandomTrait::random_u64(ref seed,0,6) {
                0 => {
                    //用生命换取删牌
                    if(select == 0){
                        role.hp.sub_eq_u16(role.hp/10);
                        assert(value_arr.len() == 1,'opt error');
                        card.delete_card(*value_arr.at(0));
                        save_flag = true;
                        
                    }else if(select == 1){
                        assert(value_arr.len() == 3,'opt error');
                        card.delete_card(*value_arr.at(0));
                        card.delete_card(*value_arr.at(1));
                        card.delete_card(*value_arr.at(2));
                        role.hp.sub_eq_u16(role.hp/4);

                        save_flag = true;
                    }else{
                        
                    }
                    
                },
                1 => {
                    //用牌换牌（随机）
                    if(select < 4){
                        assert(value_arr.len() == 1,'opt error');

                        let card_id = match user.role_category {
                            0 => panic!("error"),
                            1 => C1CardInfoImpl::get_random_card_by_rarity(seed,MathU8Trait::add_u8(C1CardInfoImpl::get_card_rarity(card.get_card(*value_arr.at(0))),1)),
                            2 => C2CardInfoImpl::get_random_card_by_rarity(seed,MathU8Trait::add_u8(C2CardInfoImpl::get_card_rarity(card.get_card(*value_arr.at(0))),1)),
                            _ => panic!("error"),
                        };
                         
                        card.delete_card(*value_arr.at(0));
                        card.add_card(card_id);
                        save_flag = true;
                    }
                },
                2 => {
                    //回复生命
                    if(select == 0){
                        let r = MathU16Trait::add_u16(role.hp,role.max_hp/10);
                        if(r > role.max_hp){
                            role.hp = role.max_hp;
                        }else{
                            role.hp = r;
                        }
                      
                        save_flag = true;
                        
                    }else if(select == 1){
                        let r = MathU16Trait::add_u16(role.hp,role.max_hp/5);
                        if(r > role.max_hp){
                            role.hp = role.max_hp;
                        }else{
                            role.hp = r;
                        }
                        card.add_card(CurseCard::Wound);

                        save_flag = true;
                    }else{
                        
                    }
                },
                3 => {
                     //用牌换血
                     if(select == 0){

                        let card_rarity = C1CardInfoImpl::get_card_rarity(card.get_card(*value_arr.at(0)));
                        assert(card_rarity  == 1,'rarity error');

                        let r = MathU16Trait::add_u16(role.hp,5);
                        if(r > role.max_hp){
                            role.hp = role.max_hp;
                        }else{
                            role.hp = r;
                        }

                        card.delete_card(*value_arr.at(0));
                        save_flag = true;
                        
                    }else if(select == 1){
                        let card_rarity = C1CardInfoImpl::get_card_rarity(card.get_card(*value_arr.at(0)));
                        assert(card_rarity == 2,'rarity error');

                        role.hp = role.max_hp;

                        card.delete_card(*value_arr.at(0));
                        save_flag = true;
                    }else{
                        
                    }
                },
                4 => {
                     //用血换牌(随机)
                     if(select == 0){
                        role.hp.sub_eq_u16(5);
                        let card_id = match user.role_category {
                            0 => panic!("error"),
                            1 => C1CardInfoImpl::get_random_card_by_rarity(seed,1),
                            2 => C2CardInfoImpl::get_random_card_by_rarity(seed,1),
                            _ => panic!("error"),
                        };
 
                        card.add_card(card_id);
                        save_flag = true;
                        
                    }else if(select == 1){
                        role.hp.sub_eq_u16(15);
                        let card_id = match user.role_category {
                            0 => panic!("error"),
                            1 => C1CardInfoImpl::get_random_card_by_rarity(seed,2),
                            2 => C2CardInfoImpl::get_random_card_by_rarity(seed,2),
                            _ => panic!("error"),
                        };
 
                        card.add_card(card_id);
                        save_flag = true;
                    }else{
                        
                    }
                },
                5 => {
                    //用牌换牌-等价交换（随机） 
                    assert(value_arr.len() == 1,'opt error');

                       
                    let card_id = match user.role_category {
                        0 => panic!("error"),
                        1 => C1CardInfoImpl::get_random_card_by_rarity(seed,C1CardInfoImpl::get_card_rarity(card.get_card(*value_arr.at(0)))),
                        2 => C2CardInfoImpl::get_random_card_by_rarity(seed,C1CardInfoImpl::get_card_rarity(card.get_card(*value_arr.at(0)))),
                        _ => panic!("error"),
                    };
                     
                    card.delete_card(*value_arr.at(0));
                    card.add_card(card_id);
                    save_flag = true;
                },
                _ =>{

                },
            }
            if(save_flag){
                set!(world,(card));
            }
            role.selected_road = RoadCategory::NONE;
            set!(world,(role)); 

            let mut opt:Opt = get!(world, player, (Opt));
            opt.code = EventCode::EventAction;
            set!(world,(opt));

            emit!(world,Message { player:player, code:EventCode::EventAction});
       }
     
   }
}
