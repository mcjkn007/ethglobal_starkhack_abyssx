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

 

#[cfg(test)]
mod tests {
    use core::dict::Felt252DictTrait;
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use debug::PrintTrait;
    use core::traits::Into;
    use super::{RandomTrait};
    use dojo_starter::utils::seed::{SeedTrait};

    #[test]
    #[available_gas(100000000)]
    fn test_random() {
        let mut seed = SeedTrait::create_seed(1,2,3);
        let mut arr = ArrayTrait::<u64>::new();
        arr.append(0);
        arr.append(2);
        arr.append(3);
        arr.append(4);
        arr.append(5);

         let mut dict: Felt252Dict<u32> = Default::default();
         dict.insert(0,1);
         let a = dict.get(0);
         let b = dict.get(0);
        assert(a == b, '11111111');

        //let dict = RandomTrait::create_random_sequence(ref seed,@arr);
    }
 
}
