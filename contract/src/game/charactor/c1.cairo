use core::traits::AddEq;
use core::dict::Felt252DictTrait;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::array::ArrayTrait;
 
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX,CardResult};
use abyss_x::utils::bit::{Bit32Trait};


use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::attribute::{Attribute,AttributeState,AttributeTrait,CalAttributeTrait};
use abyss_x::game::status::{StatusCategory,StatusTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam2,EnemyTrait};
use abyss_x::game::action::{EntityTrait,ActionTrait,DamageTrait};
use abyss_x::game::talent::{TalentTrait};
use abyss_x::game::relic::{RelicCategory,RelicTrait};

mod C1Ability{
    const Armor_Double:u32 = 1;//双倍护甲
    const Taunt:u32 = 2;//嘲笑
    const Shield_Wall:u32 = 8;//盾墙标记
    const Burn_Bridges:u32 = 16;//你的攻击牌消耗变为0，所有攻击牌被打出时被消耗
}

mod C1Status{
    const S1:felt252 = 'c1s1';//s1 流血
    const S2:felt252 = 'c1s2';//s2 防止卡牌伤害
    const S3:felt252 = 'c1s3';//s3 回合开始获得护甲
    const S4:felt252 = 'c1s4';//s4 直到下回合开始，你最多受到10点伤害，消耗
    const S5:felt252 = 'c1s5';//s5 给予流血时，额外给予 2 层。
    const S6:felt252 = 'c1s6';//s6 从撞击牌中受到的伤害减少3点
    const S7:felt252 = 'c1s7';//s7 你每打出一张攻击牌，给予目标敌人 1 层流血。
    const S8:felt252 = 'c1s8';//s8 触发嗜血效果时，抽1张牌
    const S9:felt252 = 'c1s9';//s9 回合开始时，给予所有敌人1层虚弱和易伤
    const S10:felt252 = 'c1s10';//s10 你的撞击卡牌造成额外3点伤害，你额外受到1点伤害 
    const S11:felt252 = 'c1s11';//回合开始时如果你有护甲，对所有敌人造成6点伤害
    const S12:felt252 = 'c1s12';//回合开始时如果你有护甲，获得1点能量
    const S13:felt252 = 'c1s13';//从撞击牌受到伤害时，获得1点能量
}
impl C1DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16){
        self.status.cal_damage_status(ref value);
    }
    fn damage_taken(ref self:Attribute,ref target:Attribute, mut value:u16){
        if(Bit32Trait::is_bit_fast(self.ability,C1Ability::Shield_Wall)){
            let mut s4 = self.status.get(C1Status::S4);
            if(s4 > 0){
                //盾墙
                match core::integer::u16_checked_sub(s4,value){
                    Option::Some(r) => {
                        self.status.insert(C1Status::S4,r);
                    },
                    Option::None => {
                        self.status.insert(C1Status::S4,0);
                        value = 0;
                    },
                };
            }else{
                value = 0;
            }
        }
        
        if(self.sub_hp_and_armor(value)){
            self.check_taunt_ability();
        }

        self.status.cal_damaged_status(ref value);
        let thorns = self.status.get(StatusCategory::Thorns);
        if(thorns > 0){
            target.sub_hp_and_armor(thorns);
        }
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn direct_damage_taken(ref self:Attribute,mut value:u16){

        if(Bit32Trait::is_bit_fast(self.ability,C1Ability::Shield_Wall)){
            let mut s4 = self.status.get(C1Status::S4);
            if(s4 > 0){
                //盾墙
                match core::integer::u16_checked_sub(s4,value){
                    Option::Some(r) => {
                        self.status.insert(C1Status::S4,r);
                    },
                    Option::None => {
                        self.status.insert(C1Status::S4,0);
                        value = 0;
                    },
                };
            }else{
                value = 0;
            }
        }

        if(self.sub_hp_and_armor(value)){
            self.check_taunt_ability();
        }
    }
}

