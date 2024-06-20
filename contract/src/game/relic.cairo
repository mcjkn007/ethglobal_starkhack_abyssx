use core::dict::Felt252DictTrait;
 
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::bit::{Bit64Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX,DebuffCard};
use abyss_x::utils::constant::{POW_2_U64};

use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::status::{StatusTrait};
use abyss_x::game::adventurer::{Adventurer,AdventurerCommonTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam2,EnemyTeam3,EnemyCategory};

 

mod RelicCategory{
    const R1: u64 = 0x1;
    const R2: u64 = 0x2;
    const R3: u64 = 0x4;
    const R4: u64 = 0x8;

    const R5: u64 = 0x10;
    const R6: u64 = 0x20;
    const R7: u64 = 0x40;
    const R8: u64 = 0x80;

    const R9: u64 = 0x100;
    const R10: u64 = 0x200;
    const R11: u64 = 0x400;
    const R12: u64 = 0x800;

    const R13: u64 = 0x1000;
    const R14: u64 = 0x2000;
    const R15: u64 = 0x4000;
    const R16: u64 = 0x8000;

    const R17: u64 = 0x10000;
    const R18: u64 = 0x20000;
    const R19: u64 = 0x40000;
    const R20: u64 = 0x80000;

}
 
#[generate_trait]
impl RelicImpl of RelicTrait {
    #[inline]
    fn check_relic_1(ref self:Adventurer){
        //在战斗结束时，回复6点生命。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R1){
            true=> self.attr.add_hp(6),
            false => {}
        }
    }
    #[inline]
    fn check_relic_2(ref self:Adventurer){
        //在每场战斗开始时，额外抽 2 张牌。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R2){
            true => self.draw_cards.add_eq(2),
            false => {}
        }
    }
    #[inline]
    fn check_relic_3(ref self:Adventurer){
        
         
    }
    #[inline]
    fn check_relic_4(ref self:Adventurer){
        //如果你在回合结束时没有任何格挡，获得6点格挡。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R4){
            true=> {
                if(self.attr.armor.is_zero_u16()){
                    self.attr.add_armor(6);
                }
            },
            false => {}
        }
    }
    #[inline]
    fn check_relic_5(ref self:Adventurer){
        //你在回合结束时不再自动丢弃所有手牌。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R5){
            true => {},
            false => self.round_end_disard_cards(),
        }
    }
    #[inline]
    fn check_relic_6(ref self:Adventurer){
        //多余的能量可以留到下一回合。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R6){
            true=>  self.energy.add_eq_u16(self.max_energy),
            false =>  self.energy = self.max_energy
        }
    }
    #[inline]
    fn check_relic_7(ref self:Adventurer){
        //精英敌人在被打败时多掉落一件遗物。
       
    }
    #[inline]
    fn check_relic_8(ref self:Adventurer){
        //可以将卡牌奖励转变为+2最大生命值。
       
    }
    #[inline]
    fn check_relic_9(ref self:Adventurer)->bool{
        //你不会再被虚弱。
        return Bit64Trait::is_bit_fast(self.relic,RelicCategory::R9);
    }
    #[inline]
    fn check_relic_10(ref self:Adventurer)->bool{
        //你不会再被易碎。
        return Bit64Trait::is_bit_fast(self.relic,RelicCategory::R10);
    }
    #[inline]
    fn check_relic_11(ref self:Adventurer)->bool{
        //你不会再被易碎。
        return Bit64Trait::is_bit_fast(self.relic,RelicCategory::R11);
    }
    #[inline]
    fn check_relic_12(ref self:Adventurer){
        //现在你可以在休息处发现遗物。
       
    }
    #[inline]
    fn check_relic_13(ref self:Adventurer,category:EnemyCategory){
        if(category== EnemyCategory::B1){
            //在Boss战与精英战中，你的最大能量+1
            match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R13){
                true => self.add_max_energy(1),
                false => {}
            }
        }
    }
    #[inline]
    fn check_relic_14(ref self:Adventurer){
        //在战斗开始时，将2张伤口放入你的抽牌堆，你的最大能量+1
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R13){
            true => {
                self.init_cards.append(DebuffCard::Wound);
                self.init_cards.append(DebuffCard::Wound);
                self.add_max_energy(1);
            },
            false => {}
        }
    }
}