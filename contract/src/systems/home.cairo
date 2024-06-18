 
// define the interface
 use starknet::{ContractAddress};
#[dojo::interface]
trait IHome{
    fn login();
    fn set_name(name:felt252);
    fn exchange_meme(meme_address:ContractAddress);
}

// dojo decorator
#[dojo::contract]
mod home {
    use core::traits::Index;
    use core::option::OptionTrait;
    use core::serde::Serde;
 
    //use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
    use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
    use abyss_x::models::{
        user::{User,UserState,UserTrait},
        name::{Name,NameTrait}
    };

    use abyss_x::utils::{
        constant::{EventCode}
    };
 
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        HomeEvent:HomeEvent,
    }
    #[derive(Drop, starknet::Event)]
    struct HomeEvent {
        player: ContractAddress,
        event: EventCode
    }
    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl HomeImpl of super::IHome<ContractState> {
        fn login(world: IWorldDispatcher){
            let player = get_caller_address();
 
            let mut user:User = get!(world, player, (User));

            if(user.state == UserState::NONE){
                //register
                //card
            
              //  set!(world,(CardSlotTrait::init_cardslot(player)));
                let mut n = get!(world, player, (Name));
                n.init();
  
                set!(world,(n));

                user.reset();
                set!(world,(user));
            }
            emit!(world,HomeEvent { player:player, event:EventCode::Login});
        }
        fn set_name(world: IWorldDispatcher,name:felt252){
            let player = get_caller_address();
 
            let mut user = get!(world, player, (User));

            assert(user.state != UserState::NONE, 'user state is wrong');

            let mut n = get!(world, player, (Name));
            n.name = name;

            set!(world,(n));

            emit!(world,HomeEvent { player:player, event:EventCode::SetNickName});
        }
        fn exchange_meme(world: IWorldDispatcher,meme_address:ContractAddress){
  
           // let player = get_caller_address();
 
           // let mut user = get!(world, player, (User));
           // let token_dispatcher = ERC20ABIDispatcher { contract_address:meme_address };
           // let a = token_dispatcher.totalSupply();
           //  println!("{:?}", a);
        }
    }
}
 