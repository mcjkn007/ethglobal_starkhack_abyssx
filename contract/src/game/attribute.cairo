use core::traits::DivEq;
use core::traits::MulEq;
 
use abyss_x::utils::pow::{Pow128Trait};
use abyss_x::utils::bit::{Bit128Trait};
use abyss_x::utils::constant::{MIN_U8,MAX_U8,MIN_U16,MAX_U16,POW_2_u128};
use abyss_x::utils::math::{MathU8Trait};
 
mod AttributeAbility{
    const Maintain_Armor:u128 = 0x1_u128;
}
 
#[derive(Copy,Drop, Serde)]
struct Attribute {
    hp:u16,
    max_hp:u16,

    energy:u8,
    max_energy:u8,

    armor:u16,

    str:u16,
    agi:u16,

    weak:u8,//虚弱 造成伤害-50
    fever:u8,//狂热 造成伤害+50

    fragile:u8,//易碎 受到伤害+50
    courage:u8,//勇气 受到伤害-50

    fear:u8,//畏惧 护甲加成-50
    sturdy:u8,//坚强 护甲加成+50
     
    ability:u128,

    idols:u256,
 
}

 
#[generate_trait]
impl AttributeImpl of AttributeTrait {
    fn add_hp(ref self:Attribute,value:u16){
        match core::integer::u16_checked_add(self.hp,value){
            Option::Some(r) =>{
                if(r >= self.max_hp){
                    self.hp = self.max_hp;
                }else{
                    self.hp = r;
                }
            },
            Option::None =>{
                self.hp = self.max_hp;
            }
        }
    }
 
    fn sub_hp_max(ref self:Attribute,value:u16){
        match core::integer::u16_checked_sub(self.max_hp,value){
            Option::Some(r) =>{
                self.max_hp = r;
            },
            Option::None =>{
                self.max_hp = MIN_U16;
            }
        }
        if(self.hp > self.max_hp){
            self.hp = self.max_hp;
        }
    }
 
    fn sub_armor(ref self:Attribute,ref value:u16){
        match core::integer::u16_checked_sub(self.armor,value){
            Option::Some(r) =>{
                self.armor = r;
            },
            Option::None =>{
                value = value - self.armor;
                self.armor = MIN_U16;
            }
        }
    }
    
    #[inline(always)]
    fn add_ability(ref self:Attribute,ability:u128){
        self.ability  =  self.ability & ability;
    }
    #[inline(always)]
    fn sub_ability(ref self:Attribute,ability:u128){
        self.ability  =  self.ability & ~ability;
    }
    fn init_attribute()->Attribute{
        return Attribute{
            hp:100_u16,
            max_hp:100_u16,
        
            energy:3_u8,
            max_energy:3_u8,
        
            armor:0_u16,
        
            str:0_u16,
            agi:0_u16,
        
            weak:0_u8, 
            fever:0_u8,
        
            fragile:0_u8,
            courage:0_u8,
        
            fear:0_u8,
            sturdy:0_u8,
             
        
            ability:0_u128,
        
            idols:0_u256,
  
        };
    }

    fn cal_damage_self_status(ref self:Attribute,ref value:u16){
         
        if(self.weak != 0_u8){
            value.div_eq(2_u16);
        }
        if(self.fever != 0_u8){
            value.mul_eq(2_u16);
        }
    }

    fn cal_damage_target_status(ref self:Attribute,ref value:u16){
        if(self.fragile != 0_u8){
            value.mul_eq(2_u16);
        }
        if(self.courage != 0_u8){
            value.div_eq(2_u16);
        }
    }

    fn cal_armor_self_status(ref self:Attribute,ref value:u16){
        if(self.fear != 0_u8){
            value.div_eq(2_u16);
        }
        if(self.sturdy != 0_u8){
            value.mul_eq(2_u16);
        }
    }
 
    fn round_begin(ref self:Attribute){
        self.energy = self.max_energy;

        if(Bit128Trait::is_bit_fast(self.ability,AttributeAbility::Maintain_Armor)){
             
        }else{
            self.armor = 0;
        }
        self.weak.self_sub_u8();
        self.fever.self_sub_u8();
        self.fragile.self_sub_u8();
        self.courage.self_sub_u8();
        self.fear.self_sub_u8();
        self.sturdy.self_sub_u8();
    }
    fn round_end(ref self:Attribute){
  
      
    }
}
 