use core::dict::Felt252DictTrait;
use core::array::ArrayTrait;
use abyss_x::utils::constant::{DebuffCard};
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::status::{CommonStatus,StatusTrait};

use abyss_x::game::attribute::{Attribute,AttributeTrait,CalAttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait,EnemyCategory};

use abyss_x::game::action::{ActionTrait,DamageTrait};
 
impl B2ActionImpl of ActionTrait<Enemy,Adventurer>{
    //勇士
    fn new()->Enemy{
        return Enemy{
            category:EnemyCategory::B2,
            attr:AttributeTrait::new(250),
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

    fn action(ref self:Enemy,ref target:Adventurer,mut data:u16){
        
        if(data == 0){
            
        }else if(data == 1){
            //第一轮 造成X点伤害6次。
            let mut value:u16 = MathU16Trait::add_u16(target.attr.hp/12_u16,1);
            self.e_calculate_damage_dealt(ref value);

            target.c_damage_taken(value);
            target.c_damage_taken(value);
            target.c_damage_taken(value);
            target.c_damage_taken(value);
            target.c_damage_taken(value);
            target.c_damage_taken(value);
        }else{
            data.sub_eq_u16(2);
            let up:bool = data/7_u16 > 0;
            match  data%7 {
                0 => {
                    //造成6点伤害，在玩家弃牌堆加一张灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(value);
                    if(up){
                        target.right_cards.append(DebuffCard::BurnUp);
                    }else{
                        target.right_cards.append(DebuffCard::Burn);
                    }
                },
                1 => {
                    //其他 造成5点伤害两次
                    let mut value = 5;
                    self.e_calculate_damage_dealt(ref value);
        
                    target.c_damage_taken(value);
                    target.c_damage_taken(value);
                },
                2 => {
                    //造成6点伤害，在玩家弃牌堆加一张灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(value);
                    if(up){
                        target.right_cards.append(DebuffCard::BurnUp);
                    }else{
                        target.right_cards.append(DebuffCard::Burn);
                    }
                },
                3 => {
                    //获得2点力量，12点格挡
                    self.attr.status.insert(CommonStatus::Amplify_Damage,MathU16Trait::add_u16(self.attr.status.get(CommonStatus::Amplify_Damage),2));
                    self.attr.b1_add_armor(12);
                },
                4 => {
                    //其他 造成5点伤害两次
                    let mut value = 5;
                    self.e_calculate_damage_dealt(ref value);
        
                    target.c_damage_taken(value);
                    target.c_damage_taken(value);
                },
                5 => {
                    //造成6点伤害，在玩家弃牌堆加一张灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(value);
                    if(up){
                        target.right_cards.append(DebuffCard::BurnUp);
                    }else{
                        target.right_cards.append(DebuffCard::Burn);
                    }
                },
                6 =>{
                    //造成2点伤害6次，并向弃牌堆加入3张升级后的灼烧
                    let mut value = 6;
                    self.e_calculate_damage_dealt(ref value);
                    target.c_damage_taken(value);
                    target.c_damage_taken(value);

                    target.right_cards.append(DebuffCard::BurnUp);
                    target.right_cards.append(DebuffCard::BurnUp);
                    target.right_cards.append(DebuffCard::BurnUp);
                },
                _ =>{}
            }
        }
        
    }
}

impl B2DamageImpl of DamageTrait {
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

#[generate_trait]
impl B2StatusImpl of B1StatusTrait {
#[inline]
fn b1_add_armor(ref self:Attribute,mut value:u16){
    self.status.cal_armor_status(ref value);
    self.add_armor(value);
    }
}