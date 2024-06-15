use starknet::ContractAddress;
 

#[derive(Model, Copy, Drop, Serde)]
struct User {
    #[key]
    player:ContractAddress,
    nickname:felt252,
    state:UserState,
    score:u32,
}

#[derive(Serde, Copy, Drop, Introspect,PartialEq)]
enum UserState {
    None,
    Free,
    StageBegin,
    StageEnd,
}

impl UserStateIntoU32 of Into<UserState, u32> {
    fn into(self: UserState) -> u32 {
        match self {
            UserState::None => 0,
            UserState::Free => 1,
            UserState::StageBegin => 2,
            UserState::StageEnd => 3,
 
        }
    }
}

#[generate_trait]
impl UserImpl of UserTrait {
    fn init_user(player:ContractAddress)->User{
        return User{
            player:player,
            nickname:'red',
            state:UserState::Free,
            score:0
        };
    }
}
