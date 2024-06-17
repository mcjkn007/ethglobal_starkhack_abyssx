
use core::option::OptionTrait;
use starknet::ContractAddress;
use abyss_x::utils::bit::{Bit256Trait,Bit128Trait,Bit16Trait};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::utils::constant::{POW_2_U256};

#[derive(Model, Copy, Drop, Serde)]
struct Card {
    #[key]
    player: ContractAddress,
 
    cards:u256,
}
#[generate_trait]
impl CardImpl of CardTrait {
    fn get_cards(ref self:Card)->Array<u8>{
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
    fn delete_card(ref self:Card,value:u8){
         self.cards = Bit256Trait::clean_bit_fast(self.cards,Bit256Trait::shift_left(0xf,value));
     }
}
 