use core::dict::Felt252DictTrait;
use abyss_x::utils::math::{MathU8Trait,MathU16Trait};

use abyss_x::utils::constant::{POW_2_U64};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::status::{StatusTrait};
 
mod CommonRelic{
    const R0: u64 = 0x1;
    const R1: u64 = 0x2;
    const R2: u64 = 0x4;
    const R3: u64 = 0x8;

    const R4: u64 = 0x10;
    const R5: u64 = 0x20;
    const R6: u64 = 0x40;
    const R7: u64 = 0x80;

    const R8: u64 = 0x100;
    const R9: u64 = 0x200;
    const R10: u64 = 0x400;
    const R11: u64 = 0x800;

    const R12: u64 = 0x1000;
    const R13: u64 = 0x2000;
    const R14: u64 = 0x4000;
    const R15: u64 = 0x8000;

    const R16: u64 = 0x10000;
    const R17: u64 = 0x20000;
    const R18: u64 = 0x40000;
    const R19: u64 = 0x80000;


}
 
#[generate_trait]
impl RelicImpl of RelicTrait {
  
}