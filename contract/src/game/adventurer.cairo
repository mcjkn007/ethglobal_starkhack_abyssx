 
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait,RandomArrayTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait,MathU8Trait};
use abyss_x::utils::bit::{Bit64Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX,HAND_CARD_NUMBER_INIT,DebuffCard,MAX_U16,MIN_U16};
 
use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::relic::{RelicCategory,RelicTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam2,EnemyTeam3,EnemyCategory};
use abyss_x::game::charactor::c1::{C1Action1Impl,C1Action2Impl,C1EntityImpl,C1DamageImpl};
use abyss_x::game::charactor::c2::{C2ActionImpl,C2EntityImpl,C2DamageImpl};
 
use abyss_x::models::role::{Role,RoleTrait};
use abyss_x::models::card::{Card,CardTrait};
 
 
 
#[derive(Destruct)]
struct Adventurer{
    seed:u64,
    attr:Attribute,
    category:u8,

    energy:u16,
    max_energy:u16,

    draw_cards:u16,

    talent:u16,
    blessing:u32,
    relic:u64,

    init_cards:Array<u8>,
    left_cards:Array<u8>,
    mid_cards:DictMap<u8>,
    right_cards:Array<u8>,
}

 
pub trait AdventurerTrait<T> {
     
    fn c_game_begin(ref self:Adventurer,ref target:T);
    fn c_game_end(ref self:Adventurer,ref target:T);
    fn c_round_begin(ref self:Adventurer,ref target:T);
    fn c_round_end(ref self:Adventurer,ref target:T);

    fn c_adv_action(ref self:Adventurer,ref target:T,opt:u16);
    fn c_action_feedback(ref self:Adventurer,ref target:T,ref value:u16);

}

#[generate_trait]
impl AdventurerCommonImpl of AdventurerCommonTrait{
    #[inline]
    fn new(category:u8) -> Adventurer{
        return match category {
            0 => panic!("error init"),
            1 => C1EntityImpl::new(),
            2 => C2EntityImpl::new(),
            _ => panic!("error init"),
        };
    }
    
    #[inline]
    fn init(ref self:Adventurer,ref role:Role,ref card:Card){
        
        self.attr.hp = role.hp.into();
        self.attr.max_hp = role.max_hp.into();
       
        self.talent = role.talent;
        self.blessing =  role.blessing;
        self.relic = role.relic;

 
        self.seed = role.seed;
        self.seed = 123;

        self.init_cards = card.get_cards();
    }
    #[inline]
    fn add_energy(ref self:Adventurer,value:u16){
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
    fn sub_energy(ref self:Adventurer,value:u16){
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
    fn add_max_energy(ref self:Adventurer,value:u16){
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
    fn c_calculate_damage_dealt(ref self:Adventurer,ref value:u16){
        match self.category {
            0 => panic!("error"),
            1 => C1DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            2 => C2DamageImpl::calculate_damage_dealt(ref self.attr,ref value),
            _ => panic!("error"),
        };
    }
    #[inline]
    fn c_damage_taken(ref self:Adventurer,ref target:Attribute, value:u16){
        match self.category {
            0 => panic!("error"),
            1 => C1DamageImpl::damage_taken(ref self.attr,ref target, value),
            2 => C2DamageImpl::damage_taken(ref self.attr,ref target, value),
            _ => panic!("error"),
        };
    }
    #[inline]
    fn c_calculate_direct_damage_dealt(ref self:Adventurer,ref value:u16){
        match self.category {
            0 => panic!("error"),
            1 => C1DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            2 => C2DamageImpl::calculate_direct_damage_dealt(ref self.attr,ref value),
            _ => panic!("error"),
        };
    }
    #[inline]
    fn c_direct_damage_taken(ref self:Adventurer,value:u16){
        match self.category {
            0 => panic!("error"),
            1 => C1DamageImpl::direct_damage_taken(ref self.attr, value),
            2 => C2DamageImpl::direct_damage_taken(ref self.attr,value),
            _ => panic!("error"),
        };
    }
    #[inline]
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
    #[inline]
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
    #[inline]
    fn discard_cards(ref self:Adventurer){
        loop{
            if(self.mid_cards.empty()){
                self.mid_cards.clean_value_dict();
                break;
            }
            self.right_cards.append(self.mid_cards.pop_back_fast());
        };
    }
    #[inline]
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

impl Adv_EnemyImpl of AdventurerTrait<Enemy>{
  
    #[inline]
    fn c_game_begin(ref self:Adventurer,ref target:Enemy){

        //检测遗物
        //在每场战斗开始时，额外抽 2 张牌。
        self.check_relic_2();
        //在Boss战与精英战中，你的最大能量+1
        self.check_relic_13(target.category);

        self.left_cards = RandomArrayTrait::random_number(ref self.seed,self.init_cards.len()); 
        self.draw_cards_from_left(self.draw_cards); 

        match self.category {
            0 => {},
            1 => C1Action1Impl::game_begin(ref self,ref target),
            2 => C2ActionImpl::game_begin(ref self,ref target),
            _ => {},
        };
    }
    #[inline]
    fn c_game_end(ref self:Adventurer,ref target:Enemy){
        //在战斗结束时，回复6点生命。
        self.check_relic_1();

        match self.category {
            0 => {},
            1 => C1Action1Impl::game_begin(ref self,ref target),
            2 => C2ActionImpl::game_begin(ref self,ref target),
            _ => {},
        };
    }
    #[inline]
    fn c_round_begin(ref self:Adventurer,ref target:Enemy){
        //多余的能量可以留到下一回合。
        self.check_relic_6();

        self.draw_cards_from_left(self.draw_cards);
        self.attr.round_begin();

        match self.category {
            0 => {},
            1 => C1Action1Impl::round_begin(ref self,ref target),
            2 => C2ActionImpl::round_begin(ref self,ref target),
            _ => {},
        };
    }
    #[inline]
    fn c_round_end(ref self:Adventurer,ref target:Enemy){
        //如果你在回合结束时没有任何格挡，获得6点格挡。
        self.check_relic_4();
        //你在回合结束时不再自动丢弃所有手牌。
        self.check_relic_5();

        self.attr.round_end();

        match self.category {
            0 => {},
            1 => C1Action1Impl::round_end(ref self,ref target),
            2 => C2ActionImpl::round_end(ref self,ref target),
            _ => {},
        };
    }
    #[inline]
    fn c_adv_action(ref self:Adventurer,ref target:Enemy,opt:u16){
        match self.category {
            0 => {},
            1 => C1Action1Impl::action(ref self,ref target,opt),
            2 => C2ActionImpl::action(ref self,ref target,opt),
            _ => {}
        };
    }
    #[inline]
    fn c_action_feedback(ref self:Adventurer,ref target:Enemy,ref value:u16){
        match self.category {
            0 => {},
            1 => C1Action1Impl::action_feedback(ref self,ref target,value),
            2 => C2ActionImpl::action_feedback(ref self,ref target,value),
            _ => {},
        };
    }
}
impl Adv_EnemyTeam2Impl of AdventurerTrait<EnemyTeam2>{

    #[inline]
    fn c_game_begin(ref self:Adventurer,ref target:EnemyTeam2){

        //在每场战斗开始时，额外抽 2 张牌。
        self.check_relic_2();
        //在Boss战与精英战中，你的最大能量+1
        self.check_relic_13(target.e1.category);

        self.left_cards = RandomArrayTrait::random_number(ref self.seed,self.init_cards.len()); 
        self.draw_cards_from_left(self.draw_cards); 

 
        
        match self.category {
            0 => {},
            1 => C1Action2Impl::game_begin(ref self,ref target),
            2 => {},
            _ => {},
        };
    }
    #[inline]
    fn c_game_end(ref self:Adventurer,ref target:EnemyTeam2){
        match self.category {
            0 => {},
            1 => C1Action2Impl::game_begin(ref self,ref target),
            2 => {},
            _ => {},
        };
    }
    #[inline]
    fn c_round_begin(ref self:Adventurer,ref target:EnemyTeam2){

        self.draw_cards_from_left(self.draw_cards);
        self.draw_cards = HAND_CARD_NUMBER_INIT;

        self.attr.round_begin();
 
        match self.category {
            0 => {},
            1 => C1Action2Impl::round_begin(ref self,ref target),
            2 => {},
            _ => {},
        };
    }
    #[inline]
    fn c_round_end(ref self:Adventurer,ref target:EnemyTeam2){
        //你在回合结束时不再自动丢弃所有手牌。
        self.check_relic_5();
        
        self.attr.round_end();

        match self.category {
            0 => {},
            1 => C1Action2Impl::round_end(ref self,ref target),
            2 => {},
            _ => {},
        };
    }
    #[inline]
    fn c_adv_action(ref self:Adventurer,ref target:EnemyTeam2,opt:u16){
        match self.category {
            0 => {},
            1 => C1Action2Impl::action(ref self,ref target,opt),
            2 => {},
            _ => {}
        };
    }
    #[inline]
    fn c_action_feedback(ref self:Adventurer,ref target:EnemyTeam2,ref value:u16){
        match self.category {
            0 => {},
            1 => C1Action2Impl::action_feedback(ref self,ref target,value),
            2 => {},
            _ => {},
        };
    }
}
 
 
 

 
 