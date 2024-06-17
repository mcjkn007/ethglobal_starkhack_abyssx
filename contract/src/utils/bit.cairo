use core::traits::TryInto;
use core::option::OptionTrait;
 
use debug::PrintTrait;
use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};

#[generate_trait]
impl Bit256Impl of Bit256Trait {
    #[inline]
    fn is_bit(bit:u256,n:u8)->bool{
       return bit & Pow256Trait::fast_pow_2(n) != 0_u256;
    }
    #[inline]
    fn is_bit_fast(bit:u256,mask:u256)->bool{
        return bit & mask != 0_u256;
    }
    #[inline]
    fn set_bit(bit:u256,n:u8)->u256{
        return bit | Pow256Trait::fast_pow_2(n);
    }
    #[inline]
    fn set_bit_fast(bit:u256,mask:u256)->u256{
        return bit | mask;
    }
    #[inline]
    fn clean_bit(bit:u256,n:u8)->u256{
        return bit & ~Pow256Trait::fast_pow_2(n);
    }
    #[inline]
    fn clean_bit_fast(bit:u256,mask:u256)->u256{
        return bit & ~mask;
    }
    #[inline]
    fn match_bit(a:u256,b:u256)->bool{
        return (~a) & b == 0;
    }
    #[inline]
    fn cut_bit(bit:u256,n:u8,mask:u256)->u256{
        return bit / Pow256Trait::fast_pow_2(n) & mask;
    }
    #[inline]
    fn cut_bit_fast(bit:u256,shift:u256,mask:u256)->u256{
        return bit / shift & mask;
    }
    #[inline]
    fn cut_bit_8(bit:u256,shift:u8)->u256{
        return bit / Pow256Trait::fast_pow_2_8(shift) & 0xf_u256;
    }

    #[inline]
    fn shift_left(x:u256,n:u8) -> u256 {
        return x * Pow256Trait::fast_pow_2(n);
    }
    #[inline]
    fn shift_left_fast(x:u256,shift:u256) -> u256 {
        return x * shift;
    }
    #[inline]
    fn shift_right(x:u256, n: u8) -> u256 {
        return x / Pow256Trait::fast_pow_2(n);
    }
    #[inline]
    fn shift_right_fast(x:u256, shift:u256) -> u256 {
        return x / shift;
    }
}

#[generate_trait]
impl Bit128Impl of Bit128Trait {
    #[inline]
    fn is_bit(bit:u128,n:u8)->bool{
        return bit & Pow128Trait::fast_pow_2(n) != 0_u128;
    }
    #[inline]
    fn is_bit_fast(bit:u128,mask:u128)->bool{
        return bit & mask != 0_u128;
    }
    #[inline]
    fn set_bit(bit:u128,n:u8)->u128{
        return bit | Pow128Trait::fast_pow_2(n);
    }
    #[inline]
    fn set_bit_fast(bit:u128,mask:u128)->u128{
        return bit | mask;
    }
    #[inline]
    fn clean_bit(bit:u128,n:u8)->u128{
        return bit & ~Pow128Trait::fast_pow_2(n);
    }
    #[inline]
    fn clean_bit_fast(bit:u128,mask:u128)->u128{
        return bit & ~mask;
    }
    #[inline]
    fn match_bit(a:u128,b:u128)->bool{
        return (~a) & b == 0_u128;
    }
    #[inline]
    fn cut_bit(bit:u128,shift:u8,mask:u128)->u128{
        return bit / Pow128Trait::fast_pow_2(shift) & mask;
    }
    #[inline]
    fn cut_bit_fast(bit:u128,shift:u128,mask:u128)->u128{
        return bit / shift & mask;
    }
    #[inline]
    fn shift_left(x:u128, n: u8)->u128 {
        return x * Pow128Trait::fast_pow_2(n);
    }
    #[inline]
    fn shift_left_fast(x:u128, shift: u128)->u128 {
        return x * shift;
    }
    #[inline]
    fn shift_right(x:u128, n: u8)->u128{
        return  x / Pow128Trait::fast_pow_2(n);
    }
    #[inline]
    fn shift_right_fast(x:u128, shift: u128)->u128{
        return  x / shift;
    }
}

 