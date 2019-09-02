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
		IMPORT  GPIO_Init
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortQ_Output
		IMPORT  PortP_Output
        IMPORT  PortJ_Input	


; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO

MainLoop
; ****************************************
; Escrever código que lê o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************
	MOV R0, #0
	BL PortA_Output
	BL PortQ_Output
	BL PortB_Output
	BL PortP_Output
	MOV R9, #1
	MOV R7, #1
MantemContagem
	MOV R11, #0
	MOV R8, #0
	MOV R0, #0
	BL PortB_Output
	MOV R0, #5
	BL SysTick_Wait1ms
	BL SSD
	MOV R4, #99
	MOV R12, #15
MantemLED
	MOV R11, #0
Conta
	ADDS R11, R7
	CMP R11, R12
	BGT MantemLED
	ADDS R8, R9 
	CMP R8, R4
	BGT MantemContagem
	MOV R0, #5
	BL SysTick_Wait1ms
	BL SSD
Verifica_SW1
	BL PortJ_Input
	CMP R0, #2_00000010
	BNE Verifica_SW2
	BL IncrementaPasso
	B Conta
Verifica_SW2
	BL PortJ_Input
	CMP R0, #2_00000001
	BNE Conta
	BL DecrementaPasso
	B Conta

;--------------------------------------------------------------------------------
; Função IncrementaPasso
; Parâmetro de entrada: R9
; Parâmetro de saída: R9
IncrementaPasso
	CMP R9, #9
	IT NE
		ADDSNE R9, #1
	BX LR
;--------------------------------------------------------------------------------
; Função DecrementaPasso
; Parâmetro de entrada: R9
; Parâmetro de saída: R9
DecrementaPasso
	CMP R9, #1
	IT NE
		SUBSNE R9, #1
	BX LR
;--------------------------------------------------------------------------------
; Função SSD
; Parâmetro de entrada: R3
; Parâmetro de saída: Não tem
SSD
	MOV R10, #0
Loop
	ADDS R10, #1
	MOV R5, #10
	MOV R0, #2_00010000
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	UDIV R6, R8, R5
	PUSH {LR}
	BL CodificaValor
	POP {LR}
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	MOV R0, #0
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	MOV R0, #2_00100000
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	MUL R6, R6, R5
	SUB R6, R8, R6
	PUSH {LR}
	BL CodificaValor
	POP {LR}
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	MOV R0, #0
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	MOV R0, #2_00100000
	PUSH {LR}
	BL PortP_Output
	POP {LR}
	PUSH {LR}
	BL CodificaLED
	POP {LR}
	MOV R0, #5
	PUSH {LR}
	BL SysTick_Wait1ms
	POP {LR}
	MOV R0, #0
	PUSH {LR}
	BL PortP_Output
	POP {LR}
	CMP R10, #100
	BNE Loop
	BX LR
;--------------------------------------------------------------------------------
; Função CodificaLED
; Parâmetro de entrada: R11
; Parâmetro de saída: Não tem
CodificaLED
	CMP R11, #0
	BNE LED2
	MOV R0, #2_00000001
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED2
	CMP R11, #1
	BNE LED3
	MOV R0, #2_00000011
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED3
	CMP R11, #2
	BNE LED4
	MOV R0, #2_00000111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED4
	CMP R11, #3
	BNE LED5
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED5
	CMP R11, #4
	BNE LED6
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00010000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED6
	CMP R11, #5
	BNE LED7
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED7
	CMP R11, #6
	BNE LED8
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_01110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED8
	CMP R11, #7
	BNE LED9
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_11110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED9
	CMP R11, #8
	BNE LED10
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_01110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED10
	CMP R11, #9
	BNE LED11
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED11
	CMP R11, #10
	BNE LED12
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00010000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED12
	CMP R11, #11
	BNE LED13
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED13
	CMP R11, #12
	BNE LED14
	MOV R0, #2_00000111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED14
	CMP R11, #13
	BNE LED15
	MOV R0, #2_00000011
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED15
	CMP R11, #14
	BNE LED16
	MOV R0, #2_00000001
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	BX LR
LED16
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R11, #-1
	BX LR
;--------------------------------------------------------------------------------
; Função CodificaValor
; Parâmetro de entrada: R6
; Parâmetro de saída: Não tem
CodificaValor
	CMP R6, #0
	BNE Um
	MOV R0, #2_00110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Um
	CMP R6, #1
	BNE Dois
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00000110
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Dois
	CMP R6, #2
	BNE Tres
	MOV R0, #2_01010000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00001011
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Tres
	CMP R6, #3
	BNE Quatro
	MOV R0, #2_01000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Quatro
	CMP R6, #4
	BNE Cinco
	MOV R0, #2_01100000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00000110
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Cinco
	CMP R6, #5
	BNE Seis
	MOV R0, #2_01100000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00001101
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Seis
	CMP R6, #6
	BNE Sete
	MOV R0, #2_01110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00001101
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Sete
	CMP R6, #7
	BNE Oito
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00000111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Oito
	CMP R6, #8
	BNE Nove
	MOV R0, #2_01110000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
Nove
	MOV R0, #2_01100000
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	MOV R0, #2_00001111
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	BX LR
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
