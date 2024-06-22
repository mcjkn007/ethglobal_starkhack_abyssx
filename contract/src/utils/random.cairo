use core::traits::RemEq;
use core::traits::DivEq;
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

const RANDOM_P1:u128 = 1103515245;
const RANDOM_P2:u128 = 12345;
const RANDOM_P3:u128 = 65536;
const RANDOM_P4:u128 = 0x7fffffff;

 
use abyss_x::utils::vector::{Vector,VectorTrait};
use abyss_x::utils::math::{MathU8Trait,MathU32Trait,MathU64Trait}; 
 
#[generate_trait]
impl RandomImpl of RandomTrait{
    fn random_u64_loop(ref seed:u64,loop_num:u8){
        let mut i:u8 = 0;
        loop{
            if(i == loop_num){
                break;
            }
            seed = match core::integer::u128_checked_add(seed.into()*RANDOM_P1,RANDOM_P2) {
                Option::Some(r) => (r & RANDOM_P4).try_into().unwrap(),
                Option::None => 0,
            };
            i.self_add_u8();
        };
    }
    #[inline]
    fn random_u64(ref seed:u64,min:u64,max:u64) -> u64{
        //左闭右开
        seed = match core::integer::u128_checked_add(seed.into()*RANDOM_P1,RANDOM_P2) {
            Option::Some(r) => (r & RANDOM_P4).try_into().unwrap(),
            Option::None => 0,
        };
        return MathU64Trait::add_u64(min,seed % MathU64Trait::sub_u64(max,min));
    }
 
    #[inline]
    fn random_u64_c(ref seed:u64,min:u64,max:u64) -> u64{
        //左闭右闭
        seed = match core::integer::u128_checked_add(seed.into()*RANDOM_P1,RANDOM_P2) {
            Option::Some(r) => (r & RANDOM_P4).try_into().unwrap(),
            Option::None => 0,
        };
 
        return MathU64Trait::add_u64(min,seed % (MathU64Trait::sub_u64(max,min)+1));
    }
}

#[generate_trait]
impl RandomContainerImpl<T,+Drop<T>, +Copy<T>,+AddEq<T>,+PartialOrd<T>,+Into<T, felt252>, +Into<u8, T>,+Into<T, u32>,+Into<T, u64>,+PartialEq<T>, +Felt252DictValue<T>> of RandomContainerTrait<T>{
    fn random_array(ref seed:u64,data:@Array<T>)->Array<T>{
 
        let mut cur_pos:u8 = data.len().try_into().unwrap();
        let mut dict: Felt252Dict<u8> = Default::default(); 
        let mut result: Array<T> = ArrayTrait::new();
        loop{
             
            if(cur_pos == 1){
                
                result.append(*data.at(MathU8Trait::sub_u8(dict.get(0),1).into()));
                break;
            } 
        
            let rand_pos:felt252 = RandomTrait::random_u64(ref seed,0,MathU8Trait::sub_u8(cur_pos,1).into()).into();
            let mut v:u8 = dict.get(rand_pos);
            if(v == 0){
                result.append(*data.at(rand_pos.try_into().unwrap()).try_into().unwrap());
            }else{
                result.append(*data.at((MathU8Trait::sub_u8(v,1)).try_into().unwrap()));
            }
            v = dict.get((MathU8Trait::sub_u8(cur_pos,1)).into());

            if(v == 0){
                dict.insert(rand_pos,cur_pos.try_into().unwrap());
            }else{
                dict.insert(rand_pos,v);
            }
 
            cur_pos.self_sub_u8();
        };

        return result;
    }
   
    fn random_ref_dict(ref seed:u64,ref data:Felt252Dict<T>,data_size:u32){
        
        let mut cur_pos:u32 = data_size;
        loop{
            if(cur_pos == 0){
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
 
        let mut cur_pos:u8 = size.try_into().unwrap();
        let mut dict: Felt252Dict<u8> = Default::default(); 
        let mut result: Array<u8> = ArrayTrait::new();
        loop{
            if(cur_pos == 1){
                result.append(MathU8Trait::sub_u8(dict.get(0),1));
                break;
            } 
            println!("seed  : {}",seed);
            let rand_pos:felt252 = RandomTrait::random_u64(ref seed,0,MathU8Trait::sub_u8(cur_pos,1).into()).into();
            let mut v:u8 = dict.get(rand_pos);
            println!("rand_pos  : {}",rand_pos);
            println!("cur_pos  : {}",cur_pos-1);
            println!("---------");
            if(v == 0){
                result.append(rand_pos.try_into().unwrap());
            }else{
                result.append((MathU8Trait::sub_u8(v,1)));
            }
            v = dict.get((MathU8Trait::sub_u8(cur_pos,1)).into());
            if(v == 0){
                dict.insert(rand_pos,cur_pos.try_into().unwrap());
            }else{
                dict.insert(rand_pos,v);
            }
            cur_pos.self_sub_u8();
        };

        return result;
    }
}

 