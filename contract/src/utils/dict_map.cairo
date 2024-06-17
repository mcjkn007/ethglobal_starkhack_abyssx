
use abyss_x::utils::math::{MathU32Trait};
use core::Felt252DictTrait;


struct DictMap<T>{
    key:Felt252Dict<T>,
    value:Felt252Dict<u32>,
    size:u32,
}

impl DestructDictMap<T, +Drop<T>, +Felt252DictValue<T>> of Destruct<DictMap<T>> {
    fn destruct(self: DictMap<T>) nopanic {
        self.key.squash();
        self.value.squash();
    }
}

 
 
#[generate_trait]
impl DictMapImpl<T, +Drop<T>, +Copy<T>,+PartialEq<T>,+Felt252DictValue<T>,+Into<u8,T>,+Into<T,u32>,+Into<T,felt252>> of DictMapTrait<T> {
    fn new()->DictMap<T>{
        return DictMap{
            key:Default::default(),
            value:Default::default(),
            size:0_u32
        };
    }
    #[inline(always)]
    fn size(self: @DictMap<T>) -> u32{
        return *self.size;
    }
    fn empty(self:@DictMap<T>) -> bool{
        return *self.size == 0_u32;
    }
    fn at(ref self:DictMap<T>, index: u32)->T{
        return self.key.get(index.into());
    }
    fn check_value(ref self:DictMap<T>, value: T)->bool{
        return self.value.get(value.into()) != 0_u8.into();
    }
    fn remove_value(ref self:DictMap<T>, value: T){
        let index:u32 = self.value.get(value.into());
        if(index != self.size){    
            self.key.insert((index).into(), self.key.get(self.size.into()));
        }
        self.value.insert(value.into(),0_u8.into());
        self.size.self_sub_u32();
    }
    
    fn push_back(ref self:DictMap<T>,value:T){
        self.key.insert((self.size.self_add__u32()).into(),value);
        self.value.insert(value.into(),self.size);
    }
 
    fn pop_back(ref self:DictMap<T>)->T{
        let result = self.key.get((self.size.self_sub__u32()).into());
        self.value.insert(result.into(),0_u8.into());
        return result;
    }
    fn pop_back_fast(ref self:DictMap<T>)->T{
        return self.key.get((self.size.self_sub__u32()).into());
    }
    fn clean_value_dict(ref self:DictMap<T>){
        self.value = Default::default();
    }
}

 