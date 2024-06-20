 use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::status::{StatusTrait,StatusCategory};

use abyss_x::game::attribute::{Attribute,AttributeState,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory,EnemyStatus};


use abyss_x::game::action::{EntityTrait,ActionTrait,DamageTrait};
 
impl M1EntityImpl of EntityTrait<Enemy>{
    //邪教徒
    #[inline]
    fn new()->Enemy{
        return Enemy{
            category:EnemyCategory::M1,
            round:0,
            attr:AttributeTrait::new(54),
        };
    }
}

impl M1ActionImpl of ActionTrait<Enemy,Adventurer>{
   
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
    fn  action(ref self:Enemy,ref target:Adventurer,mut data:u16){
        self.round.add_eq_u16(data);
    
        if(self.round == 0){
            
        }else{
            let mut value = MathU16Trait::add_u16(6,2*data);
            self.e_calculate_damage_dealt(ref value);
            target.c_damage_taken(ref self.attr,value);
        }
    }
}

impl M1DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn damage_taken(ref self:Attribute,ref target:Attribute, mut value:u16){
        
        self.status.cal_damaged_status(ref value);

        self.sub_hp_and_armor(value); 
        let thorns = self.status.get(StatusCategory::Thorns);
        if(thorns.is_no_zero_u16()){
            target.sub_hp_and_armor(thorns);
        }
        if(self.hp.is_zero_u16()){
            self.state = AttributeState::Death;
        }
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn direct_damage_taken(ref self:Attribute,mut value:u16){
        self.sub_hp_and_armor(value); 
        if(self.hp.is_zero_u16()){
            self.state = AttributeState::Death;
        }
       
    }
}
 