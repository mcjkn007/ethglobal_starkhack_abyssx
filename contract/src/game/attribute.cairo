use core::traits::AddEq;
use abyss_x::utils::math::MathU16Trait;
use abyss_x::utils::pow::{Pow128Trait};
use abyss_x::utils::bit::{Bit128Trait,Bit64Trait};
use abyss_x::utils::constant::{MIN_U8,MAX_U8,MIN_U16,MAX_U16,POW_2_U128,HAND_CARD_NUMBER_INIT};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::game::status::{CommonStatus,StatusTrait};
use abyss_x::game::relic::{CommonRelic};


mod AttributeState{
    const Null:u8 = 0;
    const Live:u8 = 1;
    const Death:u8 = 2;
}

struct Attribute {

    state:u8,

    hp:u16,
    max_hp:u16,

    energy:u16,
    max_energy:u16,

    draw_cards:u16,

    armor:u16,

    awake:u16,
    blessing:u32,
    ability:u32,

    relic:u64,

  

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
        
            energy:3,
            max_energy:3,

            draw_cards:5,
        
            armor:0,

            awake:0,
            blessing:0,
            relic:0,

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
    fn add_energy(ref self:Attribute,value:u16){
        match core::integer::u16_checked_add(self.energy,value){
            Option::Some(r) =>{
                self.energy = r;
            },
            Option::None =>{
                self.energy = MAX_U16;
            }
        }
    }
    #[inline]
    fn sub_energy(ref self:Attribute,value:u16){
        match core::integer::u16_checked_sub(self.energy,value){
            Option::Some(r) =>{
                self.energy = r;
            },
            Option::None =>{
                self.energy = MIN_U16;
            }
        }
    }
    #[inline]
    fn add_max_energy(ref self:Attribute,value:u16){
        match core::integer::u16_checked_add(self.max_energy,value){
            Option::Some(r) =>{
                self.max_energy = r;
            },
            Option::None =>{
                self.max_energy = MAX_U16;
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
     
        //  

        //在每场战斗开始时，额外抽 2 张牌。
        match Bit64Trait::is_bit_fast(self.relic,CommonRelic::R1){
            true => self.draw_cards.add_eq(2),
            false => {}
        }
        self.status.game_begin();
    }
    #[inline]
    fn game_end(ref self:Attribute){
        //在战斗结束时，回复6点生命。
        match Bit64Trait::is_bit_fast(self.relic,CommonRelic::R0){
            true=> self.add_hp(6),
            false => {}
        }
        self.status.game_end();
    }
    #[inline]
    fn round_begin(ref self:Attribute){
        //多余的能量可以留到下一回合。
        match Bit64Trait::is_bit_fast(self.relic,CommonRelic::R5){
            true=>  self.energy.add_eq_u16(self.max_energy),
            false =>  self.energy = self.max_energy
        }

        self.draw_cards = HAND_CARD_NUMBER_INIT;
        self.status.round_begin();
    }
    #[inline]
    fn round_end(ref self:Attribute){
      // 如果你在回合结束时没有任何格挡，获得6点格挡。
      match Bit64Trait::is_bit_fast(self.relic,CommonRelic::R3){
        true=> {
            if(self.armor.is_zero_u16()){
                self.add_armor(6);
            }
        },
        false => {}
    }
        self.status.round_end();
    }
}
#[generate_trait]
impl CalAttributerImpl of CalAttributeTrait{
 
 
}