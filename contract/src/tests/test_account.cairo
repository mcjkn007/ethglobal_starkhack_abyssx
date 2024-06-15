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
        systems::{account::{account, IAccountsDispatcher, IAccountsDispatcherTrait},
        
        },
        models::{user::{User,UserState,user}},
         
    };

    #[test]
    #[available_gas(3000000000)]
    fn test_login() {
       
        let caller = starknet::contract_address_const::<0x0>();

        // models
        let mut models = array![user::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', account::TEST_CLASS_HASH.try_into().unwrap());
        let account_system = IAccountsDispatcher { contract_address };

        // call move with direction right
        account_system.login();
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_set_nick_name() {
       
        let caller = starknet::contract_address_const::<0x0>();

        // models
        let mut models = array![user::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', account::TEST_CLASS_HASH.try_into().unwrap());
        let account_system = IAccountsDispatcher { contract_address };

        // call move with direction right
        account_system.set_nickname('black');

    }
}
