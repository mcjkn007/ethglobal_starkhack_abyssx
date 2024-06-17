#[cfg(test)]
mod tests {

    use abyss_x::utils::math::MathU8Trait;
use core::dict::Felt252DictTrait;
use core::array::SpanTrait;
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use abyss_x::utils::bit::{Bit256Trait,Bit128Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    use abyss_x::utils::math::{MathU32Trait};
    use abyss_x::utils::constant::{POW_2_U256,POW_2_U128};

    use abyss_x::game::charactor::c1::{C1StatusTrait};
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_dict() {
        let mut balances: Felt252Dict<u8> = Default::default();

        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
        
        balances.insert('bleed',1);
        println!("test_dict 1 gas : {}", initial - testing::get_available_gas());
    }


    #[test]
    #[available_gas(1_000_000_000)]
    fn test_struct() {
      let mut c1 = C1StatusTrait::new();
      
      let mut initial = testing::get_available_gas();
      gas::withdraw_gas().unwrap();
      
      c1.bleed.add_eq_u8(1);
      println!("test_struct 1 gas : {}", initial - testing::get_available_gas());
    }
   
}
 