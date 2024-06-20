use abyss_x::utils::math::MathU16Trait;
  
use abyss_x::utils::bit::{Bit16Trait};

use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::status::{StatusTrait};
use abyss_x::game::adventurer::{Adventurer,AdventurerCommonTrait};

mod TalentCategory{
    const T1: u16 = 0x1;
    const T2: u16 = 0x2;
    const T3: u16 = 0x4;
    const T4: u16 = 0x8;

    const T5: u16 = 0x10;
    const T6: u16 = 0x20;
    const T7: u16 = 0x40;
    const T8: u16 = 0x80;

    const T9: u16 = 0x100;
    const T10: u16 = 0x200;
    const T11: u16 = 0x400;
    const T12: u16 = 0x800;

    const T13: u16 = 0x1000;
    const T14: u16 = 0x2000;
    const T15: u16 = 0x4000;
    const T16: u16 = 0x8000;
    
}
 

#[generate_trait]
impl TalentImpl of TalentTrait {
    #[inline]
    fn check_talent_1(ref self:Adventurer,ref value:u16){
        //你的卡牌造成额外50%伤害
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T1){
            true => {
                value = (value/10)*15;
            },
            false => {
                
            }
        }
    }
    #[inline]
    fn check_talent_2(ref self:Adventurer,ref value:u16){
        //你的卡牌提供额外50%护甲
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T2){
            true=> {
                value = (value/10)*15;
            },
            false => {}
        }
    }
    #[inline]
    fn check_talent_3(ref self:Adventurer,ref value:u16){
        //你的能力牌消耗-1
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T3){
            true=> {
                value.self_sub_u16();
            },
            false => {}
        }
    }
    #[inline]
    fn check_talent_4(ref self:Adventurer,ref value:u16){
        //你的卡牌费用最高消耗为2
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T4){
            true=> {
                if(value > 2){
                    value = 2;
                }
            },
            false => {}
        }
    }
    #[inline]
    fn check_talent_5(ref self:Adventurer,ref value:u16){
        //你赋予的debuff层数额外+1
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T4){
            true=> {
                value.self_add_u16();
            },
            false => {}
        }
    }
    #[inline]
    fn check_talent_6(ref self:Adventurer,ref value:u16){
        //你获得的buff层数额外+1
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T4){
            true=> {
                value.self_add_u16();
            },
            false => {}
        }
    }
    #[inline]
    fn check_talent_7(ref self:Adventurer,ref value:u16){
        //你的抽牌效果额外+1
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T4){
            true=> {
                value.self_add_u16();
            },
            false => {}
        }
    }
    #[inline]
    fn check_talent_8(ref self:Adventurer,ref value:u16){
        //你的能量获取额外+1
        match Bit16Trait::is_bit_fast(self.talent,TalentCategory::T4){
            true=> {
                value.self_add_u16();
            },
            false => {}
        }
    }
}
