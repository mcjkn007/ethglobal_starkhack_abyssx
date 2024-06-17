use abyss_x::game::adventurer::{Adventurer};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
 
use abyss_x::game::monster::m1::{M1ActionImpl,M1DamageImpl};
use abyss_x::game::monster::m2::{M2ActionImpl,M2DamageImpl};

use abyss_x::game::monster::b1::{B1ActionImpl,B1DamageImpl};
use abyss_x::game::monster::b2::{B2ActionImpl,B2DamageImpl};
use abyss_x::game::monster::b3::{B3ActionImpl,B3DamageImpl};

use abyss_x::utils::math::{MathU32Trait,MathU16Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum EnemyCategory{
    M1,
    M2,
    B1,
    B2,
    B3
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
 
 
 
#[generate_trait]
impl EnemyImpl of EnemyTrait {
    #[inline]
    fn new(category:EnemyCategory) -> Enemy{
        return match category {
            EnemyCategory::M1 => M1ActionImpl::new(),
            EnemyCategory::M2 => M2ActionImpl::new(),
            EnemyCategory::B1 => B1ActionImpl::new(),
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
    fn e_game_begin(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::game_begin(ref self,ref target),
            EnemyCategory::M2 => M2ActionImpl::game_begin(ref self,ref target),
            
            EnemyCategory::B1 => B1ActionImpl::game_begin(ref self,ref target),
            EnemyCategory::B2 => B2ActionImpl::game_begin(ref self,ref target),
            EnemyCategory::B3 => B3ActionImpl::game_begin(ref self,ref target),
            _ =>  panic!("error action enemy"),
        };
    }
     
    #[inline]
    fn e_round_begin(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::round_begin(ref self,ref target),
            EnemyCategory::M2 => M2ActionImpl::round_begin(ref self,ref target),
            
            EnemyCategory::B1 => B1ActionImpl::round_begin(ref self,ref target),
            EnemyCategory::B2 => B2ActionImpl::round_begin(ref self,ref target),
            EnemyCategory::B3 => B3ActionImpl::round_begin(ref self,ref target),
            _ =>  panic!("error action enemy"),
        };
         
    }
    #[inline]
    fn e_round_end(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::round_end(ref self,ref target),
            EnemyCategory::M2 => M2ActionImpl::round_end(ref self,ref target),

            EnemyCategory::B1 => B1ActionImpl::round_end(ref self,ref target),
            EnemyCategory::B2 => B2ActionImpl::round_end(ref self,ref target),
            EnemyCategory::B3 => B3ActionImpl::round_end(ref self,ref target),
            _ =>  panic!("error action enemy"),
        };
       
    }
    #[inline]
    fn e_calculate_damage_dealt(ref self:Enemy,ref value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M2 => M2DamageImpl::calculate_damage_dealt(ref self.attr,ref value),

            EnemyCategory::B1 => B1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            EnemyCategory::B2 => B2DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            EnemyCategory::B3 => B3DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_damage_taken(ref self:Enemy, value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::damage_taken(ref self.attr, value),
            EnemyCategory::M2 => M2DamageImpl::damage_taken(ref self.attr, value),

            EnemyCategory::B1 => B1DamageImpl::damage_taken(ref self.attr, value),
            EnemyCategory::B2 => B2DamageImpl::damage_taken(ref self.attr, value),
            EnemyCategory::B3 => B3DamageImpl::damage_taken(ref self.attr, value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_calculate_direct_damage_dealt(ref self:Enemy,ref value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M2 => M2DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),

            EnemyCategory::B1 => B1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            EnemyCategory::B2 => B2DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            EnemyCategory::B3 => B3DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_direct_damage_taken(ref self:Enemy, value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::direct_damage_taken(ref self.attr, value),
            EnemyCategory::M2 => M2DamageImpl::direct_damage_taken(ref self.attr, value),

            EnemyCategory::B1 => B1DamageImpl::direct_damage_taken(ref self.attr, value),
            EnemyCategory::B2 => B2DamageImpl::direct_damage_taken(ref self.attr, value),
            EnemyCategory::B3 => B3DamageImpl::direct_damage_taken(ref self.attr, value),
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn enemy_action(ref self:Enemy,ref target:Adventurer,round:u16){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::action(ref self,ref target,round),
            EnemyCategory::M2 => M2ActionImpl::action(ref self,ref target,round),

            EnemyCategory::B1 => B1ActionImpl::action(ref self,ref target,round),
            EnemyCategory::B2 => B2ActionImpl::action(ref self,ref target,round),
            EnemyCategory::B3 => B3ActionImpl::action(ref self,ref target,round),
            _ =>  panic!("error action enemy"),
        };
    }
 

    
     
}

 