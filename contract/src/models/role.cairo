use core::option::OptionTrait;
use starknet::ContractAddress;

 

use abyss_x::utils::bit::{Bit256Trait,Bit128Trait,Bit16Trait};
use abyss_x::utils::math::{MathU8Trait};

use abyss_x::utils::constant::{POW_2_U256};

#[derive(Model, Copy, Drop, Serde)]
struct Role {
    #[key]
    player: ContractAddress,

    hp:u8,
    max_hp:u8,
    gold:u16,
    awake:u16,

    blessing:u32,

}

mod RoleCategory{
    const NONE:u32 = 0;
    const WARRIOR:u32 = 1;
    const ROGUE:u32 = 2;
    const MAGE:u32 = 3;
}

#[generate_trait]
impl RoleImpl of RoleTrait {
    fn reset(ref self:Role){
     
        self.hp = 0;
        self.max_hp = 0;
        self.awake = 0;
        self.gold = 0;

        self.blessing = 0;
 
    }
    fn get_cards(ref self:Role)->Array<u8>{
        let mut result =  ArrayTrait::<u8>::new();
 
        //let mut cards:u256 = self.cards;
        let mut cards:u256 = 0;
        result.append((cards & 0xf_u256).try_into().unwrap());
        loop{
            if(cards == 0){
                break;
            }
            cards /= POW_2_U256::_8;
            let mut v:u8 = (cards & 0xf_u256).try_into().unwrap();
 
            if(v.is_zero_u8()){
                break;
            }
            result.append(v);
        };
        return result;
    }
    fn get_cards_test(ref cards:u256)->Array<u8>{
        let mut result =  ArrayTrait::<u8>::new();
        result.append((cards & 0xf_u256).try_into().unwrap());
        loop{
            if(cards == 0){
                break;
            }
            cards /= POW_2_U256::_8;
            let mut v:u8 = (cards & 0xf_u256).try_into().unwrap();
 
            if(v.is_zero_u8()){
                break;
            }
            result.append(v);
        };
        return result;
    }
    fn rest(ref self:Role){
        match core::integer::u8_checked_add(self.hp,self.max_hp/10*3){
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
    fn awake(ref self:Role,value:u8){

        assert(Bit16Trait::is_bit(self.awake,value) == false, 'awake wrong');
     
        self.awake = Bit16Trait::set_bit(self.awake,value);
    }
    
}