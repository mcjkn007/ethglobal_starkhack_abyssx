use abyss_x::game::explorer::{Explorer,ExplorerInheritTrait,ExplorerTrait,ExplorerCategory,CardTarget};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam3};
 
 
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};

mod C1CardID{
    const Attack:u8 = 1_u8;
    const Defence:u8 = 2_u8;
}

mod C1CardCost{
    const Attack:u8 = 1_u8;
    const Defence:u8 = 1_u8;
} 
 
mod C1CardValue{
    const Attack:u16 = 6_u16;
    const Defence:u16 = 5_u16;
} 


impl C1ExplorerImpl of ExplorerInheritTrait{
    fn init_explorer() -> Explorer{
        return Explorer{
            seed:0,
            hand_cards_init:5,
            attr:AttributeTrait::init_attribute(),
            category:ExplorerCategory::C1,
            role_cards:ArrayTrait::<u8>::new(),
            left_cards:ArrayTrait::<u8>::new(),
            mid_cards:DictMapTrait::<u8>::new(),
            right_cards:ArrayTrait::<u8>::new(),
        };
    } 
    fn get_card_target(card_id: u8) -> CardTarget {
        match card_id {
            0 => CardTarget::One,
            1 => CardTarget::One,
            2 => CardTarget::Self,
            _ => CardTarget::Self
        }
    }
    fn get_card_energy(card_id: u8) -> u8{
        match card_id {
            0 => 1_u8,
            1 => 1_u8,
            _ => 1_u8
        }
    }
 
    fn use_card_self(ref self:Explorer,card_id:u8){
        self.attr.energy.self_sub_u8_e(C1ExplorerImpl::get_card_energy(card_id));
       
        if(card_id == C1CardID::Defence){
            let mut value:u16 = MathU16Trait::add_u16(self.attr.agi,C1CardValue::Defence);
            self.attr.cal_armor_self_status(ref value);
            self.attr.armor.add_eq_u16(value);
        }
    }
    fn use_card(ref self:Explorer,ref target:Enemy,card_id:u8){
        self.attr.energy.self_sub_u8_e(C1ExplorerImpl::get_card_energy(card_id));

        if(card_id == C1CardID::Attack){
            let mut value:u16 = MathU16Trait::add_u16(self.attr.str,C1CardValue::Attack);
            self.attr.cal_damage_self_status(ref value);
            target.attr.cal_damage_target_status(ref value);
        
            target.attr.sub_armor(ref value);    
            target.attr.hp.sub_eq_u16(value);
        }
    }
}