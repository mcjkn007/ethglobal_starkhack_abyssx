use core::array::ArrayTrait;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::traits::Into;
 

use poseidon::PoseidonTrait;
use hash::HashStateTrait;
use debug::PrintTrait;

trait SeedTrait {
    fn create_seed(p1:felt252,p2:felt252,p3:felt252)->u64;
}
impl SeedImpl of SeedTrait {
    fn create_seed(p1:felt252,p2:felt252,p3:felt252)->u64{
        let mut state = PoseidonTrait::new();
        state = state.update(p1);
        state = state.update(p2);
        state = state.update(p3);
        let mut v:u256 = state.finalize().into();
        v = v & 0x7fffffff;
        return v.try_into().unwrap();
    }
}