.model small
.stack 100h
.data
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

.code
main proc
    mov ax, @data            ; Initialize data segment
    mov ds, ax

    ; Display the menu
    call display_menu

    ; Program exit
    mov ah, 4Ch              ; Exit to DOS
    int 21h
main endp

display_menu proc
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
display_menu endp

end main
