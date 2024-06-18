use core::dict::Felt252DictTrait;
use abyss_x::utils::math::{MathU8Trait,MathU16Trait};


use abyss_x::game::attribute::{Attribute,AttributeTrait};

 
mod CommonStatus{
    const Weak:felt252 = 'c_weak';//虚弱 造成伤害-25
    const Fragile:felt252 = 'c_fragile';//易碎 受到伤害+50
    const Fear:felt252 = 'c_fear';//畏惧 护甲加成-25

    const Thorns:felt252 = 'c_thorns';//荆棘 受到3点伤害
    const Amplify_Damage:felt252 = 'c_amplify_damage';//伤害加深

}
 

#[generate_trait]
impl StatusImpl of StatusTrait {
    #[inline]
    fn cal_damage_status(ref self:Felt252Dict<u16>,ref value:u16){
        let ad = self.get(CommonStatus::Amplify_Damage);
        value.add_eq_u16(ad);
        
        match self.get(CommonStatus::Weak){
            0=> {},
            _=> {
                value.mul_eq(2_u16);
            },
        }
    }
    #[inline]
    fn cal_damaged_status(ref self:Felt252Dict<u16>,ref value:u16){
        match self.get(CommonStatus::Fragile){
            0=> {},
            _=> {
                value.mul_eq(2_u16);
            },
        }
    }
    #[inline]
    fn cal_armor_status(ref self:Felt252Dict<u16>,ref value:u16){
        match self.get(CommonStatus::Fear){
            0=> {},
            _=> {
                value.div_eq(4_u16);
                value.mul_eq(3_u16);
            },
        }
       
    }
    #[inline]
    fn round_begin(ref self:Felt252Dict<u16>){
        
    }
    #[inline]
    fn round_end(ref self:Felt252Dict<u16>){
        let s1:u16 = self.get(CommonStatus::Weak);
        if(s1.is_no_zero_u16()){
            self.insert(CommonStatus::Weak,MathU16Trait::sub_u16(s1,1));
        }
        let s2:u16 = self.get(CommonStatus::Fragile);
        if(s2.is_no_zero_u16()){
            self.insert(CommonStatus::Fragile,MathU16Trait::sub_u16(s2,1));
        }
        let s3:u16 = self.get(CommonStatus::Fear);
        if(s3.is_no_zero_u16()){
            self.insert(CommonStatus::Fear,MathU16Trait::sub_u16(s3,1));
        }
    }
}