#[cfg(test)]
mod tests {

    use core::array::SpanTrait;
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use abyss_x::utils::bit::{Bit256Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    use abyss_x::utils::math::{MathU32Trait};

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_1() {
        let mut c:u32 = 0;
        if(c != 0){
            c.self_sub_u32();
        }
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_2() {
        let mut c:u32 = 1;
        c.self_sub_u32();
    }
}
 