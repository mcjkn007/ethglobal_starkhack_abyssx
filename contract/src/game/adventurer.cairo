
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait,RandomArrayTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX};

use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam2,EnemyTeam3};
use abyss_x::game::charactor::c1::{C1ActionImpl,C1DamageImpl};
use abyss_x::game::charactor::c2::{C2ActionImpl,C2DamageImpl};
 
use abyss_x::models::role::{Role,RoleTrait};
use abyss_x::models::card::{Card,CardTrait};
 
 
 
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

 
pub trait AdventurerTrait<T> {
    fn c_game_begin(ref self:Adventurer,ref target:T);
    fn c_round_begin(ref self:Adventurer,ref target:T);
    fn c_round_end(ref self:Adventurer,ref target:T);

    fn c_adv_action(ref self:Adventurer,ref target:T,opt:u16);
    fn c_action_feedback(ref self:Adventurer,ref target:T,ref value:u16);

}
impl AdventurerImpl of AdventurerTrait<Enemy>{
    #[inline]
    fn c_game_begin(ref self:Adventurer,ref target:Enemy){
        match self.category {
            0 => panic!("c_game_begin1"),
            1 => C1ActionImpl::game_begin(ref self,ref target),
            2 => C2ActionImpl::game_begin(ref self,ref target),
            _ => panic!("c_game_begin2"),
        };
    }
    #[inline]
    fn c_round_begin(ref self:Adventurer,ref target:Enemy){
        match self.category {
            0 => panic!("c_round_begin"),
            1 => C1ActionImpl::round_begin(ref self,ref target),
            2 => C2ActionImpl::round_begin(ref self,ref target),
            _ => panic!("c_round_begin"),
        };
    }
    #[inline]
    fn c_round_end(ref self:Adventurer,ref target:Enemy){
        match self.category {
            0 => panic!("c_round_end"),
            1 => C1ActionImpl::round_end(ref self,ref target),
            2 => C2ActionImpl::round_end(ref self,ref target),
            _ => panic!("c_round_end"),
        };
    }
    #[inline]
    fn c_adv_action(ref self:Adventurer,ref target:Enemy,opt:u16){
        match self.category {
            0 => panic!("c_adv_action"),
            1 => C1ActionImpl::action(ref self,ref target,opt),
            2 => C2ActionImpl::action(ref self,ref target,opt),
            _ => panic!("c_adv_action")
        };
    }
    #[inline]
    fn c_action_feedback(ref self:Adventurer,ref target:Enemy,ref value:u16){
        match self.category {
            0 => panic!("c_action_feedback"),
            1 => C1ActionImpl::action_feedback(ref self,ref target,value),
            2 => C2ActionImpl::action_feedback(ref self,ref target,value),
            _ => panic!("c_action_feedback"),
        };
    }
}

#[generate_trait]
impl AdventurerCommonImpl of AdventurerCommonTrait{
    #[inline]
    fn new(category:u8) -> Adventurer{
        return match category {
            0 => panic!("error init"),
            1 => C1ActionImpl::new(),
            2 => C2ActionImpl::new(),
            _ => panic!("error init"),
        };
    }
    #[inline]
    fn init(ref self:Adventurer,seed:u64,idols:u64,ref role:Role,ref card:Card){
        self.seed = seed;
        self.attr.idols = idols;

        self.attr.hp = role.hp.into();
        self.attr.max_hp = role.max_hp.into();
        self.attr.awake = role.awake;

    //  let mut seed = role.seed+role.hp.into()+role.cur_stage.into();
        self.seed = 123;

        self.init_cards = card.get_cards();
        
        self.left_cards = RandomArrayTrait::random_number(ref self.seed,self.init_cards.len());
    
        
    }
    #[inline]
    fn c_calculate_damage_dealt(ref self:Adventurer,ref value:u16){
        match self.category {
            0 => panic!("c_calculate_damage_dealt"),
            1 => C1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            2 => C2DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            _ => panic!("c_calculate_damage_dealt"),
        };
    }
    #[inline]
    fn c_damage_taken(ref self:Adventurer,ref target:Attribute, value:u16){
        match self.category {
            0 => panic!("c_damage_taken"),
            1 => C1DamageImpl::damage_taken(ref self.attr,ref target, value),
            2 => C2DamageImpl::damage_taken(ref self.attr,ref target, value),
            _ => panic!("c_damage_taken"),
        };
    }
    #[inline]
    fn c_calculate_direct_damage_dealt(ref self:Adventurer,ref value:u16){
        match self.category {
            0 => panic!("c_calculate_direct_damage_dealt"),
            1 => C1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            2 => C2DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            _ => panic!("c_calculate_direct_damage_dealt"),
        };
    }
    #[inline]
    fn c_direct_damage_taken(ref self:Adventurer,value:u16){
        match self.category {
            0 => panic!("c_direct_damage_taken"),
            1 => C1DamageImpl::direct_damage_taken(ref self.attr, value),
            2 => C2DamageImpl::direct_damage_taken(ref self.attr,value),
            _ => panic!("c_calculate_direct_damage_dealt"),
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
    #[inline]
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
     
    
   
}
 
 

 
 