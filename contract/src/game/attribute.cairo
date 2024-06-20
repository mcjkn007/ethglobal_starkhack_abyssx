use core::traits::AddEq;
use abyss_x::utils::math::MathU16Trait;
use abyss_x::utils::pow::{Pow128Trait};
use abyss_x::utils::bit::{Bit128Trait,Bit64Trait};
use abyss_x::utils::constant::{MIN_U8,MAX_U8,MIN_U16,MAX_U16,POW_2_U128,HAND_CARD_NUMBER_INIT};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::game::status::{StatusCategory,StatusTrait};
 

mod AttributeState{
    const Null:u8 = 0;
    const Live:u8 = 1;
    const Death:u8 = 2;
}

struct Attribute {

    state:u8,

    hp:u16,
    max_hp:u16,
 
    armor:u16,

    ability:u32,

    status:Felt252Dict<u16>,
}

impl DestructAttribute of Destruct<Attribute> {
    fn destruct(self: Attribute) nopanic {
        self.status.squash();
    }
}

 
#[generate_trait]
impl AttributeImpl of AttributeTrait {
    #[inline]
    fn new(hp:u16)->Attribute{
        return Attribute{
            state:AttributeState::Live,
            hp:hp,
            max_hp:hp,
 
            armor:0,

            ability:0,

            status:Default::default(),
        };
    }
    #[inline]
    fn add_hp(ref self:Attribute,value:u16){
        match core::integer::u16_checked_add(self.hp,value){
            Option::Some(r) =>{
                if(r > self.max_hp){
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
    #[inline]
    fn sub_hp(ref self:Attribute,value:u16){
        match core::integer::u16_checked_sub(self.hp,value){
            Option::Some(r) =>{
                self.hp = r;
            },
            Option::None =>{
                self.hp = MIN_U16;
            }
        }
    }
    #[inline]
    fn sub_hp_and_armor(ref self:Attribute,mut value:u16)->bool{
        match core::integer::u16_checked_sub(self.armor,value){
            Option::Some(r) =>{
                self.armor = r;
                return false;
            },
            Option::None =>{
                value.sub_eq_u16(self.armor);
                self.armor = MIN_U16;
                match core::integer::u16_checked_sub(self.hp,value){
                    Option::Some(r) =>{
                        self.hp = r;
                    },
                    Option::None =>{
                        self.hp = MIN_U16;
                    }
                }
                return true;
            }
        }
    }
    #[inline]
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
    #[inline]
    fn add_armor(ref self:Attribute,value:u16){
        match core::integer::u16_checked_add(self.armor,value){
            Option::Some(r) =>{
                self.armor = r;
            },
            Option::None =>{
                self.armor = MAX_U16;
            }
        }
    }
    #[inline]
    fn sub_armor(ref self:Attribute,ref value:u16){
        match core::integer::u16_checked_sub(self.armor,value){
            Option::Some(r) =>{
                self.armor = r;
            },
            Option::None =>{
                value -= self.armor;
                self.armor = MIN_U16;
            }
        }
    }

    #[inline]
    fn add_ability(ref self:Attribute,ability:u32){
        self.ability  =  self.ability & ability;
    }
    #[inline]
    fn remove_ability(ref self:Attribute,ability:u32){
        self.ability  =  self.ability & ~ability;
    }
    #[inline]
    fn game_begin(ref self:Attribute){
        self.status.game_begin();
    }
    #[inline]
    fn game_end(ref self:Attribute){
        self.status.game_end();
    }
    #[inline]
    fn round_begin(ref self:Attribute){
        self.status.round_begin();
    }
    #[inline]
    fn round_end(ref self:Attribute){
        self.status.round_end();
    }
}
#[generate_trait]
impl CalAttributerImpl of CalAttributeTrait{
 
 
}