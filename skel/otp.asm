%include "io.mac"

section .text
    global otp
    extern printf

otp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement the One Time Pad cipher

;; I loop through the strings starting from the end
;; of those and store the characters from the adresses
;; esi + ecx - 1 and edi + ecx - 1 in eax and ebx where
;; edi is the register that contains the key and esi
;; is plaintext
;; I decrement the value in ecx so i can iterate through
;; the characters of the strings

;; The label where the loop in the strings begins
loop_cipher:
;; here I put in eax and ebx the caracters taken from
;; the plaintext and the key strings
    mov eax, [esi + ecx - 1]
    mov ebx, [edi + ecx - 1]
;; here i make the xor and store it in eax
    xor eax, ebx
;; I store at the same position in edx the result
;; (I store only one byte, so I use the al 8-bit
;; register)
    mov [edx + ecx - 1], al
;; I decrement the value stored in ecx
    sub ecx, 1
    cmp ecx, 1
;; if ecx is not 0 yet, so the 2 strings still have
;; characters to be worked with, then i jump at the
;; loop_cipher label
    jge loop_cipher

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY