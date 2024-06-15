use core::option::OptionTrait;
use core::traits::TryInto;
use core::clone::Clone;
use core::array::ArrayTrait;
use starknet::ContractAddress;
use abyss_x::utils::{vec::{Vec2,Vec3}};
use abyss_x::models::{role::{Role,RoleCategory},property::{Property,BaseProperty}};

 
#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum CardTarget{
    None,
    Self,
    SingleEnemy,
    Enemies
}

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum CardID{
    None,
    Attack,
    Smash,
    InfiniteStrike,
    BladeDance,
    Bloodthirst,
    Defence,
    Fever,
    Shout,
    ShiledWall,
    Avatar,
    DefensiveStance,
    BerserkerStance,
    Bloodbath,
    Bastion,
    ShowofPower,
}

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum CardCategory{
    None,
    Attack,
    Skill,
    Ability
}

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum CardEffectMoment{
    None,
    RightNow,
    RoundBeginBuff,
    RoundBeginDebuff,
    RoundEndBuff,
    RoundEndDebuff,
    KilledEnemy
}

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum CardEffect{
    None,
    HP_S,
    HP_A,
    HP_MAX_S,
    HP_MAX_A,
    Energy_S,
    Energy_A,
    Energy_MAX_S,
    Energy_MAX_A,

    Armor_S,
    Armor_A,
    Power_A_S,
    Power_A_A,
    Power_M_S,
    Power_M_A,

    Fragile,
    Weak,
    Fear,
    Maintain_Armor,
}

impl U32IntoCardID of Into<u32, CardID> {
    fn into(self: u32) -> CardID {
        match self.into() {
            0 => CardID::None,
            1 => CardID::Attack,
            2 => CardID::Smash,
            3 => CardID::InfiniteStrike,
            4 => CardID::BladeDance,
            5 => CardID::Bloodthirst,
            6 => CardID::Defence,
            7 => CardID::Fever,
            8 => CardID::Shout,
            9 => CardID::ShiledWall,
            10 => CardID::Avatar,
            11 => CardID::DefensiveStance,
            12 => CardID::BerserkerStance,
            13 => CardID::Bloodbath,
            14 => CardID::Bastion,
            15 => CardID::ShowofPower,
            _ => CardID::None
        }
    }
}

impl CardEffectMomentIntoU32 of Into<CardEffectMoment, u32> {
    fn into(self: CardEffectMoment) -> u32 {
        match self {
            CardEffectMoment::None => 0,
            CardEffectMoment::RightNow => 1,
            CardEffectMoment::RoundBeginBuff => 2,
            CardEffectMoment::RoundBeginDebuff => 3,
            CardEffectMoment::RoundEndBuff => 4,
            CardEffectMoment::RoundEndDebuff => 5,
            CardEffectMoment::KilledEnemy => 6,
        }
    }
}

 
impl CardTargetIntoU32 of Into<CardTarget, u32> {
    fn into(self: CardTarget) -> u32 {
        match self {
            CardTarget::None => 0,
            CardTarget::Self => 1,
            CardTarget::SingleEnemy => 2,
            CardTarget::Enemies => 3,
        }
    }
}

impl CategoryIntoU32 of Into<CardCategory, u32> {
    fn into(self: CardCategory) -> u32 {
        match self {
            CardCategory::None => 0,
            CardCategory::Attack => 1,
            CardCategory::Skill => 2,
            CardCategory::Ability => 3,
        }
    }
}

impl CardEffectIntoU32 of Into<CardEffect, u32> {
    fn into(self: CardEffect) -> u32 {
        match self {
            CardEffect::None => 0,
            CardEffect::HP_S => 1,
            CardEffect::HP_A => 2,
            CardEffect::HP_MAX_S => 3,
            CardEffect::HP_MAX_A => 4,

            CardEffect::Energy_S => 5,
            CardEffect::Energy_A => 6,
            CardEffect::Energy_MAX_S => 7,
            CardEffect::Energy_MAX_A => 8,

            CardEffect::Armor_S => 9,
            CardEffect::Armor_A => 10,
 
            CardEffect::Power_A_S => 11,
            CardEffect::Power_A_A => 12,
            CardEffect::Power_M_S => 13,
            CardEffect::Power_M_A => 14,

            CardEffect::Fragile =>15,
            CardEffect::Weak => 16,
            CardEffect::Fear => 17,
            CardEffect::Maintain_Armor => 18,
        }
    }
}
 
trait CardTrait {
    
    fn create_role_init_card(category:RoleCategory)->Array<CardID>;
    fn calculate_card(ref self:Property,ref target:Property,card_id:u32);

    fn card_effect(ref self:BaseProperty,ref target:BaseProperty,effect:u32,value:u32);

    fn get_card_target(card_id: u32) -> CardTarget;
    fn get_card_energy(card_id: u32) -> u32;
    fn get_card_cost(card_id: u32) -> bool;
    fn get_card_value(card_id: u32) -> Array<u32>;
    fn get_card_effect(card_id: u32) -> Array<Vec2>;
}

