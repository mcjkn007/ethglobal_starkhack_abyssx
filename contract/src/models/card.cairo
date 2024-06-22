use core::num::traits::zero::Zero;
use core::traits::SubEq;
use core::traits::AddEq;

use core::option::OptionTrait;
use starknet::ContractAddress;
use abyss_x::utils::bit::{Bit256Trait,Bit128Trait,Bit64Trait,Bit32Trait,Bit16Trait};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::utils::constant::{POW_2_U256,POW_2_U128,POW_2_U64};

#[derive(Copy, Drop, Serde,IntrospectPacked)]
#[dojo::model]
struct Card {
    #[key]
    player: ContractAddress,

    slot_1:u64,
    slot_2:u64,
}
#[generate_trait]
impl CardImpl of CardTrait {
    #[inline]
    fn init_cards(ref self:Card){
        self.slot_1 =  0b00000010_00000010_00000010_00000001_00000001_00000001_00000001_00000001;
        self.slot_2 =  0b00000010_00000010;
    }
    #[inline]
    fn reset(ref self:Card){
        self.slot_1 =  0;
        self.slot_2 =  0;
    }
    #[inline]
    fn get_cards(ref self:Card)->Array<u8>{
        let mut result =  ArrayTrait::<u8>::new();
    
        let mut cards:u64 = self.slot_1;
        result.append((cards & 0xf).try_into().unwrap());
        loop{
            if(cards == 0){
                break;
            }
            cards /= POW_2_U64::_8;
            let mut v:u8 = (cards & 0xf).try_into().unwrap();
    
            if(v > 0){
                result.append(v);
            }
        };
        if(self.slot_2 > 0){
            cards = self.slot_2;
            result.append((cards & 0xf).try_into().unwrap());
            loop{
                if(cards == 0){
                    break;
                }
                cards /= POW_2_U64::_8;
                let mut v:u8 = (cards & 0xf).try_into().unwrap();
    
                if(v > 0){
                    result.append(v);
                }
            };
        }
        return result;
    }
    
    #[inline]
    fn get_card(ref self:Card,n:u8)->u8{
        let mut cards:u64 = 0;
        if(n < 8){
            cards = self.slot_1;
        }else{
            cards = self.slot_2;
        }
      
        cards /= Bit64Trait::shift_left(POW_2_U64::_8,8*n);
        return (cards & 0xf).try_into().unwrap();
    }

    #[inline]
    fn add_card(ref self:Card,value:u8){
        let mut i:u8 = 0;
        let mut cards:u64 = self.slot_1;
        loop{
            if(i == 8){
                break;
            }
            if(cards == 0){
                break;
            }
            cards /= POW_2_U64::_8;
            if(cards & 0xf == 0){
                break;
            }
            i.add_eq(1);
        };
        if(i < 8){
            self.slot_1 = self.slot_1 | Bit64Trait::shift_left(value.into(),8*i);
        }else{
            i = 0;
            cards = self.slot_2;
            loop{
                if(i == 8){
                    break;
                }
                if(cards == 0){
                    break;
                }
                cards /= POW_2_U64::_8;
                if(cards & 0xf == 0){
                    break;
                }
                i.add_eq(1);
            };
            assert(i < 8, 'card error');

            self.slot_2 = self.slot_2 | Bit64Trait::shift_left(value.into(),8*i);
        }
       

        
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
        if(n < 8){
            self.slot_1 = Bit64Trait::clean_bit_fast(self.slot_1,Bit64Trait::shift_left(0xf,8*n));
        }else{
            self.slot_2 = Bit64Trait::clean_bit_fast(self.slot_2,Bit64Trait::shift_left(0xf,8*n));
        }
         
     }
}
 