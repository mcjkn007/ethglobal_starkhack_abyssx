
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait,RandomArrayTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};

use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam2,EnemyTeam3};
use abyss_x::game::charactor::c1::{C1Impl,C1DamageImpl};
use abyss_x::game::charactor::c2::{C2Impl,C2DamageImpl};
use abyss_x::game::status::{Status};

use abyss_x::models::role::{Role,RoleTrait};
 

 
const ADVTURER_C1:u8 = 0;
const ADVTURER_C2:u8 = 1;
 
#[derive(Destruct)]
struct Adventurer{
    seed:u64,
    attr:Attribute,
    category:u8,
 
    init_cards:Array<u8>,
    left_cards:Array<u8>,
    mid_cards:DictMap<u8>,
    right_cards:Array<u8>,
}

pub trait AdventurerBaseTrait {
    fn new() -> Adventurer;
 
    fn get_card_energy(card_id: u8) -> u16;

    fn game_begin_e1(ref self:Adventurer,ref target:Enemy);
    fn game_begin_e2(ref self:Adventurer,ref target:EnemyTeam2);
    fn game_begin_e3(ref self:Adventurer,ref target:EnemyTeam3);

    fn round_begin_e1(ref self:Adventurer,ref target:Enemy);
    fn round_begin_e2(ref self:Adventurer,ref target:EnemyTeam2);
    fn round_begin_e3(ref self:Adventurer,ref target:EnemyTeam3);
    
    fn round_end_e1(ref self:Adventurer,ref target:Enemy);
    fn round_end_e2(ref self:Adventurer,ref target:EnemyTeam2);
    fn round_end_e3(ref self:Adventurer,ref target:EnemyTeam3);

    fn use_card_e1(ref self:Adventurer,ref target:Enemy,opt:u16);
    fn use_card_e2(ref self:Adventurer,ref target:EnemyTeam2,card_id:u8);
    fn use_card_e3(ref self:Adventurer,ref target:EnemyTeam3,card_id:u8);
}

#[generate_trait]
impl AdventurerImpl of AdventurerTrait{
    #[inline]
    fn new(category:u8) -> Adventurer{
        return match category {
            0 => C1Impl::new(),
            1 => C2Impl::new(),
            _ => panic!("error init exp"),
        };
    }
    #[inline]
    fn init(ref self:Adventurer,ref role:Role){
        self.seed = role.seed;
             
        self.attr.hp = role.hp;
        self.attr.idols = role.idols;

      //  let mut seed = role.seed+role.hp.into()+role.cur_stage.into();
        self.seed = 123;
 
        self.init_cards = role.get_cards();
        
        self.left_cards = RandomArrayTrait::random_number(ref self.seed,self.init_cards.len());
       
          
    }
    #[inline]
    fn c_game_begin_e1(ref self:Adventurer,ref target:Enemy){
        match self.category {
            0 => C1Impl::game_begin_e1(ref self,ref target),
            1 => C2Impl::game_begin_e1(ref self,ref target),
            _ => panic!("error init exp"),
        };
    }
    #[inline]
    fn c_round_begin_e1(ref self:Adventurer,ref target:Enemy){
        match self.category {
            0 => C1Impl::round_begin_e1(ref self,ref target),
            1 => C2Impl::round_begin_e1(ref self,ref target),
            _ => panic!("error init exp"),
        };
    }
    #[inline]
    fn c_round_end_e1(ref self:Adventurer,ref target:Enemy){
        match self.category {
            0 => C1Impl::round_end_e1(ref self,ref target),
            1 => C2Impl::round_end_e1(ref self,ref target),
            _ => panic!("error init exp"),
        };
    }
    #[inline]
    fn c_calculate_damage_dealt(ref self:Adventurer,ref value:u16){
        match self.category {
            0 => C1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            1 => C2DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            _ => panic!("error init exp"),
        };
    }
    #[inline]
    fn c_damage_taken(ref self:Adventurer, value:u16){
        match self.category {
            0 => C1DamageImpl::damage_taken(ref self.attr, value),
            1 => C2DamageImpl::damage_taken(ref self.attr, value),
            _ => panic!("error init exp"),
        };
    }
    #[inline]
    fn c_calculate_direct_damage_dealt(ref self:Adventurer,ref value:u16){
        match self.category {
            0 => C1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            1 => C2DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            _ => panic!("error init exp"),
        };
    }
    #[inline]
    fn c_direct_damage_taken(ref self:Adventurer, value:u16){
        match self.category {
            0 => C1DamageImpl::direct_damage_taken(ref self.attr, value),
            1 => C2DamageImpl::direct_damage_taken(ref self.attr, value),
            _ => panic!("error init exp"),
        };
    }
    fn draw_cards_from_left(ref self:Adventurer,mut draw_count:u16){
        if(self.mid_cards.size() == HAND_CARD_NUMBER_MAX){
            return;
        }
         
    
        loop{
            match self.left_cards.pop_front() {
                Option::Some(r) => {
                  //  println!("draw_cards_from_left gas : {}",r);
        
                    self.mid_cards.push_back(r);

                    draw_count.self_sub_u16();
                    if(draw_count.is_zero_u16()){
                        break;
                    }
                    if(self.mid_cards.size() == HAND_CARD_NUMBER_MAX){
                        break;
                    }
                     
                },
                Option::None => {
                    if(self.right_cards.len().is_zero_u32()){
                        break;
                    }
                    self.left_cards = RandomContainerTrait::random_array(ref self.seed,@self.right_cards);
                    self.right_cards = ArrayTrait::<u8>::new();
                },
            }
        };
    }
    
    fn draw_cards_from_right(ref self:Adventurer,mut draw_count:u32){
        if(self.mid_cards.size() == HAND_CARD_NUMBER_MAX){
            return;
        }

        loop{
            match self.right_cards.pop_front() {
                Option::Some(r) => {
                    self.mid_cards.push_back(r);

                    draw_count.self_sub_u32();
                    if(self.mid_cards.size() == HAND_CARD_NUMBER_MAX){
                        break;
                    }
                    if(draw_count.is_zero_u32()){
                        break;
                    }
                },
                Option::None => {
                    break;
                },
            }
        };
    }
    fn discard_card(ref self:Adventurer,card:u8){
        self.mid_cards.remove_value(card);
        self.right_cards.append(card);
    }
    #[inline]
    fn consume_card(ref self:Adventurer,card:u8){
        self.mid_cards.remove_value(card);
    }
    fn discard_cards(ref self:Adventurer){
        loop{
            if(self.mid_cards.empty()){
                self.mid_cards.clean_value_dict();
                break;
            }
            self.right_cards.append(self.mid_cards.pop_back_fast());
        };
    }
    fn round_end_disard_cards(ref self:Adventurer){
        loop{
            if(self.mid_cards.empty()){
                self.mid_cards.clean_value_dict();
                break;
            }
            self.right_cards.append(self.mid_cards.pop_back_fast());
        };
    }
     
    #[inline]
    fn explorer_e1_action(ref self:Adventurer,ref target:Enemy,opt:u16){
        match self.category {
            0 => C1Impl::use_card_e1(ref self,ref target,opt),
            1 => C2Impl::use_card_e1(ref self,ref target,opt),
            _ => panic!("error action exp")
        };
    }
    fn explorer_e2_action(ref self:Adventurer,ref target:EnemyTeam2,opt:u16){
        
    }
    fn explorer_e3_action(ref self:Adventurer,ref target:EnemyTeam3,opt:u16){
        
    }
}
 
 

 
 