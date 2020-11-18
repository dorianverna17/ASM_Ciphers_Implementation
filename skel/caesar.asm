%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement the caesar cipher

;; i jump over the first 2 labels now because they
;; are going to help later

    jmp loop_cipher

;; label that i jump to if key + char ASCII value
;; is more than z and is also more than 127, because
;; I have to repeatedly decrement the ebx until is less
;; than z (one sub operation may not be enough,
;; ex. key = 100)
;; if i'm done looping then i jump to the process of storing

decrement_char_ASCII_value:
    sub ebx, 26
    cmp bl, 0
    jl decrement_char_ASCII_value
    jmp store_eax

;; if the character is greater than a
;; then it doesn't have to stay the same and
;; must be replaced, so we jump back from
;; where we jumped to this check_label
;; (continue_instructions label)
;; otherwise i jump to loop_storing label to store the char
;; as it is

check_less_a:
    cmp al, 'a'
    jge continue_instructions
    jmp loop_storing

;; I store in eax the character from plaintext
;; if the character has ASCII value greater than
;; the one of z, then it has no point to go through
;; all the below tests and we jump to loop_storing label
;; and store the value unchanged because it's not a letter
;; I am doing the same thing if the character's ASCII
;; code is less than the one of A - the characters
;; remains unchanged and i store it the way it is in ciphertext
;; if the character is greater than Z i jump to
;; check_less_a to check if it is between Z and a.
;; In this case, the character remains unchanged.

loop_cipher:
    mov eax, [esi + ecx - 1]
    cmp al, 'z'
    jg loop_storing
    cmp al, 'A'
    jl loop_storing
    cmp al, 'Z'
    jg check_less_a

;; this label is put here just to get back here if
;; the char in al is not between Z and a 
;; ebx stores the value that the char needs to be
;; replaced with.
;; If the incremented value is more than 127, then
;; we have to compare bl with 0 because it is
;; signed interpretation.
;; If bl is less than 0 than we have to decrement
;; char that we want to put in the string with 26 
;; until it is in the range of charactes a-z

continue_instructions:
    mov ebx, eax
    add ebx, edi
    cmp bl, 0
    jl decrement_char_ASCII_value

;; here i store ebx in eax so that my upcomig labels
;; work (if i store at the required address in edx directly
;; the ebx, then it breaks)
;; in the below label i once again check if the char to be
;; stored is greater than z or Z (if true then i decrement in
;; label "decrement")

store_eax:
    mov eax, ebx
    cmp al, 'z'
    jg decrement
    cmp al, 'a'
    jge loop_storing
    cmp al, 'Z'
    jg decrement

;; the label in which I store the incremented char at the
;; proper address in edx, depending on the iterator (ecx)
;; I take the characters starting from the end of the string
;; in this label i also loop after decrementing the ecx
;; when ecx is 0 then i jump to the end label of the program

loop_storing:
    mov [edx + ecx - 1], al
    sub ecx, 1
    cmp ecx, 1
    jge loop_cipher
    jmp end

;; here i decrement once again if the conditions in store_eax
;; are true and jump back to putting the element in edx

decrement:
    sub eax, 26
    jmp loop_storing

;; here i jump if i want to end the program (from label loop_storing)
end:

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY