
use abyss_x::game::attribute::{Attribute,AttributeTrait};
use abyss_x::game::enemy::{Enemy,EnemyTeam3};
 
use abyss_x::utils::dict_map::{DictMap,DictMapTrait};
use abyss_x::utils::random::{RandomTrait,RandomContainerTrait};
use abyss_x::utils::math::{MathU32Trait,MathU16Trait};
use abyss_x::utils::constant::{HAND_CARD_NUMBER_MAX,CardTarget};

use abyss_x::game::charactor::c1::{C1ExplorerImpl};
use abyss_x::game::charactor::c2::{C2ExplorerImpl};

 
#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum ExplorerCategory {
    C1,
    C2,
}

impl U8IntoExplorerCategory of Into<u8, ExplorerCategory> {
    fn into(self: u8) -> ExplorerCategory {
        match self {
            0 => ExplorerCategory::C1,
            1 => ExplorerCategory::C2,
            _ => ExplorerCategory::C1
        }
    }
}
 
#[derive(Destruct)]
struct Explorer {
    seed:u64,
    hand_cards_init:u32,
    attr:Attribute,
    category:ExplorerCategory,

    role_cards:Array<u8>,
    left_cards:Array<u8>,
    mid_cards:DictMap<u8>,
    right_cards:Array<u8>,
}

pub trait ExplorerInheritTrait {
    fn init_explorer() -> Explorer;
 
    fn get_card_target(card_id: u8)->CardTarget;
    fn get_card_energy(card_id: u8) -> u8;
    
    fn use_card_self(ref self:Explorer,card_id:u8);
    fn use_card(ref self:Explorer,ref target:Enemy,card_id:u8);
}

#[generate_trait]
impl ExplorerImpl of ExplorerTrait{
    fn round_begin(ref self:Explorer){
        self.draw_cards_from_left(self.hand_cards_init);
        self.attr.round_begin();
    }
    fn round_end(ref self:Explorer){
        self.discard_cards();
        self.attr.round_end();
    }
     
    fn draw_cards_from_left(ref self:Explorer,draw_count:u32){
        
        if(self.mid_cards.size() == HAND_CARD_NUMBER_MAX){
            return;
        }

        let mut draw_count = draw_count;
        let count = HAND_CARD_NUMBER_MAX - self.mid_cards.size();
        if(count < draw_count){
            draw_count = count;
        }

        let size = self.left_cards.len();
        let mut i:u32 = 0_u32;
        if(draw_count < size){
            loop{
                if(i == draw_count){
                    break;
                }
                //let v = self.left_cards.pop_front().unwrap();
               // self.mid_cards.push_back(v);
               // println!("draw_cards_from_left gas : {}", v);
                self.mid_cards.push_back(self.left_cards.pop_front().unwrap());
                i.self_add_u32();
            };
        }else if(draw_count == size){
            loop{
                if(i == draw_count){
                    break;
                }
                //let v = self.left_cards.pop_front().unwrap();
                //self.mid_cards.push_back(v);
                //println!("draw_cards_from_left gas : {}", v);
                self.mid_cards.push_back(self.left_cards.pop_front().unwrap());
                i.self_add_u32();
            };
            self.left_cards = RandomContainerTrait::random_ref_array(ref self.seed,ref self.right_cards);
        }else{
            loop{
                if(i == size){
                    break;
                }
                 
                self.mid_cards.push_back(self.left_cards.pop_front().unwrap());
                i.self_add_u32();
            };
      
            self.left_cards = RandomContainerTrait::random_ref_array(ref self.seed,ref self.right_cards);
            loop{
                if(i == draw_count){
                    break;
                }
                self.mid_cards.push_back(self.left_cards.pop_front().unwrap());
                i.self_add_u32();
            };
        }
    }
    fn draw_cards_from_right(ref self:Explorer,draw_count:u32){
        let mut i:u32 = 0_u32;
        let size = self.right_cards.len();
        loop{
            if(i == draw_count || i == size || self.mid_cards.size() == HAND_CARD_NUMBER_MAX){
                break;
            }
            self.mid_cards.push_back(self.right_cards.pop_front().unwrap());
            i.self_add_u32();
        };
    }
    fn discard_card(ref self:Explorer,card:u8){
        self.mid_cards.remove_value(card);
        self.right_cards.append(card);
    }
    fn consume_card(ref self:Explorer,card:u8){
        self.mid_cards.remove_value(card);
    }
    fn discard_cards(ref self:Explorer){
        loop{
            if(self.mid_cards.size() == 0_u32){
                self.mid_cards.clean_value_dict();
                break;
            }
            self.right_cards.append(self.mid_cards.pop_back_fast());
        };
    }
    
