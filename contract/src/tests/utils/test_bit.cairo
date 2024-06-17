#[cfg(test)]
mod tests {

    use core::array::SpanTrait;
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use abyss_x::utils::bit::{Bit256Trait,Bit128Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    use abyss_x::utils::math::{MathU32Trait};
    use abyss_x::utils::constant::{POW_2_U256,POW_2_U128};

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_is_bit_u256() {
        let mut bit:u256 = 5232;
        Bit256Trait::is_bit(bit,100);
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_is_bit_u256_fast() {
        let mut bit:u256 = 5232;
        Bit256Trait::is_bit_fast(bit,POW_2_U256::_100);
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_set_bit_u256() {
        let mut bit:u256 = 5232;
        Bit256Trait::set_bit(bit,100);
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_is_bit_u128() {
        let mut bit:u128 = 5232;
        Bit128Trait::is_bit(bit,100);
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_is_bit_u128_fast() {
        let mut bit:u128 = 5232;
        Bit128Trait::is_bit_fast(bit,POW_2_U128::_100);
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_set_bit_u128() {
        let mut bit:u128 = 5232;
        Bit128Trait::set_bit(bit,100);
    }
}
 