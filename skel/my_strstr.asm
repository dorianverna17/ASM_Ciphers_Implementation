%include "io.mac"

; I use it1 and it2 to iterate through the haystack
; and the needle. I use var to store the length of
; the haystack (so that I can use ecx for other purposes)
section .data
    it1     DD 0
    it2     DD 0
    var     DD 0

section .text
    global my_strstr
    extern printf

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len
    ;; DO NOT MODIFY

    ;; TO DO: Implement my_strstr

; I make sure that it1, it2 and eax are 0. Then I store the lenght
; of the haystack in var and jump to looping through the haystack 
    mov byte [it1], 0
    mov byte [it2], 0
    xor eax, eax
    mov [var], ecx
    jmp loop_haystack

; Here I check if the needle is at the given position in the haystack
; I loop through each element of the needle and compare it to the
; element in the haystack (using it2 as the iterator). If it2 is 
; equal to edx at the beginning of the loop then the haystack contains
; the needle so I jump tostring_found label. Otherwise I have to
; continue the search until I reach the end of the haystack
check_needle:
    cmp byte [it2], dl
    je string_found
    mov cl, byte [it2]
    mov al, byte [ebx + ecx]
    add cl, byte [it1]
    add byte [it2], 1
    cmp byte [esi + ecx], al
    je check_needle
    mov al, byte [it1]
    jmp continue_haystack

; This is the main loop. Whenever I enter it, I reinitialize
; eax and the value at it2 with 0. eax gets the current position
; in the haystack (it1). We then compare the first char in needle
; ([ebx]) with the current char in the haystack [esi + eax] (I use
; ecx as an auxiliary)
loop_haystack:
    xor eax, eax
    mov byte [it2], 0
    mov eax, [it1]
    mov cl, byte [ebx]
    cmp byte [esi + eax], cl
; If the comparison results in equality, then I have to check if the
; needle is there in the haystack, so I do this at tte check_needle label 
    je check_needle

; I jump here if I didn't find the needle or I continue the loop if the
; above comparison results in non-equality. I increment it1 here and use
; the haystack length stored in [var] to check if I've reached the end of
; the haystack, otherwise I continue looping
continue_haystack:
    add dword [it1], 1
    mov ecx, [var]
    cmp [it1], ecx
    jl loop_haystack

; If I have reached the end of the loop so I don't jump anymore at the
; loop_haystack label, then I didn't find the needle so I have to return
; the length of the haystack + 1. After that I jump directly at the end of
; the program so that I don't enter in string_found label
string_not_found:
    mov cl, byte [var]
    mov byte [edi], cl
    add byte [edi], 1
    jmp end

; If the string is found then I have to put it1 (the position at which it was
; found) in the edi
string_found:
    mov cl, byte [it1]
    mov byte [edi], cl
    
; End of the program. I jump here if the needle is not in the hasytack
end:

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