#[generate_trait]
impl C1StatusImpl of C1StatusTrait {
    #[inline]
    fn check_s1(ref self:Adventurer,ref target:Attribute,consume:bool)->u16{
        //流血
        let s1 = target.status.get(C1Status::S1);
        if(s1 > 0){
            target.sub_hp_and_armor(s1); 
            self.check_s8();
            if(consume){
                target.status.insert(C1Status::S1,0);
                return s1;
            } 
        }
        return 0;
    }
    #[inline]
    fn check_s1_double(ref self:Adventurer,ref target:Attribute,consume:bool)->u16{
        //流血
        let s1 = target.status.get(C1Status::S1)*2;
        if(s1 > 0){
            target.sub_hp_and_armor(s1); 
            self.check_s8();
            if(consume){
                target.status.insert(C1Status::S1,0);
                return s1;
            } 
        }
        return 0;
    }
    #[inline]
    fn add_bleed(ref self:Attribute,value:u16){
        let mut s5:u16 = self.status.get(C1Status::S5);
        s5.add_eq_u16(value); 
        self.status.insert(C1Status::S1,MathU16Trait::add_u16(self.status.get(C1Status::S1),s5)); 
    }
    #[inline]
    fn check_s7(ref self:Attribute,ref target:Attribute){
        //你每打出一张攻击牌，给予目标敌人 1 层流血。
        let s7:u16 = self.status.get(C1Status::S7);
        if(s7 > 0){
            target.add_bleed(s7);
        } 
    }
    #[inline]
    fn check_s8(ref self:Adventurer){
        //嗜血时，抽1张牌。
        let s8:u16 = self.attr.status.get(C1Status::S8);
        if(s8 > 0){
            self.draw_cards_from_left(s8);
        }
    }
    #[inline]
    fn add_s10_damage(ref self:Attribute,ref value:u16){
        let s10:u16 = self.status.get(C1Status::S10);
        if(s10 > 0){
            value.add_eq_u16(s10*3);
        }
    }
    #[inline]
    fn damage_by_card(ref self:Adventurer,mut value:u16){
        let s2 = self.attr.status.get(C1Status::S2);
        if(s2 > 0){
            self.attr.status.insert(C1Status::S2,MathU16Trait::sub_u16(self.attr.status.get(C1Status::S2),1)); 
        }else{
            let s10 = self.attr.status.get(C1Status::S10);
            //add
            if(s10 > 0){
                value.add_eq_u16(s10);
            }
            let s6 = self.attr.status.get(C1Status::S6);
            //sub
            if(s6 > 0){
                value.sub_eq_u16(s6);
            }
            //受到伤害
            let s13 = self.attr.status.get(C1Status::S13);
            if(s13 > 0 && value > 0){
                self.energy.add_eq_u16(s13);
                 
            }
            if(self.attr.sub_hp_and_armor(value)){
                self.attr.check_taunt_ability();
            }
        }
    }
    #[inline]
    fn c1_add_armor(ref self:Attribute,value:u16){
        let mut v = value;
        if(Bit32Trait::is_bit_fast(self.ability,C1Ability::Armor_Double)){
            v.add_eq_u16(value);
        }
        self.status.cal_armor_status(ref v);
        self.add_armor(v);
    }
    #[inline]
    fn check_taunt_ability(ref self:Attribute){
        if(Bit32Trait::is_bit_fast(self.ability,C1Ability::Taunt)){
            Bit32Trait::clean_bit_fast(self.ability,C1Ability::Taunt);
        } 
    }
    #[inline]
    fn check_burn_bridges_ability(ref self:Adventurer,card_result:CardResult)->CardResult{
        if(Bit32Trait::is_bit_fast(self.attr.ability,C1Ability::Burn_Bridges)){
            return CardResult::Consume;
        } 
        return card_result;
    }
    #[inline]
    fn check_shield_wall_ability(ref self:Attribute){
        if(Bit32Trait::is_bit_fast(self.ability,C1Ability::Shield_Wall)){
            self.remove_ability(C1Ability::Shield_Wall);
            self.status.insert(C1Status::S4,0);
        } 
    }
    
}

impl C1EntityImpl of EntityTrait<Adventurer> {
    #[inline]
    fn new()->Adventurer{
        return Adventurer{
            seed:0,
            attr:AttributeTrait::new(80),
            category:1,

            energy:3,
            max_energy:3,
        
            draw_cards:5,
            talent:0,
            blessing:0,
            relic:0,
            relic_flag:0,

            init_cards:ArrayTrait::<u8>::new(),
            left_cards:ArrayTrait::<u8>::new(),
            mid_cards:DictMapTrait::<u8>::new(),
            right_cards:ArrayTrait::<u8>::new()
        };
    }
}
 
impl C1Action1Impl of ActionTrait<Adventurer,Enemy>{
    #[inline]
    fn game_begin(ref self:Adventurer,ref target:Enemy){
       
    }
    #[inline]
    fn game_end(ref self:Adventurer,ref target:Enemy){
       
    }

    fn round_begin(ref self:Adventurer,ref target:Enemy)
    {
        if(Bit32Trait::is_bit_fast(self.attr.ability,C1Ability::Taunt)){
            
        }else{
            self.attr.armor = 0_u16;
        }
        
        let s3:u16 = self.attr.status.get(C1Status::S3);//回合开始获得护甲
        if(s3 > 0){
            self.attr.c1_add_armor(s3);
            self.attr.status.insert(C1Status::S3,0);
        }

        self.attr.check_shield_wall_ability();//直到下回合开始，你最多受到10点伤害

        let s9 = self.attr.status.get(C1Status::S9);//回合开始时，给予所有敌人1层虚弱和易伤
        if(s9 > 0){
            target.attr.add_weak(1);
            target.attr.add_fragile(1);
        }
        if(self.attr.armor > 0){
            let s11 = self.attr.status.get(C1Status::S11);//回合开始时如果你有护甲，对所有敌人造成6点伤害
            if(s11 > 0)
            {
                target.e_direct_damage_taken(s11);
            }
            let s12 = self.attr.status.get(C1Status::S12);//回合开始时如果你有护甲，获得1点能量
            if(s12 > 0)
            {
               self.energy.add_eq_u16(s12);
            }
        }
         
    }

    fn round_end(ref self:Adventurer,ref target:Enemy){
        
    }

