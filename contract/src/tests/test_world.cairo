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
use token::tests::utils;
use token::tests::constants::{
    ZERO, OWNER, SPENDER, RECIPIENT, NAME, SYMBOL, DECIMALS, SUPPLY, VALUE
};

use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
 
use token::erc20::interface;
use token::erc20::ERC20::Approval;
use token::erc20::ERC20::ERC20Impl;
use token::erc20::ERC20::ERC20MetadataImpl;
use token::erc20::ERC20::InternalImpl;
use token::erc20::ERC20::Transfer;
use token::erc20::ERC20;
use starknet::ContractAddress;
use starknet::contract_address_const;
use starknet::testing;
use zeroable::Zeroable;

 
use token::erc20::models::{erc_20_balance,erc_20_allowance,erc_20_meta};
use token::erc20::models::{ERC20Balance,ERC20Allowance,ERC20Meta};
 
 
use token::erc20::ERC20::_worldContractMemberStateTrait;
use debug::PrintTrait;


    // import test utils
    use dojo_starter::{
        systems::{account::{account, IAccountsDispatcher, IAccountsDispatcherTrait},
        
        },
        models::{user::{User,UserState,user}},
         
    };

fn STATE() -> (IWorldDispatcher, ERC20::ContractState) {
 
      // models
    let mut models = array![erc_20_balance::TEST_CLASS_HASH,erc_20_allowance::TEST_CLASS_HASH,erc_20_meta::TEST_CLASS_HASH];
    let world = spawn_test_world(models);
    let mut state = ERC20::contract_state_for_testing();
 
    state._world.write(world.contract_address);
    (world, state)
}

fn setup() -> ERC20::ContractState {
    let (world, mut state) = STATE();
    ERC20::constructor(ref state, world.contract_address, NAME, SYMBOL, SUPPLY, OWNER());
    utils::drop_event(ZERO());
    state
}

fn assert_event_transfer(from: ContractAddress, to: ContractAddress, value: u256) {
    let event = utils::pop_log::<Transfer>(ZERO()).unwrap();
    assert(event.from == from, 'Invalid `from`');
    assert(event.to == to, 'Invalid `to`');
    assert(event.value == value, 'Invalid `value`');
}

fn assert_only_event_transfer(from: ContractAddress, to: ContractAddress, value: u256) {
    assert_event_transfer(from, to, value);
    utils::assert_no_events_left(ZERO());
}


    #[test]
    #[available_gas(3000000000)]
  
    fn test_token() {
 
        let (_world, mut state) = STATE();

        InternalImpl::initializer(ref state, NAME, SYMBOL);
        InternalImpl::_mint(ref state, OWNER(), SUPPLY);

        println!("{:?}",_world.contract_address);
        let token_dispatcher = ERC20ABIDispatcher { contract_address:_world.contract_address };
        let a  = token_dispatcher.total_supply();
        println!("{:?}", a);

          let contract_address = _world
            .deploy_contract('salt', account::TEST_CLASS_HASH.try_into().unwrap());
        let actions_system = IAccountsDispatcher { contract_address };
       // actions_system.erc20(_world.contract_address);
        println!("22222");

    }
}
