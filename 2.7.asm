.686
.model flat

extern _ExitProcess@4 : PROC
extern __read : PROC
extern _MessageBoxW@16 : PROC
public _main
extern __write : PROC

.data
    tekst_pocz db 10, 'Prosze napisac jakis tekst '
    db 'i nacisnac Enter', 10
    koniec_t db ?
    tekst_pocz2 dw 'N','a','p','i','s', 0
    magazyn db 80 dup (?) ;inicjalizacja tablicy o d³ugoœci 80 bajtów, o niekreœlonej zawartoœci
    magazyn2 db 160 
    nowa_linia db 10
    liczba_znakow dd ?

.code
_main PROC
    ; wyœwietlenie tekstu informacyjnego
    ; liczba znaków tekstu
     mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
     push ecx
     push OFFSET tekst_pocz ; adres tekstu
     push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
     call __write ; wyœwietlenie tekstu pocz¹tkowego
     add esp, 12 ; usuniecie parametrów ze stosu
    ; czytanie wiersza z klawiatury
     push 80 ; maksymalna liczba znaków
     push OFFSET magazyn
     push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
     call __read ; czytanie znaków z klawiatury
     add esp, 12 ; usuniecie parametrów ze stosu
    ; kody ASCII napisanego tekstu zosta³y wprowadzone
    ; do obszaru 'magazyn'
    ; funkcja read wpisuje do rejestru EAX liczbê
    ; wprowadzonych znaków
     mov liczba_znakow, eax
    ; rejestr ECX pe³ni rolê licznika obiegów pêtli
     mov ecx, eax
     mov ebx, 0 ; indeks pocz¹tkowy
     mov eax, 0 ; indeks w nowej tablicy magazyn2

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
  
    cmp dl, 164
    je zamien_a

    cmp dl, 143
    je zamien_c
 
    cmp dl, 168
    je zamien_e

    cmp dl, 157
    je zamien_l

    cmp dl, 227
    je zamien_n

    cmp dl, 224
    je zamien_o

    cmp dl, 151
    je zamien_s

    cmp dl, 141
    je zamien_zkr

    cmp dl, 189
    je zamien_z

jmp dalej

zamien_a:
     mov magazyn2[eax], 04H
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

zamien_c:
     mov magazyn2[eax], 06H
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

zamien_e:
     mov magazyn2[eax], 18H
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

zamien_l:
     mov magazyn2[eax], 41H
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

zamien_n:
     mov magazyn2[eax], 43H
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

zamien_o:
     mov magazyn2[eax], 0D3H
     inc eax
     mov magazyn2[eax], 00H
     jmp dalej2

zamien_s:
     mov magazyn2[eax], 5AH
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

zamien_zkr:
     mov magazyn2[eax], 79H
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

zamien_z:
     mov magazyn2[eax], 7BH
     inc eax
     mov magazyn2[eax], 01H
     jmp dalej2

dalej: 
    mov magazyn2[eax], dl
    inc eax;
    mov magazyn2[eax], 00H

dalej2:
    inc eax
    inc ebx ; inkrementacja indeksu
    dec ecx


jnz ptl ; sterowanie pêtl¹
; wyœwietlenie przekszta³conego tekstu
 push 0 ; sta³a MB_OK
 push OFFSET tekst_pocz2
 push OFFSET magazyn2
 push 0 ; NULL
 call _MessageBoxW@16
 
 add esp, 12 ; usuniecie parametrów ze stosu
 push 0
 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END

