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
    fn test_camp_system() {

        // models
        let mut models = array![user::TEST_CLASS_HASH,card::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let account_system = IAccountDispatcher { contract_address:world.deploy_contract('account', account::TEST_CLASS_HASH.try_into().unwrap()) };
        account_system.login();
 
        let camp_system = ICampDispatcher { contract_address:world.deploy_contract('camp', camp::TEST_CLASS_HASH.try_into().unwrap()) };
        println!("---------test_camp_system_begin----------");
        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
        camp_system.set_up_deck(1,'red',0x11050105030101110501050301011105010503010111050105030101);
        let mut gas = initial - testing::get_available_gas();
        println!("set_up_deck gas : {}", gas);

        initial = testing::get_available_gas();
        camp_system.delete_deck(1,'red');
        gas = initial - testing::get_available_gas();
        println!("delete_deck gas : {}", gas);
        println!("---------test_camp_system_end----------");
    }
}
