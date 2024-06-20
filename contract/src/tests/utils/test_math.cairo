
#[cfg(test)]
mod tests {
 
    use core::num::traits::zero::Zero;
use abyss_x::utils::math::{MathU8Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_eq_zero_u8_base() {
        let mut c:u8 = 1;
        if(c == 0){
            c += 1;
        }else{
            c -= 1;
        }
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_eq_zero_u8() {
        let mut c:u8 = 1;
        if(c == 0){
            c += 1;
        }else{
            c -= 1;
        }
    }
}