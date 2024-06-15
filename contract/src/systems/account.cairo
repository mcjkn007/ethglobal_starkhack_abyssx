 
// define the interface
use starknet::{ContractAddress,SyscallResultTrait, syscalls,get_caller_address,get_contract_address,get_block_timestamp};

#[dojo::interface]
trait IAccounts {
    fn register();
    fn erc20(contract_address:ContractAddress);
}

// dojo decorator
#[dojo::contract]
mod account {
    use core::traits::Index;
    use core::option::OptionTrait;
    use core::serde::Serde;


    use super::{IAccounts};

    use origami::map::hex::{types::Direction};
    use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
 
    use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
    use dojo_starter::models::{
        user::{User,UserState},
        role::{Role,RoleCategory,RoleTrait},
        enemy::{Enemy,EnemyTrait},
        card::{Card,CardID,CardTarget,CardTrait},
        stage::{StageCategory,StageTrait},
        property::{Property,BaseProperty,PropertyTrait}
    };

    use dojo_starter::utils::{
        seed::{SeedTrait},
        random::{RandomTrait},
        mathtools::{Vec2,MathToolsTrait},
        constant::{MAX_STAGE,EventCode,ERC20_ADD}
    };

    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl AccountImpl of IAccounts<ContractState> {
        fn register(world: IWorldDispatcher) {
             
            let player = get_caller_address();
 
            let user = get!(world, player, (User));

            if(user.state == UserState::None){
                set!(
                    world,
                    (
                        User { player, state: UserState::Free,score:0}
                    )
                );
            }   
          

           // let mut res:Span<felt252> = syscalls::call_contract_syscall(add, selector!("transferFrom"), output_array.span()).unwrap_syscall();

           
          //  Serde::<bool>::deserialize(ref res).unwrap();
 
        }
        fn erc20(world: IWorldDispatcher,contract_address:ContractAddress){

        
           // println!("{:?}",add);
            let token_dispatcher = ERC20ABIDispatcher { contract_address };
            println!("erc   2222");
            let a  = token_dispatcher.total_supply();
            println!("{:?}", a);
        }
    }
}
 