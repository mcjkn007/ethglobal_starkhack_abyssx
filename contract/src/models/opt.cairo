use starknet::ContractAddress;
use abyss_x::utils::constant::{EventCode};
 

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Opt {
    #[key]
    player: ContractAddress,
    code: EventCode
}