 
// define the interface
use starknet::{ContractAddress};
#[dojo::interface]
trait ICamp{
   fn camp_action(action:u8,value:u8);
}

// dojo decorator
#[dojo::contract]
mod camp {
   use core::traits::Index;
   use core::option::OptionTrait;
   use core::serde::Serde;

   //use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
   use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
   use abyss_x::models::{
       user::{User,UserState,UserTrait},
       role::{Role,RoadCategory,RoleCategory,RoleTrait},
       card::{Card,CardTrait},
       message::{Message},
       opt::{Opt}
   };

   use abyss_x::utils::{
        constant::{EventCode,CampAciton,U8IntoCampAciton},
        random::{RandomTrait,RandomContainerTrait},
        
   };
 
   // impl: implement functions specified in trait
   #[abi(embed_v0)]
   impl CampImpl of super::ICamp<ContractState> {
    fn camp_action(world: @IWorldDispatcher,action:u8,value:u8){
            let player = get_caller_address();

            let user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME, 'state is wrong');

            let mut role:Role = get!(world, (player), (Role));
            
            assert(role.cur_stage > 1, 'stage is wrong');
            assert(role.selected_road == RoadCategory::Camp, 'stage is wrong');
            
    
            let act:CampAciton = action.into();
            match act {
                CampAciton::Null =>{

                },
                CampAciton::Rest => {
                    role.rest();
                },
                CampAciton::DeleteCard => {
                    let mut card:Card = get!(world, (player), (Card));
                    card.delete_card(value);
                    set!(world,(card)); 
                },
                CampAciton::Talent => {
                    role.talent(value);

                },
                _ => {},
        }
      
             
            let mut opt:Opt = get!(world, player, (Opt));
            opt.code = EventCode::CampAction;
            set!(world,(opt));

            role.selected_road = RoadCategory::NONE;
            set!(world,(role)); 

            emit!(world,Message { player:player, code:EventCode::CampAction});
       }
     
   }
}
