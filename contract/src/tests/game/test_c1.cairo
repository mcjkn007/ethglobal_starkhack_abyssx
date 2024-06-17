#[cfg(test)]
mod tests {
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
 
    use debug::PrintTrait;
    use core::array::SpanTrait;
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use abyss_x::utils::bit::{Bit256Trait};
    use abyss_x::utils::pow::{Pow256Trait,Pow128Trait};
    use abyss_x::utils::array_map::{ArrayMap,ArrayMapTrait};
    use abyss_x::utils::random::{RandomArrayTrait};
 
    use abyss_x::game::{
        charactor::c1::{C1Impl,C1CardImpl},
        adventurer::{Adventurer,AdventurerTrait},
        attribute::{Attribute,AttributeTrait},
        enemy::{Enemy,EnemyTeam3,EnemyTrait},
    };
    use abyss_x::models::{
        user::{User,UserState},
        role::{Role,RoleCategory,RoleTrait}
    };


    fn get_adv()->Adventurer{
        let mut adv:Adventurer = AdventurerTrait::new(0_u8);
        adv.seed = 123;
             
        let mut cards = 0b000000100000001000000010000000100000001_000000001_00000001_00000001_00000001_00000001;
        adv.init_cards = RoleTrait::get_cards_test(ref cards);
        
        adv.left_cards = RandomArrayTrait::random_number(ref adv.seed,adv.init_cards.len());

        adv.c_round_begin();
        return adv;
    }
    #[test]

    #[available_gas(1_000_000_000)]
    fn test_c1() {
        let mut adv:Adventurer = get_adv();
        let mut e = EnemyTrait::get_enemy(1);

       // let mut initial = testing::get_available_gas();
        
 
            let initial = testing::get_available_gas();
            gas::withdraw_gas().unwrap();

            adv.

            println!("action gas : {}", initial - testing::get_available_gas());
    }
    
   
 
}
 