    fn action_feedback(ref self:Adventurer,ref target:Enemy,data:u16){

    }
    fn action(ref self:Adventurer,ref target:Enemy,data:u16){
        let card_index = (data/256_u16).try_into().unwrap();
       // println!("card_index   {}",card_index);
        assert(self.mid_cards.check_value(card_index), 'card void');

        let card_id = *self.init_cards.at(card_index.into());
        let card_category = C1CardImpl::get_card_category(card_id);
         

        let result = match card_id {
            0 => panic!("error"),
            1 => self.c1(ref target),
            2 => self.c2(),
            3 => self.c3(ref target),
            4 => self.c4(ref target),
            5 => self.c5(),
            6 => self.c6(ref target),
            7 => self.c7(),
            8 => self.c8(ref target),
            9 => self.c9(),
            10 => self.c10(),
            11 => self.c11(ref target),
            12 => self.c12(ref target),
            13 => self.c13(ref target),
            14 => self.c14(ref target),
            15 => self.c15(ref target),
            16 => self.c16(ref target),
            17 => self.c17(ref target),
            18 => self.c18(ref target),
            19 => self.c19(ref target),
            20 => self.c20(ref target),
            21 => self.c21(),
            22 => self.c22(),
            23 => self.c23(),
            24 => self.c24(ref target),
            25 => self.c25(ref target),
            26 => self.c26(ref target),
            27 => self.c27(ref target),
            28 => self.c28(ref target),
            29 => self.c29(ref target),
            30 => self.c30(ref target),
            31 => self.c31(ref target),
            32 => self.c32(ref target),
            33 => self.c33(ref target),
            34 => self.c34(ref target),
            35 => self.c35(),
            36 => self.c36(),
            37 => self.c37(),
            38 => self.c38(ref target),
            39 => self.c39(ref target),
            40 => self.c40(ref target),
            41 => self.c41(ref target),
            42 => self.c42(),
            43 => self.c43(),
            44 => self.c44(),
            45 => self.c45(),
            46 => self.c46(),
            47 => self.c47(),
            48 => self.c48(),
            49 => self.c49(),
            50 => self.c50(),
            51 => self.c51(),
            _=> panic!("error"),
        };
        target.e_action_feedback(ref self,card_category);

        match result {
            CardResult::Null =>{},
            CardResult::Consume => self.consume_card(card_index),
            CardResult::Discard => self.discard_card(card_index),
        }

        match card_category {
            0 =>{},
            1 =>self.check_relic_18(),
            2 =>self.check_relic_19(),
            3 =>self.check_relic_20(),
            _ =>{},
        }
        let mut energy = C1CardImpl::get_card_energy(card_id);
        if(C1CardImpl::get_card_rarity(card_id) == 3){
            //你的橙色牌费用减一。
            self.check_relic_12(ref energy);
        }
         
        //当你使用卡牌时，消耗能量变为受到伤害
        self.check_relic_1(energy);
    }
}

impl C1Action2Impl of ActionTrait<Adventurer,EnemyTeam2>{
    #[inline]
    fn game_begin(ref self:Adventurer,ref target:EnemyTeam2){
       
    }
    #[inline]
    fn game_end(ref self:Adventurer,ref target:EnemyTeam2){
       
    }

    fn round_begin(ref self:Adventurer,ref target:EnemyTeam2)
    {
        if(Bit32Trait::is_bit_fast(self.attr.ability,C1Ability::Taunt)){
            
        }else{
            self.attr.armor = 0_u16;
        }
        
        let s3:u16 = self.attr.status.get(C1Status::S3);//回合开始获得护甲
        if(s3 > 0){
            self.attr.c1_add_armor(s3);
            self.attr.status.insert(C1Status::S3,0);
        }

        self.attr.check_shield_wall_ability();//直到下回合开始，你最多受到10点伤害

        let s9 = self.attr.status.get(C1Status::S9);//回合开始时，给予所有敌人1层虚弱和易伤
        if(s9 > 0){
            if(target.e1.attr.state == AttributeState::Live){
                target.e1.attr.add_weak(1);
                target.e1.attr.add_fragile(1);
            }
            if(target.e2.attr.state == AttributeState::Live){
                target.e2.attr.add_weak(1);
                target.e2.attr.add_fragile(1);
            }
        }
        if(self.attr.armor > 0){
            let s11 = self.attr.status.get(C1Status::S11);//回合开始时如果你有护甲，对所有敌人造成6点伤害
            if(s11 > 0)
            {
                if(target.e1.attr.state == AttributeState::Live){
                    target.e1.e_direct_damage_taken(s11);
                }
                if(target.e2.attr.state == AttributeState::Live){
                    target.e2.e_direct_damage_taken(s11);
                }
            }
            let s12 = self.attr.status.get(C1Status::S12);//回合开始时如果你有护甲，获得1点能量
            if(s12 > 0)
            {
               self.energy.add_eq_u16(s12);
            }
        }
         
    }

    fn round_end(ref self:Adventurer,ref target:EnemyTeam2){
        
    }

