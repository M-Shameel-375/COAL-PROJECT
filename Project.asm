.model small
.stack 100h
.data
    ; Menu and prompt messages
    msgTitle db 13, 10, 9, 9, " ____________________________________________", 13, 10, "$"
    msgHeader db 9, 9, "|      Employee Management System           |", 13, 10, "$"
    msgBorder db 9, 9, "|____________________________________________|", 13, 10, "$"
    msgOption1 db 9, 9, "| [1]  To Enter data                        |", 13, 10, "$"
    msgOption2 db 9, 9, "| [2]  To Show data                         |", 13, 10, "$"
    msgOption3 db 9, 9, "| [3]  To Search data                       |", 13, 10, "$"
    msgOption4 db 9, 9, "| [4]  To Update data                       |", 13, 10, "$"
    msgOption5 db 9, 9, "| [5]  To Delete data                       |", 13, 10, "$"
    msgOption6 db 9, 9, "| [6]  To Logout                            |", 13, 10, "$"
    msgOption7 db 9, 9, "| [7]  To Exit                              |", 13, 10, "$"
    msgFooter db 9, 9, "|____________________________________________|", 13, 10, "$"
    msgPrompt db 13, 10, 9, 9, "Enter your choice ==> $"
    
    ; Employee data prompts
    msgEmpCountPrompt db "How many employees data do you want to enter ==> $"
    msgEmployeeAdded db "Employee Added successfully", 0Dh, 0Ah, "$"
    msgEnterName db "Enter employee name: $"
    msgEnterID db "Enter id: $"
    msgEnterAddress db "Enter address: $"
    msgEnterContact db "Enter contact: $"
    msgEnterSalary db "Enter salary: $"
    ; Other data messages...
    msgLimitReached db "Employee limit reached!", 13, 10, "$"
    ; Storage for employee data (max 10 employees, adjust as needed)
    total db 0                      ; Total number of employees
    maxEmployees equ 10
    empSize equ 90                  ; Fixed size per employee (name, id, address, etc.)
    empData db maxEmployees * empSize dup(?)

.code
main proc
    mov ax, @data            ; Initialize data segment
    mov ds, ax

    ; Display menu and get user choice
display_menu_start:
    call display_menu_proc
    call get_choice
    cmp al, '1'
    je enter_data

    ; Exit program if choice is '7'
    cmp al, '7'
    je exit_program

    ; Loop back to display menu for any other choice
    jmp display_menu_start

enter_data:
    call emp_data             ; Calls the procedure to add employee data
    jmp display_menu_start

exit_program:
    mov ah, 4Ch              ; Exit to DOS
    int 21h
main endp

display_menu_proc proc
    ; Print each menu line
    lea dx, msgTitle
    mov ah, 9
    int 21h

    lea dx, msgHeader
    mov ah, 9
    int 21h

    lea dx, msgBorder
    mov ah, 9
    int 21h

    lea dx, msgOption1
    mov ah, 9
    int 21h

    lea dx, msgOption2
    mov ah, 9
    int 21h

    lea dx, msgOption3
    mov ah, 9
    int 21h

    lea dx, msgOption4
    mov ah, 9
    int 21h

    lea dx, msgOption5
    mov ah, 9
    int 21h

    lea dx, msgOption6
    mov ah, 9
    int 21h

    lea dx, msgOption7
    mov ah, 9
    int 21h

    lea dx, msgFooter
    mov ah, 9
    int 21h

    lea dx, msgPrompt
    mov ah, 9
    int 21h
    ret
display_menu_proc endp 

get_choice proc
    ; Get user choice
    mov ah, 1               ; DOS function to read character from keyboard
    int 21h
    ret
get_choice endp

emp_data proc
    ; Check if max employee limit reached
    mov al, total            ; Load the total into AL (8-bit register)
    cmp al, maxEmployees
    jae emp_data_full        ; If total >= maxEmployees, skip adding

    ; Calculate offset for the new employee
    mov bl, al               ; Move AL (total) into BL (lower 8 bits of BX)
    mov al, empSize          ; Move empSize into AL
    mul bl                   ; Multiply total * empSize
    add bx, offset empData   ; Point BX to start of new employee's record

    ; Enter employee name
    call newline
    lea dx, msgEnterName
    mov ah, 9
    int 21h
    call get_input
    mov di, bx
    mov si, offset buffer
    call store_string
    
    ; Enter employee ID
    call newline
    lea dx, msgEnterID
    mov ah, 9
    int 21h
    call get_input
    add di, 30
    mov si, offset buffer
    call store_string

    ; Enter employee address
    call newline
    lea dx, msgEnterAddress
    mov ah, 9
    int 21h
    call get_input
    add di, 20
    mov si, offset buffer
    call store_string

    ; Enter employee contact
    call newline
    lea dx, msgEnterContact
    mov ah, 9
    int 21h
    call get_input
    add di, 20
    mov si, offset buffer
    call store_string

    ; Enter employee salary
    call newline
    lea dx, msgEnterSalary
    mov ah, 9
    int 21h
    call get_input
    add di, 20
    mov si, offset buffer
    call store_string

    ; Display employee added message
    lea dx, msgEmployeeAdded
    mov ah, 9
    int 21h
    
    ; Increment total employee count
    inc total
    ret

emp_data_full:
    ; Display message if max employee limit is reached
    lea dx, msgLimitReached
    mov ah, 9
    int 21h
    ret
emp_data endp


; Procedure to get input into buffer
buffer db 50 dup(?)
get_input proc
    mov ah, 0Ah                     ; DOS input function
    lea dx, buffer
    int 21h
    ret
get_input endp

newline proc
    mov ah, 2
    mov dl, 13      
    int 21h
    mov dl, 10      
    int 21h
    ret
newline endp


; Procedure to store string from buffer to memory at [di]
store_string proc
    mov cx, 30                      ; Max size for name
store_loop:
    lodsb                           ; Load byte from buffer
    stosb                           ; Store byte to destination
    loop store_loop
    ret
store_string endp

end main