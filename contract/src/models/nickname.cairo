use core::traits::TryInto;
use core::array::SpanTrait;
use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::model::Model;

#[derive(Model, Copy, Drop,Serde)]
struct NickName {
    #[key]
    player:ContractAddress,
 
    nickname:felt252,
}
 
#[generate_trait]
impl NickNameImpl of NickNameTrait {
    fn init(ref self:NickName){
        self.nickname = 'Sin.nombre';
    }
 
}