bits 16 ; чтоб ТОЧНО генерировал 16 битный код

global _start ; все это для .exe а не .com

section _TEXT class=CODE ; для WCC, чтоб видел нашь код там где надо

extern map_load ;наш map.asm
extern map_find_player ;наш map.asm
; extern -- для использования Си/асм из какого то файла
; константы :3
PLAYER equ 0x0902 ; ярко синий ☻
WALL equ '#'


_start:

    mov ax, _DATA        ; ЧТОБ ПАДЛА МНЕ НЕ ЛОМАЛА (WCC видеть дата, игра работать. ХЫ)
    mov ds, ax

    call load_room

    mov ax, 0xB800
    mov es, ax 
    ;магия пола
    mov dx, [es:si]
    mov [kolin_floor], dx

    mov word [es:si], 0x0902 ; КОЛИН=ПСИНА. Превращем Псину в Колина

    gloop:
    mov ah, 00h ; ждем нажатие от клавы (BIOS прерывание - Не будет реагировать на спец конбинаци DOS)
    int 16h
    ;управление
    cmp ah, 01h ; проверка на кливишу escape
    je exit

    cmp ah, 48h ; стрелка вверх
    je pup

    cmp ah, 50h ; стрелка вниз
    je pdwn

    cmp ah, 4Bh ; стрелка влево
    je plft

    cmp ah, 4Dh ; стрелка вправо 
    je prght

    jmp gloop

    ; убейте меня, я уже перестаю понимать как это работает :_3
    pup:
        mov ax, -160
        call dmov

    pdwn:
        mov ax, 160
        call dmov

    plft:
        mov ax, -2
        call dmov

    prght:
        mov ax, 2
        call dmov

    exit:
        mov ah, 4Ch ; завершение программы. Отдаем управление DOS
        int 21h

    clean:      ; очитска экрана символом null (0x00)
        mov ax, 0x0700
        xor di, di
        mov cx, 2000
        rep stosw
        ret
    ;  уни блок для управление/проверки через ax
    dmov:
        mov bx, si
        add bx, ax ;ХРАНИТЬ ВСЕ В AX!!!!!!!!!!!
        mov dx, [es:bx]
        cmp dl, 'D'
        je next_room
        cmp dl, 0xFB ; от 80h и до FFh символа только hex :<
        je gloop
        cmp dl, 0xF8 ; °
        je gloop
        cmp dl, 0x13 ; (‼) какя то хуйня которую через hex надо :\ 
        je gloop
        cmp dl, 0xDC ; ▄ допустим лужа латекса
        je death
        cmp dl, WALL
        je gloop
        ;херня, чтоб Колин пол не рушил
        mov ax, [kolin_floor]
        mov [es:si], ax
        mov [kolin_floor], dx
        mov si, bx
        mov word [es:si], PLAYER
        jmp gloop

    load_room:
        mov [kolin_floor], 0x0020
        mov bx, [current_room] 
        shl bx, 1                
        mov dx, [maps_greed + bx]
        call map_load            
        call map_find_player     
        mov si, di
        ret

    next_room:
        inc word [current_room] ; просто увеличиваем и переходим на след. id
        call clean 
        call load_room          
        
        mov ax, 0xB800
        mov es, ax 
        mov word [es:si], 0x0902
        
        jmp gloop

    death:
        call screen_dead ; наш смертный экран трансфуррмации 
        jmp exit

%include "screens.asm"

section _DATA class=DATA

kolin_floor dw 0x0020
; грузим карты/скрины для использования
deaths_screen db "screen\deaths.bin"
map_00 db "map\map.bin", 0
map_01 db "map\map2.bin", 0
map_02 db "map\map3.bin", 0

maps_greed: ; для удобых id: 0, 1, 2...
    dw map_00 
    dw map_01
    dw map_02

current_room dw 0 ;считалка для next_room и удобного перехода