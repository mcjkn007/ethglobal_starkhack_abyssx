use core::option::OptionTrait;
use core::traits::TryInto;
use starknet::ContractAddress;
use starknet::storage_access::StorePacking;
use core::dict::Felt252DictTrait;

use abyss_x::utils::bit::{BitTrait};
use abyss_x::utils::vector::{Vector,VectorTrait};
 
#[derive(Model,Copy, Drop, Serde,PartialEq)]
struct Card {
    #[key]
    player:ContractAddress,
    #[key]
    role_category:u32,
    slot:u256,
}

#[generate_trait]
impl CardImpl of CardTrait {
    fn init_card(player:ContractAddress)->Card{
        return Card{
            player:player,
            role_category:1,
            slot:2047
        };
    }
}
