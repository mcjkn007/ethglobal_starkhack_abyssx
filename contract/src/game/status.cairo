use core::dict::Felt252DictTrait;
use abyss_x::utils::math::{MathU8Trait,MathU16Trait};

use abyss_x::utils::bit::{Bit64Trait};
use abyss_x::game::attribute::{Attribute,AttributeTrait};
 
 
mod StatusCategory{
    const Weak:felt252 = 'c_weak';//虚弱 造成伤害-25
    const Fragile:felt252 = 'c_fragile';//易碎 受到伤害+50
    const Fear:felt252 = 'c_fear';//畏惧 护甲加成-25

    const Thorns:felt252 = 'c_thorns';//荆棘 受到3点伤害
    const AD:felt252 = 'c_amplify_damage';//伤害加深

}
 

#[generate_trait]
impl StatusImpl of StatusTrait {
    #[inline]
    fn add_weak(ref self:Attribute,value:u16){
        self.status.insert(StatusCategory::Weak,MathU16Trait::add_u16(self.status.get(StatusCategory::Weak),value));
    }
    #[inline]
    fn add_fragile(ref self:Attribute,value:u16){
        self.status.insert(StatusCategory::Fragile,MathU16Trait::add_u16(self.status.get(StatusCategory::Fragile),value));
    }
    #[inline]
    fn add_fear(ref self:Attribute,value:u16){
        self.status.insert(StatusCategory::Fear,MathU16Trait::add_u16(self.status.get(StatusCategory::Fear),value));
    }
    #[inline]
    fn add_thorns(ref self:Attribute,value:u16){
        self.status.insert(StatusCategory::Thorns,MathU16Trait::add_u16(self.status.get(StatusCategory::Thorns),value));
    }
    #[inline]
    fn add_ad(ref self:Attribute,value:u16){
        self.status.insert(StatusCategory::AD,MathU16Trait::add_u16(self.status.get(StatusCategory::AD),value));
    }

    #[inline]
    fn cal_damage_status(ref self:Felt252Dict<u16>,ref value:u16){
        let ad = self.get(StatusCategory::AD);
        value.add_eq_u16(ad);
        
        match self.get(StatusCategory::Weak){
            0=> {},
            _=> {
                value.mul_eq(2_u16);
            },
        }
    }
    #[inline]
    fn cal_damaged_status(ref self:Felt252Dict<u16>,ref value:u16){
        match self.get(StatusCategory::Fragile){
            0=> {},
            _=> {
                value.mul_eq(2_u16);
            },
        }
    }
    #[inline]
    fn cal_armor_status(ref self:Felt252Dict<u16>,ref value:u16){
        match self.get(StatusCategory::Fear){
            0=> {},
            _=> {
                value.div_eq(4_u16);
                value.mul_eq(3_u16);
            },
        }
       
    }
    #[inline]
    fn game_begin(ref self:Felt252Dict<u16>){
      
    }
    #[inline]
    fn game_end(ref self:Felt252Dict<u16>){
     
    }
    #[inline]
    fn round_begin(ref self:Felt252Dict<u16>){
        
    }
    #[inline]
    fn round_end(ref self:Felt252Dict<u16>){
        let s1:u16 = self.get(StatusCategory::Weak);
        if(s1 > 0){
            self.insert(StatusCategory::Weak,MathU16Trait::sub_u16(s1,1));
        }
        let s2:u16 = self.get(StatusCategory::Fragile);
        if(s2 > 0){
            self.insert(StatusCategory::Fragile,MathU16Trait::sub_u16(s2,1));
        }
        let s3:u16 = self.get(StatusCategory::Fear);
        if(s3 > 0){
            self.insert(StatusCategory::Fear,MathU16Trait::sub_u16(s3,1));
        }
    }
}