use core::traits::TryInto;
use core::array::SpanTrait;
use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo::model::Model;

#[derive(Copy, Drop,Serde)]
#[dojo::model]
struct Name {
    #[key]
    player:ContractAddress,
 
    name:felt252,
}
 
#[generate_trait]
impl NameImpl of NameTrait {
    #[inline]
    fn init(ref self:Name){
        self.name = 'Sin.nombre';
    }
 
}