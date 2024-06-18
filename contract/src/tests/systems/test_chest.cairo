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
        systems::{
            chest::{chest,IChestDispatcher,IChestDispatcherTrait},
            home::{home,IHomeDispatcher,IHomeDispatcherTrait},
            battle::{battle,IBattleDispatcher,IBattleDispatcherTrait}
        },
        models::{user::{User,user},
      
        },
         
    };


    #[test]
    #[available_gas(3000000000)]
    fn test_camp_system() {

        // models
        let mut models = array![user::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        let home_system = IHomeDispatcher { contract_address:world.deploy_contract('home', home::TEST_CLASS_HASH.try_into().unwrap()) };
        home_system.login();

        let battle_system = IBattleDispatcher { contract_address:world.deploy_contract('battle', battle::TEST_CLASS_HASH.try_into().unwrap()) };
        battle_system.start_game(1,1);

        // deploy systems contract
        let chest_system = IChestDispatcher { contract_address:world.deploy_contract('chest', chest::TEST_CLASS_HASH.try_into().unwrap()) };
       
        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
 
        chest_system.chest_action();
        
        println!("chest_action gas : {}", initial-testing::get_available_gas());
     
      
    }
}