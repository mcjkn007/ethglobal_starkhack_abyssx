 use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::status::{StatusTrait};

use abyss_x::game::attribute::{Attribute,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory};


use abyss_x::game::action::{ActionTrait,DamageTrait};
 
impl M1ActionImpl of ActionTrait<Enemy,Adventurer>{
    //邪教徒
    fn new()->Enemy{
        return Enemy{
            category:EnemyCategory::M1,
            attr:AttributeTrait::new(20),
        };
    }
    #[inline]
    fn game_begin(ref self:Enemy,ref target:Adventurer){
    
    }
    fn round_begin(ref self:Enemy,ref target:Adventurer){
        self.attr.round_begin();
    }
    fn round_end(ref self:Enemy,ref target:Adventurer){
        self.attr.round_end();
    }

    fn  action(ref self:Enemy,ref target:Adventurer,mut data:u16){
        if(data == 0){
            
        }else{
            let mut value = MathU16Trait::add_u16(6,2*data);
            self.e_calculate_damage_dealt(ref value);
            target.c_damage_taken(value);
        }
    }
}

impl M1DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn  damage_taken(ref self:Attribute,mut value:u16){
        
        self.status.cal_damaged_status(ref value);

        self.sub_hp_and_armor(value); 
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn  direct_damage_taken(ref self:Attribute,mut value:u16){
        self.sub_hp_and_armor(value); 
    }
}
 