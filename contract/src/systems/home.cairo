 
// define the interface
 use starknet::{ContractAddress};
#[dojo::interface]
trait IHome{
    fn login();
    fn set_name(name:felt252);
    fn test(game_mode:u32);
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
        name::{Name,NameTrait},
        message::{Message},
        opt::{Opt}
    };

    use abyss_x::utils::{
        constant::{EventCode}
    };
 
  
    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl HomeImpl of super::IHome<ContractState> {
        fn login(world: @IWorldDispatcher){
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
            let mut opt:Opt = get!(world, player, (Opt));
            opt.code = EventCode::Login;
            set!(world,(opt));

            emit!(world,Message { player:player, code:EventCode::Login});
        }
        fn set_name(world: @IWorldDispatcher,name:felt252){
            let player = get_caller_address();
 
            let mut user = get!(world, player, (User));

            assert(user.state != UserState::NONE, 'user state is wrong');

            let mut n = get!(world, player, (Name));
            n.name = name;

            set!(world,(n));

            emit!(world,Message { player:player, code:EventCode::SetNickName});
        }
        fn test(world: @IWorldDispatcher,game_mode:u32){
            let player = get_caller_address();
 
            let mut user = get!(world, player, (User));

            assert(user.state != UserState::NONE, 'user state is wrong');

            user.game_mode = game_mode.try_into().unwrap();
            set!(world,(user));
            
            emit!(world,Message { player:player, code:EventCode::SetNickName});
        }
    }
}
 