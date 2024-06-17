#[cfg(test)]
mod tests {
    use core::dict::Felt252DictTrait;
use debug::PrintTrait;
    use core::array::SpanTrait;
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use abyss_x::utils::math::{MathU32Trait};
    use abyss_x::utils::bit::{Bit256Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    use abyss_x::utils::dict_map::{DictMap,DictMapTrait};

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_dict_map() {
        let mut t1  = DictMapTrait::<u8>::new();
        t1.push_back(1);
        t1.push_back(2);
        t1.push_back(3);
        t1.push_back(4);
        t1.push_back(5);
        t1.push_back(6);
        t1.push_back(7);
        t1.push_back(8);
        t1.push_back(9);
        t1.push_back(10);

        

        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
    
        t1.push_back(11);
        t1.push_back(21);
        t1.remove_value(3);

        let mut t2 = array![];

        loop{
            if(t1.size() == 0_u32){
                break;
            }
            t2.append(t1.pop_back());
        };
      
    }

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_dict_map_fast() {
        let mut t1  = DictMapTrait::<u8>::new();
        t1.push_back(1);
        t1.push_back(2);
        t1.push_back(3);
        t1.push_back(4);
        t1.push_back(5);
        t1.push_back(6);
        t1.push_back(7);
        t1.push_back(8);
        t1.push_back(9);
        t1.push_back(10);

        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
        t1.push_back(5);
        t1.remove_value(5);
    
        t1.push_back(11);
        t1.push_back(21);
        t1.remove_value(3);

        let mut t2 = array![];

        loop{
            if(t1.size() == 0_u32){
                t1.clean_value_dict();
                break;
            }
            t2.append(t1.pop_back_fast());
        };
        
    }
    
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_dict_map11() {
        let mut t1:Felt252Dict<u32>  = Default::default();
        t1.insert(1,1);
        t1.insert(2,2);
        t1.insert(3,3);
        t1.insert(4,4);
        t1.insert(5,5);
        t1.insert(6,6);
 
        let mut i:u32 = 2;
        t1.insert(i.into(),t1.get((i.self_add__u32().into())));

        println!("test_dict_map11 gas : {}", t1.get(i.into()));
        
    }
    
}
 