 
#[cfg(test)]
mod tests {
    use core::array::ArrayTrait;
    use abyss_x::utils::random::{RandomTrait,RandomContainerTrait,RandomArrayTrait};
    use abyss_x::utils::vector::{Vector,VectorTrait};
 
 
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_random_u64() { 
        let mut seed:u64 = 4294967295;
        let result = RandomTrait::random_u64(ref seed,1,10);
    }
}

 