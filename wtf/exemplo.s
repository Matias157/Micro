; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
; Função main()
Start  
; Comece o código aqui <======================================================
;	MOV R0, #65
;	MOV R1, #0x1B00
;	MOVT R1, #0x1B00
;	MOV R2, #0x5678
;	MOVT R2, #0x1234
;	MOV R3, #0x0040
;	MOVT R3, #0x2000
;	STR R0, [R3]
;	STR R1, [R3, #4]
;	STR R2, [R3, #8]
;	MOV R4, #0x0001
;	MOVT R4, #0x000F
;	STR R4, [R3, #12]
;	MOV R5, #0xCD
;	STRH R5, [R3, #6]
;	LDR R7, [R3]
;	LDR R8, [R3, #8]
;	MOV R9, R7
;	MOV R1, #0xF0
;	ANDS R0, R1, #2_01010101
;	MOV R2, #2_11001100
;	ANDS R1, R2, #2_00110011
;	MOV R3, #2_10000000
;	ORRS R2, R3, #2_00110111
;	MOV R4, #0xABCD
;	MOVT R4, #0xABCD
;	MOV R3, #0xFFFF
;	MOVT R3, #0x0000
;	BICS R3, R4, R3
;	MOV R1, #701
;	LSRS R1, #5
;	MOV R2, #32067
;	NEG R2, R2
;	LSRS R2, #4
;	MOV R3, #701
;	ASRS R3, #3
;	MOV R4, #32067
;	NEG R4, R4
;	ASRS R4, #5
;	MOV R5, #255
;	LSRS R5, #8
;	MOV R6, #58982
;	NEG R6, R6
;	LSRS R6, #18
;	MOV R7, #0x1234
;	MOVT R7, #0xFABC
;	RORS R7, #10
;	MOV R8, #0x4321
;	RRXS R8, R8
;	RRXS R8, R8
;	MOV R0, #101
;	ADDS R0, #253
;	MOV R1, #40543
;	ADD R1, #1500
;	MOV R2, #340
;	SUBS R2, #123
;	MOV R3, #1000
;	SUBS R3, #2000
;	MOV R4, #54378
;	MOV R9, #4
;	MUL R4, R4, R9
;	MOV R5, #0x3344
;	MOVT R5, #0x1122
;	MOV R6, #0x2211
;	MOVT R6, #0x4433
;	UMULL R7, R8, R5, R6
;	MOV R10, #0x7560
;	MOVT R10, #0xFFFF
;	MOV R11, #1000
;	SDIV R10, R10, R11
;	MOV R11, #0x7560
;	MOVT R11, #0xFFFF
;	MOV R12, #1000
;	UDIV R11, R11, R12
;	MOV R0, #10
;	CMP R0, #9
;	ITTE GE
;		MOVGE R1, #50
;		ADDGE R2, R1, #32
;		MOVLT R3, #75
;	MOV R0, #10
;	MOV R1, #0xCC22
;	MOVT R1, #0xFF11
;	MOV R2, #1234
;	MOV R3, #0x300
;	PUSH {R0}
;	PUSH {R1}
;	PUSH {R2}
;	PUSH {R3}
;	MOV R1, #60
;	MOV R2, #0x1234
;	POP {R3}
;	POP {R2}
;	POP {R1}
;	POP {R0}
;		MOV R0, #10
;volta	ADDS R0, #5
;		CMP R0, #50
;		BNE volta
;		CMP R0, #50
;		BEQ func
;chamada 
;		B fimfunc
;func	MOV R1, R0
;		CMP R1, #50
;		BGE pula
;		ADDS R1, #1
;pula	MOV R1, #50
;		NEG R1, R1
;		B chamada
;fimfunc 
;		NOP
;trava	B trava
		
		
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
