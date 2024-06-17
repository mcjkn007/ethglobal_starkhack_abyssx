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
        systems::{home::{home,IHomeDispatcher,IHomeDispatcherTrait}
        },
        models::{user::{User,user},
      
        },
         
    };


    #[test]
    #[available_gas(3000000000)]
    fn test_home_system() {

        // models
        let mut models = array![user::TEST_CLASS_HASH];

        // deploy world with models
        let world = spawn_test_world(models);

        // deploy systems contract
        let home_system = IHomeDispatcher { contract_address:world.deploy_contract('home', home::TEST_CLASS_HASH.try_into().unwrap()) };
        println!("---------test_home_system_begin----------");
        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();

        home_system.login();
       
        println!("login gas : {}", initial-testing::get_available_gas());

        initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();

        home_system.set_nickname('black');
        
        println!("set_nickname gas : {}", initial-testing::get_available_gas());
        println!("---------test_home_system_end----------");
      
    }
}
