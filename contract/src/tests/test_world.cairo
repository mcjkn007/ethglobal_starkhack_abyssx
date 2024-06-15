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
use token::erc20::erc20::{ERC20};
use starknet::ContractAddress;
use starknet::contract_address_const;
use starknet::testing;
use zeroable::Zeroable;

 
use token::erc20::models::{
    ERC20Allowance, erc_20_allowance, ERC20Balance, erc_20_balance, ERC20Meta, erc_20_meta
};

 
use token::erc20::ERC20::_worldContractMemberStateTrait;
use debug::PrintTrait;


    // import test utils
    use abyss_x::{
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

fn setup() -> (IWorldDispatcher, ERC20::ContractState) {
    let (world, mut state) = STATE();
    ERC20::constructor(ref state, world.contract_address, NAME, SYMBOL, SUPPLY, OWNER());
    utils::drop_event(ZERO());
    (world,state)
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
 
       // let (_world, mut state) = STATE();
 
       // InternalImpl::_mint(ref state, OWNER(), SUPPLY);
 
      //  assert(ERC20Impl::total_supply(@state) == SUPPLY, 'Should eq SUPPLY');

        println!("0000");
        let mut models = array![erc_20_balance::TEST_CLASS_HASH,erc_20_allowance::TEST_CLASS_HASH,erc_20_meta::TEST_CLASS_HASH];
        let world = spawn_test_world(models);
        println!("11111");
       // let mut erc20_dispatcher = ERC20ABIDispatcher {contract_address: world.deploy_contract('salt', ERC20::TEST_CLASS_HASH.try_into().unwrap())};
        println!("2222");
       // let a  = erc20_dispatcher.total_supply();
      //  println!("{:?}", a);
        

       // let erc20_add = world.deploy_contract('ERC20', erc_20::TEST_CLASS_HASH.try_into().unwrap());
       // let token_dispatcher = ERC20ABIDispatcher { contract_address:erc20_add };
       // let a  = token_dispatcher.total_supply();
       // println!("{:?}", a);

       // let contract_address = world.deploy_contract('salt', account::TEST_CLASS_HASH.try_into().unwrap());
      //  let actions_system = IAccountsDispatcher { contract_address };
       // actions_system.erc20(_world.contract_address);
 

    }
}
