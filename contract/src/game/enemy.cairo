use abyss_x::game::adventurer::{Adventurer};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
 
use abyss_x::game::monster::m1::{M1EnemyImpl,M1DamageImpl};
use abyss_x::game::monster::m2::{M2EnemyImpl,M2DamageImpl};

use abyss_x::utils::math::{MathU32Trait,MathU16Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum EnemyCategory{
    M1,
    M2,
}

#[derive(Destruct)]
struct Enemy {
    category:EnemyCategory,
    attr:Attribute
}

#[derive(Destruct)]
struct EnemyTeam2 {
    e1:Enemy,
    e2:Enemy
}
 
#[derive(Destruct)]
struct EnemyTeam3 {
    e1:Enemy,
    e2:Enemy,
    e3:Enemy
}
 
pub trait EnemyBaseTrait {
    fn new() -> Enemy;

    fn get_enemy_action(round:u8)->u8;

    fn round_begin(ref self:Enemy,ref target:Adventurer);
    fn round_end(ref self:Enemy,ref target:Adventurer);

    fn use_card(ref self:Enemy,ref target:Adventurer,round:u8);
}

 
#[generate_trait]
impl EnemyImpl of EnemyTrait {
    #[inline]
    fn new(category:EnemyCategory) -> Enemy{
        return match category {
            EnemyCategory::M1 => M1EnemyImpl::new(),
            EnemyCategory::M2 => M2EnemyImpl::new(),
            _ => panic!("error init enemy"),
        };
    }
    #[inline]
    fn get_enemy(stage:u32)->Enemy{
        return EnemyTrait::new(EnemyCategory::M1);
    }
    fn get_enemies(stage:u32)->EnemyTeam3{
        return EnemyTeam3{
            e1:EnemyTrait::new(EnemyCategory::M1),
            e2:EnemyTrait::new(EnemyCategory::M2),
            e3:EnemyTrait::new(EnemyCategory::M1),
        };
    }
    #[inline]
    fn e_round_begin(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1EnemyImpl::round_begin(ref self,ref target),
            EnemyCategory::M2 => M2EnemyImpl::round_begin(ref self,ref target),
            _ =>  panic!("error action enemy"),
        };
         
    }
    #[inline]
    fn e_round_end(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1EnemyImpl::round_end(ref self,ref target),
            EnemyCategory::M2 => M2EnemyImpl::round_end(ref self,ref target),
            _ =>  panic!("error action enemy"),
        };
       
    }
    #[inline]
    fn e_calculate_damage_dealt(ref self:Enemy,ref value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M2 => M2DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_damage_taken(ref self:Enemy, value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::damage_taken(ref self.attr, value),
            EnemyCategory::M2 => M2DamageImpl::damage_taken(ref self.attr, value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_calculate_direct_damage_dealt(ref self:Enemy,ref value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M2 => M2DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_direct_damage_taken(ref self:Enemy, value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::direct_damage_taken(ref self.attr, value),
            EnemyCategory::M2 => M2DamageImpl::direct_damage_taken(ref self.attr, value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn enemy_action(ref self:Enemy,ref target:Adventurer,round:u8){
        match self.category{ 
            EnemyCategory::M1 => M1EnemyImpl::use_card(ref self,ref target,round),
            EnemyCategory::M2 => M2EnemyImpl::use_card(ref self,ref target,round),
            _ =>  panic!("error action enemy"),
        };
    }
 

    
     
}

 