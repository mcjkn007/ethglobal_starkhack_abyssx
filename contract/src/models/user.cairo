use core::traits::TryInto;
use core::array::SpanTrait;
use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::model::Model;

#[derive(Copy, Drop,Serde,IntrospectPacked)]
#[dojo::model]
struct User {
    #[key]
    player:ContractAddress,

    state:u8,
    game_mode:u8,
    role_category:u8,
}
 

mod UserState{
    //user
    const NONE:u8 = 0;
    const FREE:u8 = 1;
    const GAME:u8 = 2;
}
 
#[generate_trait]
impl UserImpl of UserTrait {
    #[inline]
    fn reset(ref self:User){

        self.state = UserState::FREE;
        self.game_mode = 0;
        self.role_category = 0;
    }
    fn read_user(world: IWorldDispatcher,key:felt252){
        
      
    }
}
