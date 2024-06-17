#[generate_trait]
impl Pow256Impl of Pow256Trait {
    fn pow(b: u256, n: u8)-> u256{
 
        let mut b: u256 = b;
        let mut result: u256 = 1_u256;
        let mut n = n;
        loop {
            if (n % 2 != 0_u8) {
                result *= b;
            }
            n /= 2_u8;
            if (n == 0_u8) {
                break;
            }
            b *= b;
        };
        return result;
    }
    fn fast_pow_2(n:u8)->u256{
        return match n {
            0 => 0x1_u256,
            1 => 0x2_u256,
            2 => 0x4_u256,
            3 => 0x8_u256,

            4 => 0x10_u256,
            5 => 0x20_u256,
            6 => 0x40_u256,
            7 => 0x80_u256,

            8 => 0x100_u256,
            9 => 0x200_u256,
            10 => 0x400_u256,
            11 => 0x800_u256,

            12 => 0x1000_u256,
            13 => 0x2000_u256,
            14 => 0x4000_u256,
            15 => 0x8000_u256,

            16 => 0x10000_u256,
            17 => 0x20000_u256,
            18 => 0x40000_u256,
            19 => 0x80000_u256,

            20 => 0x100000_u256,
            21 => 0x200000_u256,
            22 => 0x400000_u256,
            23 => 0x800000_u256,

            24 => 0x1000000_u256,
            25 => 0x2000000_u256,
            26 => 0x4000000_u256,
            27 => 0x8000000_u256,

            28 => 0x10000000_u256,
            29 => 0x20000000_u256,
            30 => 0x40000000_u256,
            31 => 0x80000000_u256,

            32 => 0x100000000_u256,
            33 => 0x200000000_u256,
            34 => 0x400000000_u256,
            35 => 0x800000000_u256,

            36 => 0x1000000000_u256,
            37 => 0x2000000000_u256,
            38 => 0x4000000000_u256,
            39 => 0x8000000000_u256,

            40 => 0x10000000000_u256,
            41 => 0x20000000000_u256,
            42 => 0x40000000000_u256,
            43 => 0x80000000000_u256,

            44 => 0x100000000000_u256,
            45 => 0x200000000000_u256,
            46 => 0x400000000000_u256,
            47 => 0x800000000000_u256,

            48 => 0x1000000000000_u256,
            49 => 0x2000000000000_u256,
            50 => 0x4000000000000_u256,
            51 => 0x8000000000000_u256,

            52 => 0x10000000000000_u256,
            53 => 0x20000000000000_u256,
            54 => 0x40000000000000_u256,
            55 => 0x80000000000000_u256,

            56 => 0x100000000000000_u256,
            57 => 0x200000000000000_u256,
            58 => 0x400000000000000_u256,
            59 => 0x800000000000000_u256,

            60 => 0x1000000000000000_u256,
            61 => 0x2000000000000000_u256,
            62 => 0x4000000000000000_u256,
            63 => 0x8000000000000000_u256,

            64 => 0x10000000000000000_u256,
            65 => 0x20000000000000000_u256,
            66 => 0x40000000000000000_u256,
            67 => 0x80000000000000000_u256,

            68 => 0x100000000000000000_u256,
            69 => 0x200000000000000000_u256,
            70 => 0x400000000000000000_u256,
            71 => 0x800000000000000000_u256,

            72 => 0x1000000000000000000_u256,
            73 => 0x2000000000000000000_u256,
            74 => 0x4000000000000000000_u256,
            75 => 0x8000000000000000000_u256,

            76 => 0x10000000000000000000_u256,
            77 => 0x20000000000000000000_u256,
            78 => 0x40000000000000000000_u256,
            79 => 0x80000000000000000000_u256,

            80 => 0x100000000000000000000_u256,
            81 => 0x200000000000000000000_u256,
            82 => 0x400000000000000000000_u256,
            83 => 0x800000000000000000000_u256,

            84 => 0x1000000000000000000000_u256,
            85 => 0x2000000000000000000000_u256,
            86 => 0x4000000000000000000000_u256,
            87 => 0x8000000000000000000000_u256,

            88 => 0x10000000000000000000000_u256,
            89 => 0x20000000000000000000000_u256,
            90 => 0x40000000000000000000000_u256,
            91 => 0x80000000000000000000000_u256,

            92 => 0x100000000000000000000000_u256,
            93 => 0x200000000000000000000000_u256,
            94 => 0x400000000000000000000000_u256,
            95 => 0x800000000000000000000000_u256,

            96 => 0x1000000000000000000000000_u256,
            97 => 0x2000000000000000000000000_u256,
            98 => 0x4000000000000000000000000_u256,
            99 => 0x8000000000000000000000000_u256,

            100 => 0x10000000000000000000000000_u256,
            101 => 0x20000000000000000000000000_u256,
            102 => 0x40000000000000000000000000_u256,
            103 => 0x80000000000000000000000000_u256,

            104 => 0x100000000000000000000000000_u256,
            105 => 0x200000000000000000000000000_u256,
            106 => 0x400000000000000000000000000_u256,
            107 => 0x800000000000000000000000000_u256,

            108 => 0x1000000000000000000000000000_u256,
            109 => 0x2000000000000000000000000000_u256,
            110 => 0x4000000000000000000000000000_u256,
            111 => 0x8000000000000000000000000000_u256,

            112 => 0x10000000000000000000000000000_u256,
            113 => 0x20000000000000000000000000000_u256,
            114 => 0x40000000000000000000000000000_u256,
            115 => 0x80000000000000000000000000000_u256,

            116 => 0x100000000000000000000000000000_u256,
            117 => 0x200000000000000000000000000000_u256,
            118 => 0x400000000000000000000000000000_u256,
            119 => 0x800000000000000000000000000000_u256,

            120 => 0x1000000000000000000000000000000_u256,
            121 => 0x2000000000000000000000000000000_u256,
            122 => 0x4000000000000000000000000000000_u256,
            123 => 0x8000000000000000000000000000000_u256,

            124 => 0x10000000000000000000000000000000_u256,
            125 => 0x20000000000000000000000000000000_u256,
            126 => 0x40000000000000000000000000000000_u256,
            127 => 0x80000000000000000000000000000000_u256,

            128 => 0x100000000000000000000000000000000_u256,
            129 => 0x200000000000000000000000000000000_u256,
            130 => 0x400000000000000000000000000000000_u256,
            131 => 0x800000000000000000000000000000000_u256,

            132 => 0x1000000000000000000000000000000000_u256,
            133 => 0x2000000000000000000000000000000000_u256,
            134 => 0x4000000000000000000000000000000000_u256,
            135 => 0x8000000000000000000000000000000000_u256,

            136 => 0x10000000000000000000000000000000000_u256,
            137 => 0x20000000000000000000000000000000000_u256,
            138 => 0x40000000000000000000000000000000000_u256,
            139 => 0x80000000000000000000000000000000000_u256,

            140 => 0x100000000000000000000000000000000000_u256,
            141 => 0x200000000000000000000000000000000000_u256,
            142 => 0x400000000000000000000000000000000000_u256,
            143 => 0x800000000000000000000000000000000000_u256,

            144 => 0x1000000000000000000000000000000000000_u256,
            145 => 0x2000000000000000000000000000000000000_u256,
            146 => 0x4000000000000000000000000000000000000_u256,
            147 => 0x8000000000000000000000000000000000000_u256,

            148 => 0x10000000000000000000000000000000000000_u256,
            149 => 0x20000000000000000000000000000000000000_u256,
            150 => 0x40000000000000000000000000000000000000_u256,
            151 => 0x80000000000000000000000000000000000000_u256,

            152 => 0x100000000000000000000000000000000000000_u256,
            153 => 0x200000000000000000000000000000000000000_u256,
            154 => 0x400000000000000000000000000000000000000_u256,
            155 => 0x800000000000000000000000000000000000000_u256,

            156 => 0x1000000000000000000000000000000000000000_u256,
            157 => 0x2000000000000000000000000000000000000000_u256,
            158 => 0x4000000000000000000000000000000000000000_u256,
            159 => 0x8000000000000000000000000000000000000000_u256,

            160 => 0x10000000000000000000000000000000000000000_u256,
            161 => 0x20000000000000000000000000000000000000000_u256,
            162 => 0x40000000000000000000000000000000000000000_u256,
            163 => 0x80000000000000000000000000000000000000000_u256,

            164 => 0x100000000000000000000000000000000000000000_u256,
            165 => 0x200000000000000000000000000000000000000000_u256,
            166 => 0x400000000000000000000000000000000000000000_u256,
            167 => 0x800000000000000000000000000000000000000000_u256,

            168 => 0x1000000000000000000000000000000000000000000_u256,
            169 => 0x2000000000000000000000000000000000000000000_u256,
            170 => 0x4000000000000000000000000000000000000000000_u256,
            171 => 0x8000000000000000000000000000000000000000000_u256,

            172 => 0x10000000000000000000000000000000000000000000_u256,
            173 => 0x20000000000000000000000000000000000000000000_u256,
            174 => 0x40000000000000000000000000000000000000000000_u256,
            175 => 0x80000000000000000000000000000000000000000000_u256,

            176 => 0x100000000000000000000000000000000000000000000_u256,
            177 => 0x200000000000000000000000000000000000000000000_u256,
            178 => 0x400000000000000000000000000000000000000000000_u256,
            179 => 0x800000000000000000000000000000000000000000000_u256,

            180 => 0x1000000000000000000000000000000000000000000000_u256,
            181 => 0x2000000000000000000000000000000000000000000000_u256,
            182 => 0x4000000000000000000000000000000000000000000000_u256,
            183 => 0x8000000000000000000000000000000000000000000000_u256,

            184 => 0x10000000000000000000000000000000000000000000000_u256,
            185 => 0x20000000000000000000000000000000000000000000000_u256,
            186 => 0x40000000000000000000000000000000000000000000000_u256,
            187 => 0x80000000000000000000000000000000000000000000000_u256,

            188 => 0x100000000000000000000000000000000000000000000000_u256,
            189 => 0x200000000000000000000000000000000000000000000000_u256,
            190 => 0x400000000000000000000000000000000000000000000000_u256,
            191 => 0x800000000000000000000000000000000000000000000000_u256,

            192 => 0x1000000000000000000000000000000000000000000000000_u256,
            193 => 0x2000000000000000000000000000000000000000000000000_u256,
            194 => 0x4000000000000000000000000000000000000000000000000_u256,
            195 => 0x8000000000000000000000000000000000000000000000000_u256,

            196 => 0x10000000000000000000000000000000000000000000000000_u256,
            197 => 0x20000000000000000000000000000000000000000000000000_u256,
            198 => 0x40000000000000000000000000000000000000000000000000_u256,
            199 => 0x80000000000000000000000000000000000000000000000000_u256,

            200 => 0x100000000000000000000000000000000000000000000000000_u256,
            201 => 0x200000000000000000000000000000000000000000000000000_u256,
            202 => 0x400000000000000000000000000000000000000000000000000_u256,
            203 => 0x800000000000000000000000000000000000000000000000000_u256,

            204 => 0x1000000000000000000000000000000000000000000000000000_u256,
            205 => 0x2000000000000000000000000000000000000000000000000000_u256,
            206 => 0x4000000000000000000000000000000000000000000000000000_u256,
            207 => 0x8000000000000000000000000000000000000000000000000000_u256,

            208 => 0x10000000000000000000000000000000000000000000000000000_u256,
            209 => 0x20000000000000000000000000000000000000000000000000000_u256,
            210 => 0x40000000000000000000000000000000000000000000000000000_u256,
            211 => 0x80000000000000000000000000000000000000000000000000000_u256,

            212 => 0x100000000000000000000000000000000000000000000000000000_u256,
            213 => 0x200000000000000000000000000000000000000000000000000000_u256,
            214 => 0x400000000000000000000000000000000000000000000000000000_u256,
            215 => 0x800000000000000000000000000000000000000000000000000000_u256,

            216 => 0x1000000000000000000000000000000000000000000000000000000_u256,
            217 => 0x2000000000000000000000000000000000000000000000000000000_u256,
            218 => 0x4000000000000000000000000000000000000000000000000000000_u256,
            219 => 0x8000000000000000000000000000000000000000000000000000000_u256,

            220 => 0x10000000000000000000000000000000000000000000000000000000_u256,
            221 => 0x20000000000000000000000000000000000000000000000000000000_u256,
            222 => 0x40000000000000000000000000000000000000000000000000000000_u256,
            223 => 0x80000000000000000000000000000000000000000000000000000000_u256,

            224 => 0x100000000000000000000000000000000000000000000000000000000_u256,
            225 => 0x200000000000000000000000000000000000000000000000000000000_u256,
            226 => 0x400000000000000000000000000000000000000000000000000000000_u256,
            227 => 0x800000000000000000000000000000000000000000000000000000000_u256,

            228 => 0x1000000000000000000000000000000000000000000000000000000000_u256,
            229 => 0x2000000000000000000000000000000000000000000000000000000000_u256,
            230 => 0x4000000000000000000000000000000000000000000000000000000000_u256,
            231 => 0x8000000000000000000000000000000000000000000000000000000000_u256,

            232 => 0x10000000000000000000000000000000000000000000000000000000000_u256,
            233 => 0x20000000000000000000000000000000000000000000000000000000000_u256,
            234 => 0x40000000000000000000000000000000000000000000000000000000000_u256,
            235 => 0x80000000000000000000000000000000000000000000000000000000000_u256,

            236 => 0x100000000000000000000000000000000000000000000000000000000000_u256,
            237 => 0x200000000000000000000000000000000000000000000000000000000000_u256,
            238 => 0x400000000000000000000000000000000000000000000000000000000000_u256,
            239 => 0x800000000000000000000000000000000000000000000000000000000000_u256,

            240 => 0x1000000000000000000000000000000000000000000000000000000000000_u256,
            241 => 0x2000000000000000000000000000000000000000000000000000000000000_u256,
            242 => 0x4000000000000000000000000000000000000000000000000000000000000_u256,
            243 => 0x8000000000000000000000000000000000000000000000000000000000000_u256,

            244 => 0x10000000000000000000000000000000000000000000000000000000000000_u256,
            245 => 0x20000000000000000000000000000000000000000000000000000000000000_u256,
            246 => 0x40000000000000000000000000000000000000000000000000000000000000_u256,
            247 => 0x80000000000000000000000000000000000000000000000000000000000000_u256,

            248 => 0x100000000000000000000000000000000000000000000000000000000000000_u256,
            249 => 0x200000000000000000000000000000000000000000000000000000000000000_u256,
            250 => 0x400000000000000000000000000000000000000000000000000000000000000_u256,
            251 => 0x800000000000000000000000000000000000000000000000000000000000000_u256,

            252 => 0x1000000000000000000000000000000000000000000000000000000000000000_u256,
            253 => 0x2000000000000000000000000000000000000000000000000000000000000000_u256,
            254 => 0x4000000000000000000000000000000000000000000000000000000000000000_u256,
            255 => 0x8000000000000000000000000000000000000000000000000000000000000000_u256,

            _ => 1_u256
        };
    }
    fn fast_pow_2_8(n:u8)->u256{
        if(n == 0){
            return 1;
        }else if(n == 8){
            return 0x100;
        }else if(n == 16){
            return 0x10000;
        }else if(n == 24){
            return 0x1000000;
        }else if(n == 32){
            return 0x100000000;
        }else if(n == 40){
            return 0x10000000000;
        }else if(n == 48){
            return 0x1000000000000;
        }else if(n == 56){
            return 0x100000000000000;
        }else if(n == 64){
            return 0x10000000000000000;
        }else if(n == 72){
            return 0x1000000000000000000;
        }else if(n == 80){
            return 0x100000000000000000000;
        }else if(n == 88){
            return 0x10000000000000000000000;
        }else if(n == 96){
            return 0x1000000000000000000000000;
        }else if(n == 104){
            return 0x100000000000000000000000000;
        }else if(n == 112){
            return 0x10000000000000000000000000000;
        }else if(n == 120){
            return 0x1000000000000000000000000000000;
        }else if(n == 128){
            return 0x100000000000000000000000000000000;
        }else if(n == 136){
            return 0x10000000000000000000000000000000000;
        }else if(n == 144){
            return 0x1000000000000000000000000000000000000;
        }else if(n == 152){
            return 0x100000000000000000000000000000000000000;
        }else if(n == 160){
            return 0x10000000000000000000000000000000000000000;
        }else if(n == 168){
            return 0x1000000000000000000000000000000000000000000;
        }else if(n == 176){
            return 0x100000000000000000000000000000000000000000000;
        }else if(n == 184){
            return 0x10000000000000000000000000000000000000000000000;
        }else if(n == 192){
            return 0x1000000000000000000000000000000000000000000000000;
        }else if(n == 200){
            return 0x100000000000000000000000000000000000000000000000000;
        }else if(n == 208){
            return 0x10000000000000000000000000000000000000000000000000000;
        }else if(n == 216){
            return 0x1000000000000000000000000000000000000000000000000000000;
        }else if(n == 224){
            return 0x100000000000000000000000000000000000000000000000000000000;
        }else if(n == 232){
            return 0x10000000000000000000000000000000000000000000000000000000000;
        }else if(n == 240){
            return 0x1000000000000000000000000000000000000000000000000000000000000;
        }else if(n == 248){
            return 0x100000000000000000000000000000000000000000000000000000000000000;
        }else{
            return 1;
        }
    }
}

