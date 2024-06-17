use core::option::OptionTrait;
use starknet::ContractAddress;
use abyss_x::utils::bit::{Bit256Trait};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::utils::constant::{POW_2_U256};

#[derive(Model, Copy, Drop, Serde)]
struct Role {
    #[key]
    player: ContractAddress,
    #[key]
    category:u8,

    game_mode:u8,
    cur_stage:u8,

    hp:u16,
    gold:u16,

    seed:u64,

    blessing:u128,

    cards:u256,
    idols:u256,

}

mod RoleCategory{
    const NONE:u32 = 0;
    const WARRIOR:u32 = 1;
    const ROGUE:u32 = 2;
    const MAGE:u32 = 3;
}

#[generate_trait]
impl RoleImpl of RoleTrait {
    fn reset(ref self:Role){
        self.seed = 0;

        self.game_mode = 0;
        self.cur_stage = 0;

        self.hp = 0;
        self.gold = 0;

        self.blessing = 0;

        self.cards = 0;
        self.idols = 0;
      
    
    }
    fn get_cards(ref self:Role)->Array<u8>{
        let mut result =  ArrayTrait::<u8>::new();
 
        let mut cards:u256 = self.cards;
        result.append((cards & 0xf_u256).try_into().unwrap());
        loop{
            if(cards == 0){
                break;
            }
            cards /= POW_2_U256::_8;
            let mut v:u8 = (cards & 0xf_u256).try_into().unwrap();
 
            if(v.is_zero_u8()){
                break;
            }
            result.append(v);
        };
        return result;
    }
    fn get_cards_test(ref cards:u256)->Array<u8>{
        let mut result =  ArrayTrait::<u8>::new();
        result.append((cards & 0xf_u256).try_into().unwrap());
        loop{
            if(cards == 0){
                break;
            }
            cards /= POW_2_U256::_8;
            let mut v:u8 = (cards & 0xf_u256).try_into().unwrap();
 
            if(v.is_zero_u8()){
                break;
            }
            result.append(v);
        };
        return result;
    }
}