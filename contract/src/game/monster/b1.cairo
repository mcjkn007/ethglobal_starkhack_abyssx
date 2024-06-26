use core::dict::Felt252DictTrait;
use core::array::ArrayTrait;
use abyss_x::utils::constant::{CurseCard};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::status::{StatusCategory,StatusTrait};

use abyss_x::game::attribute::{Attribute,AttributeState,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory,EnemyStatus};

use abyss_x::game::action::{EntityTrait,ActionTrait,DamageTrait};

impl B1EntityImpl of EntityTrait<Enemy>{
    //6火
    #[inline]
    fn new()->Enemy{
        return Enemy{
            category:EnemyCategory::B1,
            round:0,
            attr:AttributeTrait::new(250),
        };
    }
}

impl B1ActionImpl of ActionTrait<Enemy,Adventurer>{
    #[inline]
    fn game_begin(ref self:Enemy,ref target:Adventurer){
       
    }
    #[inline]
    fn game_end(ref self:Enemy,ref target:Adventurer){
       
    }

    fn round_begin(ref self:Enemy,ref target:Adventurer){
        
    }
    fn round_end(ref self:Enemy,ref target:Adventurer){
       
    }
    fn action_feedback(ref self:Enemy,ref target:Adventurer,data:u16){

    }
    fn action(ref self:Enemy,ref target:Adventurer,data:u16){
        self.round.add_eq_u16(data);
    
        if(self.round == 0){  
            
        }else if(self.round == 1){
            //第一轮 造成X点伤害6次。
            let mut value:u16 = MathU16Trait::add_u16(target.attr.hp/12_u16,1);
            self.e_calculate_damage_dealt(ref value);

            target.c_damage_taken(ref self.attr,value);
            target.c_damage_taken(ref self.attr,value);
            target.c_damage_taken(ref self.attr,value);
            target.c_damage_taken(ref self.attr,value);
            target.c_damage_taken(ref self.attr,value);
            target.c_damage_taken(ref self.attr,value);
        }else{
            self.round.sub_eq_u16(2);
            let up:bool = self.round/7_u16 > 0;
            match  self.round%7 {
                0 => {
                    //造成6点伤害，在玩家弃牌堆加一张灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(ref self.attr,value);
                    if(up){
                        target.right_cards.append(CurseCard::BurnUp);
                    }else{
                        target.right_cards.append(CurseCard::Burn);
                    }
                },
                1 => {
                    //其他 造成5点伤害两次
                    let mut value = 5;
                    self.e_calculate_damage_dealt(ref value);
        
                    target.c_damage_taken(ref self.attr,value);
                    target.c_damage_taken(ref self.attr,value);
                },
                2 => {
                    //造成6点伤害，在玩家弃牌堆加一张灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(ref self.attr,value);
                    if(up){
                        target.right_cards.append(CurseCard::BurnUp);
                    }else{
                        target.right_cards.append(CurseCard::Burn);
                    }
                },
                3 => {
                    //获得2点力量，12点格挡
                    self.attr.add_ad(2);
                    self.attr.b1_add_armor(12);
                },
                4 => {
                    //其他 造成5点伤害两次
                    let mut value = 5;
                    self.e_calculate_damage_dealt(ref value);
        
                    target.c_damage_taken(ref self.attr,value);
                    target.c_damage_taken(ref self.attr,value);
                },
                5 => {
                    //造成6点伤害，在玩家弃牌堆加一张灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(ref self.attr,value);
                    if(up){
                        target.right_cards.append(CurseCard::BurnUp);
                    }else{
                        target.right_cards.append(CurseCard::Burn);
                    }
                },
                6 =>{
                    //造成2点伤害6次，并向弃牌堆加入3张升级后的灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(ref self.attr,value);
                    target.c_damage_taken(ref self.attr,value);

                    target.right_cards.append(CurseCard::BurnUp);
                    target.right_cards.append(CurseCard::BurnUp);
                    target.right_cards.append(CurseCard::BurnUp);
                },
                _ =>{}
            }
        }
        
    }
}

impl B1DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn damage_taken(ref self:Attribute,ref target:Attribute, mut value:u16){
        
        self.status.cal_damaged_status(ref value);

        self.sub_hp_and_armor(value); 
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn direct_damage_taken(ref self:Attribute,mut value:u16){
        self.sub_hp_and_armor(value); 
    }
}

#[generate_trait]
impl B1StatusImpl of B1StatusTrait {
#[inline]
fn b1_add_armor(ref self:Attribute,mut value:u16){
    self.status.cal_armor_status(ref value);
    self.add_armor(value);
    }
}