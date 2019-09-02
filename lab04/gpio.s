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
NVIC_EN1_R           EQU 	0xE000E104		; Enable 1 interrup��es de de 32 a 63
NVIC_PRI12_R         EQU	0xE000E430		; Prioridade das interrup��es de 48 a 51
; ========================
; Defini��es dos Ports
; PORT A
GPIO_PORTA_AHB_LOCK_R		EQU		0x40058520
GPIO_PORTA_AHB_CR_R			EQU		0x40058524
GPIO_PORTA_AHB_AMSEL_R		EQU		0x40058528
GPIO_PORTA_AHB_PCTL_R		EQU		0x4005852C
GPIO_PORTA_AHB_DIR_R		EQU		0x40058400
GPIO_PORTA_AHB_AFSEL_R		EQU		0x40058420
GPIO_PORTA_AHB_DEN_R		EQU		0x4005851C
GPIO_PORTA_AHB_PUR_R		EQU		0x40058510
GPIO_PORTA_AHB_DATA_R		EQU		0x400583FC
GPIO_PORTA               	EQU		2_000000000000001
	
; PORT E
GPIO_PORTE_AHB_LOCK_R       EQU     0x4005C520
GPIO_PORTE_AHB_CR_R         EQU     0x4005C524
GPIO_PORTE_AHB_AMSEL_R      EQU     0x4005C528
GPIO_PORTE_AHB_PCTL_R       EQU     0x4005C52C
GPIO_PORTE_AHB_DIR_R        EQU     0x4005C400
GPIO_PORTE_AHB_AFSEL_R      EQU     0x4005C420
GPIO_PORTE_AHB_DEN_R        EQU     0x4005C51C
GPIO_PORTE_AHB_PUR_R        EQU     0x4005C510
GPIO_PORTE_AHB_DATA_R       EQU     0x4005C3FC
GPIO_PORTE               	EQU		2_000000000010000

; PORT F
GPIO_PORTF_AHB_LOCK_R       EQU     0x4005D520
GPIO_PORTF_AHB_CR_R         EQU     0x4005D524
GPIO_PORTF_AHB_AMSEL_R      EQU     0x4005D528
GPIO_PORTF_AHB_PCTL_R       EQU     0x4005D52C
GPIO_PORTF_AHB_DIR_R        EQU     0x4005D400
GPIO_PORTF_AHB_AFSEL_R      EQU     0x4005D420
GPIO_PORTF_AHB_DEN_R        EQU     0x4005D51C
GPIO_PORTF_AHB_PUR_R        EQU     0x4005D510
GPIO_PORTF_AHB_DATA_R       EQU     0x4005D3FC
GPIO_PORTF               	EQU		2_000000000100000

; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU     0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU     0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU     0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU     0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU     0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU     0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU     0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU     0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU     0x400603FC
GPIO_PORTJ               	EQU     2_000000100000000

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortA_Output			; Permite chamar PortA_Output de outro arquivo
		EXPORT PortE_Output			; Permite chamar PortE_Output de outro arquivo
		EXPORT PortF_Output			; Permite chamar PortF_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo	

		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; ****************************************
