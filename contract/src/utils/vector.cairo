use core::dict::Felt252DictTrait;
use core::nullable::{NullableTrait, match_nullable, FromNullableResult};

struct Vector<T> {
    data:Felt252Dict<Nullable<T>>,
    size:u32
}
 
 pub trait VectorTrait<T> {
    fn new()->Vector<T>;
    fn size(self: @Vector<T>)->u32;
    fn empty(self: @Vector<T>)->bool;
    fn at(ref self:Vector<T>, index: u32)->T;
    fn insert(ref self:Vector<T>,index:u32,data:T);
    fn remove(ref self:Vector<T>,index:u32);
    fn push_back(ref self:Vector<T>,data:T);
    fn pop_back(ref self:Vector<T>)->T;
}

impl DestructVec<T, +Drop<T>> of Destruct<Vector<T>> {
    fn destruct(self: Vector<T>) nopanic {
        self.data.squash();
    }
}
 
impl VectorImpl<T,+Drop<T>, +Copy<T>> of VectorTrait<T> {
    fn new()->Vector<T>{
        return Vector{
            data:Default::default(),
            size:0
        };
    }
    fn size(self: @Vector<T>) -> u32{
        return *self.size;
    }
    fn empty(self:@ Vector<T>) -> bool{
        return *self.size == 0;
    }
    fn at(ref self:Vector<T>, index: u32)->T{
        assert(index < self.size(), 'Index out of bounds');
        let val = self.data.get(index.into());
        let result = match match_nullable(val) {
            FromNullableResult::Null => panic!("No value found"),
            FromNullableResult::NotNull(val) => val.unbox(),
        };
        return result;
    }
    fn insert(ref self:Vector<T>,index:u32,data:T){
        assert(index < self.size(), 'Index out of bounds');
        if(index == self.size()-1){
            self.data.insert(index.into(),NullableTrait::new(data));
        }else{
            let mut i = self.size();
            loop{
                if(i < index){
                    break;
                }
                 self.insert(i.into(),self.at(i-1));
                i -= 1;
            }
        }
         self.size += 1;
    }
    fn remove(ref self:Vector<T>,index:u32){
        assert(index < self.size(), 'Index out of bounds');
        if(index ==self.size() -1){
            self.pop_back();
        }else{
            let mut i = index;
            loop{
                if(i < self.size()){
                    break;
                }
                self.insert(i.into(),self.at(i+1));
                i += 1;
            };
            self.size -= 1;
        }  
    }
    fn push_back(ref self:Vector<T>,data:T){
        self.data.insert(self.size.into(),NullableTrait::new(data));
        self.size += 1;
    }
    fn pop_back(ref self:Vector<T>)->T{
        assert(self.size() != 0, 'Vector is empty');
        let result = self.at(self.size-1);
        self.size -= 1;
        return result;
    }
}


#[cfg(test)]
mod tests {
    use super::{Vector,VectorTrait};
 
    #[test]
    #[ignore]
    #[available_gas(100_000_000)]
    fn test_vector() {
        println!("---------vector_test----------");

        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
         
        let mut result = VectorTrait::<u8>::new();
        let mut gas = initial - testing::get_available_gas();
        println!("vector new gas : {}", gas);

        initial = testing::get_available_gas();
        result.push_back(1);
        gas = initial - testing::get_available_gas();
        println!("vector push gas : {}", gas);

        initial = testing::get_available_gas();
        let a = result.at(0);
        gas = initial - testing::get_available_gas();
        println!("vector get gas : {}", gas);
        println!("---------vector_test----------");
    }
}
