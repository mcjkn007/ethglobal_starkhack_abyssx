use starknet::ContractAddress;
use abyss_x::utils::constant::{EventCode};
 

#[derive(Copy, Drop, Serde)]
#[dojo::model]
#[dojo::event]
struct Message {
    #[key]
    player: ContractAddress,
    code: EventCode
}