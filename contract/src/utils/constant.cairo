use starknet::{ContractAddress,contract_address_const};
use starknet::Event;

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum EventCode{
    None,
    Login,
    SetNickName,
    StartGame,
    GiveUpGame,
    SelectNextStage,
    CheckBattleResult,
    ChooseEventBonus,
}

const ERC20_ADD:felt252 = 0x056834208d6a7cc06890a80ce523b5776755d68e960273c9ef3659b5f74fa494;

const MAX_STAGE:u32 = 12_u32;