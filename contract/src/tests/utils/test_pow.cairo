#[cfg(test)]
mod tests {

    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    #[test]
    #[available_gas(100_000_000)]
    fn test_pow_u256() {
        let mut result = Pow256Trait::pow(2,200);
    }
    #[test]
    #[available_gas(100_000_000)]
    fn test_pow_u256_fast() {
        let mut result = Pow256Trait::fast_pow_2(200);
    }
    #[test]
    #[available_gas(100_000_000)]
    fn test_pow_u128() {
        let mut result = Pow128Trait::pow(2,100);
    }
    #[test]
    #[available_gas(100_000_000)]
    fn test_pow_u128_fast() {
        let mut result = Pow128Trait::fast_pow_2(100);
    }
  

}