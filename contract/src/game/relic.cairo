use core::dict::Felt252DictTrait;
 
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::bit::{Bit64Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX,CurseCard};
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
    fn check_relic_1(ref self:Adventurer, value:u16){
        //当你使用卡牌时，消耗能量变为受到伤害. 
         match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R1){
            true=> {
                self.attr.sub_hp_and_armor(value);
            },
            false => {
                self.sub_energy(value);
            }
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
    fn check_relic_3(ref self:Adventurer)->bool{
        //每回合使用的第一张牌不会进入弃牌堆。
        if(Bit64Trait::is_bit_fast(self.relic_flag,RelicCategory::R3)){
            self.relic_flag = Bit64Trait::clean_bit_fast(self.relic_flag,RelicCategory::R3);
            return true;
        }
        return false;
    }
    #[inline]
    fn check_relic_4(ref self:Adventurer){
        //在回合结束时，如果你有护甲，获得6点格挡。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R4){
            true => {
                if(self.attr.armor > 0){
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
    fn check_relic_7(ref self:Adventurer,ref value:u16){
        //对敌人造成伤害时候，额外增加1点伤害
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R7){
            true=>  {
                value.add_eq_u16(1);
            },
            false =>{}
        }
    }
    #[inline]
    fn check_relic_8(ref self:Adventurer){
        //在每回合结束时，回复2点生命。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R8){
            true=>  {
                self.attr.add_hp(2);
            },
            false =>{}
        }
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
    fn check_relic_12(ref self:Adventurer,ref value:u16){
        //你的橙色牌费用减一。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R12){
            true =>{
                value.sub_eq_u16(1);
            },  
            false => {}
        }
    }
    #[inline]
    fn check_relic_13(ref self:Adventurer,ref enemy:Enemy){
        //在每场战斗开始时，所有敌人获得1点伤害加深，你的最大能量+1
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R13){
            true =>{
                enemy.attr.add_ad(2);
                self.add_max_energy(1);
            },  
            false => {}
        }
    }
    #[inline]
    fn check_relic_14(ref self:Adventurer,init:bool){
        //在回合结束时，受到3点伤害，你的最大能量+1
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R13){
            true => {
                match init {
                    true=> {
                        self.add_max_energy(1);
                    },
                    false=> {
                        self.attr.sub_hp_and_armor(3);
                    },
                }
                
            },
            false => {}
        }
    }
    #[inline]
    fn check_relic_15(ref self:Adventurer,init:bool){
        //在每场战斗开始时，最大生命减少10点，战斗结束后恢复，你的最大能量+1
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R15){
            true => {
                match init {
                    true=> {
                        self.attr.sub_hp_max(10);
                        self.add_max_energy(1);
                    },
                    false=> {
                        self.attr.add_hp_max(10);
                    },
                }
                
            },
            false => {}
        }
    }
    #[inline]
    fn check_relic_16(ref self:Adventurer,init:bool){
        //在回合开始时，抽牌数-1。你的最大能量+1
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R16){
            true => {
                match init {
                    true=> {
                        self.add_max_energy(1);
                    },
                    false=> {
                        self.draw_cards.sub_eq_u16(1);
                    },
                }
                
            },
            false => {}
        }
    }
    #[inline]
    fn check_relic_17(ref self:Adventurer)->bool{
        //你使用的牌会进入抽牌堆底。
        return Bit64Trait::is_bit_fast(self.relic,RelicCategory::R17);
    }
    #[inline]
    fn check_relic_18(ref self:Adventurer){
        //你每打出一张攻击牌，本回合获得1点能量，但是会获得一层虚弱。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R20){
            true => {
               self.add_energy(1);
               self.attr.add_weak(1);
            },
            false => {}
        }
    }
    #[inline]
    fn check_relic_19(ref self:Adventurer){
        //你每打出一张技能牌，本回合获得1点能量，但是会获得一层脆弱。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R18){
            true => {
               self.add_energy(1);
               self.attr.add_fear(1);
            },
            false => {}
        }
    }
    #[inline]
    fn check_relic_20(ref self:Adventurer){
        //你每打出一张能力牌，本回合获得1点能量，但是会获得一层易碎。
        match Bit64Trait::is_bit_fast(self.relic,RelicCategory::R19){
            true => {
               self.add_energy(1);
               self.attr.add_fragile(1);
            },
            false => {}
        }
    }
}