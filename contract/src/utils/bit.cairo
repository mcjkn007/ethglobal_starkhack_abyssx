use core::traits::TryInto;
use core::option::OptionTrait;
 
use debug::PrintTrait;
use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};

#[generate_trait]
impl Bit256Impl of Bit256Trait {
    fn is_bit(bit:u256,n:u8)->bool{
       return bit & Pow256Trait::fast_pow_2(n) != 0_u256;
    }
    fn is_bit_fast(bit:u256,mask:u256)->bool{
        return bit & mask != 0_u256;
    }
    fn set_bit(bit:u256,n:u8)->u256{
        return bit | Pow256Trait::fast_pow_2(n);
    }
    fn clean_bit(bit:u256,n:u8)->u256{
        return bit & ~Pow256Trait::fast_pow_2(n);
    }
    fn clean_bit_mask(bit:u256,mask:u256)->u256{
        return bit & ~mask;
    }
    fn match_bit(a:u256,b:u256)->bool{
        return (~a) & b == 0;
    }
    fn cut_bit(bit:u256,mask:u256,shift:u8)->u256{
        return bit / Pow256Trait::fast_pow_2(shift) & mask;
    }
    fn cut_bit_8(bit:u256,shift:u8)->u256{
        return bit / Pow256Trait::fast_pow_2_8(shift) & 0xf_u256;
    }
    fn shift_left(x:u256, n: u8) -> u256 {
        return x * Pow256Trait::fast_pow_2(n);
    }
    fn shift_right(x:u256, n: u8) -> u256 {
        return x / Pow256Trait::fast_pow_2(n);
    }
 
}

#[generate_trait]
impl Bit128Impl of Bit128Trait {
    fn is_bit(bit:u128,n:u8)->bool{
        return bit & Pow128Trait::fast_pow_2(n) != 0_u128;
    }
    #[inline]
    fn is_bit_fast(bit:u128,mask:u128)->bool{
        return bit & mask != 0_u128;
    }
    fn set_bit(bit:u128,n:u8)->u128{
        return bit | Pow128Trait::fast_pow_2(n);
    }
    fn clean_bit(bit:u128,n:u8)->u128{
        return bit & ~Pow128Trait::fast_pow_2(n);
    }
    fn clean_bit_mask(bit:u128,mask:u128)->u128{
        return bit & ~mask;
    }
    fn match_bit(a:u128,b:u128)->bool{
        return (~a) & b == 0_u128;
    }
    fn cut_bit(bit:u128,mask:u128,shift:u8)->u128{
        return bit / Pow128Trait::fast_pow_2(shift) & mask;
    }
    fn shift_left(x:u128, n: u8)->u128 {
        //return x * Pow128Trait::fast_pow_2(n);
        return  core::integer::u128_checked_mul(x,Pow128Trait::fast_pow_2(n)).unwrap();
    }
    fn shift_right(x:u128, n: u8)->u128{
        return  x / Pow128Trait::fast_pow_2(n);
    }
}

 