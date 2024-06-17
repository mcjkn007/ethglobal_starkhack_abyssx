use core::box::BoxTrait;
use core::traits::AddEq;
use core::clone::Clone;
use core::array::ArrayTrait;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::traits::Into;
use core::dict::Felt252DictTrait;
use poseidon::PoseidonTrait;
use hash::HashStateTrait;
use debug::PrintTrait;

const RANDOM_P1:u64 = 1103515245_u64;
const RANDOM_P2:u128 = 12345_128;
const RANDOM_P3:u128 = 0x7fffffff_u128;

 
use abyss_x::utils::vector::{Vector,VectorTrait};
use abyss_x::utils::math::{MathU8Trait,MathU32Trait,MathU64Trait}; 
 
#[generate_trait]
impl RandomImpl of RandomTrait{
    fn random_u64_loop(seed:u64,loop_num:u32,min:u64,max:u64) -> u64{
        let mut i:u32 = 0_u32;
        let mut s:u64 = seed;
        loop{
            if(i == loop_num){
                break;
            }
            s = match core::integer::u128_checked_add(core::integer::u64_wide_mul(s,RANDOM_P1),RANDOM_P2) {
                Option::Some(r) => (r & RANDOM_P3).try_into().unwrap(),
                Option::None => 0,
            };
        };
       
        return MathU64Trait::add_u64(min,s % MathU64Trait::sub_u64(max,min));
    }
    #[inline]
    fn random_u64(ref seed:u64,min:u64,max:u64) -> u64{
        seed = match core::integer::u128_checked_add(core::integer::u64_wide_mul(seed,RANDOM_P1),RANDOM_P2) {
            Option::Some(r) => (r & RANDOM_P3).try_into().unwrap(),
            Option::None => 0,
        };
        return MathU64Trait::add_u64(min,seed % MathU64Trait::sub_u64(max,min));
    }
    #[inline]
    fn random_u64_c(ref seed:u64,min:u64,max:u64) -> u64{
        seed = match core::integer::u128_checked_add(core::integer::u64_wide_mul(seed,RANDOM_P1),RANDOM_P2) {
            Option::Some(r) => (r & RANDOM_P3).try_into().unwrap(),
            Option::None => 0,
        };
        return MathU64Trait::add_u64(min,seed % (MathU64Trait::sub_u64(max,min)+1));
    }
}

#[generate_trait]
impl RandomContainerImpl<T,+Drop<T>, +Copy<T>,+AddEq<T>,+PartialOrd<T>,+Into<T, felt252>, +Into<u8, T>,+Into<T, u32>,+Into<T, u64>,+PartialEq<T>, +Felt252DictValue<T>> of RandomContainerTrait<T>{
    fn random_array(ref seed:u64,data:@Array<T>)->Array<T>{
 
        let mut cur_pos:u32 = data.len();
        let mut dict: Felt252Dict<u8> = Default::default(); 
        let mut result: Array<T> = ArrayTrait::new();
        loop{
             
            if(cur_pos == 1_u32){
                result.append(*data.at(MathU32Trait::sub_u32(dict.get(1).into(),1_u32)));
                break;
            } 
        
            let mut rand_pos:u64 =  MathU64Trait::add_u64(RandomTrait::random_u64(ref seed,0_u64,cur_pos.into()),1_u64);
            let v:u8 = dict.get(rand_pos.try_into().unwrap());
            if(v.is_zero_u8()){
                result.append(*data.at((MathU64Trait::sub_u64(rand_pos,1_u64)).try_into().unwrap()));
            }else{
                result.append(*data.at((MathU8Trait::sub_u8(v,1_u8)).try_into().unwrap()));
            }
            dict.insert(rand_pos.try_into().unwrap(),cur_pos.try_into().unwrap());
            cur_pos.self_sub_u32();
        };

        return result;
    }
   
    fn random_ref_dict(ref seed:u64,ref data:Felt252Dict<T>,data_size:u32){
        
        let mut cur_pos:u32 = data_size;
        loop{
            if(cur_pos.is_zero_u32()){
                break;
            }
             
            let rand_pos:u64 = RandomTrait::random_u64(ref seed,0_u64,cur_pos.into());
            let v:T = data.get(rand_pos.into());
            cur_pos.self_sub_u32();

            data.insert(rand_pos.into(),data.get(cur_pos.into()));
            data.insert(cur_pos.into(),v);
            
        };
    }
}
#[generate_trait]
impl RandomArrayImpl of RandomArrayTrait{

    fn random_number(ref seed:u64,size:u32)->Array<u8>{
 
        let mut cur_pos:u32 = size;
        let mut dict: Felt252Dict<u8> = Default::default(); 
        let mut result: Array<u8> = ArrayTrait::new();
        loop{
            if(cur_pos == 1_u32){
                result.append(MathU8Trait::sub_u8(dict.get(1).into(),1_u8));
                break;
            } 
        
            let mut rand_pos:u64 =  MathU64Trait::add_u64(RandomTrait::random_u64(ref seed,0_u64,cur_pos.into()),1_u64);
            let v:u8 = dict.get(rand_pos.try_into().unwrap());
            if(v.is_zero_u8()){
                result.append((MathU64Trait::sub_u64(rand_pos,1_u64)).try_into().unwrap());
            }else{
                result.append((MathU8Trait::sub_u8(v,1_u8)).try_into().unwrap());
            }
            dict.insert(rand_pos.try_into().unwrap(),cur_pos.try_into().unwrap());
            cur_pos.self_sub_u32();
        };

        return result;
    }
}

 