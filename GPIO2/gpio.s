; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000


; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
									

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; ****************************************
; Escrever fun��o de inicializa��o dos GPIO
; Inicializar as portas J e N
; ****************************************
    LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
	MOV		R1, #GPIO_PORTN                 ;Seta o bit da porta F
	ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
    STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
    LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO
	LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
	MOV     R2, #GPIO_PORTN                 ;Seta os bits correspondentes �s portas para fazer a compara��o
	ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
    TST     R1, R2							;ANDS de R1 com R2
    BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando

    MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
    LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta J
    STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
    LDR     R0, =GPIO_PORTN_AHB_AMSEL_R			;Carrega o R0 com o endere�o do AMSEL para a porta F
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta F da mem�ria

    MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
    LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
    LDR     R0, =GPIO_PORTN_AHB_PCTL_R      	;Carrega o R0 com o endere�o do PCTL para a porta F
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da mem�ria

    LDR     R0, =GPIO_PORTN_AHB_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta F
	MOV     R1, #2_00010001					;PF4 & PF0 para LED
    STR     R1, [R0]						;Guarda no registrador
			
    LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
    MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com sa�da
    STR     R1, [R0]						;Guarda no registrador PCTL da porta J da mem�ria

    MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
    LDR     R0, =GPIO_PORTN_AHB_AFSEL_R			;Carrega o endere�o do AFSEL da porta F
	STR     R1, [R0]						;Escreve na porta
    LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTN_AHB_DEN_R			;Carrega o endere�o do DEN
    MOV     R1, #2_00010001                     ;Ativa os pinos PF0 e PF4 como I/O Digital
    STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
 
    LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
	MOV     R1, #2_00000011                     ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
	STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
			

	LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
	MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 e 1
    STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
			
	BX LR

; -------------------------------------------------------------------------------
; Fun��o PortN_Output
; Par�metro de entrada: 
; Par�metro de sa�da: N�o tem
PortN_Output
; ****************************************
; Escrever fun��o que acende ou apaga o LED
; ****************************************
	LDR R1, =GPIO_PORTN_AHB_DATA_R
	LDR R2, [R1]
	BIC R2, #2_00010000
	ORR R0, R0, R2
	STR R0, [R1]
	BX LR
	
; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever fun��o que l� a chave e retorna 
; um registrador se est� ativada ou n�o
; ****************************************
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R
	LDR R0, [R1]
	BX LR


    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo