use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct User {
    #[key]
    player:ContractAddress,
    nickname:felt252,
 
    state:u8,
   // temp:u32,
   // mint_ticket:u32,
}


mod UserState{
    //user
    const NONE:u8 = 0;
    const FREE:u8 = 1;
    const GAME:u8 = 2;
}
 
#[generate_trait]
impl UserImpl of UserTrait {
    fn init(ref self:User){
        self.nickname = 'Sin.nombre';
        self.state = UserState::FREE;
     //   self.mint_ticket = 0_u32;
    }
}
