use abyss_x::game::attribute::{Attribute,AttributeTrait};

pub trait DamageTrait {
    fn calculate_damage_dealt(ref self:Attribute,ref value:u16,);
    fn damage_taken(ref self:Attribute, value:u16);

    fn calculate_direct_damage_dealt(ref self:Attribute,ref value:u16);
    fn direct_damage_taken(ref self:Attribute, value:u16);
}
