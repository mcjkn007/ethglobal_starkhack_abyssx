
use core::option::OptionTrait;
use starknet::ContractAddress;
use abyss_x::utils::bit::{Bit256Trait,Bit128Trait,Bit16Trait};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::utils::constant::{POW_2_U256};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Idol {
    #[key]
    player: ContractAddress,
 
    idols:u64,
}
 