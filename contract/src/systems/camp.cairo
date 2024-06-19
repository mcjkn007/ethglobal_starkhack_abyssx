 
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
       role::{Role,RoleCategory,RoleTrait},
       card::{Card,CardTrait}
   };

   use abyss_x::utils::{
        constant::{EventCode,CampAciton,U8IntoCampAciton}
   };

   #[event]
   #[derive(Drop, starknet::Event)]
   enum Event {
       CampEvent:CampEvent,
   }
   #[derive(Drop, starknet::Event)]
   struct CampEvent {
       player: ContractAddress,
       event: EventCode
   }


   // impl: implement functions specified in trait
   #[abi(embed_v0)]
   impl CampImpl of super::ICamp<ContractState> {
    fn camp_action(world: IWorldDispatcher,action:u8,value:u8){
            let player = get_caller_address();

            let user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME, 'state is wrong');

            //assert(role.cur_stage%2 == 1, 'stage category is wrong');
            let act:CampAciton = action.into();
            match act {
                CampAciton::Rest => {
                    let mut role:Role = get!(world, (player), (Role));
                    role.rest();
                    set!(world,(role)); 
                },
                CampAciton::Awake => {
                    let mut role:Role = get!(world, (player), (Role));
                    role.awake(value);
                    set!(world,(role)); 
                },
                CampAciton::DeleteCard => {
                    let mut card:Card = get!(world, (player), (Card));
                    card.delete_card(value);
                    set!(world,(card)); 
                },
                _ => {},
        }
      
             
            emit!(world,CampEvent { player:player, event:EventCode::CampAction});
       }
     
   }
}
