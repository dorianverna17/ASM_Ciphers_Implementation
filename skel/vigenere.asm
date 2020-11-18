%include "io.mac"

; Here are the variables that I am using during the program
; plaintext_len is the length of the plaintext and key_len is
; the length of the key
section .data
    plaintext_len DB 0
    key_len DB 0

section .text
    global vigenere
    extern printf

vigenere:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
    ;; DO NOT MODIFY

    ;; TODO: Implement the Vigenere cipher

; Here I initialize the two variable with the values that they
; should contain and I jump to the main_label so that I don't
; enter construct_key label directly
    mov [plaintext_len], ecx
    mov [key_len], ebx
    jmp main_label

; In this label I copy the key from ebx in edx. This way, I can reuse
; ebx for other purposes and I will store the modified characters directly
; in edx
construct_key:
    mov bl, byte [edi + eax]
    mov byte [edx + eax], bl
    add eax, 1
    cmp eax, [key_len]
    jl construct_key
    jmp extend_key

; Here I check if the label is smaller in length than the plaintext
; If it is so, then I have to extend it until it has the same length
; as the plaintext. Firstly, I put the key in edx (the extended key
; will be in edx).
main_label:
    cmp ebx, ecx
    mov eax, 0
    mov ebx, 0
    jl construct_key

; This is the loop where I extend the key. Firstly, I initialize ecx
; and eax with 0. In ebx I store the length of the key
extend_key:
    mov ecx, 0
    mov eax, 0
    mov ebx, [key_len]

; This is the loop in which I make the so-called extension of the key
; in edx. ebx and ecx are both iterators, but ecx starts from 0 and ebx
; from the end of the original key length. This way I obtain the extended
; key but it does not ignore the spaces and the characters which are not 
; letters so I have to shift the elements of the key to the right when I
; find a non-lettter char
loop_extend:
    mov al, byte [edx + ecx]
    mov byte [edx + ebx], al
    add bl, 1
    add cl, 1
    cmp bl, [plaintext_len]
    jl loop_extend

; The shift mentioned before is made in the following. I reinitialize ecx
; and eax with the wanted values
    mov cl, [plaintext_len]
    mov eax, 0

; I iterate through the plaintext and check if the char at the position eax
; is different from a letter (in this case I have to modify the extended key).
; I have to shift all the elements from that character to the right, getting
; rid of the last element in the key.
loop_elements:
; We have to compare with the ASCII values of the letters in order to get to
; know I have to eliminate the char at the end of the key and shift right the
; elements in the key. In case the element is different from a letter I jump
; to eliminate_char label
    cmp byte [esi + eax], 'A'
    jl eliminate_char
    cmp byte [esi + eax], 'z'
    jg eliminate_char
    cmp byte [esi + eax], 'Z'
; The auxiliary is necessary because for a char with ASCII code bigger than Z
; I have to check if it is less then the one of 'a'
    jg eliminate_char_auxiliary

; After modifying the key I still need to check if there are more elements
; like this in the plaintext so I have to continue the loop until we reach
; the end of the plaintext. If there are no more elements to be replaced in
; the key and shifted, then I can begin transforming the edx (begin cipher)
continue_loop:
    add eax, 1
    cmp eax, ecx
    jl loop_elements
    jmp begin_cipher

; This is the label at which I check if the char has the ASCII code between
; the one if 'Z' and the one of 'a'.
eliminate_char_auxiliary:
    cmp byte[esi + eax], 'a'
    jl eliminate_char
    jmp continue_loop

; At this label, I shift the elements in the key to the right, the last
; element of edx being replaced at each iteration
shift_right:
    mov bl, byte [edx + ecx - 2]
    mov byte [edx + ecx - 1], bl
    sub ecx, 1
    cmp cl, al
    jg shift_right
    jmp change_after_shift

; This is the label where I shift the elements in the extended key starting
; from the position of the char that is not a letter.
eliminate_char:
    jmp shift_right

; This is the label I return to after shifting right.
; After that, I jump back to looping
change_after_shift:
    mov cl, [plaintext_len]
    cmp al, cl
    jmp continue_loop
    
; Here I decrement the ASCII code for the enciphered letters
decrement:
    sub al, 26
    jmp replace_in_edx

; If the char to be enciphered is an upper letter, then the result will
; be also an upper one. If the resulting ASCII code is bigger than Z then
; I have to decrement by 26
add_upper:
    add al, byte [esi + ecx]
    cmp al, 'Z'
    jg decrement
    jmp replace_in_edx

; If the char to be enciphered is a lower letter, then the result will
; be also a lower one. If the resulting ASCII code is bigger than z then
; I have to decrement by 26
add_lower:
    add al, byte [esi + ecx]
    cmp al, 'z'
    jg decrement
    cmp al, 0
    jl decrement
    jmp replace_in_edx    

; In this label I check if the char with ASCII code greater than Z is
; a non-letter char. If it is so, then I jump to add_char_raw, otherwise
; I have to perform addition
check_aux:
    cmp byte [esi + ecx], 'a'
    jl add_char_raw
    jmp add_char

; In this label I add the non-letter char to edx as it is
add_char_raw:
    mov al, byte [esi + ecx]
    jmp replace_in_edx

; In this label I begin the cipher algorithm. I iterate the contents of the
; plaintext starting from the end. If the element encountered is not a 
; letter, then I add it to the final version of the enciphered text as it is
begin_cipher:
    cmp byte [esi + ecx], 'z'
    jg add_char_raw
    cmp byte [esi + ecx], 'Z'
    jg check_aux
    cmp byte [esi + ecx], 'A'
    jl add_char_raw

; Here I calculate the ASCII code of the enciphered char (in case it is a
; letter). I substract 65 from it to get its position from the alphabet
; Then, depending on the character that has to be enciphered, I either
; have to add the substracted value to a lower letter or an upper one
add_char:
    mov eax, 0
    mov al, byte [edx + ecx]
    sub al, 65
    cmp byte [esi + ecx], 'Z'
    jle add_upper
    cmp byte [esi + ecx], 'a'
    jge add_lower
    
; Here I replace the char in edx with it enciphered. Then I loop
replace_in_edx:
    mov byte [edx + ecx], al
    sub ecx, 1
    cmp ecx, 0
    jge begin_cipher

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY