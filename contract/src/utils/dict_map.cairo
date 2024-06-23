
use abyss_x::utils::math::{MathU32Trait};
use core::Felt252DictTrait;


struct DictMap{
    value:Felt252Dict<u8>,
    key:Felt252Dict<u8>,
    size:u32,
    max:u32,
}

impl DestructDictMap of Destruct<DictMap>{
    fn destruct(self: DictMap) nopanic {
        self.value.squash();
        self.key.squash();
    }
}

 
#[generate_trait]
impl DictMapImpl of DictMapTrait {
    #[inline]
    fn new()->DictMap{
        return DictMap{
            value:Default::default(),
            key:Default::default(),
            size:0,
            max:0
        };
    }
    #[inline]
    fn size(self: @DictMap) -> u32{
        return *self.size;
    }
    #[inline]
    fn empty(self:@DictMap) -> bool{
        return (*self.size) == 0;
    }
    #[inline]
    fn at(ref self:DictMap, index: u32)->u8{
        return self.value.get(index.into());
    }
    #[inline]
    fn check_value(ref self:DictMap, value: u8)->bool{
        return self.key.get(value.into()) > 0;
    }
    #[inline]
    fn remove_value(ref self:DictMap, value: u8){
        let mut i = 0;
        loop{
            if(i == self.size){
                break;
            }
            if(self.value.get(i.into()) == value){
                self.value.insert(i.into(),0);
                self.key.insert(value.into(),0);
                self.size -=1;
                break;
            }
            i +=1;
        };
    }

    #[inline]
    fn push_back(ref self:DictMap,value:u8){
        let mut i:u8 = 0;
        loop{
            if(self.size == 10){
                break;
            }
            if(self.value.get(i.into()) == 0){
                self.value.insert(i.into(),value);
                self.key.insert(value.into(),i+1);
                self.size +=1;
                self.max +=1;
                break;
            }
            i +=1;
        };
    }
    #[inline]
    fn pop_all(ref self:DictMap)->Array<u8>{
        let mut result = ArrayTrait::new();
        let mut i:u32 = 0;
        loop{
            if(i == self.max){
                break;
            }
            if(self.value.get(i.into()) != 0){
                result.append(self.value.get(i.into()));
            }
            i +=1;
        };
        self.value = Default::default();
        self.key = Default::default();
        self.size = 0;
        self.max = 0;
        
        return result;
    }
    
    
}

 