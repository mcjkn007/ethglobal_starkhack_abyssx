use starknet::{ContractAddress,contract_address_const};
use starknet::Event;
 
#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum EventCode{
    None,
    Login,
    SetNickName,
    SetUpDeck,
    RenameDeck,
    DeleteDeck,
    StartGame,
    GiveUpGame,
    SelectNextStage,
    CheckBattleResult,
    ChooseEventBonus,
}
//pack
const DIGIT_8:u32 = 8_u32;
const DIGIT_16:u32 = 16_u32;
const DIGIT_32:u32 = 32_u32; 

const MASK_8:u256 = 0xf;
const MASK_16:u256 = 0xff;
const MASK_32:u256 = 0xffffffff; 

//card
const CARD_MAX:u32 = 32_u32; 
//property
const PROPERTY_BASE_MAX:u32 = 8_u32;
const PROPERTY_STATUS_MAX:u32 = 32_u32; 

const SLOT_SIZE:u32 = 256_u32;
const MAX_STAGE:u32 = 12_u32;