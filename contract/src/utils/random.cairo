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
const RANDOM_P2:u64 = 12345_u64;
const RANDOM_P3:u64 = 0x7fffffff;

trait RandomTrait {
    fn random(seed:u64,min:u64,max:u64) -> u64;
    fn random_r(ref seed:u64,min:u64,max:u64) -> u64;
}

impl RandomImpl of RandomTrait{
     fn random(seed:u64,min:u64,max:u64) -> u64{
        let s:u128 = ((seed * RANDOM_P1 + RANDOM_P2) & RANDOM_P3).into();
        return min + s.try_into().unwrap() % (max - min + 1);
    }
    fn random_r(ref seed:u64,min:u64,max:u64) -> u64{
        let s:u128 = ((seed * RANDOM_P1 + RANDOM_P2) & RANDOM_P3).into();
        seed = s.try_into().unwrap();
        return min + seed % (max - min + 1);
    }
}


trait RandomContainerTrait<T> {
  fn random_array(ref seed:u64,data:@Array<T>)->Array<T>;
  fn random_dict(ref seed:u64,ref data:Felt252Dict<T>,data_size:u32)->Felt252Dict<T>;
}

impl RandomContainerImpl<T,+Drop<T>, +Copy<T>, +Felt252DictValue<T>> of RandomContainerTrait<T>{
    fn random_array(ref seed:u64,data:@Array<T>)->Array<T>{
 
        let data_size = data.len();

        assert(data_size > 1, 'random sequence len error');

        let mut dict: Felt252Dict<T> = Default::default();
        let mut i = 0;

        loop{
            if(i == data_size){
                break;
            }
            dict.insert(i.into(),*data.at(i));
            i += 1;
        };

        let mut cur_pos:u64 = data_size.into()-1;
        loop{
            if(cur_pos == 0){
                break;
            }
             
            let rand_pos:u64 = RandomTrait::random_r(ref seed,0_u64,cur_pos);
            let v:T = dict.get(rand_pos.into());
            dict.insert(rand_pos.into(),dict.get(cur_pos.into()));
            dict.insert(cur_pos.into(),v);
            cur_pos -= 1;
        };

        let mut arr = array![];
        i = 0;
        loop{
            if(i == data_size){
                break;
            }
            arr.append(dict.get(i.into()));
            i += 1;
        };
        return arr;
    }
    fn random_dict(ref seed:u64,ref data:Felt252Dict<T>,data_size:u32)->Felt252Dict<T>{
 
        assert(data_size > 1, 'random sequence len error');

        let mut dict: Felt252Dict<T> = Default::default();
        let mut i = 0;

        loop{
            if(i == data_size){
                break;
            }
            let v = data.get(i.into());
            dict.insert(i.into(),v);
            i += 1;
        };

        let mut cur_pos:u64 = data_size.into()-1;
        loop{
            if(cur_pos == 0){
                break;
            }
             
            let rand_pos:u64 = RandomTrait::random_r(ref seed,0_u64,cur_pos);
            let v:T = dict.get(rand_pos.into());
            dict.insert(rand_pos.into(),dict.get(cur_pos.into()));
            dict.insert(cur_pos.into(),v);
            cur_pos -= 1;
        };
        return dict;
    }
}

 