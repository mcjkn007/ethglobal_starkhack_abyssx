use starknet::ContractAddress;
use abyss_x::utils::bit::{Bit256Trait};
use abyss_x::utils::math::{MathU8Trait};

#[derive(Model, Copy, Drop, Serde)]
struct Role {
    #[key]
    player: ContractAddress,
    #[key]
    category:u8,

    seed:u64,

    game_mode:u8,
    cur_stage:u8,
     
    hp:u16,
    gold:u16,

    cards:u256,
    idols:u256,

    temp:u256,
}

mod RoleCategory{
    const NONE:u32 = 0;
    const WARRIOR:u32 = 1;
    const ROGUE:u32 = 2;
    const MAGE:u32 = 3;
}

#[generate_trait]
impl RoleImpl of RoleTrait {
    fn reset_role(ref self:Role){
        self.seed = 0;

        self.game_mode = 0;
        self.cur_stage = 0;

        self.hp = 0;
        self.gold = 0;

        self.cards = 0;
        self.idols = 0;
        self.temp = 0;
    
    }
    fn get_cards(ref self:Role)->Array<u8>{
        let mut result =  ArrayTrait::<u8>::new();
        let mut i:u8 = 0_u8;
       
        loop{
            if(i == 32_u8){
                break;
            }
            let v:u8 = Bit256Trait::cut_bit_8(self.cards,i*8_u8).try_into().unwrap();
            if(v == 0_u8){
                break;
            }
            result.append(v);

            i.self_add_u8();
        };
        return result;
    }
 
}