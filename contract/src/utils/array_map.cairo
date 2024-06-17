use core::option::OptionTrait;
use core::array::ArrayTrait;
use core::clone::Clone;

use abyss_x::utils::pow::{Pow128Trait};
use abyss_x::utils::math::{MathU32Trait};
 
#[derive(Drop)]
struct ArrayMap<T> {
    value:Array<T>,
    map:u128,
    size:u32,
}
 
 pub trait ArrayMapTrait<T> {
    fn new()->ArrayMap<T>;
    fn size(self: @ArrayMap<T>)->u32;
    fn empty(self: @ArrayMap<T>)->bool;
    fn at(ref self:ArrayMap<T>, index: u32)->T;
    fn check_value(ref self:ArrayMap<T>, value: T)->bool;
    fn remove_value(ref self:ArrayMap<T>, value: T);
    fn push_back(ref self:ArrayMap<T>,value:T);
    fn pop_front(ref self:ArrayMap<T>)->T;
}
 
impl ArrayMapImpl<T,+Drop<T>, +Copy<T>,+PartialEq<T>,+Into<T,u8>,+Into<u8,T>,+Into<T,u32>,+Into<T,felt252>> of ArrayMapTrait<T> {
    #[inline]
    fn new()->ArrayMap<T>{
        return ArrayMap{
            value:ArrayTrait::<T>::new(),
            map:0,
            size:0,
        };
    }
    #[inline]
    fn size(self: @ArrayMap<T>) -> u32{
        return *self.size;
    }
    #[inline]
    fn empty(self:@ ArrayMap<T>) -> bool{
        return (*self.size).is_zero_u32();
    }
    fn at(ref self:ArrayMap<T>, index: u32)->T{
        return *self.value.at(index);
    }
    fn check_value(ref self:ArrayMap<T>, value: T)->bool{
        return self.map & Pow128Trait::fast_pow_2(value.into()) != 0_u128;
    }
    fn remove_value(ref self:ArrayMap<T>, value: T){
        self.map = self.map & ~Pow128Trait::fast_pow_2(value.into());
        self.size.self_sub_u32();
    }
    
    fn push_back(ref self:ArrayMap<T>,value:T){
        self.value.append(value);
        self.map = self.map | Pow128Trait::fast_pow_2(value.into());
        self.size.self_add_u32();
    }
 
    fn pop_front(ref self:ArrayMap<T>)->T{
        let mut v:T = 0_u8.into();
        loop{
            match self.value.pop_front() {
                Option::Some(r) => {
                    if(self.map & Pow128Trait::fast_pow_2(r.into()) != 0_u128){
                        self.map = self.map & ~Pow128Trait::fast_pow_2(r.into());
                        v = r.into();
                        self.size.self_sub_u32();
                        break;
                    }
                },
                Option::None => {
                    break;
                },
            }
        };
       
        return v;
    }
}

 