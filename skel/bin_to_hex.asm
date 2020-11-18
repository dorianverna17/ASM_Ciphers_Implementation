%include "io.mac"

section .data
; The variables that I use through the program
    sum: DD 0
    var: DD 0
    hex_length: DD 0

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement bin to hex

; Here I intialize registers with 0, calculate the number
; of characters that the hex string will have. I put this
; size at the address defined by hex_length (I use eax and
; ebx to perform this division). If the number of bits is
; not a multiple of 4, then I have to add 1 so I jump to
; add_length, otherwise I jump directly to storing the 
; new_line character at the end of the edx string
    mov eax, 0
    mov ebx, 0
    mov eax, ecx
    sub ecx, 1
    mov [var], ecx
    mov bl, 4
    div bl
    mov byte [hex_length], al
    cmp ah, 0
    mov eax, 0
    jg add_length
    jmp store_length

; Here I put the a number character in edx
; I have to add 48 to the sum to obtain its ASCII code
; If hex_length is 0 then I should jump to the end
; Otherwise I have to get back to the loop
put_integer:
    mov ebx, [sum]
    add ebx, 48
    mov [var], ecx
    mov ecx, dword [hex_length]
    mov byte [edx + ecx], bl
    mov ecx, [var]
    cmp dword [hex_length], 0
    je end
    jmp get_back_to_main_loop

; Here I put the a letter character in edx
; I have to add 55 to the sum to obtain its ASCII code
; If hex_length is 0 then I should jump to the end
; Otherwise I have to get back to the loop
put_char:
    mov ebx, [sum]
    add ebx, 55
    mov [var], ecx
    mov ecx, dword [hex_length]
    mov byte [edx + ecx], bl
    mov ecx, [var]
    cmp dword [hex_length], 0
    je end
    jmp get_back_to_main_loop 

; Here I increment the value of hex_length if the length
; of the bit sequence is not a multiple of 4
add_length:
    add byte [hex_length], 1

; Here I store the new_line at the end, at the position
; which is last in the edx (according to the length of
; the hex value which was previously calculated). After
; that, I decrement hex_length and go to main_loop
store_length:
    mov eax, 0
    mov eax, [hex_length] ;
    mov byte [edx + eax], 10 ;
    sub byte [hex_length], 1
    mov eax, 0

; Here I loop over the sequence of bits
; I start the loop by reintializing ebx and the value at
; the address represented by sum with 0. Sum represent the
; value for the transformation in hexa (0 - 15) - the number
; on 4 bits
main_loop:
    mov ebx, 0
    mov dword [sum], 0
; Here I loop 4 times at once and get the value of the number
; determined by the 4 bits and store it in sum, then I convert
; sum to the character for hexa.
loop_4_bits:
; Here I get the bit at the position ecx (store it in eax)
    mov eax, 0
    mov al, byte [esi + ecx]
; I decrement eax with 48 so that I don't have the ASCII code in
; eax but the value (either 0 or 1) in it
    sub eax, 48
; ebx is telling me the position of the bit in the group of the 4
; so that i know with wich power of 2 should I multiply it
; I need ecx so I can multiply (shift left), so I store the ecx
; in var in order
    mov [var], ecx
    mov ecx, ebx
    shl eax, cl
; I add it to the sum finally
    add [sum], eax
; I put back the value in ecx 
    mov ecx, [var]
; I increment ebx and compare ecx. If ecx is 0 then that means that
; I have finished looping through the bit sequence so I should break
; from the loop and jump to another label outside the loop (I put this
; comparison here because it happens for the last sequence of bits to be
; less than 4 bits)
    add ebx, 1
    cmp ecx, 0
    je end_loop
; If ecx is not 0, the we still have to loop so I decrement it. We
; compare ebx with 4, if ebx is less than 4 it means we haven't
; finished working with 4 bits so we still need to read another bite
    dec ecx
    cmp ebx, 4
    jl loop_4_bits
; if ebx is equal to 4 then we finished reading a group of 4 bits and
; we need to add their sum to edx as a char. We have to check if it will
; be a letter or a number. If sum is less or equal 9 then we have to add
; a number, otherwise it is a letter
    cmp byte [sum], 9
    jle put_integer
    jg put_char
; When I finished adding the char in edx I come back here and check with
; ecx if there are anymore bits in the sequence, depending on which I continue
; looping or going to the end. I also decrement hex_length
get_back_to_main_loop:
    sub dword [hex_length], 1
    cmp ecx, 0
    jge main_loop

; I use to jump here when ecx is 0 (I have no more bits in the sequence).
; But I still need to add one more char in edx so I do it
end_loop:
    cmp byte [sum], 9
    jle put_integer
    cmp byte [sum], 9
    jg put_char
; Here I end the program
end:

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY