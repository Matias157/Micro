; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores

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
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us
		IMPORT  GPIO_Init
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortQ_Output
		IMPORT  PortP_Output
		IMPORT  PortM_Output
		IMPORT  PortK_Output
		IMPORT  PortL_Output
        IMPORT  PortJ_Input
		IMPORT  PortC_Input
			
Aberto DCB  "Digite senha",0
Fechado DCB "Cofre fechado",0
Fechando DCB "Cofre fechando",0

; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO

MainLoop
; ****************************************
	BL inicializa_LCD
	LDR R5, =Aberto
	BL mostra_LCD
apertou
	BL verifica_teclado
	CMP R7, #'#'
	BEQ apertou
	PUSH {R7}
	BL verifica_teclado
	CMP R7, #'#'
	BEQ apertou
	PUSH {R7}
	BL verifica_teclado
	CMP R7, #'#'
	BEQ apertou
	PUSH {R7}
	BL verifica_teclado
	CMP R7, #'#'
	BEQ apertou
	PUSH {R7}
	BL verifica_teclado
	CMP R7, #'#'
	ITE EQ
		NOPEQ
		BNE apertou
	POP {R7}
	MOV R9, R7
	POP {R7}
	MOV R10, R7
	POP {R7}
	MOV R11, R7
	POP {R7}
	MOV R12, R7
	MOV R0, #1000
	BL SysTick_Wait1ms
	BL inicializa_LCD
	LDR R5, =Fechando
	BL mostra_LCD
	MOV R0, #5000
	BL SysTick_Wait1ms
	BL inicializa_LCD
	LDR R5, =Fechado
	BL mostra_LCD
apertou2
	BL verifica_teclado
	CMP R7, R12
	BNE apertou2
	BL verifica_teclado
	CMP R7, R11
	BNE apertou2
	BL verifica_teclado
	CMP R7, R10
	BNE apertou2
	BL verifica_teclado
	CMP R7, R9
	BNE apertou2
	B MainLoop
	
inicializa_LCD
	MOV R0, #0x38
	PUSH {LR}
	BL PortK_Output
	POP {LR}
	MOV R0, #0x38
	PUSH {LR}
	BL PortK_Output
	POP {LR}
	MOV R0, #2_00000100
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #0x06
	PUSH {LR}
	BL PortK_Output
	POP {LR}
	MOV R0, #2_00000100
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #0x0E
	PUSH {LR}
	BL PortK_Output
	POP {LR}
	MOV R0, #2_00000100
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #0x01
	PUSH {LR}
	BL PortK_Output
	POP {LR}
	MOV R0, #2_00000100
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #164
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	BX LR

mostra_LCD
	LDRB R0, [R5], #1
	MOV R6, R0
	CMP R6, #0
	BXEQ LR
	PUSH {LR}
	BL PortK_Output
	POP {LR}
	MOV R0, #10
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	MOV R0, #2_00000101
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	MOV R0, #40
	PUSH {LR}
	BL SysTick_Wait1us
	POP {LR}
	MOV R0, #2_00000001
	PUSH {LR}
	BL PortM_Output
	POP {LR}
	CMP R6, #0
	BNE mostra_LCD
	
verifica_teclado
	MOV R0, #2_00001110
	PUSH {LR}
	BL PortL_Output
	POP {LR}
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11100000
	BEQ Um
	CMP R0, #2_11010000
	BEQ Dois
	CMP R0, #2_10110000
	BEQ Tres
	MOV R0, #2_00001101
	PUSH {LR}
	BL PortL_Output
	POP {LR}
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11100000
	BEQ Quatro
	CMP R0, #2_11010000
	BEQ Cinco
	CMP R0, #2_10110000
	BEQ Seis
	MOV R0, #2_00001011
	PUSH {LR}
	BL PortL_Output
	POP {LR}
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11100000
	BEQ Sete
	CMP R0, #2_11010000
	BEQ Oito
	CMP R0, #2_10110000
	BEQ Nove
	MOV R0, #2_00000111
	PUSH {LR}
	BL PortL_Output
	POP {LR}
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11010000 
	BEQ Zero
	CMP R0, #2_10110000
	BEQ Hash
	B verifica_teclado
Um
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Um
	MOV R7, #1
	BX LR
Dois
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Dois
	MOV R7, #2
	BX LR
Tres
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Tres
	MOV R7, #3
	BX LR
Quatro
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Quatro
	MOV R7, #4
	BX LR
Cinco
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Cinco
	MOV R7, #5
	BX LR
Seis
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Seis
	MOV R7, #6
	BX LR
Sete
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Sete
	MOV R7, #7
	BX LR
Oito
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Oito
	MOV R7, #8
	BX LR
Nove
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Nove
	MOV R7, #9
	BX LR
Zero
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Zero
	MOV R7, #0
	BX LR
Hash
	PUSH {LR}
	BL PortC_Input
	POP {LR}
	BIC R0, #2_00001111
	CMP R0, #2_11110000
	BNE Hash
	MOV R7, #'#'
	BX LR
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
