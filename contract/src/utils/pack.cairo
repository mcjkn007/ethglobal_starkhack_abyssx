use abyss_x::utils::vector::{Vector,VectorTrait};
use abyss_x::utils::bit::{BitTrait};
 
#[generate_trait]
impl PackImpl of PackTrait{
    fn unpack_8(bit:u256)->Array<u8>{
        let mut arr = array![];
        let mut i = 0;
        loop{
            if(i == 32){
                break;
            }
            arr.append(BitTrait::cut_bit_8(bit,8*i).try_into().unwrap());
            i += 1;
        };
        return arr;
    }
    fn pack_8(arr:@Array<u8>)->u256{
        let mut result:u256 = 0;
        let mut i = 0;
        let size = arr.len();
            loop{
                if(i == size){
                    break;
                }
                result += BitTrait::shift_left_8((*arr.at(i)).into(),8*i);
                i += 1;
            };
        return result;
    }
    fn unpack_16(bit:u256)->Array<u16>{
        let mut arr = array![];
        let mut i = 0;
        loop{
            if(i == 16){
                break;
            }
            arr.append(BitTrait::cut_bit_16(bit,16*i).try_into().unwrap());
            i += 1;
        };
        return arr;
    }
    fn pack_16(arr:@Array<u16>)->u256{
        let mut result:u256 = 0;
        let mut i = 0;
        let size = arr.len();
            loop{
                if(i == size){
                    break;
                }
                result += BitTrait::shift_left_16((*arr.at(i)).into(),16*i);
                i += 1;
            };
        return result;
    }
    fn unpack_32(bit:u256)->Array<u32>{
        let mut arr: Array<u32> = array![];
        let mut i = 0;
        loop{
            if(i == 8){
                break;
            }
            arr.append(BitTrait::cut_bit_32(bit,32*i).try_into().unwrap());
            i += 1;
        };
        return arr;
    }
    fn pack_32(arr:@Array<u32>)->u256{
        let mut result:u256 = 0;
        let mut i = 0;
        let size = arr.len();
            loop{
                if(i == size){
                    break;
                }
                result += BitTrait::shift_left((*arr.at(i)).into(),32*i);
                i += 1;
            };
        return result;
    }

