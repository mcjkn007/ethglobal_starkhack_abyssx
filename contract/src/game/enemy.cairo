use abyss_x::game::explorer::{Explorer};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
 
use abyss_x::game::monster::m1::{M1EnemyImpl};
use abyss_x::game::monster::m2::{M2EnemyImpl};

use abyss_x::utils::math::{MathU32Trait,MathU16Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX,CardTarget};

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum EnemyCategory {
    M1,
    M2,
 
}
#[derive(Copy, Drop, Serde)]
struct EnemyTeam3 {
    e1:Enemy,
    e2:Enemy,
    e3:Enemy
}
 

#[derive(Copy,Drop,Serde)]
struct Enemy {
    category:EnemyCategory,
    attr:Attribute
}

pub trait EnemyInheritTrait {
    fn init_enemy() -> Enemy;

    fn get_enemy_action_card(round:u8)->u8;
    fn get_card_target(card_id: u8)->CardTarget;

    fn use_card_self(ref self:Enemy,card_id:u8);
    fn use_card(ref self:Enemy,ref target:Explorer,card_id:u8);
}

 
#[generate_trait]
impl EnemyImpl of EnemyTrait {
    fn round_begin(ref self:Enemy){
        self.attr.round_begin();
    }
    fn round_end(ref self:Enemy){
        self.attr.round_end();
    }
    fn init_enemy(category:EnemyCategory) -> Enemy{
        return match category {
            EnemyCategory::M1 => M1EnemyImpl::init_enemy(),
            EnemyCategory::M2 => M2EnemyImpl::init_enemy(),
            _ => M1EnemyImpl::init_enemy(),
        };
    }
    fn enemy_action(ref self:Enemy,ref target:Explorer,round:u8){
        self.round_begin(); 
        match self.category {
            EnemyCategory::M1 => {
                let enemy_card:u8 = M1EnemyImpl::get_enemy_action_card(round);
                if(M1EnemyImpl::get_card_target(enemy_card) == CardTarget::Self){
                    M1EnemyImpl::use_card_self(ref self,enemy_card);
                }else{
                    M1EnemyImpl::use_card(ref self,ref target,enemy_card);
                }
            },
            EnemyCategory::M2 => {
                let enemy_card:u8 = M2EnemyImpl::get_enemy_action_card(round);
                if(M2EnemyImpl::get_card_target(enemy_card) == CardTarget::Self){
                    M2EnemyImpl::use_card_self(ref self,enemy_card);
                }else{
                    M2EnemyImpl::use_card(ref self,ref target,enemy_card);
                }
            },
            _ => {

            },
        };
        self.round_end(); 
    }
 
    fn get_enemies(stage:u32)->EnemyTeam3{
        return EnemyTeam3{
            e1:EnemyTrait::init_enemy(EnemyCategory::M1),
            e2:EnemyTrait::init_enemy(EnemyCategory::M1),
            e3:EnemyTrait::init_enemy(EnemyCategory::M1),
        };
    }
    fn get_enemy(stage_process:u32)->Enemy{
        return EnemyTrait::init_enemy(EnemyCategory::M1);
    }

    
     
}

 