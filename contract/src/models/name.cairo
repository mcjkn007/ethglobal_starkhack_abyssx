use core::traits::TryInto;
use core::array::SpanTrait;
use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::model::Model;

#[derive(Model, Copy, Drop,Serde)]
struct Name {
    #[key]
    player:ContractAddress,
 
    name:felt252,
}
 
#[generate_trait]
impl NameImpl of NameTrait {
    fn init(ref self:Name){
        self.name = 'Sin.nombre';
    }
 
}