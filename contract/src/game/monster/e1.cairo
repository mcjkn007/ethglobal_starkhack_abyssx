use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
 
use abyss_x::game::attribute::{Attribute,AttributeState,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory,EnemyStatus};
use abyss_x::game::relic::{RelicCategory,RelicTrait};
use abyss_x::game::status::{StatusCategory,StatusTrait};
use abyss_x::game::action::{EntityTrait,ActionTrait,DamageTrait};
 
impl E1EntityImpl of EntityTrait<Enemy>{
    //大块头
    fn new()->Enemy{
        return Enemy{
            category:EnemyCategory::M1,
            round:0,
            attr:AttributeTrait::new(54),
        };
    }
}

impl E1ActionImpl of ActionTrait<Enemy,Adventurer>{
    
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
        if(data == 2){
            self.attr.add_ad(2);
        }
         
    }
    fn  action(ref self:Enemy,ref target:Adventurer,mut data:u16){
        self.round.add_eq_u16(data);
        self.round = self.round%8;
        if(self.round == 0){
            
             
        }else if(self.round == 1 || self.round == 4 || self.round ==6){
            let mut value = 6;
            self.e_calculate_damage_dealt(ref value);
            target.c_damage_taken(ref self.attr,value);
            if(target.check_relic_9() == false){
                target.attr.add_fragile(1);
            }
             
        }else{
            let mut value = 14;
            self.e_calculate_damage_dealt(ref value);
            target.c_damage_taken(ref self.attr,value);
        }
    }
}

impl E1DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn damage_taken(ref self:Attribute,ref target:Attribute, mut value:u16){
        
        self.status.cal_damaged_status(ref value);

        self.sub_hp_and_armor(value); 
        let thorns = self.status.get(StatusCategory::Thorns);
        if(thorns > 0){
            target.sub_hp_and_armor(thorns);
        }
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn direct_damage_taken(ref self:Attribute,mut value:u16){
        self.sub_hp_and_armor(value); 
    }
}
 