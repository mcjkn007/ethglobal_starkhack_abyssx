use core::dict::Felt252DictTrait;
 
use abyss_x::utils::math::{MathU32Trait};
 
struct Vector<T> {
    vector:Felt252Dict<T>,
    size:u32
}
 
 pub trait VectorTrait<T> {
    fn new()->Vector<T>;
    fn size(self: @Vector<T>)->u32;
    fn empty(self: @Vector<T>)->bool;
    fn at(ref self:Vector<T>, index: u32)->T;
    fn replace(ref self:Vector<T>, index: u32,value:T);
    fn insert(ref self:Vector<T>,index:u32,value:T);
    fn swap(ref self:Vector<T>,begin:u32,end:u32);
    fn remove(ref self:Vector<T>,index:u32);
    fn push_back(ref self:Vector<T>,value:T);
    fn pop_back(ref self:Vector<T>)->T;
   
}
 
impl DestructVec<T, +Drop<T>,+Felt252DictValue<T>> of Destruct<Vector<T>> {
    fn destruct(self: Vector<T>) nopanic {
        self.vector.squash();
    }
}
 
impl VectorImpl<T,+Drop<T>, +Copy<T>,+Felt252DictValue<T>> of VectorTrait<T> {
    fn new()->Vector<T>{
        return Vector{
            vector:Default::default(),
            size:0_u32
        };
    }
    #[inline(always)]
    fn size(self: @Vector<T>) -> u32{
        return *self.size;
    }
    fn empty(self:@ Vector<T>) -> bool{
        return *self.size == 0_u32;
    }
    fn at(ref self:Vector<T>, index: u32)->T{
        return self.vector.get(index.into());
    }
    fn replace(ref self:Vector<T>, index: u32,value:T){
        self.vector.insert(index.into(), value);
    }
 
    fn insert(ref self:Vector<T>,index:u32,value:T){
        if(index == MathU32Trait::sub_u32(self.size,1_u32)){
            self.vector.insert(index.into(),value);
        }else{
            let mut i = self.size;
            loop{
                if(i == index){
                    break;
                }
                 self.vector.insert(i.into(),self.vector.get((i.self_sub__u32()).into()));     
            };
            self.vector.insert(index.into(),value);
        }
        self.size.self_add_u32();
    }
  
    fn swap(ref self:Vector<T>,begin:u32,end:u32){
        let v = self.vector.get(begin.into());
        self.vector.insert(begin.into(),self.vector.get(end.into()));
        self.vector.insert(end.into(),v);
    }
     
    fn remove(ref self:Vector<T>,index:u32){
        let size = MathU32Trait::sub_u32(self.size,1_u32);
        if(index == size){
            self.size.self_sub_u32();
        }else{
            let mut i = index;
            loop{
                if(i == size){
                    break;
                }
                self.vector.insert(i.into(),self.vector.get((i.self_add__u32()).into()));
            };
            self.size.self_sub_u32();
        }  
    }
    fn push_back(ref self:Vector<T>,value:T){
        self.vector.insert(self.size.into(),value);
        self.size.self_add_u32();
    }
    fn pop_back(ref self:Vector<T>)->T{
        return self.vector.get((self.size.self_sub__u32()).into());
    }
}


 