#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    use integer::BoundedInt;
use integer::u256;
use integer::u256_from_felt252;
 
 
use token::erc20::ERC20::_worldContractMemberStateTrait;
use debug::PrintTrait;


    // import test utils
    use abyss_x::{
        systems::{account::{account, IAccountDispatcher, IAccountDispatcherTrait},
                    camp::{camp,ICampDispatcher,ICampDispatcherTrait}
        },
        models::{user::{User,UserState,user},
                card::{Card,card}
        },
         
    };

    #[test]
    #[available_gas(3000000000)]
    fn test_login() {

        // models
        let mut models = array![user::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
       
        let account_system = IAccountDispatcher { contract_address:world.deploy_contract('account', account::TEST_CLASS_HASH.try_into().unwrap()) };

        // call move with direction right
        account_system.login();
    }

    #[test]
    
    #[available_gas(3000000000)]
    fn test_account_system() {

        // models
        let mut models = array![user::TEST_CLASS_HASH,card::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let account_system = IAccountDispatcher { contract_address:world.deploy_contract('account', account::TEST_CLASS_HASH.try_into().unwrap()) };
        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
        account_system.login();
        println!("---------test_account_system_begin----------");
        let mut gas = initial - testing::get_available_gas();
        println!("login gas : {}", gas);

        initial = testing::get_available_gas();
        account_system.set_nickname('black');
        gas = initial - testing::get_available_gas();
        println!("set_nickname gas : {}", gas);
        println!("---------test_account_system_end----------");
      
    }
}
