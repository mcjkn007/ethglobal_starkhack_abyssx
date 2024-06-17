#[cfg(test)]
mod tests {

    use super::{Pow256Trait};
    #[test]
    #[available_gas(100_000_000)]
    fn test_pow() {
        let mut result = Pow256Trait::pow(2,200);
    }
 
    

}