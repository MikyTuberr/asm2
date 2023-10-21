.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
extern _MessageBoxA@16 : PROC
public _main

.data
    tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
    db 'i nacisnac Enter', 10
    koniec_t db ? ; ? -> nieokreœlona wartoœæ
    magazyn db 80 dup (?) ;inicjalizacja tablicy o d³ugoœci 80 bajtów, o niekreœlonej zawartoœci
    nowa_linia db 10
    liczba_znakow dd ?

.code
_main PROC
    mov ecx, (OFFSET koniec_t) - (OFFSET tekst_pocz)
    push ecx
    push OFFSET tekst_pocz
    push 1
    call __write
    add esp, 12

    push 80
    push OFFSET magazyn
    push 0
    call __read
    add esp, 12

    mov liczba_znakow, eax
    mov ecx, eax
    mov ebx, 0

ptl:
    mov dl, magazyn[ebx]
    ; Zamiana ma³ych liter na wielkie litery
    cmp dl, 'a'
    jb polskie_litery
    cmp dl, 'z'
    ja polskie_litery
    sub dl, 20H
    jmp dalej

polskie_litery:
    ; Zamiana liter specyficznych dla jêzyka polskiego
    cmp dl, 165
    je zamien_a

    cmp dl, 134
    je zamien_c

    cmp dl, 169
    je zamien_e

    cmp dl, 136
    je zamien_l

    cmp dl, 228
    je zamien_n

    cmp dl, 162
    je zamien_o

    cmp dl, 152
    je zamien_s

    cmp dl, 171
    je zamien_zkr

    cmp dl, 190
    je zamien_z
  
zamien_a:
    mov dl, 164
    jmp dalej

zamien_c:
    mov dl, 143
    jmp dalej

zamien_e:
    mov dl, 168
    jmp dalej

zamien_l:
    mov dl, 157
    jmp dalej

zamien_n:
    mov dl, 227
    jmp dalej

zamien_o:
    mov dl, 224
    jmp dalej

zamien_s:
    mov dl, 151
    jmp dalej

zamien_zkr:
    mov dl, 141
    jmp dalej

zamien_z:
    mov dl, 189
    jmp dalej


dalej:
    mov magazyn[ebx], dl
    inc ebx
     
    dec ecx
    jnz ptl ;wroc do pêtli + przed³uzenie pêtli

    push liczba_znakow
    push OFFSET magazyn
    push 1
    call __write

    add esp, 12 ;czyszczenie stosu
    push 0
    call _ExitProcess@4

_main ENDP
END
