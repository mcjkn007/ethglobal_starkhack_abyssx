use abyss_x::game::explorer::{Explorer,ExplorerInheritTrait,ExplorerTrait,ExplorerCategory};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyInheritTrait,EnemyCategory};
 
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX,CardTarget};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

mod M1CardID{
    const Attack:u8 = 1_u8;
    const Defence:u8 = 2_u8;
}

mod M1CardValue{
    const Attack:u16 = 6_u16;
    const Defence:u16 = 5_u16;
} 


impl M1EnemyImpl of EnemyInheritTrait{
    fn init_enemy() -> Enemy{
        let mut result = Enemy{
            category:EnemyCategory::M1,
            attr:AttributeTrait::init_attribute(),
        };
        result.attr.hp = 30;
        return result;
    } 
    fn get_card_target(card_id: u8) -> CardTarget {
        match card_id {
            0 => CardTarget::One,
            1 => CardTarget::One,
            2 => CardTarget::Self,
            _ => CardTarget::Self
        }
    }
    fn get_enemy_action_card(round:u8)->u8
    {
        return 1;
    }

    fn use_card_self(ref self:Enemy,card_id:u8){
        if(card_id == M1CardID::Defence){
            let mut value:u16 = MathU16Trait::add_u16(self.attr.agi,M1CardValue::Defence);
            self.attr.cal_armor_self_status(ref value);
            self.attr.armor.add_eq_u16(value);
        }
    }
    fn use_card(ref self:Enemy,ref target:Explorer,card_id:u8){
 
        if(card_id == M1CardID::Attack){
            let mut value:u16 = MathU16Trait::add_u16(self.attr.str,M1CardValue::Attack);
            self.attr.cal_damage_self_status(ref value);
            target.attr.cal_damage_target_status(ref value);
        
            target.attr.sub_armor(ref value);    
            target.attr.hp.sub_eq_u16(value);
        }
    }
}