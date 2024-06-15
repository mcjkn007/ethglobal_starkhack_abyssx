 
// define the interface
#[dojo::interface] 
trait ICamp{
    fn set_up_deck(role_category:u32,deck_name:felt252,cards:u256);
    fn rename_deck(role_category:u32,old_name:felt252,new_name:felt252);
    fn delete_deck(role_category:u32,deck_name:felt252);
}

// dojo decorator
#[dojo::contract]
mod camp {
    use core::traits::Index;
    use core::option::OptionTrait;
    use core::serde::Serde;
 
    use token::erc20::ERC20::interface::{ERC20ABI,ERC20ABIDispatcherTrait,ERC20ABIDispatcher};
    use starknet::{ContractAddress,SyscallResultTrait,SyscallResult, syscalls,get_caller_address,get_contract_address,get_block_timestamp,contract_address_const};
    use abyss_x::models::{
        user::{User,UserState,UserTrait},
        card::{Card},
        deck::{Deck}
    };

    use abyss_x::utils::{
        bit::{BitTrait},
        constant::{MAX_STAGE,SLOT_SIZE,MASK_8,DIGIT_8,CARD_MAX,EventCode},
        pack::{PackTrait},
        vector::{Vector,VectorTrait}
    };
 
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CampEvent:CampEvent,
    }
    #[derive(Drop, starknet::Event)]
    struct CampEvent {
        player: ContractAddress,
        event: EventCode
    }
    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl CampImpl of super::ICamp<ContractState> {
        fn set_up_deck(world:IWorldDispatcher,role_category:u32,deck_name:felt252,cards:u256){
            let player = get_caller_address();
 
            let mut user = get!(world, player, (User));

            assert(user.state == UserState::Free, 'user state is wrong');

            let card:Card = get!(world, (player,role_category), (Card));
            let mut i = 1;
            let mut cur_card:u32 = BitTrait::cut_bit_8(cards,0).try_into().unwrap();
            loop{
                if(i == 32 || cur_card == 0){
                    break;
                }
                cur_card = BitTrait::cut_bit_8(cards,DIGIT_8*i).try_into().unwrap();
                assert(BitTrait::is_bit(card.slot,cur_card) == true, 'card unlocked');
                i += 1;
            };

            let mut deck:Deck = get!(world, (player,deck_name,role_category), (Deck));
            
            deck.slot = cards;

            set!(world,(deck));

            emit!(world,CampEvent { player:player, event:EventCode::SetUpDeck});
        }
         
        fn rename_deck(world:IWorldDispatcher,role_category:u32,old_name:felt252,new_name:felt252){
             let player = get_caller_address();
 
            let mut user = get!(world, player, (User));

            assert(user.state == UserState::Free, 'user state is wrong');

            let mut old_deck:Deck = get!(world, (player,old_name,role_category), (Deck));

            let mut new_deck = old_deck.clone();

            delete!(world,(old_deck));

            new_deck.name = new_name;
            set!(world,(new_deck));

            emit!(world,CampEvent { player:player, event:EventCode::RenameDeck});
        }
        fn delete_deck(world:IWorldDispatcher,role_category:u32,deck_name:felt252){
            let player = get_caller_address();
 
            let mut user = get!(world, player, (User));

            assert(user.state == UserState::Free, 'user state is wrong');

            let mut deck:Deck = get!(world, (player,deck_name,role_category), (Deck));
            delete!(world,(deck));

            emit!(world,CampEvent { player:player, event:EventCode::DeleteDeck});
        }
    }
}
 