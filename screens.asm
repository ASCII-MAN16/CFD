; КАРОЧЕ! ТУТ БУДУТ ВСЯКИЕ СКРИНЫ И КАТСЦЕНЫ

extern map_load

screen_dead:
    call clean
    mov dx, deaths_screen
    call map_load
ret
