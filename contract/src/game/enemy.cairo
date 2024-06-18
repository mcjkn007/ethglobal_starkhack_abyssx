use abyss_x::game::adventurer::{Adventurer};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
 
use abyss_x::game::monster::m1::{M1ActionImpl,M1DamageImpl};
use abyss_x::game::monster::m2::{M2ActionImpl,M2DamageImpl};
use abyss_x::game::monster::m3::{M3ActionImpl,M3DamageImpl};
use abyss_x::game::monster::m4::{M4ActionImpl,M4DamageImpl};

use abyss_x::game::monster::b1::{B1ActionImpl,B1DamageImpl};

use abyss_x::utils::math::{MathU32Trait,MathU16Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum EnemyCategory{
    M1,
    M2,
    M3,
    M4,

    E1,

    B1,
    B2,
    B3
}

 
mod EnemyStatus{
    const Attacked_Armor:felt252 = 'e_attacked_armor';//蜷身 当受到 攻击 伤害时，蜷起身子并获得 n 点护甲
    const Fly:felt252 = 'e_fly';//飞行，受到伤害减少50%
    const Vertigo:felt252 = 'e_vertigo';//眩晕，停止一回合
    const Roar:felt252 = 'e_roar';//咆哮
     
}
 

#[derive(Destruct)]
struct Enemy {
    category:EnemyCategory,
    round:u16,
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
            EnemyCategory::M3 => M3ActionImpl::new(),
            EnemyCategory::M4 => M4ActionImpl::new(),

            EnemyCategory::B1 => B1ActionImpl::new(),
            _ => panic!("error init enemy"),
        };
    }
    #[inline]
    fn get_stage_1_enemey()->Enemy{
        return EnemyTrait::new(EnemyCategory::M1);
    }
    #[inline]
    fn get_stage_2_enemey()->EnemyTeam2{
        return EnemyTeam2{
            e1: EnemyTrait::new(EnemyCategory::M2),
            e2: EnemyTrait::new(EnemyCategory::M3),
        };
    }
    #[inline]
    fn get_stage_3_enemey()->EnemyTeam2{
        return EnemyTeam2{
            e1: EnemyTrait::new(EnemyCategory::M1),
            e2: EnemyTrait::new(EnemyCategory::M1),
        };
    }
    #[inline]
    fn get_stage_4_enemey()->EnemyTeam2{
        return EnemyTeam2{
            e1: EnemyTrait::new(EnemyCategory::M4),
            e2: EnemyTrait::new(EnemyCategory::M4),
        };
    }
    #[inline]
    fn get_stage_5_enemey()->Enemy{
        return EnemyTrait::new(EnemyCategory::E1);
    }
    #[inline]
    fn get_stage_7_enemey()->Enemy{
        return EnemyTrait::new(EnemyCategory::B1);
    }
    fn e_game_begin(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::game_begin(ref self,ref target),
            EnemyCategory::M2 => M2ActionImpl::game_begin(ref self,ref target),
            EnemyCategory::M3 => M3ActionImpl::game_begin(ref self,ref target),
            EnemyCategory::M4 => M4ActionImpl::game_begin(ref self,ref target),
            
            EnemyCategory::B1 => B1ActionImpl::game_begin(ref self,ref target),

            _ =>  panic!("error action enemy"),
        };
    }
     
    #[inline]
    fn e_round_begin(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::round_begin(ref self,ref target),
            EnemyCategory::M2 => M2ActionImpl::round_begin(ref self,ref target),
            EnemyCategory::M3 => M3ActionImpl::round_begin(ref self,ref target),
            EnemyCategory::M4 => M4ActionImpl::round_begin(ref self,ref target),
            
            EnemyCategory::B1 => B1ActionImpl::round_begin(ref self,ref target),

            _ =>  panic!("error action enemy"),
        };
         
    }
    #[inline]
    fn e_round_end(ref self:Enemy,ref target:Adventurer){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::round_end(ref self,ref target),
            EnemyCategory::M2 => M2ActionImpl::round_end(ref self,ref target),
            EnemyCategory::M3 => M3ActionImpl::round_end(ref self,ref target),
            EnemyCategory::M4 => M4ActionImpl::round_end(ref self,ref target),

            EnemyCategory::B1 => B1ActionImpl::round_end(ref self,ref target),

            _ =>  panic!("error action enemy"),
        };
       
    }
    #[inline]
    fn e_calculate_damage_dealt(ref self:Enemy,ref value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M2 => M2DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M3 => M3DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M4 => M4DamageImpl::calculate_damage_dealt(ref self.attr,ref value),


            EnemyCategory::B1 => B1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),

            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_damage_taken(ref self:Enemy, value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::damage_taken(ref self.attr, value),
            EnemyCategory::M2 => M2DamageImpl::damage_taken(ref self.attr, value),
            EnemyCategory::M3 => M3DamageImpl::damage_taken(ref self.attr, value),
            EnemyCategory::M4 => M4DamageImpl::damage_taken(ref self.attr, value),


            EnemyCategory::B1 => B1DamageImpl::damage_taken(ref self.attr, value),
      
            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_calculate_direct_damage_dealt(ref self:Enemy,ref value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M2 => M2DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M3 => M3DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            EnemyCategory::M4 => M4DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),

            EnemyCategory::B1 => B1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),

            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn e_direct_damage_taken(ref self:Enemy, value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1DamageImpl::direct_damage_taken(ref self.attr, value),
            EnemyCategory::M2 => M2DamageImpl::direct_damage_taken(ref self.attr, value),
            EnemyCategory::M3 => M3DamageImpl::direct_damage_taken(ref self.attr, value),
            EnemyCategory::M4 => M4DamageImpl::direct_damage_taken(ref self.attr, value),

            EnemyCategory::B1 => B1DamageImpl::direct_damage_taken(ref self.attr, value),

            _ =>  panic!("error action enemy"),
        };
    }
    #[inline]
    fn enemy_action(ref self:Enemy,ref target:Adventurer,round:u16){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::action(ref self,ref target,round),
            EnemyCategory::M2 => M2ActionImpl::action(ref self,ref target,round),
            EnemyCategory::M3 => M1ActionImpl::action(ref self,ref target,round),
            EnemyCategory::M4 => M2ActionImpl::action(ref self,ref target,round),


            EnemyCategory::B1 => B1ActionImpl::action(ref self,ref target,round),

            _ =>  panic!("error action enemy"),
        };
    }
    fn e_action_feedback(ref self:Enemy,ref target:Adventurer,value:u16){
        match self.category{ 
            EnemyCategory::M1 => M1ActionImpl::action_feedback(ref self,ref target,value),
            EnemyCategory::M2 => M2ActionImpl::action_feedback(ref self,ref target,value),
            EnemyCategory::M3 => M1ActionImpl::action_feedback(ref self,ref target,value),
            EnemyCategory::M4 => M2ActionImpl::action_feedback(ref self,ref target,value),


            EnemyCategory::B1 => B1ActionImpl::action_feedback(ref self,ref target,value),

            _ =>  panic!("error action enemy"),
        };
    }
}

#[generate_trait]
impl EnemyStatusImpl of EnemyStatusTrait{
    fn check_attacked_armor(ref self:Attribute){
        let buff = self.status.get(EnemyStatus::Attacked_Armor);
        if(buff.is_no_zero_u16()){
            self.add_armor(buff);
            self.status.insert(EnemyStatus::Attacked_Armor,0);
        }
    }
}
 
