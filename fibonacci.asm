section .text

global _start

_start: 
    call getInput

    mov rdx, num
    call atoi
    mov rdi, rax
    
    call printFibonacci

    call exit



getInput: 
    mov rax, 4
    mov rbx, 1
    mov rcx, getTerms
    mov rdx,lenGetTerms
    int 0x80

    mov rax, 3
    mov rbx, 1
    mov rcx, num
    mov rdx,8
    int 0x80
    ret


printFibonacci: 
    call printNewLine

    ;rdi contains count of terms

    cmp rdi, 0
    jle printError

    mov r8, 0
    mov r9, 1
    mov r11, rdi

    mov rax, 4
    mov rbx, 1
    mov rcx, printTerms
    mov rdx, lenPrintTerms
    int 0x80

    mov rax, 4
    mov rbx, 1
    mov rcx, num
    mov rdx, 8
    int 0x80

    call printNewLine

    call printInitialTerms
    call printNewLine


loops1:
    mov rax, r9
    add rax, r8
    mov r8, r9
    mov r9, rax
    call itoa
    call printNewLine
    sub r11, byte 0x1
    cmp r11, 0
    jle exit
    jmp loops1




ret



printInitialTerms:
    mov rax, 4
    mov rbx, 1
    mov rcx, t1
    mov rdx, 1
    int 0x80
    sub r11, byte 0x1
    cmp r11, 0
    jle exit

    call printNewLine

    mov rax, 4
    mov rbx, 1
    mov rcx, t2
    mov rdx, 1
    int 0x80
    sub r11, byte 0x1
    cmp r11, 0
    jle exit
    ret


printError:
    mov rax, 4
    mov rbx, 1
    mov rcx, showError
    mov rdx, lenShowError
    int 0x80
    call exit
    ret

exit:

    call printNewLine

    mov rax, 1
    mov rbx, 0
    int 0x80
    ret


atoi:
    mov rax, 0              ; Set initial total to 0
    mov rsi , 0

    convert:
        movzx rsi, byte[rdx]   ; Get the current character
        
        cmp byte[rdx+1] ,0
        je done

        
        cmp rsi, 48             ; Anything less than 0 is invalid
        jl error
        
        cmp rsi, 57             ; Anything greater than 9 is invalid
        jg error
        
        sub rsi, 48             ; Convert from ASCII to decimal 
        imul rax, 10            ; Multiply total by 10
        add rax, rsi            ; Add current digit to total
        
        inc rdx                  ; Get the address of the next character
        jmp convert

    error:
        mov rax, -1             ; Return -1 on error
    
    done:
        ret                     ; Return total or error code


;integer to ascii conversion function
itoa:
    xor rsi,rsi
    ;last index of string
    lea rsi, [string + 0x9]  
    
    loop:
    ;divide
    xor rdx, rdx
    xor rcx,rcx
    mov rcx, 0xa
    div rcx        

    ;convert remainder to ASCII and store
    add dl, 0x30
    mov [rsi-1],dl
    dec rsi

    ;if quotient is zero, done.
    cmp rax, 0
    je print

    ;traversed through entire string
    cmp rsi,string
    je print
    
    ; repeat.
    jmp loop

    ;print next term procedure
    print:
    mov rax,4
    mov rbx,1
    lea rcx,[string]

    ;finding where string generation starts
    sub rsi, string
    add rcx,rsi

    ;finding the final length of string
    mov rdx, lenStr
    sub rdx,rsi
    
    int 0x80
    ret


printNewLine: 
    mov rax, 4
    mov rbx, 1
    mov rcx, newLine
    mov rdx, lenNewLine
    int 0x80
    ret



section .bss
    num resb 8

section .data

    getTerms db "Enter the number of terms: " 
    lenGetTerms equ $-getTerms

    printTerms db "Printing Fibonacci till term "
    lenPrintTerms equ $-printTerms

    newLine db 0xA
    lenNewLine equ $-newLine

    showError db "Invalid Number fo Terms"
    lenShowError equ $-showError

    string dd "         "  
    lenStr equ $ - string
    
    comma db ' , '

    t1 db '0'
    t2 db '1'
    t3 db '1'

    divisorTable:
    dd 1000000000
    dd 100000000
    dd 10000000
    dd 1000000
    dd 100000
    dd 10000
    dd 1000
    dd 100
    dd 10
    dd 1
    dd 0