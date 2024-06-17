#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
 
    use debug::PrintTrait;


    // import test utils
    use abyss_x::{
        systems::{home::{home, IHomeDispatcher, IHomeDispatcherTrait},
                    battle::{battle,IBattleDispatcher,IBattleDispatcherTrait}
        },
        models::{user::{User,user},
                role::{Role,role}
      
        },
         
    };


    #[test]
    #[available_gas(3000000000)]
    fn test_battle_system() {

        // models
        let mut models = array![user::TEST_CLASS_HASH,role::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let home_system = IHomeDispatcher { contract_address:world.deploy_contract('home', home::TEST_CLASS_HASH.try_into().unwrap()) };
        home_system.login();
 
        let battle_system = IBattleDispatcher { contract_address:world.deploy_contract('battle', battle::TEST_CLASS_HASH.try_into().unwrap()) };
        println!("---------test_battle_system_begin----------");
         
        battle_system.start_game(1,0);
  
        let mut arr:Array<u16> = array![]; 
        arr.append(257);
        arr.append(1280);
        arr.append(2048);

        arr.append(0);

        arr.append(1);
        arr.append(513);
        arr.append(1536);
        arr.append(0);

        arr.append(1);


        let initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
        battle_system.check_e1_battle_result(arr,0,0);
       
        println!("check_battle_result gas : {}", initial - testing::get_available_gas());
         
        println!("---------test_battle_system_end----------");
    }
}
