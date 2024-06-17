 
#[cfg(test)]
mod tests {
    use core::array::ArrayTrait;
    use abyss_x::utils::random::{RandomTrait,RandomContainerTrait,RandomArrayTrait};
    use abyss_x::utils::vector::{Vector,VectorTrait};
    use abyss_x::utils::math::{MathU32Trait};
 
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_random_u64() { 
        let mut seed:u64 = 4294967295;
        let result = RandomTrait::random_u64(ref seed,1,10);
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_random_array() { 
        let mut seed:u64 = 4294967295;
        let mut right_cards = array![1_u8,2,3,4,5];
        let aa = RandomContainerTrait::random_array(ref seed,@right_cards);
        right_cards = ArrayTrait::<u8>::new();
   
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_random_loop() { 
        let mut seed:u64 = 4294967295;
        let mut draw_count = 5;
        let mut left_cards = array![1_u8,2,3,4];
        let mut mid_cards = array![];
        let mut right_cards = array![1_u8,2,3,4,5];
        loop{
            match left_cards.pop_front() {
                Option::Some(r) => {
                    mid_cards.append(r);
    
                    draw_count.self_sub_u32();
                    if(mid_cards.len() == 10){
                        break;
                    }
                    if(draw_count == 0){
                        break;
                    }
                },
                Option::None => {
                    left_cards = RandomContainerTrait::random_array(ref seed,@right_cards);
                    right_cards = ArrayTrait::<u8>::new();
                },
            }
        };

        println!("left_cards len  : {}",left_cards.len());
    }

    
}

 