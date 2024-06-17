
use abyss_x::utils::constant::{MIN_U8,MAX_U8,MIN_U16,MAX_U16,MIN_U32,MAX_U32,MIN_U64,MAX_U64};
#[generate_trait]
impl MathU8Impl of MathU8Trait {
    #[inline]
    fn add_u8(x:u8,y:u8)->u8{
        return match core::integer::u8_checked_add(x,y){
            Option::Some(r) => r,
            Option::None => MAX_U8
        };
    }
    #[inline]
    fn sub_u8(x:u8,y:u8)->u8{
        return match core::integer::u8_checked_sub(x,y){
            Option::Some(r) => r,
            Option::None => MIN_U8
        };
    }
    #[inline]
    fn add_eq_u8(ref self:u8,y:u8){
        self = match core::integer::u8_checked_add(self,y){
            Option::Some(r) => r,
            Option::None => MAX_U8
        }
    }
    #[inline]
    fn sub_eq_u8(ref self:u8,y:u8){
        self = match core::integer::u8_checked_sub(self,y){
            Option::Some(r) => r,
            Option::None => MIN_U8
        }
    }
    #[inline]
    fn self_add_u8(ref self:u8){
        self = match core::integer::u8_checked_add(self,1_u8){
            Option::Some(r) => r,
            Option::None => MAX_U8
        }
    }
    #[inline]
    fn self_sub_u8(ref self:u8){
        self = match core::integer::u8_checked_sub(self,1_u8){
            Option::Some(r) => r,
            Option::None => MIN_U8
        }
    }
    #[inline]
    fn self_sub_u8_e(ref self:u8,y:u8){
        match core::integer::u8_checked_sub(self,y){
            Option::Some(r) =>{
                self = r;
            },
            Option::None =>{
                assert(false, 'energy not enough');
            }
        }
    }
}
 
#[generate_trait]
impl MathU16Impl of MathU16Trait {
    #[inline]
    fn add_u16(x:u16,y:u16)->u16{
        return match core::integer::u16_checked_add(x,y){
            Option::Some(r) => r,
            Option::None => MAX_U16,
        };
    }
    #[inline]
    fn sub_u16(x:u16,y:u16)->u16{
        return match core::integer::u16_checked_sub(x,y){
            Option::Some(r) => r,
            Option::None => MIN_U16,
        };
    }
    #[inline]
    fn add_eq_u16(ref self:u16,y:u16){
        self = match core::integer::u16_checked_add(self,y){
            Option::Some(r) => r,
            Option::None => MAX_U16
        }
    }
    #[inline]
    fn sub_eq_u16(ref self:u16,y:u16){
        self = match core::integer::u16_checked_sub(self,y){
            Option::Some(r) => r,
            Option::None => MIN_U16
        }
    }
    #[inline]
    fn self_add_u16(ref self:u16){
        self = match core::integer::u16_checked_add(self,1_u16){
            Option::Some(r) => r,
            Option::None => MAX_U16
        }
    }
    #[inline]
    fn self_sub_u16(ref self:u16){
        self = match core::integer::u16_checked_sub(self,1_u16){
            Option::Some(r) => r,
            Option::None => MIN_U16
        }
    }
}
 
#[generate_trait]
impl MathU32Impl of MathU32Trait {
    #[inline]
    fn add_u32(x:u32,y:u32)->u32{
        return match core::integer::u32_checked_add(x,y){
            Option::Some(r) => r,
            Option::None => MAX_U32,
        };
    }
    #[inline]
    fn sub_u32(x:u32,y:u32)->u32{
        return match core::integer::u32_checked_sub(x,y){
            Option::Some(r) => r,
            Option::None => MIN_U32,
        };
    }
    #[inline]
    fn add_eq_u32(ref self:u32,y:u32){
        self = match core::integer::u32_checked_add(self,y){
            Option::Some(r) => r,
            Option::None => MAX_U32
        }
    }
    #[inline]
    fn sub_eq_u32(ref self:u32,y:u32){
        self = match core::integer::u32_checked_sub(self,y){
            Option::Some(r) => r,
            Option::None => MIN_U32
        }
    }
    #[inline]
    fn self_add_u32(ref self:u32){
        self = match core::integer::u32_checked_add(self,1_u32){
            Option::Some(r) => r,
            Option::None => MAX_U32
        }
    }
    #[inline]
    fn self_sub_u32(ref self:u32){
        self = match core::integer::u32_checked_sub(self,1_u32){
            Option::Some(r) => r,
            Option::None => MIN_U32
        }
    }
    #[inline]
    fn self_add__u32(ref self:u32)->u32{
        self = match core::integer::u32_checked_add(self,1_u32){
            Option::Some(r) => r,
            Option::None => MAX_U32
        };
        return self;
    }
    #[inline]
    fn self_sub__u32(ref self:u32)->u32{
        self = match core::integer::u32_checked_sub(self,1_u32){
            Option::Some(r) => r,
            Option::None => MIN_U32
        };
        return self;
    }
}
 
#[generate_trait]
impl MathU64Impl of MathU64Trait {
    #[inline]
    fn add_u64(x:u64,y:u64)->u64{
        return match core::integer::u64_checked_add(x,y){
            Option::Some(r) => r,
            Option::None => MAX_U64,
        };
    }
    #[inline]
    fn sub_u64(x:u64,y:u64)->u64{
        return match core::integer::u64_checked_sub(x,y){
            Option::Some(r) => r,
            Option::None => MIN_U64,
        };
    }
    #[inline]
    fn add_eq_u64(ref self:u64,y:u64){
        match core::integer::u64_checked_add(self,y){
            Option::Some(r) =>{
                self = r;
            },
            Option::None =>{
                self = MAX_U64;
            }
        }
    }
    #[inline]
    fn sub_eq_u64(ref self:u64,y:u64){
        match core::integer::u64_checked_sub(self,y){
            Option::Some(r) =>{
                self = r;
            },
            Option::None =>{
                self = MIN_U64;
            }
        }
    }
    #[inline]
    fn self_add_u64(ref self:u64){
        match core::integer::u64_checked_add(self,1_u64){
            Option::Some(r) =>{
                self = r;
            },
            Option::None =>{
                self = MAX_U64;
            }
        }
    }
    #[inline]
    fn self_sub_u64(ref self:u64){
        match core::integer::u64_checked_sub(self,1_u64){
            Option::Some(r) =>{
                self = r;
            },
            Option::None =>{
                self = MIN_U64;
            }
        }
    }
}
 