    fn init_explorer(category:ExplorerCategory) -> Explorer{
        return match category {
            ExplorerCategory::C1 => C1ExplorerImpl::init_explorer(),
            ExplorerCategory::C2 => C2ExplorerImpl::init_explorer(),
            _ => C1ExplorerImpl::init_explorer(),
        };
    }
    fn explorer_e1_action(ref self:Explorer,ref target:Enemy,opt:u16){
        let card_index = (opt/256_u16).try_into().unwrap();
        assert(self.mid_cards.check_value(card_index), 'card void');

        let card_id = *self.role_cards.at(card_index.into());

        match self.category {
            ExplorerCategory::C1 => {
                match C1ExplorerImpl::get_card_target(card_id) {
                    CardTarget::Self => C1ExplorerImpl::use_card_self(ref self,card_id),
                    CardTarget::One => C1ExplorerImpl::use_card(ref self,ref target,card_id),
                    CardTarget::All => C1ExplorerImpl::use_card(ref self,ref target,card_id),
                }     
            },
            ExplorerCategory::C2 => {
                match C2ExplorerImpl::get_card_target(card_id) {
                    CardTarget::Self => C2ExplorerImpl::use_card_self(ref self,card_id),
                    CardTarget::One => C2ExplorerImpl::use_card(ref self,ref target,card_id),
                    CardTarget::All => C2ExplorerImpl::use_card(ref self,ref target,card_id),
                }     
            },
            _ => {}
        };
        self.discard_card(card_index);
    }
    fn explorer_e3_action(ref self:Explorer,ref target:EnemyTeam3,opt:u16){
        let card_index:u8 = (opt/256_u16).try_into().unwrap();
        let card_target:u8  = (opt%256_u16).try_into().unwrap();
        assert(self.mid_cards.check_value(card_index), 'card void');

        let card_id = *self.role_cards.at(card_index.into());
                
         
        match self.category {
            ExplorerCategory::C1 => {
                match C1ExplorerImpl::get_card_target(card_id) {
                    CardTarget::Self => C1ExplorerImpl::use_card_self(ref self,card_id),
                    CardTarget::One => {
                        match card_target {
                            0 => {
                                C1ExplorerImpl::use_card(ref self,ref target.e1,card_id);
                            },
                            1 => {
                                C1ExplorerImpl::use_card(ref self,ref target.e2,card_id);
                            },
                            2 => {
                                C1ExplorerImpl::use_card(ref self,ref target.e3,card_id);
                            },
                            _ =>{}
                        };
                    },
                    CardTarget::All => {
                        if(target.e1.attr.hp != 0){
                            C1ExplorerImpl::use_card(ref self,ref target.e1,card_id);
                        }
                        if(target.e2.attr.hp != 0){
                            C1ExplorerImpl::use_card(ref self,ref target.e2,card_id);
                        }
                        if(target.e3.attr.hp != 0){
                            C1ExplorerImpl::use_card(ref self,ref target.e3,card_id);
                        }
                    }
                } 
            },
            ExplorerCategory::C2 => {
                match C2ExplorerImpl::get_card_target(card_id) {
                    CardTarget::Self => C2ExplorerImpl::use_card_self(ref self,card_id),
                    CardTarget::One => {
                        match card_target {
                            0 => {
                                C2ExplorerImpl::use_card(ref self,ref target.e1,card_id);
                            },
                            1 => {
                                C2ExplorerImpl::use_card(ref self,ref target.e2,card_id);
                            },
                            2 => {
                                C2ExplorerImpl::use_card(ref self,ref target.e3,card_id);
                            },
                            _ =>{}
                        };
                    },
                    CardTarget::All => {
                        if(target.e1.attr.hp != 0){
                            C2ExplorerImpl::use_card(ref self,ref target.e1,card_id);
                        }
                        if(target.e2.attr.hp != 0){
                            C2ExplorerImpl::use_card(ref self,ref target.e2,card_id);
                        }
                        if(target.e3.attr.hp != 0){
                            C2ExplorerImpl::use_card(ref self,ref target.e3,card_id);
                        }
                    }
                } 
            },
            _ => {}
        };

        self.discard_card(card_index);
    }
}
 
 

 
 