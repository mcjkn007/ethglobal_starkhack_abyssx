use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerBaseTrait,AdventurerTrait};
use abyss_x::game::status::{Status,StatusTrait};
use abyss_x::game::attribute::{Attribute,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyBaseTrait,EnemyCategory};

use abyss_x::game::damage::{DamageTrait};

mod M2CardID{
    const Attack:u8 = 1_u8;
    const Defence:u8 = 2_u8;
}

mod M2CardValue{
    const Attack:u16 = 6_u16;
    const Defence:u16 = 5_u16;
} 

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


impl M2EnemyImpl of EnemyBaseTrait{
    fn new() -> Enemy{
        let mut result = Enemy{
            category:EnemyCategory::M2,
            attr:AttributeTrait::new(20),
        };
        result.attr.hp = 30;
        return result;
    } 
 
    fn get_enemy_action(round:u8)->u8
    {
        return 1;
    }
    fn round_begin(ref self:Enemy,ref target:Adventurer){
        self.attr.round_begin();
    }
    fn round_end(ref self:Enemy,ref target:Adventurer){
        self.attr.round_end();
    }
    fn use_card(ref self:Enemy,ref target:Adventurer,round:u8){
       
  
    }
}
#[generate_trait]
impl M2UseCardImpl of M2UseCardTrait{
   
}