impl CardImpl of CardTrait {
    fn create_role_init_card(category:RoleCategory)->Array<CardID>{
        let mut arr = ArrayTrait::<CardID>::new();
        if (category == RoleCategory::Warrior){
            arr.append(CardID::Attack);
            arr.append(CardID::Attack);
            arr.append(CardID::Attack);
            arr.append(CardID::Attack);
            arr.append(CardID::Smash);
            arr.append(CardID::Defence);
            arr.append(CardID::Defence);
            arr.append(CardID::Defence);
            arr.append(CardID::Defence);
            arr.append(CardID::ShiledWall);
        }
        return arr;
    }
    
    fn calculate_card(ref self:Property,ref target:Property,card_id:u32){
        let card_effect_arr:Array<Vec2> = CardTrait::get_card_effect(card_id);
        let card_value_arr:Array<u32> = CardTrait::get_card_value(card_id);

        let mut i = 0;
        let arr_size = card_effect_arr.len();
        loop {
            if(i >=arr_size){
                break;
            }
            let effect:Vec2 = *card_effect_arr[i];
            let value:u32 = *card_value_arr[i];
            
            if(effect.x == CardEffectMoment::RightNow.into()){
                CardTrait::card_effect(ref self.c,ref target.c,effect.y,value);
            }else if(effect.x == CardEffectMoment::RoundBeginBuff.into()){
                CardTrait::card_effect(ref self.c,ref target.rb_buff,effect.y,value);
            }else if(effect.x == CardEffectMoment::RoundBeginDebuff.into()){
                CardTrait::card_effect(ref self.c,ref target.rb_debuff,effect.y,value);
            }else if(effect.x == CardEffectMoment::RoundEndBuff.into()){
                CardTrait::card_effect(ref self.c,ref target.re_buff,effect.y,value);
            }else if(effect.x == CardEffectMoment::RoundEndDebuff.into()){
                CardTrait::card_effect(ref self.c,ref target.re_debuff,effect.y,value);
            }else if(effect.x == CardEffectMoment::KilledEnemy.into()){
                if(target.cur_property.hp == 0){
                    CardTrait::card_effect(ref self.cur_property,ref self.cur_property,effect.y,value);   
                } 
            }
            i += 1;
        };
    }

    fn card_effect(ref self:BaseProperty,ref target:BaseProperty,effect:u32,value:u32){
        if(effect == CardEffect::HP_S.into()){
            let mut v = value;
            if(self.power != 0){
                v += self.power;
            }
            if(self.weak != 0){
                v /= 2;
            }
            if(target.fragile != 0){
                v *= 2;
            }
            if(target.armor != 0){
                if(v > target.armor){
                    v -= target.armor;
                    target.armor = 0;
                }else{
                    target.armor -= v;
                    v = 0;
                }
            } 
            if(v >= target.hp){
                target.hp = 0;
            }else{
                target.hp -= v;
            }  
        }else if(effect == CardEffect::HP_A.into()){
            if(target.hp + value >= target.max_hp){
                target.hp = target.max_hp;
            }else{
                target.hp += value;
            }
        }else if(effect == CardEffect::HP_MAX_S.into()){
            if(value >= target.max_hp){
                target.max_hp = 0;
            }else{
                target.max_hp -= value;
            }
            if(target.hp >= target.max_hp){
                target.hp = target.max_hp;
            }
        }else if(effect == CardEffect::HP_MAX_A.into()){
            target.max_hp += value;
        }else if(effect == CardEffect::Armor_S.into()){
            if(value >= target.armor){
                target.armor = 0;
            }else{
                target.armor -= value;
            }
        }else if(effect == CardEffect::Armor_A.into()){
            if(target.fear != 0){
                target.armor += value/2;
            }else{
                target.armor += value;
            }
        }else if(effect == CardEffect::Energy_S.into()){
            if(value >= target.energy){
                target.energy = 0;
            }else{
                target.energy -= value;
            }
        }else if(effect == CardEffect::Energy_A.into()){
            target.energy += value;
        }else if(effect == CardEffect::Power_A_S.into()){
            if(value >= target.power){
                target.power = 0;
            }else{
                target.power -= value;
            }
        }else if(effect == CardEffect::Power_A_A.into()){
            target.power += value;
        }else if(effect == CardEffect::Power_M_S.into()){
            target.power /= value;
        }else if(effect == CardEffect::Power_M_A.into()){
            target.power *= value;
        }else if(effect == CardEffect::Fragile.into()){
            target.fragile += value;
        }else if(effect == CardEffect::Weak.into()){
            target.weak += value;
        }else if(effect == CardEffect::Fear.into()){
           target.fear += value;
        }else if(effect == CardEffect::Maintain_Armor.into()){
           target.maintain_armor += value;
        }
    }
    fn get_card_target(card_id: u32) -> CardTarget {
        match card_id.into() {
            CardID::None => CardTarget::None,
            CardID::Attack => CardTarget::SingleEnemy,
            CardID::Smash =>  CardTarget::SingleEnemy,
            CardID::InfiniteStrike => CardTarget::SingleEnemy,
            CardID::BladeDance => CardTarget::Enemies,
            CardID::Bloodthirst => CardTarget::SingleEnemy,
            CardID::Defence =>  CardTarget::Self,
            CardID::Fever =>  CardTarget::Self,
            CardID::Shout => CardTarget::Enemies,
            CardID::ShiledWall =>  CardTarget::Self,
            CardID::Avatar =>  CardTarget::Self,
            CardID::DefensiveStance =>  CardTarget::Self,
            CardID::BerserkerStance =>  CardTarget::Self,
            CardID::Bloodbath =>  CardTarget::Self,
            CardID::Bastion => CardTarget::Self,
            CardID::ShowofPower => CardTarget::Self
        }
     
    }
    fn get_card_energy(card_id: u32) -> u32{
        match card_id.into() {
            CardID::None => 0,
            CardID::Attack => 1,
            CardID::Smash => 2,
            CardID::InfiniteStrike => 2,
            CardID::BladeDance => 1,
            CardID::Bloodthirst => 1,
            CardID::Defence => 1,
            CardID::Fever => 1,
            CardID::Shout => 1,
            CardID::ShiledWall => 2,
            CardID::Avatar => 1,
            CardID::DefensiveStance => 1,
            CardID::BerserkerStance => 3,
            CardID::Bloodbath => 0,
            CardID::Bastion => 3,
            CardID::ShowofPower => 1
        }
    }
    fn get_card_cost(card_id: u32) -> bool{
        let id:CardID = card_id.into();
        if(id == CardID::None ||
            id == CardID::Attack ||
            id == CardID::Smash ||
            id == CardID::InfiniteStrike ||
            id == CardID::BladeDance ||
            id == CardID::Defence
        ){
            return false;
        } else {
            return true;
         }
    }

