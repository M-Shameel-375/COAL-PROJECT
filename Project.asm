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
emp_data proc
    ; Prompt for number of employees
    lea dx, msgEmpCountPrompt
    mov ah, 9
    int 21h
    
    ; Get number of employees
    mov ah, 01h
    int 21h
    sub al, '0'                     ; Convert ASCII to integer
    mov cl, al                       ; Store number in CL for loop count
    
    ; Initialize BX for data storage
    mov al, total                    ; Move total into AL (8-bit)
    mov bl, al                        ; Move the value of AL into BL (lower 8 bits of BX)
    mov al, 90                        ; Size of each employee record
    mul bl                            ; BX = total * empSize (for proper offset calculation)
    add bx, offset empData           ; Point to start of next employee record
    
    ; Loop to enter each employee's data
    mov ch, 0                         ; Clear CH for loop count
empdata_loop:
    ; Check if we've added the required number of employees
    cmp ch, cl                       ; Compare loop count (ch) with number of employees (cl)
    je end_empdata                   ; If loop count equals number of employees, jump to end
    
    ; Enter employee name
    lea dx, msgEnterName
    mov ah, 9
    int 21h
    call get_input
    mov di, bx                       ; Store name at empData + offset
    mov si, offset buffer
    call store_string
    
    ; Enter employee ID
    lea dx, msgEnterID
    mov ah, 9
    int 21h
    call get_input
    add di, 30                       ; Next 30 bytes for ID
    mov si, offset buffer
    call store_string

    ; Enter employee address
    lea dx, msgEnterAddress
    mov ah, 9
    int 21h
    call get_input
    add di, 20                       ; Next 20 bytes for address
    mov si, offset buffer
    call store_string

    ; Enter employee contact
    lea dx, msgEnterContact
    mov ah, 9
    int 21h
    call get_input
    add di, 20                       ; Next 20 bytes for contact
    mov si, offset buffer
    call store_string

    ; Enter employee salary
    lea dx, msgEnterSalary
    mov ah, 9
    int 21h
    call get_input
    add di, 20                       ; Next 20 bytes for salary
    mov si, offset buffer
    call store_string
    
    ; Prepare for next employee
    add bx, empSize                  ; Move to next employee slot in data array
    inc ch                           ; Increase counter
    
    ; Loop back to ask for next employee's data
    jmp empdata_loop                 ; Continue loop for the next employee
    
end_empdata:
    ; Display employee added message
    lea dx, msgEmployeeAdded
    mov ah, 9
    int 21h
    
    ; Update total employee count
    mov al, total
    add al, cl
    mov total, al
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
