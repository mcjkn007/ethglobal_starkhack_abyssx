 
// define the interface
use starknet::{ContractAddress};
#[dojo::interface]
trait IChest{
   fn chest_action(value:u8);
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
       role::{Role,RoadCategory},
       message::{Message},
       opt::{Opt}
   };

   use abyss_x::utils::{
        constant::{EventCode,SeedDiff},
        math::{MathU64Trait,MathU32Trait},
        random::{RandomTrait,RandomContainerTrait},
        bit::{Bit64Trait}
   };

 
   // impl: implement functions specified in trait
   #[abi(embed_v0)]
   impl ChestImpl of super::IChest<ContractState> {
    fn chest_action(world: @IWorldDispatcher,value:u8){
            let player = get_caller_address();

            //UserTrait::read_user(world,player.into());
         
            let user:User = get!(world, player, (User));

            assert(user.state.into() == UserState::GAME, 'state is wrong');

         
            let mut role:Role = get!(world,(player), (Role));
            assert(role.cur_stage > 1, 'stage is wrong');
            assert(role.hp > 0,'hp error');
        
            
            assert(role.selected_road == RoadCategory::Chest, 'stage is wrong');

            if(value == 1){
                let mut seed:u64 = MathU64Trait::add_u64(role.seed,SeedDiff::Relic);
                RandomTrait::random_u64_loop(ref seed,role.cur_stage);
                
    
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
            }
             
            role.selected_road = RoadCategory::NONE;
            set!(world,(role)); 

            let mut opt:Opt = get!(world, player, (Opt));
            opt.code = EventCode::ChestAction;
            set!(world,(opt));

             

            emit!(world,Message { player:player, code:EventCode::ChestAction});
       }
     
   }
}
