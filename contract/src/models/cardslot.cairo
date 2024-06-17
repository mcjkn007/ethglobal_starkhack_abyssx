use core::option::OptionTrait;
use core::traits::TryInto;
use starknet::ContractAddress;
use starknet::storage_access::StorePacking;
use core::dict::Felt252DictTrait;

use abyss_x::utils::vector::{Vector,VectorTrait};

 
#[derive(Model,Copy, Drop, Serde,PartialEq)]
struct CardSlot {
    #[key]
    player:ContractAddress,
    #[key]
    role_category:u32,
    slot:u256,
}

#[generate_trait]
impl CardSlotImpl of CardSlotTrait {
    fn init_cardslot(player:ContractAddress)->CardSlot{
        return CardSlot{
            player:player,
            role_category:1,
            slot:2047
        };
    }
    fn check_cardslot(slot:u256,cards:u256)->bool{
        return (~slot) & cards != 0;
    }
}
 