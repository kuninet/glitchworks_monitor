;Glitch Works Monitor I/O Module for Motorola MC6850 ACIA

;Adjust CTLPRT and DATPRT for your specific hardware.
;Stack Pointer initialized at 0xFFFF, adjust as needed.
;
;After including this module, you still need to
;set the ORG in the main monitor source.

CTLPRT  equ 80H
DATPRT  equ 81H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SETUP -- Prepare the system for running the
;   monitor
;
;pre: none
;post: stack and console are initialized
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SETUP:  LXI SP, 0FFFFH
        LXI H, INIUART$
        MVI B, 02H              ; length of ini string
INURT:  MOV A, M
        OUT CTLPRT
        INX H
        DCR B
        JNZ INURT
        JMP SE1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CINNE -- Get a char from the console, no echo
;
;pre: console device is initialized
;post: received char is in A register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CINNE:  IN CTLPRT
        ANI 01H
        JZ CINNE
        IN DATPRT
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CIN -- Get a char from the console and echo
;
;pre: console device is initialized
;post: received char is in A register
;post: received char is echoed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CIN:    CALL CINNE
        OUT DATPRT
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;COUT -- Output a character to the console
;
;pre: A register contains char to be printed
;post: character is printed to the console
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COUT:   PUSH B
        MOV B, A
COUT1:  IN CTLPRT
        ANI 02H
        JZ COUT1
        MOV A, B
        OUT DATPRT
        POP B
        RET

;Init string for the 6850, x16 clock, 8N1
INIUART$:  db 03H,16H

;I/O Module description string
MSG$:     db 13, 10, 'Built with Motorola MC6850 I/O module', 0
