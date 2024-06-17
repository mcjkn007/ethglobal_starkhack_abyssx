#[cfg(test)]
mod tests {
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
 
    use debug::PrintTrait;
    use core::array::SpanTrait;
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use abyss_x::utils::bit::{Bit256Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    use abyss_x::utils::array_map::{ArrayMap,ArrayMapTrait};

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_array_map() {
        let mut t1  = ArrayMapTrait::<u8>::new();
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
            t2.append(t1.pop_front());
        };
    }
   
}
 