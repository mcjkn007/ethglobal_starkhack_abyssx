use core::option::OptionTrait;
use starknet::ContractAddress;

 

use abyss_x::utils::bit::{Bit256Trait,Bit128Trait,Bit16Trait};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::utils::constant::{POW_2_U256};

#[derive(Copy, Drop, Serde,IntrospectPacked)]
#[dojo::model]
struct Role {
    #[key]
    player: ContractAddress,
    cur_stage:u8,

    hp:u16,
    max_hp:u16,

    talent:u16,
    blessing:u32,

    relic:u64,
    seed:u64,
}

mod RoleCategory{
    const NONE:u32 = 0;
    const WARRIOR:u32 = 1;
    const ROGUE:u32 = 2;
    const MAGE:u32 = 3;
}

#[generate_trait]
impl RoleImpl of RoleTrait {
    #[inline]
    fn reset(ref self:Role){
     
        self.hp = 0;
        self.max_hp = 0;
      
        self.cur_stage = 0;

        self.talent = 0;
        self.blessing = 0;
        self.relic = 0;
        self.seed = 0;
 
    }
    #[inline]
    fn rest(ref self:Role){
        match core::integer::u16_checked_add(self.hp,self.max_hp/4){
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
    fn talent(ref self:Role,value:u8){

        assert(Bit16Trait::is_bit(self.talent,value) == false, 'Talent wrong');
     
        self.talent = Bit16Trait::set_bit(self.talent,value);
    }
    
}