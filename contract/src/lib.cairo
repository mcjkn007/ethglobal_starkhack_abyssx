 
mod game{
    mod charactor{
        mod c1;
        mod c2;
    }
    mod monster{
        mod m1;
        mod m2;
    }
    mod adventurer;
    mod attribute;
    mod damage;
    mod status;
 
 
    mod enemy;
    mod stage;

}

mod models {
    mod cardslot;
    mod deck;
    mod role;
    mod user;
}

mod systems {
    mod battle;
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
