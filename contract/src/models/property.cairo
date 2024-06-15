use abyss_x::utils::{
    constant::{MASK_32,DIGIT_32,MASK_8,DIGIT_8},
    bit::{BitTrait}
};

#[derive(Copy, Drop, Serde, Introspect,PartialEq)]
struct BaseProperty {
    base:u256,
    buff:u256,
    debuff:u256,
}

#[derive(Copy, Drop, Serde, Introspect,PartialEq)]
struct Property {
    c:BaseProperty,
    rb_buff:BaseProperty,
    rb_debuff:BaseProperty,
    re_buff:BaseProperty,
    re_debuff:BaseProperty,
}

 
enum PropertyBaseCategory{
    HP,
    MAX_HP,
    ENERGY,
    MAX_ENERGY,
    ARMOR,
}
impl PropertyBaseCategoryIntoU32 of Into<PropertyBaseCategory, u32> {
    fn into(self: PropertyBaseCategory) -> u32{
        match self {
            PropertyBaseCategory::HP => 0,
            PropertyBaseCategory::MAX_HP => 1,
            PropertyBaseCategory::ENERGY => 2,  
            PropertyBaseCategory::MAX_ENERGY => 3, 
            PropertyBaseCategory::ARMOR => 4, 
        }
    }
}

enum PropertyBuffCategory{
    POWER,
 
}

enum PropertyDeBuffCategory{
    FRAGILE,
    WEAK,
    FEAR,
 
}
impl PropertyDeBuffCategoryIntoU32 of Into<PropertyDeBuffCategory, u32> {
    fn into(self: PropertyDeBuffCategory) -> u32{
        match self {
            PropertyDeBuffCategory::FRAGILE => 0,
            PropertyDeBuffCategory::WEAK => 1,
            PropertyDeBuffCategory::FEAR => 2,          
        }
    }
}

#[generate_trait]
impl PropertyImpl of PropertyTrait {
    fn zero_propery()->BaseProperty{
        return BaseProperty{
            base:0,
            buff:0,
            debuff:0
        };
    }
    fn init_base_property()->BaseProperty{
        let mut result:u256 = 0;
        result += 80;//hp
    
        result += BitTrait::shift_left(80,DIGIT_32);//max hp
        result += BitTrait::shift_left(3,DIGIT_32*2);//energy 
        result += BitTrait::shift_left(3,DIGIT_32*3);//max energy 

        return BaseProperty{
            base:result,
            buff:0,
            debuff:0
        };

    }
    fn init_property()->Property{
        return Property{
                c:PropertyTrait::init_base_property(),
                rb_buff:BaseProperty{
                base:0,
                buff:0,
                debuff:0
            },
                rb_debuff:BaseProperty{
                base:0,
                buff:0,
                debuff:0
            },
                re_buff:BaseProperty{
                base:0,
                buff:0,
                debuff:0
            },
                re_debuff:BaseProperty{
                base:0,
                buff:0,
                debuff:0
            }
        };
    }
    fn get_base_property(bit:u256,category:u32)->u256{
        return BitTrait::cut_bit(bit,MASK_32,DIGIT_32*category);
    }
    fn get_status_property(bit:u256,category:u32)->u256{
        return BitTrait::cut_bit(bit,MASK_8,DIGIT_8*category);
    }
    fn modify_base_property(bit:u256,category:u32,value:u256)->u256{
        let mask = BitTrait::shift_left(MASK_32,DIGIT_32*category);
        return BitTrait::clean_bit(bit,mask) & BitTrait::shift_left(value,DIGIT_32*category);
    }
    fn modify_status_property(bit:u256,category:u32,value:u256)->u256{
        let mask = BitTrait::shift_left(MASK_8,DIGIT_8*category);
        return BitTrait::clean_bit(bit,mask) & BitTrait::shift_left(value,DIGIT_8*category);
    }
    fn add(ref self:BaseProperty,other:BaseProperty){
         
        let fear =  PropertyTrait::get_status_property(self.debuff,PropertyDeBuffCategory::FEAR.into());
        if(fear != 0){
            let mut armor:u256 = PropertyTrait::get_base_property(other.base,PropertyBaseCategory::ARMOR.into());
            armor /= 2;
 
            self.base += PropertyTrait::modify_base_property(other.base,PropertyBaseCategory::ARMOR.into(),armor);
        }else{
            self.base += other.base;
        }
         
        self.buff += other.buff;
        self.debuff += other.debuff;
        // overflow warming
         
    }
 
    fn round_end_action(ref self:Property){
        self.c.add(self.re_buff);
       // self.c.sub(self.re_debuff);
    }
}

#[cfg(test)]
mod tests {
    use super::{PropertyTrait,PropertyBaseCategory};
    
    #[test]
    #[available_gas(10000000)]
    fn test_init_property() {
        let p = PropertyTrait::init_property();

       // let a = PropertyTrait::get_base_property(p.c.base,PropertyBaseCategory::HP.into());
       //
    }

 
}