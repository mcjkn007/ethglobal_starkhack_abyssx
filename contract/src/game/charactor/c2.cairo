 
 
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};
use abyss_x::utils::bit::{Bit128Trait};

use abyss_x::game::adventurer::{Adventurer,AdventurerTrait,AdventurerCommonTrait};
use abyss_x::game::attribute::{Attribute,AttributeTrait,CalAttributeTrait};
use abyss_x::game::status::{StatusTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam2,EnemyTeam3};

use abyss_x::game::action::{ActionTrait,DamageTrait};
 
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

#[derive(Destruct)]
struct C2{
    seed:u64,
    attr:Attribute,
    category:u8,
 
    init_cards:Array<u8>,
    left_cards:Array<u8>,
    mid_cards:DictMap<u8>,
    right_cards:Array<u8>,
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
    fn new() -> Adventurer{
        return Adventurer{
            seed:0,
            attr:AttributeTrait::new(80),
            category:2,
            init_cards:ArrayTrait::<u8>::new(),
            left_cards:ArrayTrait::<u8>::new(),
            mid_cards:DictMapTrait::<u8>::new(),
            right_cards:ArrayTrait::<u8>::new(),
        };
    } 
 
 

    fn game_begin(ref self:Adventurer,ref target:Enemy){}
   

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

#[generate_trait]
impl C2CardImpl of C2CardTrait{
    fn get_card_energy(card_id: u8) -> u16{
        return match card_id {
            0 => 1,
            1 => 1,
            _ => 1
        };
    }
}