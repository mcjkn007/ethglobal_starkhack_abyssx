fn choose_event_bonus(world:IWorldDispatcher,opt:u64,value:Vec2){
    return;
    let player = get_caller_address();

    let mut user:User = get!(world, player, (User));

    assert(user.state == UserState::GAME_EVENT, 'check stage ops state is wrong');

    let mut role:Role = get!(world, player, (Role));

    assert(role.cur_stage%2 != 0, 'stage category is wrong');

    let stage_category:StageCategory = opt.into();
    let stage_arr = StageTrait::get_stage_category(role.seed,role.cur_stage);
    let mut i = 0;
    let mut stage_arr_len = stage_arr.len();
    let mut check_flag = false;
    loop{
        if(i >= stage_arr_len){
            break;
        }
        if(*stage_arr[i] == stage_category){
            check_flag = true;
        }
        i +=1;
    };
    assert(check_flag == true, 'event opt is wrong');

    if(stage_category == StageCategory::Camp){
        if(value.x == 0){
            //rest
            let add_hp = role.property.cur_property.max_hp/4;
            if(role.property.cur_property.hp + add_hp >=role.property.cur_property.max_hp){
                role.property.cur_property.hp = role.property.cur_property.max_hp;
            }else{
                role.property.cur_property.hp += add_hp;
            }
             
        }else{
            //upgrade
            let mut card:Card = get!(world, (player,value.y), (Card));
            assert(card.id != CardID::None, 'card is void');
            if(card.id == CardID::InfiniteStrike){
                card.level += 1;
            }
            assert(card.level == 0, 'upgrade card is void');
            card.level = 1;

            set!(world,(card));
        }
    }else if(stage_category == StageCategory::Cave){
        if(value.x == 0){
            //add card
            let mut i:u32 = 0;
            let mut card_slot = role.cards;
            loop{
                let check:bool = BitTrait::is_bit(card_slot,i.into());
                if(check == false){
                    let card:Card = CardTrait::create_role_card(player,i.into(),value.y.into());
                     set!(world,(card));
                     break;
                }
                if(BitTrait::fast_pow_2(i.into()) > card_slot){
                    break;
                }
                i +=1;
            };
        }else{
            //delete card
            let mut card_slot = role.cards;
            let check:bool = BitTrait::is_bit(card_slot,value.y.into());
            assert(check == true, 'delete card is void');
            card_slot = BitTrait::set_bit(card_slot,value.y.into(),false);
        }
    }else if(stage_category == StageCategory::Idol){
        
    }else{

    }
    set!(world,(user));
    set!(world,(role));
    emit!(world,ActionEvent { player, event:EventCode::ChooseEventBonus});
}