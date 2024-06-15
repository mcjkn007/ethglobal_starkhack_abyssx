#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u32,
    y: u32
}

#[derive(Copy, Drop, Serde, Introspect)]
struct Vec3 {
    x: u32,
    y: u32,
    z: u32
}

trait MathToolsTrait {
    fn pow(base: u256, power: u256)-> u256;
    fn checkbit(bit:u256,i:u256)->bool;
    fn setbit(bit:u256,i:u256,one:bool)->u256;
}

impl MathToolsImpl of MathToolsTrait {
     fn pow(base: u256, power: u256)-> u256{
        if(power == 0){
            return 1;
        }
        let mut b = base;
        let mut p = power;
        let mut i:u256 = 1;
        let mut result:u256 = 1;

        loop {
            if(p % 2 == 1){
                result *= b;
                break;
            }
            b *= b;
            p /= 2;
            i +=1;
        };
         
        return result;
     }

     fn checkbit(bit:u256,i:u256)->bool{
        if(bit & MathToolsTrait::pow(2,i) == 0){
            return false;
        }
        return true;
     }
     fn setbit(bit:u256,i:u256,one:bool)->u256{
        if(one){
            return bit+(bit | MathToolsTrait::pow(2,i));
        } 
        return bit+(bit & ~MathToolsTrait::pow(2,i));
     }
}