    fn unpack_8_fast(bit:u256)->Array<u8>{
        let mut arr = array![];
        arr.append(BitTrait::cut_bit_8(bit,0).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,8).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,16).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,24).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,32).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,40).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,48).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,56).try_into().unwrap());

        arr.append(BitTrait::cut_bit_8(bit,64).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,72).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,80).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,88).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,96).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,104).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,112).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,120).try_into().unwrap());

        arr.append(BitTrait::cut_bit_8(bit,128).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,136).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,144).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,152).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,160).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,168).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,176).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,184).try_into().unwrap());

        arr.append(BitTrait::cut_bit_8(bit,192).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,200).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,208).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,216).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,224).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,232).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,240).try_into().unwrap());
        arr.append(BitTrait::cut_bit_8(bit,248).try_into().unwrap());
        return arr;
    }
    fn pack_8_fast(arr:@Array<u8>)->u256{
        let mut result:u256 = 0;

        result += BitTrait::shift_left_8((*arr.at(0)).into(),0);
        result += BitTrait::shift_left_8((*arr.at(1)).into(),8);
        result += BitTrait::shift_left_8((*arr.at(2)).into(),16);
        result += BitTrait::shift_left_8((*arr.at(3)).into(),24);
        result += BitTrait::shift_left_8((*arr.at(4)).into(),32);
        result += BitTrait::shift_left_8((*arr.at(5)).into(),40);
        result += BitTrait::shift_left_8((*arr.at(6)).into(),48);
        result += BitTrait::shift_left_8((*arr.at(7)).into(),56);

        result += BitTrait::shift_left_8((*arr.at(8)).into(),64);
        result += BitTrait::shift_left_8((*arr.at(9)).into(),72);
        result += BitTrait::shift_left_8((*arr.at(10)).into(),80);
        result += BitTrait::shift_left_8((*arr.at(11)).into(),88);
        result += BitTrait::shift_left_8((*arr.at(12)).into(),96);
        result += BitTrait::shift_left_8((*arr.at(13)).into(),104);
        result += BitTrait::shift_left_8((*arr.at(14)).into(),112);
        result += BitTrait::shift_left_8((*arr.at(15)).into(),120);

        result += BitTrait::shift_left_8((*arr.at(16)).into(),128);
        result += BitTrait::shift_left_8((*arr.at(17)).into(),136);
        result += BitTrait::shift_left_8((*arr.at(18)).into(),144);
        result += BitTrait::shift_left_8((*arr.at(19)).into(),152);
        result += BitTrait::shift_left_8((*arr.at(20)).into(),160);
        result += BitTrait::shift_left_8((*arr.at(21)).into(),168);
        result += BitTrait::shift_left_8((*arr.at(22)).into(),176);
        result += BitTrait::shift_left_8((*arr.at(23)).into(),184);

        result += BitTrait::shift_left_8((*arr.at(24)).into(),192);
        result += BitTrait::shift_left_8((*arr.at(25)).into(),200);
        result += BitTrait::shift_left_8((*arr.at(26)).into(),208);
        result += BitTrait::shift_left_8((*arr.at(27)).into(),216);
        result += BitTrait::shift_left_8((*arr.at(28)).into(),224);
        result += BitTrait::shift_left_8((*arr.at(29)).into(),232);
        result += BitTrait::shift_left_8((*arr.at(30)).into(),240);
        result += BitTrait::shift_left_8((*arr.at(31)).into(),248);
        
        return result;
    }
    fn unpack_16_fast(bit:u256)->Array<u16>{
        let mut arr = array![];
        arr.append(BitTrait::cut_bit_16(bit,0).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,16).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,32).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,48).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,64).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,80).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,96).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,112).try_into().unwrap());

        arr.append(BitTrait::cut_bit_16(bit,128).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,144).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,160).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,176).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,192).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,208).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,224).try_into().unwrap());
        arr.append(BitTrait::cut_bit_16(bit,240).try_into().unwrap());

        return arr;
    }
    fn pack_16_fast(arr:@Array<u16>)->u256{
        let mut result:u256 = 0;

        result += BitTrait::shift_left_16((*arr.at(0)).into(),0);
        result += BitTrait::shift_left_16((*arr.at(1)).into(),16);
        result += BitTrait::shift_left_16((*arr.at(2)).into(),32);
        result += BitTrait::shift_left_16((*arr.at(3)).into(),48);
        result += BitTrait::shift_left_16((*arr.at(4)).into(),64);
        result += BitTrait::shift_left_16((*arr.at(5)).into(),80);
        result += BitTrait::shift_left_16((*arr.at(6)).into(),96);
        result += BitTrait::shift_left_16((*arr.at(7)).into(),112);

        result += BitTrait::shift_left_16((*arr.at(8)).into(),128);
        result += BitTrait::shift_left_16((*arr.at(9)).into(),144);
        result += BitTrait::shift_left_16((*arr.at(10)).into(),160);
        result += BitTrait::shift_left_16((*arr.at(11)).into(),176);
        result += BitTrait::shift_left_16((*arr.at(12)).into(),192);
        result += BitTrait::shift_left_16((*arr.at(13)).into(),208);
        result += BitTrait::shift_left_16((*arr.at(14)).into(),224);
        result += BitTrait::shift_left_16((*arr.at(15)).into(),240);

 
        
        return result;
    }
    fn unpack_32_fast(bit:u256)->Array<u32>{
        let mut arr = array![];
        arr.append(BitTrait::cut_bit_32(bit,0).try_into().unwrap());
        arr.append(BitTrait::cut_bit_32(bit,32).try_into().unwrap());
        arr.append(BitTrait::cut_bit_32(bit,64).try_into().unwrap());
        arr.append(BitTrait::cut_bit_32(bit,96).try_into().unwrap());
        arr.append(BitTrait::cut_bit_32(bit,128).try_into().unwrap());
        arr.append(BitTrait::cut_bit_32(bit,160).try_into().unwrap());
        arr.append(BitTrait::cut_bit_32(bit,192).try_into().unwrap());
        arr.append(BitTrait::cut_bit_32(bit,224).try_into().unwrap());
 
        return arr;
    }
    fn pack_32_fast(arr:@Array<u8>)->u256{
        let mut result:u256 = 0;

        result += BitTrait::shift_left_32((*arr.at(0)).into(),0);
        result += BitTrait::shift_left_32((*arr.at(1)).into(),32);
        result += BitTrait::shift_left_32((*arr.at(2)).into(),64);
        result += BitTrait::shift_left_32((*arr.at(3)).into(),96);
        result += BitTrait::shift_left_32((*arr.at(4)).into(),128);
        result += BitTrait::shift_left_32((*arr.at(5)).into(),160);
        result += BitTrait::shift_left_32((*arr.at(6)).into(),192);
        result += BitTrait::shift_left_32((*arr.at(7)).into(),224);

        return result;
    }
}

#[cfg(test)]
mod tests {
    use super::{PackTrait};
    use abyss_x::utils::vector::{Vector,VectorTrait};
    use abyss_x::utils::bit::{BitTrait};

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_pack() {
        println!("---------pack_test----------");

        let mut initial = testing::get_available_gas();
        gas::withdraw_gas().unwrap();
         
        let data = 0x11050105030101110501050301011105010503010111050105030101;
        let mut result:Array<u8> = PackTrait::unpack_8(data);
        let mut gas = initial - testing::get_available_gas();
        println!("unpack_8 gas : {}", gas);
 
        println!("---------pack_test----------");
    }
    #[test]
    #[available_gas(1_000_000_000)]
    fn test_pack_fast() {
        let data = 0x11050105030101110501050301011105010503010111050105030101;
        let a = PackTrait::unpack_8_fast(data);
    }

}

 