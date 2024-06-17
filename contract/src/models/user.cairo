use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct User {
    #[key]
    player:ContractAddress,
    nickname:felt252,
    state:u8
}


mod UserState{
    //user
    const NONE:u8 = 0;
    const FREE:u8 = 1;
    const GAME_BATTLE:u8 = 2;
    const GAME_EVENT:u8 = 3;
}
 
#[generate_trait]
impl UserImpl of UserTrait {
    fn init_user(player:ContractAddress)->User{
        return User{
            player:player,
            nickname:'Sin.nombre',
            state:UserState::FREE
        };
    }
}
