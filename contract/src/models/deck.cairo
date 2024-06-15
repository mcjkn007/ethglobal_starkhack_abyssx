use starknet::ContractAddress;

#[derive(Model,Copy, Drop, Serde,PartialEq)]
struct Deck {
    #[key]
    player:ContractAddress,
    #[key]
    name:felt252,
    #[key]
    role_category:u32,
    slot:u256,
}
