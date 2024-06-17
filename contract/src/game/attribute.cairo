use abyss_x::utils::math::MathU16Trait;
use abyss_x::utils::pow::{Pow128Trait};
use abyss_x::utils::bit::{Bit128Trait};
use abyss_x::utils::constant::{MIN_U8,MAX_U8,MIN_U16,MAX_U16,POW_2_U128,HAND_CARD_NUMBER_INIT};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::game::status::{Status,StatusTrait};
use abyss_x::game::charactor::c1::{C1StatusTrait};


#[derive(Destruct)]
struct Attribute {
    hp:u16,
    max_hp:u16,

    energy:u16,
    max_energy:u16,

    draw_cards:u16,

    armor:u16,

    status:Felt252Dict<u16>,

    ability:u128,
    idols:u256,
}

 
#[generate_trait]
impl AttributeImpl  of AttributeTrait {
    #[inline]
    fn new(hp:u16)->Attribute{
        return Attribute{
            hp:hp,
            max_hp:hp,
        
            energy:3,
            max_energy:3,
            draw_cards:5,
        
            armor:0_u16,
        
           // str:0_u16,
           // agi:0_u16,

          //  status:StatusTrait::new(),
            //sp_status:SPStatusTrait::new(),
            status:Default::default(),
            ability:0_u128,
            idols:0_u256,
             
         //   c_status:Default::default(),
  
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
    fn add_ability(ref self:Attribute,ability:u128){
        self.ability  =  self.ability & ability;
    }
    #[inline]
    fn remove_ability(ref self:Attribute,ability:u128){
        self.ability  =  self.ability & ~ability;
    }
 
    fn round_begin(ref self:Attribute){
        self.status.round_begin();
        self.energy = self.max_energy;
        self.draw_cards = HAND_CARD_NUMBER_INIT;
    }
    fn round_end(ref self:Attribute){
      //  self.draw_cards.sub_eq_u16(self.status.fewer_cards.into());
        self.status.round_end();
    }
}
#[generate_trait]
impl CalAttributerImpl of CalAttributeTrait{
 
 
}