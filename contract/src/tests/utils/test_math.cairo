
#[cfg(test)]
mod tests {
 
    use abyss_x::utils::math::{MathU8Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
 
 
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_self_sub_u8() {
        let mut c:u8 = 1;
        c.self_sub_u8();
    }
 
}