#[generate_trait]
impl Pow128Impl of Pow128Trait {
    fn pow(b: u128, n: u8)-> u128{
        let mut b: u128 = b;
        let mut result: u128 = 1_u128;
        let mut n = n;
        loop {
            if (n % 2_u8 != 0_8) {
                result *= b;
            }
            n /= 2_u8;
            if (n == 0_u8) {
                break;
            }
            b *= b;
        };
        return result;
    }
    fn fast_pow_2(n:u8)->u128{
        return match n {
            0 => 0x1_u128,
            1 => 0x2_u128,
            2 => 0x4_u128,
            3 => 0x8_u128,
    
            4 => 0x10_u128,
            5 => 0x20_u128,
            6 => 0x40_u128,
            7 => 0x80_u128,
    
            8 => 0x100_u128,
            9 => 0x200_u128,
            10 => 0x400_u128,
            11 => 0x800_u128,
    
            12 => 0x1000_u128,
            13 => 0x2000_u128,
            14 => 0x4000_u128,
            15 => 0x8000_u128,
    
            16 => 0x10000_u128,
            17 => 0x20000_u128,
            18 => 0x40000_u128,
            19 => 0x80000_u128,
    
            20 => 0x100000_u128,
            21 => 0x200000_u128,
            22 => 0x400000_u128,
            23 => 0x800000_u128,
    
            24 => 0x1000000_u128,
            25 => 0x2000000_u128,
            26 => 0x4000000_u128,
            27 => 0x8000000_u128,
    
            28 => 0x10000000_u128,
            29 => 0x20000000_u128,
            30 => 0x40000000_u128,
            31 => 0x80000000_u128,
    
            32 => 0x100000000_u128,
            33 => 0x200000000_u128,
            34 => 0x400000000_u128,
            35 => 0x800000000_u128,
    
            36 => 0x1000000000_u128,
            37 => 0x2000000000_u128,
            38 => 0x4000000000_u128,
            39 => 0x8000000000_u128,
    
            40 => 0x10000000000_u128,
            41 => 0x20000000000_u128,
            42 => 0x40000000000_u128,
            43 => 0x80000000000_u128,
    
            44 => 0x100000000000_u128,
            45 => 0x200000000000_u128,
            46 => 0x400000000000_u128,
            47 => 0x800000000000_u128,
    
            48 => 0x1000000000000_u128,
            49 => 0x2000000000000_u128,
            50 => 0x4000000000000_u128,
            51 => 0x8000000000000_u128,
    
            52 => 0x10000000000000_u128,
            53 => 0x20000000000000_u128,
            54 => 0x40000000000000_u128,
            55 => 0x80000000000000_u128,
    
            56 => 0x100000000000000_u128,
            57 => 0x200000000000000_u128,
            58 => 0x400000000000000_u128,
            59 => 0x800000000000000_u128,
    
            60 => 0x1000000000000000_u128,
            61 => 0x2000000000000000_u128,
            62 => 0x4000000000000000_u128,
            63 => 0x8000000000000000_u128,
    
            64 => 0x10000000000000000_u128,
            65 => 0x20000000000000000_u128,
            66 => 0x40000000000000000_u128,
            67 => 0x80000000000000000_u128,
    
            68 => 0x100000000000000000_u128,
            69 => 0x200000000000000000_u128,
            70 => 0x400000000000000000_u128,
            71 => 0x800000000000000000_u128,
    
            72 => 0x1000000000000000000_u128,
            73 => 0x2000000000000000000_u128,
            74 => 0x4000000000000000000_u128,
            75 => 0x8000000000000000000_u128,
    
            76 => 0x10000000000000000000_u128,
            77 => 0x20000000000000000000_u128,
            78 => 0x40000000000000000000_u128,
            79 => 0x80000000000000000000_u128,
    
            80 => 0x100000000000000000000_u128,
            81 => 0x200000000000000000000_u128,
            82 => 0x400000000000000000000_u128,
            83 => 0x800000000000000000000_u128,
    
            84 => 0x1000000000000000000000_u128,
            85 => 0x2000000000000000000000_u128,
            86 => 0x4000000000000000000000_u128,
            87 => 0x8000000000000000000000_u128,
    
            88 => 0x10000000000000000000000_u128,
            89 => 0x20000000000000000000000_u128,
            90 => 0x40000000000000000000000_u128,
            91 => 0x80000000000000000000000_u128,
    
            92 => 0x100000000000000000000000_u128,
            93 => 0x200000000000000000000000_u128,
            94 => 0x400000000000000000000000_u128,
            95 => 0x800000000000000000000000_u128,
    
            96 => 0x1000000000000000000000000_u128,
            97 => 0x2000000000000000000000000_u128,
            98 => 0x4000000000000000000000000_u128,
            99 => 0x8000000000000000000000000_u128,
    
            100 => 0x10000000000000000000000000_u128,
            101 => 0x20000000000000000000000000_u128,
            102 => 0x40000000000000000000000000_u128,
            103 => 0x80000000000000000000000000_u128,
    
            104 => 0x100000000000000000000000000_u128,
            105 => 0x200000000000000000000000000_u128,
            106 => 0x400000000000000000000000000_u128,
            107 => 0x800000000000000000000000000_u128,
    
            108 => 0x1000000000000000000000000000_u128,
            109 => 0x2000000000000000000000000000_u128,
            110 => 0x4000000000000000000000000000_u128,
            111 => 0x8000000000000000000000000000_u128,
    
            112 => 0x10000000000000000000000000000_u128,
            113 => 0x20000000000000000000000000000_u128,
            114 => 0x40000000000000000000000000000_u128,
            115 => 0x80000000000000000000000000000_u128,
    
            116 => 0x100000000000000000000000000000_u128,
            117 => 0x200000000000000000000000000000_u128,
            118 => 0x400000000000000000000000000000_u128,
            119 => 0x800000000000000000000000000000_u128,
    
            120 => 0x1000000000000000000000000000000_u128,
            121 => 0x2000000000000000000000000000000_u128,
            122 => 0x4000000000000000000000000000000_u128,
            123 => 0x8000000000000000000000000000000_u128,
    
            124 => 0x10000000000000000000000000000000_u128,
            125 => 0x20000000000000000000000000000000_u128,
            126 => 0x40000000000000000000000000000000_u128,
            127 => 0x80000000000000000000000000000000_u128,
    
            _ => 1_u128
        };
    }
    
}
 