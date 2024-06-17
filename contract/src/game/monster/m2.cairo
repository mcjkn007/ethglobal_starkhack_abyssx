use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait};
use abyss_x::game::status::{StatusTrait};
use abyss_x::game::attribute::{Attribute,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory};

use abyss_x::game::action::{ActionTrait,DamageTrait};

 
impl M2DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn  damage_taken(ref self:Attribute, mut value:u16){
        
        self.status.cal_damaged_status(ref value);

        self.sub_hp_and_armor(value); 
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn  direct_damage_taken(ref self:Attribute, value:u16){

    }
}


impl M2ActionImpl of ActionTrait<Enemy,Adventurer>{
    //大颚虫
    fn new() -> Enemy{
        let mut result = Enemy{
            category:EnemyCategory::M2,
            attr:AttributeTrait::new(20),
        };
        result.attr.hp = 30;
        return result;
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
    fn action(ref self:Enemy,ref target:Adventurer,mut data:u16){
       
  
    }
}
#[generate_trait]
impl M2UseCardImpl of M2UseCardTrait{
   
}