    fn action_feedback(ref self:Adventurer,ref target:EnemyTeam2,data:u16){

    }
    fn action(ref self:Adventurer,ref target:EnemyTeam2,data:u16){
        let card_index = (data/256_u16).try_into().unwrap();
       // println!("card_index   {}",card_index);
        assert(self.mid_cards.check_value(card_index), 'card void');

        let card_id = *self.init_cards.at(card_index.into());
        let card_category = C1CardImpl::get_card_category(card_id);

        let mut result = CardResult::Null;

        if(card_id == 14){
            result = self.c14_2(ref target)
        }else if(card_id == 28){
            result = self.c28_2(ref target)
        }else if(card_id == 38){
            result = self.c38_2(ref target)
        }else{
            if(data%256 == 0){
                result = match card_id {
                    0 => panic!("error"),
                    1 => self.c1(ref target.e1),
                    2 => self.c2(),
                    3 => self.c3(ref target.e1),
                    4 => self.c4(ref target.e1),
                    5 => self.c5(),
                    6 => self.c6(ref target.e1),
                    7 => self.c7(),
                    8 => self.c8(ref target.e1),
                    9 => self.c9(),
                    10 => self.c10(),
                    11 => self.c11(ref target.e1),
                    12 => self.c12(ref target.e1),
                    13 => self.c13(ref target.e1),
                    14 => panic!("error"),
                    15 => self.c15(ref target.e1),
                    16 => self.c16(ref target.e1),
                    17 => self.c17(ref target.e1),
                    18 => self.c18(ref target.e1),
                    19 => self.c19(ref target.e1),
                    20 => self.c20(ref target.e1),
                    21 => self.c21(),
                    22 => self.c22(),
                    23 => self.c23(),
                    24 => self.c24(ref target.e1),
                    25 => self.c25(ref target.e1),
                    26 => self.c26(ref target.e1),
                    27 => self.c27(ref target.e1),
                    28 => panic!("error"),
                    29 => self.c29(ref target.e1),
                    30 => self.c30(ref target.e1),
                    31 => self.c31(ref target.e1),
                    32 => self.c32(ref target.e1),
                    33 => self.c33(ref target.e1),
                    34 => self.c34(ref target.e1),
                    35 => self.c35(),
                    36 => self.c36(),
                    37 => self.c37(),
                    38 => panic!("error"),
                    39 => self.c39(ref target.e1),
                    40 => self.c40(ref target.e1),
                    41 => self.c41(ref target.e1),
                    42 => self.c42(),
                    43 => self.c43(),
                    44 => self.c44(),
                    45 => self.c45(),
                    46 => self.c46(),
                    47 => self.c47(),
                    48 => self.c48(),
                    49 => self.c49(),
                    50 => self.c50(),
                    51 => self.c51(),
                    _=> panic!("error"),
                };
                target.e1.e_action_feedback(ref self,card_category);
            }
            else {
                result = match card_id {
                    0 => panic!("error"),
                    1 => self.c1(ref target.e2),
                    2 => self.c2(),
                    3 => self.c3(ref target.e2),
                    4 => self.c4(ref target.e2),
                    5 => self.c5(),
                    6 => self.c6(ref target.e2),
                    7 => self.c7(),
                    8 => self.c8(ref target.e2),
                    9 => self.c9(),
                    10 => self.c10(),
                    11 => self.c11(ref target.e2),
                    12 => self.c12(ref target.e2),
                    13 => self.c13(ref target.e2),
                    14 => panic!("error"),
                    15 => self.c15(ref target.e2),
                    16 => self.c16(ref target.e2),
                    17 => self.c17(ref target.e2),
                    18 => self.c18(ref target.e2),
                    19 => self.c19(ref target.e2),
                    20 => self.c20(ref target.e2),
                    21 => self.c21(),
                    22 => self.c22(),
                    23 => self.c23(),
                    24 => self.c24(ref target.e2),
                    25 => self.c25(ref target.e2),
                    26 => self.c26(ref target.e2),
                    27 => self.c27(ref target.e2),
                    28 => panic!("error"),
                    29 => self.c29(ref target.e2),
                    30 => self.c30(ref target.e2),
                    31 => self.c31(ref target.e2),
                    32 => self.c32(ref target.e2),
                    33 => self.c33(ref target.e2),
                    34 => self.c34(ref target.e2),
                    35 => self.c35(),
                    36 => self.c36(),
                    37 => self.c37(),
                    38 => panic!("error"),
                    39 => self.c39(ref target.e2),
                    40 => self.c40(ref target.e2),
                    41 => self.c41(ref target.e2),
                    42 => self.c42(),
                    43 => self.c43(),
                    44 => self.c44(),
                    45 => self.c45(),
                    46 => self.c46(),
                    47 => self.c47(),
                    48 => self.c48(),
                    49 => self.c49(),
                    50 => self.c50(),
                    51 => self.c51(),
                    _=> panic!("error"),
                };
                target.e1.e_action_feedback(ref self,card_category);
            } 
        }
 
        match result {
            CardResult::Null =>{},
            CardResult::Consume => self.consume_card(card_index),
            CardResult::Discard => self.discard_card(card_index),
        }

        match card_category {
            0 =>{},
            1 =>self.check_relic_18(),
            2 =>self.check_relic_19(),
            3 =>self.check_relic_20(),
            _ =>{},
        }

        let mut energy = C1CardImpl::get_card_energy(card_id);
        if(C1CardImpl::get_card_rarity(card_id) == 3){
            //你的橙色牌费用减一。
            self.check_relic_12(ref energy);
        }
    }
}

