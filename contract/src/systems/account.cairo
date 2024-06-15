 
// define the interface
 use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
#[dojo::interface]
trait IAccounts{
    fn login();
    fn set_nickname(nickname:felt252);
    fn exchange_meme(meme_address:ContractAddress);
}

// dojo decorator
#[dojo::contract]
mod account {
    use core::traits::Index;
    use core::option::OptionTrait;
    use core::serde::Serde;
 
    use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
    use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
    use abyss_x::models::{
        user::{User,UserState,UserTrait}
    };

    use abyss_x::utils::{
        seed::{SeedTrait},
        random::{RandomTrait},
        mathtools::{Vec2,MathToolsTrait},
        constant::{MAX_STAGE,EventCode,ERC20_ADD}
    };
 
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        AccountEvent:AccountEvent,
    }
    #[derive(Drop, starknet::Event)]
    struct AccountEvent {
        player: ContractAddress,
        event: EventCode
    }
    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl AccountImpl of super::IAccounts<ContractState> {
        fn login(world: IWorldDispatcher){
            let player = get_caller_address();
 
            let user = get!(world, player, (User));

            if(user.state == UserState::None){
                set!(world,(UserTrait::init_user(player)));
            }
            emit!(world,AccountEvent { player:player, event:EventCode::Login});

           
        }
        fn set_nickname(world: IWorldDispatcher,nickname:felt252){
            let player = get_caller_address();
 
            let mut user = get!(world, player, (User));

            assert(user.state != UserState::None, 'user state is wrong');

            user.nickname = nickname;
            set!(world,(user));

            emit!(world,AccountEvent { player:player, event:EventCode::SetNickName});
        }
        fn exchange_meme(world: IWorldDispatcher,meme_address:ContractAddress){
  

           // let token_dispatcher = ERC20ABIDispatcher { contract_address:meme_address };
           // let a = token_dispatcher.totalSupply();
           //  println!("{:?}", a);
        }
    }
}
 