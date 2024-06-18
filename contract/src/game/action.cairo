
use abyss_x::game::attribute::{Attribute,AttributeTrait};

pub trait ActionTrait<T,V> {
    fn new() -> T;

    fn game_begin(ref self:T,ref target:V);
    fn round_begin(ref self:T,ref target:V);
    fn round_end(ref self:T,ref target:V);

    fn action_feedback(ref self:T,ref target:V,data:u16);

    fn action(ref self:T,ref target:V,data:u16);
}

pub trait DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,);
    fn damage_taken(ref self:Attribute, value:u16);

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16);
    fn direct_damage_taken(ref self:Attribute, value:u16);
}
