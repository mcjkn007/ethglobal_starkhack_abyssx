use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::status::{StatusCategory,StatusTrait};

use abyss_x::game::attribute::{Attribute,AttributeState,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory,EnemyStatus,EnemyStatusTrait};


use abyss_x::game::action::{EntityTrait,ActionTrait,DamageTrait};
  
impl M4EntityImpl of EntityTrait<Enemy>{
    //异鸟
    #[inline]
    fn new()->Enemy{
        return Enemy{
            category:EnemyCategory::M4,
            round:0,
            attr:AttributeTrait::new(25),
        };
    }
}

impl M4ActionImpl of ActionTrait<Enemy,Adventurer>{
    #[inline]
    fn game_begin(ref self:Enemy,ref target:Adventurer){
       
    }
    #[inline]
    fn game_end(ref self:Enemy,ref target:Adventurer){
       
    }
    fn round_begin(ref self:Enemy,ref target:Adventurer){
        self.attr.status.insert(EnemyStatus::Fly,3);
    }
    fn round_end(ref self:Enemy,ref target:Adventurer){
    
    }
    fn action_feedback(ref self:Enemy,ref target:Adventurer,data:u16){

    }
    fn  action(ref self:Enemy,ref target:Adventurer,mut data:u16){
        let fly = self.attr.status.get(EnemyStatus::Fly);
        self.round.add_eq_u16(data);
        if(fly > 0){
            let r = self.round%4;
             if(r == 0 || r == 3){
                let mut value = 1;
                self.e_calculate_damage_dealt(ref value);
                target.c_damage_taken(ref self.attr,value);
                target.c_damage_taken(ref self.attr,value);
                target.c_damage_taken(ref self.attr,value);
                target.c_damage_taken(ref self.attr,value);
                target.c_damage_taken(ref self.attr,value);

             }else if(r == 1){
                self.attr.add_ad(1);
    
             }else if(r == 2){
                let mut value = 12;
                self.e_calculate_damage_dealt(ref value);
                target.c_damage_taken(ref self.attr,value);
             }
        }else{
            let v = self.attr.status.get(EnemyStatus::Vertigo); 
            if (v == 1){
                self.attr.status.insert(EnemyStatus::Vertigo,0); 
                self.round = 0;
            } else{
                let r = self.round%3;
                if(r == 1){
                    let mut value = 21;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(ref self.attr,value);
                }else if(r == 2){
                    self.attr.status.insert(EnemyStatus::Fly,3);
                }
            }
            
        }
    }
}

impl M4DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn damage_taken(ref self:Attribute,ref target:Attribute, mut value:u16){
        
        self.status.cal_damaged_status(ref value);

        let fly = self.status.get(EnemyStatus::Fly);
        if(fly > 0){
            value /= 2;
            if(fly == 1){
                self.status.insert(EnemyStatus::Vertigo,1);    
            }
            self.status.insert(EnemyStatus::Fly,MathU16Trait::sub_u16(self.status.get(EnemyStatus::Fly),1));
        }

        self.sub_hp_and_armor(value); 
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
 