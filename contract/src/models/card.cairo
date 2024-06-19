use core::num::traits::zero::Zero;
use core::traits::SubEq;
use core::traits::AddEq;

use core::option::OptionTrait;
use starknet::ContractAddress;
use abyss_x::utils::bit::{Bit256Trait,Bit128Trait,Bit16Trait};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::utils::constant::{POW_2_U256};

#[derive(Copy, Drop, Serde,IntrospectPacked)]
#[dojo::model]
struct Card {
    #[key]
    player: ContractAddress,
 
    cards:u256,
}
#[generate_trait]
impl CardImpl of CardTrait {
    #[inline]
    fn get_cards(ref self:Card)->Array<u8>{
        let mut result =  ArrayTrait::<u8>::new();
    
        let mut cards:u256 = self.cards;
        result.append((cards & 0xf).try_into().unwrap());
        loop{
            if(cards == 0){
                break;
            }
            cards /= POW_2_U256::_8;
            let mut v:u8 = (cards & 0xf).try_into().unwrap();
    
            if(v.is_no_zero_u8()){
                result.append(v);
            }
        };
        return result;
    }
    #[inline]
    fn add_card(ref self:Card,value:u8){
        let mut i:u8 = 0;
        let mut cards:u256 = self.cards;
        loop{
            if(cards == 0){
                break;
            }
            cards /= POW_2_U256::_8;
            if(cards & 0xf == 0){
                break;
            }
            i.add_eq(8);
        };

        self.cards = self.cards | Bit256Trait::shift_left(value.into(),i);
    }
    #[inline]
    fn delete_card(ref self:Card,n:u8){

        //let start_bit:u8 = n * 8;
    
        // 将删除位左边的位右移8位
        //let  leftPart = Bit256Trait::shift_left(Bit256Trait::shift_right(self.cards,start_bit + 8),start_bit);
    
        // 将删除位右边的位保持不变
        //let rightPart = self.cards & (Bit256Trait::shift_left(1,start_bit)-1);
         
        // 合并左边和右边的部分
       // self.cards  = leftPart | rightPart;
 
        self.cards = Bit256Trait::clean_bit_fast(self.cards,Bit256Trait::shift_left(0xf,n));
     }
}
 