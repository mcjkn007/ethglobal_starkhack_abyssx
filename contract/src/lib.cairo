 
mod game{
    mod charactor{
        mod c1;
        mod c2;
    }
    mod monster{
        mod m1;
        mod m2;
        mod b1;
        mod b2;
        mod b3;
    }
    mod action;
    mod adventurer;
    mod attribute;
     
    mod status;
 
 
    mod enemy;
    mod stage;

}

mod models {
    mod card;
    mod idol;
    mod nickname;
    mod role;
    mod user;
}

mod systems {
    mod battle;
    mod camp;
    mod chest;
    mod home;
}
mod utils{
    mod array_map;
    mod bit;
    mod constant;
    mod dict_map;
    mod math;
    mod pow;
    mod random;
    mod seed;
    mod vector;

    
}
 
mod tests {
    mod game{
      //  mod test_c1;
    }
    mod systems {
        mod test_battle;
        mod test_chest;
      //  mod test_camp;
     //   mod test_home;
    }
    
    mod utils{
       // mod test_test;
     //   mod test_array_map;
      //  mod test_bit;
       // mod test_dict_ptr;
       // mod test_pow;
       // mod test_math;
      //  mod test_random;
       // mod test_dict_map;
       mod test_vector;
    }

}
