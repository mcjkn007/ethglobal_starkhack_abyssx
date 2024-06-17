use starknet::ContractAddress;

#[derive(Model,Copy, Drop, Serde,PartialEq)]
struct Deck {
    #[key]
    player:ContractAddress,
    #[key]
    role_category:u32,
    #[key]
    position:u32,
    
    name:felt252,
    slot:u256,
}