#[generate_trait]
impl C1CardImpl of C1CardTrait{
    #[inline]
    fn get_card_energy(card_id: u8) -> u16{
        return match card_id {
            0 => 1,
            1 => 1,
            2 => 1,
            3 => 1,
            4 => 1,
            5 => 1,
            6 => 1,
            7 => 1,
            8 => 1,
            9 => 1,
            10 => 1,
            11 => 1,
            12 => 1,
            13 => 1,
            14 => 1,
            15 => 1,
            16 => 1,
            17 => 1,
            18 => 1,
            19 => 1,
            20 => 1,
            21 => 1,
            22 => 1,
            23 => 1,
            24 => 1,
            25 => 1,
            26 => 1,
            27 => 1,
            28 => 1,
            29 => 1,
            30 => 1,
            31 => 1,
            32 => 1,
            33 => 1,
            34 => 1,
            35 => 1,
            36 => 1,
            37 => 1,
            38 => 1,
            39 => 1,
            40 => 1,
            41 => 1,
            42 => 1,
            43 => 1,
            44 => 1,
            45 => 1,
            46 => 1,
            47 => 1,
            48 => 1,
            49 => 1,
            50 => 1,
            51 => 1,
            _ => 1,
        };
    }
    fn get_card_category(card_id: u8) -> u16{
        return match card_id {
            0 => 0,
            1 => 1,
            2 => 2,
            3 => 1,
            4 => 1,
            5 => 2,
            6 => 2,
            7 => 2,
            8 => 2,
            9 => 3,
            10 => 3,
            11 => 1,
            12 => 1,
            13 => 1,
            14 => 1,
            15 => 1,
            16 => 1,
            17 => 1,
            18 => 1,
            19 => 2,
            20 => 2,
            21 => 3,
            22 => 3,
            23 => 3,
            24 => 1,
            25 => 1,
            26 => 1,
            27 => 1,
            28 => 1,
            29 => 1,
            30 => 1,
            31 => 2,
            32 => 2,
            33 => 2,
            34 => 2,
            35 => 3,
            36 => 3,
            37 => 3,
            38 => 1,
            39 => 1,
            40 => 1,
            41 => 1,
            42 => 2,
            43 => 2,
            44 => 2,
            45 => 2,
            46 => 2,
            47 => 2,
            48 => 3,
            49 => 3,
            50 => 3,
            51 => 3,
            _ => 1,
        };
    }
    fn get_card_rarity(card_id: u8) -> u16{
        return match card_id {
            0 => 0,
            1 => 1,
            2 => 1,
            3 => 3,
            4 => 1,
            5 => 2,
            6 => 3,
            7 => 1,
            8 => 1,
            9 => 3,
            10 => 2,
            11 => 1,
            12 => 1,
            13 => 2,
            14 => 1,
            15 => 1,
            16 => 2,
            17 => 2,
            18 => 2,
            19 => 2,
            20 => 1,
            21 => 2,
            22 => 3,
            23 => 3,
            24 => 3,
            25 => 1,
            26 => 1,
            27 => 2,
            28 => 2,
            29 => 3,
            30 => 2,
            31 => 1,
            32 => 3,
            33 => 3,
            34 => 1,
            35 => 1,
            36 => 3,
            37 => 2,
            38 => 2,
            39 => 1,
            40 => 2,
            41 => 1,
            42 => 1,
            43 => 2,
            44 => 2,
            45 => 3,
            46 => 2,
            47 => 3,
            48 => 2,
            49 => 3,
            50 => 2,
            51 => 3,
            _ => 1,
        };
    }
    fn c1(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成 6 点伤害。
        let mut value:u16 = 6;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    #[inline]
    fn c2(ref self:Adventurer)->CardResult{
        //获得 5 点护甲。
        let mut value:u16 = 5;
        self.check_talent_2(ref value);
        self.attr.c1_add_armor(value);

        return CardResult::Discard;
    }
    
    fn c3(ref self:Adventurer,ref target:Enemy)->CardResult{
        //如果目标敌人的生命值小于等于 30 点，则将其生命值变为 0。
        if(target.attr.hp < 31){
            target.attr.hp = 0_u16;
        }

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c4(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成9点伤害，抽1牌

        let mut value:u16 = 9;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.draw_cards_from_left(1);

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
         
    }
    fn c5(ref self:Adventurer)->CardResult{
        //抽一张牌，获得卡牌能耗的能量
        self.draw_cards_from_left(1);
      
        self.energy.add_eq_u16(C1CardTrait::get_card_energy(self.mid_cards.at(self.mid_cards.size()-1)));

        return CardResult::Discard;
    }
    fn c6(ref self:Adventurer,ref target:Enemy)->CardResult{
        //去除目标的护甲
        target.attr.armor = 0;

        return CardResult::Discard;
    }
    fn c7(ref self:Adventurer)->CardResult{
        //抽3张牌，消耗
        self.draw_cards_from_left(3);

        return CardResult::Consume;
    }
    fn c8(ref self:Adventurer,ref target:Enemy)->CardResult{
        //给予2层易伤
        target.attr.add_fragile(2);

        return CardResult::Discard;
    }
    fn c9(ref self:Adventurer)->CardResult{
        //回合开始时，给予所有敌人1层虚弱和易伤
        self.attr.status.insert(C1Status::S9,MathU16Trait::add_u16(self.attr.status.get(C1Status::S9),1));

        return CardResult::Consume;
    }
    fn c10(ref self:Adventurer)->CardResult{
        //你的攻击牌消耗变为0，所有攻击牌被打出时被消耗
        self.attr.status.insert(C1Status::S10,1);

        return CardResult::Consume;
    }
    fn c11(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成 15 点伤害。受到 3 点伤害。
        let mut value:u16 = 15;
        self.check_talent_1(ref value);
        self.attr.add_s10_damage(ref value);

        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.damage_by_card(3_u16);

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c12(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成 12 点伤害。受到 3 点伤害。抽 1 张牌。
        let mut value:u16 = 12;
        self.check_talent_1(ref value);
        self.attr.add_s10_damage(ref value);

        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.damage_by_card(3_u16);
        self.draw_cards_from_left(1);

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c13(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成12点伤害，受到3点伤害，执行x次。
        let mut value:u16 = 12;
        self.check_talent_1(ref value);
        self.attr.add_s10_damage(ref value);

        self.c_calculate_damage_dealt(ref value);
        let mut i = 0;
        let mut size = self.energy;
        loop{
            if(i == size){
                break;
            }

            target.e_damage_taken(ref self.attr,value);
         
            self.damage_by_card(3_u16);

            self.check_s1(ref target.attr,true);

            i.self_add_u16();
        };
 
    
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c14(ref self:Adventurer,ref target:Enemy)->CardResult{
        //对所有敌人造成3点伤害，免疫下次撞击牌伤害
        let mut value:u16 = 3;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.attr.status.insert(C1Status::S2,MathU16Trait::add_u16(self.attr.status.get(C1Status::S2),1));

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c14_2(ref self:Adventurer,ref target:EnemyTeam2)->CardResult{
        //对所有敌人造成3点伤害，免疫下次撞击牌伤害
        let mut value:u16 = 3;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        if(target.e1.attr.state == AttributeState::Live){
            target.e1.e_damage_taken(ref self.attr,value);
            self.check_s1(ref target.e1.attr,true);
            self.attr.check_s7(ref target.e1.attr);
        }
        if(target.e2.attr.state == AttributeState::Live){
            target.e2.e_damage_taken(ref self.attr,value);
            self.check_s1(ref target.e2.attr,true);
            self.attr.check_s7(ref target.e2.attr);
        }

        self.attr.status.insert(C1Status::S2,MathU16Trait::add_u16(self.attr.status.get(C1Status::S2),1));

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c15(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成15点伤害，免疫下1次撞击牌伤害
        let mut value:u16 = 15;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.attr.status.insert(C1Status::S2,MathU16Trait::add_u16(self.attr.status.get(C1Status::S2),1));

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c16(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成 12 点伤害。受到 3 点伤害。嗜血：不受到伤害。
        let mut value:u16 =12;
        self.check_talent_1(ref value);
        self.attr.add_s10_damage(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        match self.check_s1(ref target.attr,true){
            0 => self.damage_by_card(3_u16),
            _=> {},
        }
        
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }

    fn c17(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成 12 点伤害。受到 3 点伤害。嗜血：给予 1 层易伤。
        let mut value:u16 = 12;
        self.check_talent_1(ref value);
        self.attr.add_s10_damage(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.damage_by_card(3_u16);

        match self.check_s1(ref target.attr,true) {
            0=> {},
            _=> target.attr.add_fragile(1),
        }
        self.attr.check_s7(ref target.attr);

         return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c18(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成18点伤害，受到3点伤害，本次消耗的流血伤害翻倍
        let mut value:u16 = 18;
        self.check_talent_1(ref value);
        self.attr.add_s10_damage(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.damage_by_card(3);

        self.check_s1_double(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c19(ref self:Adventurer,ref target:Enemy)->CardResult{
        //受到3点伤害，获得2点能量
        self.c_direct_damage_taken(3);
        self.energy.add_eq_u16(2);

        return CardResult::Discard;
    }
    fn c20(ref self:Adventurer,ref target:Enemy)->CardResult{
        //受到3点伤害，抽2张牌
        self.c_direct_damage_taken(3);
        self.draw_cards_from_left(2);

        return CardResult::Discard;
    }
    fn c21(ref self:Adventurer)->CardResult{
        //你的撞击卡牌造成额外3点伤害，你额外受到1点伤害
        self.attr.status.insert(C1Status::S10,MathU16Trait::add_u16(self.attr.status.get(C1Status::S10),1)); 
        return CardResult::Consume;
    }
    fn c22(ref self:Adventurer)->CardResult{
        //从撞击牌受到伤害时，获得1点能量
        self.attr.status.insert(C1Status::S13,MathU16Trait::add_u16(self.attr.status.get(C1Status::S13),3)); 

        return CardResult::Consume;
    }
    fn c23(ref self:Adventurer)->CardResult{
        //从撞击牌中受到的伤害减少3点
        self.attr.status.insert(C1Status::S6,MathU16Trait::add_u16(self.attr.status.get(C1Status::S6),3)); 

        return CardResult::Consume;
    }
    fn c24(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成9点伤害，嗜血：回复6点生命，消耗
        let mut value:u16 = 9;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        match self.check_s1(ref target.attr,true) {
            0=> {},
            _=> self.attr.add_hp(6),
        }
        self.attr.check_s7(ref target.attr);

        return CardResult::Consume;
    }
    fn c25(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成 5 点伤害。获得 5 点护甲。嗜血：效果翻倍。
        let mut damage:u16 = 5;
        self.check_talent_1(ref damage);
        let mut armor:u16 = 5;
        self.check_talent_2(ref armor);
        match self.check_s1(ref target.attr,true)  {
            0=> {},
            _=> {
                damage.add_eq_u16(5);
                armor.add_eq_u16(5);
            },
        }

        self.c_calculate_damage_dealt(ref damage);
        target.e_damage_taken(ref self.attr,damage);
        self.attr.c1_add_armor(armor);

        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c26(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成9点伤害，嗜血：抽2张牌
        let mut value:u16 = 9;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        match self.check_s1(ref target.attr,true)  {
            0=> {},
            _=> {
                self.draw_cards_from_left(2);
            },
        }
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c27(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成12点伤害，嗜血：不消耗能量。
        let mut value:u16 = 12;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        match self.check_s1(ref target.attr,true) {
            0=> {},
            _=> self.energy.add_eq_u16(2),
        }
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    
    fn c28(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成4点伤害，给予所有敌人8层流血
        let mut value:u16 = 4;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        target.attr.add_bleed(8);
 
        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c28_2(ref self:Adventurer,ref target:EnemyTeam2)->CardResult{
        //造成4点伤害，给予所有敌人8层流血
        let mut value:u16 = 4;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        if(target.e1.attr.state == AttributeState::Live){
            target.e1.e_damage_taken(ref self.attr,value);
            self.check_s1(ref target.e1.attr,true);
            self.attr.check_s7(ref target.e1.attr);
            target.e1.attr.add_bleed(8);
        }

        if(target.e2.attr.state == AttributeState::Live){
            target.e2.e_damage_taken(ref self.attr,value);
            self.check_s1(ref target.e2.attr,true);
            self.attr.check_s7(ref target.e2.attr);
            target.e2.attr.add_bleed(8);
        }

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c29(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成 9 点伤害，不移除流血。
        let mut value:u16 = 9;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.check_s1(ref target.attr,false);
        self.attr.check_s7(ref target.attr); 

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c30(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成6点伤害，嗜血：获得目标流血层数的护甲
        let mut value:u16 = 6_u16;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        let  consume = self.check_s1(ref target.attr,true);
        if(consume > 0){
            self.attr.c1_add_armor(consume);
        }
        self.attr.check_s7(ref target.attr);
 
        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c31(ref self:Adventurer,ref target:Enemy)->CardResult{
        //给予 8 层流血。
        target.attr.add_bleed(8);

        return CardResult::Discard;
    }
    fn c32(ref self:Adventurer,ref target:Enemy)->CardResult{
        //消耗目标身上的流血层数，获得等量的护甲。消耗
        let s1 = target.attr.status.get(C1Status::S1);
        if(s1 > 0){
            target.attr.status.insert(C1Status::S1,0);
            self.attr.c1_add_armor(s1);
        }
 
        return CardResult::Consume;
    }
 
    fn c33(ref self:Adventurer,ref target:Enemy)->CardResult{
        //触发流血伤害，消耗
        self.check_s1(ref target.attr,true);
        return CardResult::Consume;
    }
    fn c34(ref self:Adventurer,ref target:Enemy)->CardResult{
        //给予1层易伤，4层流血
        target.attr.add_fragile(1);
        target.attr.add_bleed(4);

        return CardResult::Discard;
    }
    fn c35(ref self:Adventurer)->CardResult{
        //给予流血时，额外给予 2 层。
        self.attr.status.insert(C1Status::S5,MathU16Trait::add_u16(self.attr.status.get(C1Status::S5),2)); 
        return CardResult::Consume;
    }
    #[inline]
    fn c36(ref self:Adventurer)->CardResult{
        //触发嗜血效果时，抽1张牌
        self.attr.status.insert(C1Status::S8,MathU16Trait::add_u16(self.attr.status.get(C1Status::S8),1)); 
        return CardResult::Consume;
    }
    fn c37(ref self:Adventurer)->CardResult{
        //你每打出一张攻击牌，给予目标敌人 1 层流血。
        self.attr.status.insert(C1Status::S7,MathU16Trait::add_u16(self.attr.status.get(C1Status::S7),1)); 
        return CardResult::Consume;
    }
    fn c38(ref self:Adventurer,ref target:Enemy)->CardResult{
        //对所有目标造成护甲值的伤害。消耗所有护甲。
        let mut value:u16 = self.attr.armor;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.attr.armor = 0_u16;

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);
        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c38_2(ref self:Adventurer,ref target:EnemyTeam2)->CardResult{
        let mut value:u16 = self.attr.armor;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        if(target.e1.attr.state == AttributeState::Live){
            target.e1.e_damage_taken(ref self.attr,value);
            self.check_s1(ref target.e1.attr,true);
            self.attr.check_s7(ref target.e1.attr);
        }
        if(target.e2.attr.state == AttributeState::Live){
            target.e2.e_damage_taken(ref self.attr,value);
            self.check_s1(ref target.e2.attr,true);
            self.attr.check_s7(ref target.e2.attr);
        }

        self.attr.armor = 0_u16;

        
        return self.check_burn_bridges_ability(CardResult::Discard);

        
    }
    fn c39(ref self:Adventurer,ref target:Enemy)->CardResult{
        //对一个目标造成6点伤害。如果你有护甲，造成额外6点伤害。
        let mut value:u16 = 6;
        if(self.attr.armor > 0){
            value.add_eq_u16(6);
        }
        self.check_talent_1(ref value);

        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);
 
        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c40(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成18点伤害，如果目标有护甲，造成额外6点伤害。
        let mut value:u16 = 6;
       
        if(target.attr.armor > 0){
            value.add_eq_u16(6);
        }
        self.check_talent_1(ref value);

        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);
 
        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    fn c41(ref self:Adventurer,ref target:Enemy)->CardResult{
        //造成6点伤害，如果你有护甲，给予1层虚弱
        let mut value:u16 = 6;
        self.check_talent_1(ref value);
        self.c_calculate_damage_dealt(ref value);
        target.e_damage_taken(ref self.attr,value);

        if(self.attr.armor > 0){
            target.attr.add_weak(1);
        }

        self.check_s1(ref target.attr,true);
        self.attr.check_s7(ref target.attr);

        return self.check_burn_bridges_ability(CardResult::Discard);
    }
    #[inline]
    fn c42(ref self:Adventurer)->CardResult{
        //获得8点护甲，抽1张牌
        let mut value:u16  = 8;
        self.check_talent_2(ref value);
        self.attr.c1_add_armor(value);
        self.draw_cards_from_left(1);

        return CardResult::Discard;
    }
    #[inline]
    fn c43(ref self:Adventurer)->CardResult{
        //如果你有护甲，获得2点能量
        if(self.attr.armor > 0){
            self.energy.add_eq_u16(2);
        }

        return CardResult::Discard;
    }
    #[inline]
    fn c44(ref self:Adventurer)->CardResult{
        //抽2张牌，获得所抽卡费用的护甲
        self.draw_cards_from_left(2);
        let mut value:u16 = C1CardTrait::get_card_energy(self.mid_cards.at(self.mid_cards.size()-1));
        value.add_eq_u16(C1CardTrait::get_card_energy(self.mid_cards.at(self.mid_cards.size()-2)));
        self.check_talent_2(ref value);

        self.attr.c1_add_armor(value);

        return CardResult::Discard;
    }
    #[inline]
    fn c45(ref self:Adventurer)->CardResult{
        //消耗你所有手牌，每张被消耗的卡牌获得8点护甲，消耗
        let mut value:u16 = 0;
        loop{
            if(self.mid_cards.empty()){
                self.mid_cards.clean_value_dict();
                break;
            }
            value.self_add_u16();
            self.mid_cards.pop_back_fast();
        };
        self.check_talent_2(ref value);
        self.attr.c1_add_armor(value);
        return CardResult::Null;
    }
    #[inline]
    fn c46(ref self:Adventurer)->CardResult{
        //获得 6 点护甲。下回合开始时获得 6 点护甲。
        let mut value:u16 = 6;
        self.check_talent_2(ref value);
        self.attr.c1_add_armor(value);

        self.attr.status.insert(C1Status::S3,MathU16Trait::add_u16(self.attr.status.get(C1Status::S3),value)); 
        return CardResult::Discard;
    }
    #[inline]
    fn c47(ref self:Adventurer)->CardResult{
        //直到下回合开始，你最多受到 10 点伤害。消耗
        self.attr.add_ability(C1Ability::Shield_Wall);
        self.attr.status.insert(C1Status::S4,10); 
        return CardResult::Consume;
    }
    #[inline]
    fn c48(ref self:Adventurer)->CardResult{
        //护甲持续到受到伤害为止。
        self.attr.add_ability(C1Ability::Taunt);
        return CardResult::Consume;
    }
    #[inline]
    fn c49(ref self:Adventurer)->CardResult{
        //获得的护甲值翻倍。
        self.attr.add_ability(C1Ability::Armor_Double);
        return CardResult::Consume;
    }
    #[inline]
    fn c50(ref self:Adventurer)->CardResult{
        //回合开始时如果你有护甲，对所有敌人造成6点伤害
        let mut value:u16 = 6;
        self.check_talent_1(ref value);
        self.attr.status.insert(C1Status::S11,MathU16Trait::add_u16(self.attr.status.get(C1Status::S11),value));
        return CardResult::Consume;
    }
    #[inline]
    fn c51(ref self:Adventurer)->CardResult{
        //回合开始时如果你有护甲，获得1点能量
        self.attr.status.insert(C1Status::S12,MathU16Trait::add_u16(self.attr.status.get(C1Status::S12),1));
        return CardResult::Consume;
    }
}

 

 