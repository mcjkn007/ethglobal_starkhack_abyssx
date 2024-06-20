
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::status::{StatusCategory,StatusTrait};
use abyss_x::game::relic::{RelicCategory,RelicTrait};

use abyss_x::game::attribute::{Attribute,AttributeState,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory,EnemyStatus,EnemyStatusTrait};


use abyss_x::game::action::{EntityTrait,ActionTrait,DamageTrait};
 
impl M3EntityImpl of EntityTrait<Enemy>{
    //绿虱虫
    #[inline]
    fn new()->Enemy{
        return Enemy{
            category:EnemyCategory::M3,
            round:0,
            attr:AttributeTrait::new(11),
        };
    }
}

impl M3ActionImpl of ActionTrait<Enemy,Adventurer>{
 
    #[inline]
    fn game_begin(ref self:Enemy,ref target:Adventurer){
        self.attr.status.insert(EnemyStatus::Attacked_Armor,5);
    }
    fn game_end(ref self:Enemy,ref target:Adventurer){

    }
    fn round_begin(ref self:Enemy,ref target:Adventurer){
        
        
    }
    fn round_end(ref self:Enemy,ref target:Adventurer){
     
    }
    fn action_feedback(ref self:Enemy,ref target:Adventurer,data:u16){

    }
    fn  action(ref self:Enemy,ref target:Adventurer,mut data:u16){
        self.round.add_eq_u16(data);
        let r = self.round%4;
        if(r == 0 || r == 3){
            if(target.check_relic_9() == false){
                target.attr.add_weak(2);
            }
        }else{
            let mut value = 6;
            self.e_calculate_damage_dealt(ref value);
            target.c_damage_taken(ref self.attr,value);
        }
    }
}

impl M3DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn damage_taken(ref self:Attribute,ref target:Attribute, mut value:u16){
        
        self.status.cal_damaged_status(ref value);

        self.sub_hp_and_armor(value); 
        if(self.hp > 0){
            self.check_attacked_armor();
        }
        let thorns = self.status.get(StatusCategory::Thorns);
        if(thorns > 0){
            target.sub_hp_and_armor(thorns);
        }
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn  direct_damage_taken(ref self:Attribute, mut value:u16){
        self.sub_hp_and_armor(value); 
    }
    
}
 