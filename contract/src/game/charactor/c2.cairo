 
 
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::bit::{Bit128Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::attribute::{Attribute,AttributeTrait,CalAttributeTrait};
use abyss_x::game::status::{StatusTrait};
use abyss_x::game::enemy::{Enemy,EnemyTrait};

use abyss_x::game::action::{EntityTrait,ActionTrait,DamageTrait,CardInfoTrait};
 
mod C2CardID{
    const Attack:u8 = 1_u8;
    const Defence:u8 = 2_u8;
}
 

mod C2CardCost{
    const Attack:u8 = 1_u8;
    const Defence:u8 = 1_u8;
} 
 
mod C2CardValue{
    const Attack:u16 = 6_u16;
    const Defence:u16 = 5_u16;
} 
 
impl C2EntityImpl of EntityTrait<Adventurer> {
    #[inline]
    fn new()->Adventurer{
        return Adventurer{
            seed:0,
            attr:AttributeTrait::new(80),
            category:1,
            energy:3,
            max_energy:3,
            draw_cards:5,
            talent:0,
            blessing:0,
            relic:0,
            relic_flag:0,
            init_cards:ArrayTrait::<u8>::new(),
            left_cards:ArrayTrait::<u8>::new(),
            mid_cards:DictMapTrait::new(),
            right_cards:ArrayTrait::<u8>::new()
        };
    }
}

impl C2DamageImpl of DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,){
        self.status.cal_damage_status(ref value);
    }
    fn  damage_taken(ref self:Attribute,ref target:Attribute, mut value:u16){
      
         
        self.status.cal_damaged_status(ref value);

        self.sub_hp_and_armor(value); 
    }

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16){

    }
    fn  direct_damage_taken(ref self:Attribute,mut value:u16){

    }
}


impl C2ActionImpl of ActionTrait<Adventurer,Enemy>{
 
    #[inline]
    fn game_begin(ref self:Adventurer,ref target:Enemy){
       
    }
    #[inline]
    fn game_end(ref self:Adventurer,ref target:Enemy){
       
    }

    fn round_begin(ref self:Adventurer,ref target:Enemy){}
   
    fn round_end(ref self:Adventurer,ref target:Enemy){}

    fn action_feedback(ref self:Adventurer,ref target:Enemy,data:u16){

    }
    fn action(ref self:Adventurer,ref target:Enemy,data:u16){
        let card_index = (data/256_u16).try_into().unwrap();
        println!("card_index c2 gas : {}", card_index);
        assert(self.mid_cards.check_value(card_index), 'card void');
 
    }
}
impl C2CardInfoImpl of  CardInfoTrait {
    fn get_card_energy(card_id: u8) -> u16{
        return match card_id {
            0 => 1,
            1 => 1,
            2 => 1,
            3 => 1,
            4 => 1,
            5 => 1,
            6 => 1,
            7 => 1,
            8 => 1,
            9 => 1,
            10 => 1,
            11 => 1,
            12 => 1,
            13 => 1,
            14 => 1,
            15 => 1,
            16 => 1,
            17 => 1,
            18 => 1,
            19 => 1,
            20 => 1,
            21 => 1,
            22 => 1,
            23 => 1,
            24 => 1,
            25 => 1,
            26 => 1,
            27 => 1,
            28 => 1,
            29 => 1,
            30 => 1,
            31 => 1,
            32 => 1,
            33 => 1,
            34 => 1,
            35 => 1,
            36 => 1,
            37 => 1,
            38 => 1,
            39 => 1,
            40 => 1,
            41 => 1,
            42 => 1,
            43 => 1,
            44 => 1,
            45 => 1,
            46 => 1,
            47 => 1,
            48 => 1,
            49 => 1,
            50 => 1,
            51 => 1,
            _ => 1,
        };
    }
    fn get_card_category(card_id: u8) -> u16{
        return match card_id {
            0 => 0,
            1 => 1,
            2 => 2,
            3 => 1,
            4 => 1,
            5 => 2,
            6 => 2,
            7 => 2,
            8 => 2,
            9 => 3,
            10 => 3,
            11 => 1,
            12 => 1,
            13 => 1,
            14 => 1,
            15 => 1,
            16 => 1,
            17 => 1,
            18 => 1,
            19 => 2,
            20 => 2,
            21 => 3,
            22 => 3,
            23 => 3,
            24 => 1,
            25 => 1,
            26 => 1,
            27 => 1,
            28 => 1,
            29 => 1,
            30 => 1,
            31 => 2,
            32 => 2,
            33 => 2,
            34 => 2,
            35 => 3,
            36 => 3,
            37 => 3,
            38 => 1,
            39 => 1,
            40 => 1,
            41 => 1,
            42 => 2,
            43 => 2,
            44 => 2,
            45 => 2,
            46 => 2,
            47 => 2,
            48 => 3,
            49 => 3,
            50 => 3,
            51 => 3,
            _ => 1,
        };
    }
    fn get_card_rarity(card_id: u8) -> u8{
        return match card_id {
            0 => 0,
            1 => 0,
            2 => 1,
            3 => 3,
            4 => 1,
            5 => 2,
            6 => 3,
            7 => 1,
            8 => 1,
            9 => 3,
            10 => 2,
            11 => 1,
            12 => 1,
            13 => 2,
            14 => 1,
            15 => 1,
            16 => 2,
            17 => 2,
            18 => 2,
            19 => 2,
            20 => 1,
            21 => 2,
            22 => 3,
            23 => 3,
            24 => 3,
            25 => 1,
            26 => 1,
            27 => 2,
            28 => 2,
            29 => 3,
            30 => 2,
            31 => 1,
            32 => 3,
            33 => 3,
            34 => 1,
            35 => 1,
            36 => 3,
            37 => 2,
            38 => 2,
            39 => 1,
            40 => 2,
            41 => 1,
            42 => 1,
            43 => 2,
            44 => 2,
            45 => 3,
            46 => 2,
            47 => 3,
            48 => 2,
            49 => 3,
            50 => 2,
            51 => 3,
            _ => 1,
        };
    }
    fn get_random_card_by_rarity(seed:u64,card_rarity:u8)->u8{
        return 1;
    }
}

#[generate_trait]
impl C2CardImpl of C2CardTrait{
    
}