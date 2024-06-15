use core::option::OptionTrait;
 
use debug::PrintTrait;
use abyss_x::utils::pow::{PowTrait};

#[generate_trait]
impl BitImpl of BitTrait {
     fn is_bit(bit:u256,n:u32)->bool{
        if(bit & PowTrait::fast_pow_2(n) == 0){
            return false;
        }
        return true;
     }
    fn set_bit(bit:u256,n:u32,one:bool)->u256{
        if(one){
            return bit+(bit | PowTrait::fast_pow_2(n));
        } 
        return bit+(bit & ~PowTrait::fast_pow_2(n));
    }
    fn clean_bit(bit:u256,mask:u256)->u256{
        return bit & ~mask;
    }

    fn cut_bit(bit:u256,mask:u256,shift:u32)->u256{
        if(shift == 0){
            return bit & mask;
        }
        return bit / PowTrait::fast_pow_2(shift) & mask;
    }
    fn shift_left(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        return x * PowTrait::fast_pow_2(n);
    }
    fn shift_right(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        if(n > 255){
            return 0;
        }
        return x / PowTrait::fast_pow_2(n);
    }
    fn cut_bit_8(bit:u256,shift:u32)->u256{
        if(shift == 0){
            return bit & 8;
        }
        return bit / PowTrait::fast_pow_2_8(shift) & 8;
    }
    fn shift_left_8(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        return x * PowTrait::fast_pow_2_8(n);
    }
    fn shift_right_8(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        if(n > 255){
            return 0;
        }
        return x / PowTrait::fast_pow_2_8(n);
    } 
    fn cut_bit_16(bit:u256,shift:u32)->u256{
        if(shift == 0){
            return bit & 16;
        }
        return bit / PowTrait::fast_pow_2_16(shift) & 16;
    }
    fn shift_left_16(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        return x * PowTrait::fast_pow_2_16(n);
    }
    fn shift_right_16(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        if(n > 255){
            return 0;
        }
        return x / PowTrait::fast_pow_2_16(n);
    } 
    fn cut_bit_32(bit:u256,shift:u32)->u256{
        if(shift == 0){
            return bit & 32;
        }
        return bit / PowTrait::fast_pow_2_32(shift) & 32;
    }
    fn shift_left_32(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        return x * PowTrait::fast_pow_2_32(n);
    }
    fn shift_right_32(x:u256, n: u32) -> u256 {
        if(n == 0){
            return x;
        }
        if(n > 255){
            return 0;
        }
        return x / PowTrait::fast_pow_2_32(n);
    }
}

#[cfg(test)]
mod tests {

    use super::{BitTrait};
    use abyss_x::utils::pow::{PowTrait};

}
 