; Escrever fun��o de inicializa��o dos GPIO
; Inicializar as portas A, J, B, Q, e P
; ****************************************
	LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
	MOV		R1, #GPIO_PORTA                 ;Seta o bit da porta A
	ORR     R1, #GPIO_PORTE					;Seta o bit da porta E, fazendo com OR
	ORR     R1, #GPIO_PORTF					;Seta o bit da porta F, fazendo com OR
	ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
    STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
    LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO
	LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
	MOV     R2, #GPIO_PORTA                 ;Seta os bits correspondentes �s portas para fazer a compara��o
	ORR     R2, #GPIO_PORTE                 ;Seta o bit da porta E, fazendo com OR
	ORR     R2, #GPIO_PORTF                 ;Seta o bit da porta F, fazendo com OR
	ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
    TST     R1, R2							;ANDS de R1 com R2
    BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando

    MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
    LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta J
    STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
    LDR     R0, =GPIO_PORTA_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta A
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta A da mem�ria
	LDR     R0, =GPIO_PORTE_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta E
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta E da mem�ria
	LDR     R0, =GPIO_PORTF_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta F
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta F da mem�ria

    MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
    LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
    LDR     R0, =GPIO_PORTA_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta A
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta A da mem�ria
	LDR     R0, =GPIO_PORTE_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta E
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta E da mem�ria
	LDR     R0, =GPIO_PORTF_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta F
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da mem�ria

    LDR     R0, =GPIO_PORTE_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta E
	MOV     R1, #2_00001111					;PE0, PE1, PE2 e PE3 para o SSD
    STR     R1, [R0]						;Guarda no registrador
	
	LDR     R0, =GPIO_PORTF_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta F
	MOV     R1, #2_00000100					;PF2 para o SSD
    STR     R1, [R0]						;Guarda no registrador
	
	LDR     R0, =GPIO_PORTA_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta A
	MOV     R1, #2_11110000					;PA4, PA5, PA6 e PA7 para o SSD
    STR     R1, [R0]						;Guarda no registrador
			
    LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
    MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com sa�da
    STR     R1, [R0]						;Guarda no registrador PCTL da porta J da mem�ria

    MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
    LDR     R0, =GPIO_PORTA_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta A
	STR     R1, [R0]						;Escreve na porta
	LDR     R0, =GPIO_PORTE_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta E
	STR     R1, [R0]						;Escreve na porta
	LDR     R0, =GPIO_PORTF_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta F
	STR     R1, [R0]						;Escreve na porta
    LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTA_AHB_DEN_R		;Carrega o endere�o do DEN
    MOV     R1, #2_11110000                 ;Ativa os pinos PA4, PA5, PA6 e PA7 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da mem�ria funcionalidade digital
	
	LDR     R0, =GPIO_PORTE_AHB_DEN_R		;Carrega o endere�o do DEN
    MOV     R1, #2_00001111                 ;Ativa os pinos PE0, PE1, PE2 e PE3 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da mem�ria funcionalidade digital
	
	LDR     R0, =GPIO_PORTF_AHB_DEN_R		;Carrega o endere�o do DEN
    MOV     R1, #2_00000100                 ;Ativa os pinos PF2 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da mem�ria funcionalidade digital
 
    LDR     R0, =GPIO_PORTJ_AHB_DEN_R		;Carrega o endere�o do DEN
	MOV     R1, #2_00000011                 ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
	STR     R1, [R0]                        ;Escreve no registrador da mem�ria funcionalidade digital
			
	LDR     R0, =GPIO_PORTJ_AHB_PUR_R		;Carrega o endere�o do PUR para a porta J
	MOV     R1, #2_00000011					;Habilitar funcionalidade digital de resistor de pull-up 
                                            ;nos bits 0 e 1
    STR     R1, [R0]						;Escreve no registrador da mem�ria do resistor de pull-up
			
	BX LR
; -------------------------------------------------------------------------------
; Fun��o PortA_Output/
; Par�metro de entrada: 
; Par�metro de sa�da: N�o tem
PortA_Output
; ****************************************
; Escrever fun��o que acende ou apaga os segmentos do SSD
; ****************************************
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os quatro bits do lido da porta R2 = R2 & 00001111
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta A o barramento de dados dos pinos A4, A5, A6 e A7
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Fun��o PortE_Output/
; Par�metro de entrada: 
; Par�metro de sa�da: N�o tem
PortE_Output
; ****************************************
; Escrever fun��o que acende ou apaga os segmentos do SSD
; ****************************************
	LDR	R1, =GPIO_PORTE_AHB_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os quatro bits do lido da porta R2 = R2 & 11110000
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta E o barramento de dados dos pinos E0, E1, E2 e E3
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Fun��o PortF_Output/
; Par�metro de entrada: 
; Par�metro de sa�da: N�o tem
PortF_Output
; ****************************************
; Escrever fun��o que acende ou apaga os segmentos do SSD
; ****************************************
	LDR	R1, =GPIO_PORTF_AHB_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00000100                     ;Primeiro limpamos os quatro bits do lido da porta R2 = R2 & 11111011
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta A o barramento de dados dos pinos F2
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever fun��o que l� a chave e retorna 
; um registrador se est� ativada ou n�o
; ****************************************
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;L� no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno
	
	ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo