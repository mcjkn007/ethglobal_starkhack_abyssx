 
// define the interface
use starknet::{ContractAddress};
#[dojo::interface]
trait IChest{
   fn chest_action();
}

// dojo decorator
#[dojo::contract]
mod chest {
   use core::traits::Index;
   use core::option::OptionTrait;
   use core::serde::Serde;

   //use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
   use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
   use abyss_x::models::{
       user::{User,UserState,UserTrait},
       role::{Role}
   };

   use abyss_x::utils::{
        constant::{EventCode,SeedDiff},
        math::{MathU64Trait,MathU32Trait},
        random::{RandomContainerTrait},
        bit::{Bit64Trait}
   };

   #[event]
   #[derive(Drop, starknet::Event)]
   enum Event {
       ChestEvent:ChestEvent,
   }
   #[derive(Drop, starknet::Event)]
   struct ChestEvent {
       player: ContractAddress,
       event: EventCode
   }


   // impl: implement functions specified in trait
   #[abi(embed_v0)]
   impl ChestImpl of super::IChest<ContractState> {
    fn chest_action(world: @IWorldDispatcher){
            let player = get_caller_address();

            //UserTrait::read_user(world,player.into());
         
            let user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME, 'state is wrong');

         
            let mut role:Role = get!(world,(player), (Role));
        
            //assert(role.cur_stage%2 == 1, 'stage category is wrong');
            let mut seed:u64 = MathU64Trait::add_u64(role.seed,SeedDiff::Chest_Relic);

            let mut a = array![1_u8,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            
            let mut arr = RandomContainerTrait::<u8>::random_array(ref seed,@a);
            loop{
                match arr.pop_front() {
                    Option::Some(r) => {
                        if(Bit64Trait::is_bit(role.relic,r) == false){
                            role.relic = Bit64Trait::set_bit(role.relic,r);
                            break;
                        }
                    },
                    Option::None => {
                       break;
                    },
                }
            };

            set!(world,(role)); 
            emit!(world,ChestEvent { player:player, event:EventCode::ChestAction});
       }
     
   }
}
