#[cfg(test)]
mod tests {
    use core::dict::Felt252DictTrait;
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory};
    use abyss_x::utils::vector::{Vector,VectorTrait,Vector2,Vector2Trait};
    use core::nullable::NullableImpl;

    #[derive(Copy,Drop,Destruct)]
    struct Vec2 {
        x:u32,
        y:u32
    }


    #[test]
    #[ignore]
    #[available_gas(100_000_000)]
    fn test_vector() {
        println!("---------vector_test----------");
 
        let mut result = VectorTrait::<u8>::new();
        result.push_back(1);
        result.push_back(2);
        result.push_back(3);
        result.push_back(4);
        result.push_back(5);
        result.push_back(6);
        result.push_back(7);
        result.push_back(8);
        result.push_back(9);
        result.push_back(10);
 
        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
        result.remove(2);
        let mut gas = initial - testing::get_available_gas();
        println!("test_vector gas : {}", gas);
     
    }
    fn test_vector2() {
     
        let mut result:Felt252Dict<Nullable<Vec2>> = Default::default();
        let e = Vec2{
            x:3,
            y:2,
        };
        result.insert(0,NullableImpl::new(e));
     
     
     
    }
}