    fn get_card_value(card_id: u32) -> Array<u32>{

        let mut arr: Array<u32> = array![];

        match card_id.into() {
            CardID::None => {},
            CardID::Attack => arr.append(6),
            CardID::Smash =>{
                arr.append(8);
                arr.append(2);
            },
            CardID::InfiniteStrike => arr.append(12),
            CardID::BladeDance => arr.append(8),
            CardID::Bloodthirst => {
                arr.append(10);
                arr.append(3);
            },
            CardID::Defence => arr.append(5),
            CardID::Fever => arr.append(2),
            CardID::Shout => arr.append(1),
            CardID::ShiledWall => arr.append(30),
            CardID::Avatar => arr.append(2),
            CardID::DefensiveStance =>  arr.append(3),
            CardID::BerserkerStance =>  arr.append(2),
            CardID::Bloodbath => {
                arr.append(2);
                arr.append(1);
            },
            CardID::Bastion => arr.append(1),
            CardID::ShowofPower => arr.append(2)
        }
        return arr;
    }

    fn get_card_effect(card_id: u32) -> Array<Vec2>{
        let mut arr: Array<Vec2> = array![];

        match card_id.into() {
                CardID::None => {},
                CardID::Attack => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::HP_S.into()}),
                CardID::Smash => {
                    arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::HP_S.into()});
                    arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Fragile.into()});
                },
                CardID::InfiniteStrike => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::HP_S.into()}),
                CardID::BladeDance => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::HP_S.into()}),
                CardID::Bloodthirst => {
                    arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::HP_S.into()});
                    arr.append(Vec2{x:CardEffectMoment::KilledEnemy.into(),y:CardEffect::HP_MAX_A.into()});
                },
                CardID::Defence =>  arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Armor_A.into()}),
                CardID::Fever => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Energy_A.into()}),
                CardID::Shout => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Fear.into()}),
                CardID::ShiledWall => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Armor_A.into()}),
                CardID::Avatar => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Power_M_A.into()}),
                CardID::DefensiveStance => arr.append(Vec2{x:CardEffectMoment::RoundEndBuff.into(),y:CardEffect::Armor_A.into()}),
                CardID::BerserkerStance => arr.append(Vec2{x:CardEffectMoment::RoundBeginBuff.into(),y:CardEffect::Power_A_A.into()}),
                CardID::Bloodbath => {
                    arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Weak.into()});
                    arr.append(Vec2{x:CardEffectMoment::RoundBeginBuff.into(),y:CardEffect::Energy_A.into()});
                },
                CardID::Bastion => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Maintain_Armor.into()}),
                CardID::ShowofPower => arr.append(Vec2{x:CardEffectMoment::RightNow.into(),y:CardEffect::Power_A_A.into()}),
        }
        return arr;
    }
}


#[cfg(test)]
mod tests {
    use super::{CardTrait};

    #[test]
    #[ignore]
    #[available_gas(100000)]
    fn test_calculate_card() {
       //
    }

 
}
