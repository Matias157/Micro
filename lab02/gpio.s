; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
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

; PORT B
GPIO_PORTB_AHB_LOCK_R		EQU		0x40059520
GPIO_PORTB_AHB_CR_R			EQU		0x40059524
GPIO_PORTB_AHB_AMSEL_R		EQU		0x40059528
GPIO_PORTB_AHB_PCTL_R		EQU		0x4005952C
GPIO_PORTB_AHB_DIR_R		EQU		0x40059400
GPIO_PORTB_AHB_AFSEL_R		EQU		0x40059420
GPIO_PORTB_AHB_DEN_R		EQU		0x4005951C
GPIO_PORTB_AHB_PUR_R		EQU		0x40059510
GPIO_PORTB_AHB_DATA_R		EQU		0x400593FC
GPIO_PORTB               	EQU		2_000000000000010

; PORT C
GPIO_PORTC_AHB_LOCK_R       EQU     0x4005A520
GPIO_PORTC_AHB_CR_R         EQU     0x4005A524
GPIO_PORTC_AHB_AMSEL_R      EQU     0x4005A528
GPIO_PORTC_AHB_PCTL_R       EQU     0x4005A52C
GPIO_PORTC_AHB_DIR_R        EQU     0x4005A400
GPIO_PORTC_AHB_AFSEL_R      EQU     0x4005A420
GPIO_PORTC_AHB_DEN_R        EQU     0x4005A51C
GPIO_PORTC_AHB_PUR_R        EQU     0x4005A510
GPIO_PORTC_AHB_DATA_R       EQU     0x4005A3FC
GPIO_PORTC               	EQU		2_000000000000100

; PORT D
GPIO_PORTD_AHB_LOCK_R       EQU     0x4005B520
GPIO_PORTD_AHB_CR_R         EQU     0x4005B524
GPIO_PORTD_AHB_AMSEL_R      EQU     0x4005B528
GPIO_PORTD_AHB_PCTL_R       EQU     0x4005B52C
GPIO_PORTD_AHB_DIR_R        EQU     0x4005B400
GPIO_PORTD_AHB_AFSEL_R      EQU     0x4005B420
GPIO_PORTD_AHB_DEN_R        EQU     0x4005B51C
GPIO_PORTD_AHB_PUR_R        EQU     0x4005B510
GPIO_PORTD_AHB_DATA_R       EQU     0x4005B3FC
GPIO_PORTD               	EQU		2_000000000001000

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

; PORT G
GPIO_PORTG_AHB_LOCK_R       EQU     0x4005E520
GPIO_PORTG_AHB_CR_R         EQU     0x4005E524
GPIO_PORTG_AHB_AMSEL_R      EQU     0x4005E528
GPIO_PORTG_AHB_PCTL_R       EQU     0x4005E52C
GPIO_PORTG_AHB_DIR_R        EQU     0x4005E400
GPIO_PORTG_AHB_AFSEL_R      EQU     0x4005E420
GPIO_PORTG_AHB_DEN_R        EQU     0x4005E51C
GPIO_PORTG_AHB_PUR_R        EQU     0x4005E510
GPIO_PORTG_AHB_DATA_R       EQU     0x4005E3FC
GPIO_PORTG               	EQU		2_000000001000000

; PORT H
GPIO_PORTH_AHB_LOCK_R       EQU     0x4005F520
GPIO_PORTH_AHB_CR_R         EQU     0x4005F524
GPIO_PORTH_AHB_AMSEL_R      EQU     0x4005F528
GPIO_PORTH_AHB_PCTL_R       EQU     0x4005F52C
GPIO_PORTH_AHB_DIR_R        EQU     0x4005F400
GPIO_PORTH_AHB_AFSEL_R      EQU     0x4005F420
GPIO_PORTH_AHB_DEN_R        EQU     0x4005F51C
GPIO_PORTH_AHB_PUR_R        EQU     0x4005F510
GPIO_PORTH_AHB_DATA_R       EQU     0x4005F3FC
GPIO_PORTH               	EQU		2_000000010000000

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
	
; PORT K
GPIO_PORTK_LOCK_R       	EQU	    0x40061520
GPIO_PORTK_CR_R         	EQU	    0x40061524
GPIO_PORTK_AMSEL_R      	EQU     0x40061528
GPIO_PORTK_PCTL_R       	EQU     0x4006152C
GPIO_PORTK_DIR_R        	EQU     0x40061400
GPIO_PORTK_AFSEL_R      	EQU     0x40061420
GPIO_PORTK_DEN_R        	EQU     0x4006151C
GPIO_PORTK_PUR_R        	EQU     0x40061510
GPIO_PORTK_DATA_R       	EQU     0x400613FC
GPIO_PORTK               	EQU     2_000001000000000

; PORT L
GPIO_PORTL_LOCK_R           EQU     0x40062520
GPIO_PORTL_CR_R             EQU     0x40062524
GPIO_PORTL_AMSEL_R          EQU     0x40062528
GPIO_PORTL_PCTL_R           EQU     0x4006252C
GPIO_PORTL_DIR_R            EQU     0x40062400
GPIO_PORTL_AFSEL_R          EQU     0x40062420
GPIO_PORTL_DEN_R            EQU     0x4006251C
GPIO_PORTL_PUR_R            EQU     0x40062510
GPIO_PORTL_DATA_R           EQU     0x400623FC
GPIO_PORTL               	EQU     2_000010000000000

; PORT M
GPIO_PORTM_LOCK_R           EQU     0x40063520
GPIO_PORTM_CR_R             EQU     0x40063524
GPIO_PORTM_AMSEL_R          EQU     0x40063528
GPIO_PORTM_PCTL_R           EQU     0x4006352C
GPIO_PORTM_DIR_R            EQU     0x40063400
GPIO_PORTM_AFSEL_R          EQU     0x40063420
GPIO_PORTM_DEN_R            EQU     0x4006351C
GPIO_PORTM_PUR_R            EQU     0x40063510
GPIO_PORTM_DATA_R           EQU     0x400633FC
GPIO_PORTM               	EQU     2_000100000000000

; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU     0x40064520
GPIO_PORTN_AHB_CR_R      	EQU     0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU     0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU     0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU     0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU     0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU     0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU     0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU     0x400643FC
GPIO_PORTN               	EQU     2_001000000000000	
	
; PORT P
GPIO_PORTP_LOCK_R			EQU		0x40065520
GPIO_PORTP_CR_R				EQU		0x40065524
GPIO_PORTP_AMSEL_R			EQU		0x40065528
GPIO_PORTP_PCTL_R			EQU		0x4006552C
GPIO_PORTP_DIR_R			EQU		0x40065400
GPIO_PORTP_AFSEL_R			EQU		0x40065420
GPIO_PORTP_DEN_R			EQU		0x4006551C
GPIO_PORTP_PUR_R			EQU		0x40065510
GPIO_PORTP_DATA_R			EQU		0x400653FC
GPIO_PORTP               	EQU		2_010000000000000

; PORT Q
GPIO_PORTQ_LOCK_R			EQU		0x40066520
GPIO_PORTQ_CR_R				EQU		0x40066524
GPIO_PORTQ_AMSEL_R			EQU		0x40066528
GPIO_PORTQ_PCTL_R			EQU		0x4006652C
GPIO_PORTQ_DIR_R			EQU		0x40066400
GPIO_PORTQ_AFSEL_R			EQU		0x40066420
GPIO_PORTQ_DEN_R			EQU		0x4006651C
GPIO_PORTQ_PUR_R			EQU		0x40066510
GPIO_PORTQ_DATA_R			EQU		0x400663FC
GPIO_PORTQ               	EQU		2_100000000000000

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortA_Output			; Permite chamar PortA_Output de outro arquivo
		EXPORT PortB_Output			; Permite chamar PortB_Output de outro arquivo
		EXPORT PortQ_Output			; Permite chamar PortQ_Output de outro arquivo
		EXPORT PortM_Output			; Permite chamar PortM_Output de outro arquivo
		EXPORT PortK_Output			; Permite chamar PortK_Output de outro arquivo
		EXPORT PortP_Output			; Permite chamar PortP_Output de outro arquivo
		EXPORT PortL_Output			; Permite chamar PortC_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT PortC_Input          ; Permite chamar PortL_Input de outro arquivo
									

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Escrever função de inicialização dos GPIO
; Inicializar as portas A, J, B, Q, e P
; ****************************************
	LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
	MOV		R1, #GPIO_PORTA                 ;Seta o bit da porta A
	ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
	ORR     R1, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
	ORR     R1, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
	ORR     R1, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
	ORR     R1, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
	ORR     R1, #GPIO_PORTK					;Seta o bit da porta K, fazendo com OR
	ORR     R1, #GPIO_PORTC					;Seta o bit da porta C, fazendo com OR
	ORR     R1, #GPIO_PORTL					;Seta o bit da porta L, fazendo com OR
    STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
    LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO
	LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
	MOV     R2, #GPIO_PORTA                 ;Seta os bits correspondentes às portas para fazer a comparação
	ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
	ORR     R2, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
	ORR     R2, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
	ORR     R2, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
	ORR     R2, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
	ORR     R2, #GPIO_PORTK					;Seta o bit da porta K, fazendo com OR
	ORR     R2, #GPIO_PORTC					;Seta o bit da porta C, fazendo com OR
	ORR     R2, #GPIO_PORTL					;Seta o bit da porta L, fazendo com OR
    TST     R1, R2							;ANDS de R1 com R2
    BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando

    MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
    LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
    STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
    LDR     R0, =GPIO_PORTA_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta A
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta A da memória
	LDR     R0, =GPIO_PORTB_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta B
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da memória
	LDR     R0, =GPIO_PORTC_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta C
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta C da memória
	LDR     R0, =GPIO_PORTQ_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta Q
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta Q da memória
	LDR     R0, =GPIO_PORTP_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta P
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta P da memória
	LDR     R0, =GPIO_PORTM_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta M
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta M da memória
	LDR     R0, =GPIO_PORTK_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta K
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta K da memória
	LDR     R0, =GPIO_PORTL_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta L
    STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta L da memória

    MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
    LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
    LDR     R0, =GPIO_PORTA_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta A
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta A da memória
	LDR     R0, =GPIO_PORTB_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta B
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória
	LDR     R0, =GPIO_PORTQ_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta Q
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória
	LDR     R0, =GPIO_PORTP_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta P
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta P da memória
	LDR     R0, =GPIO_PORTM_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta M
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta M da memória
	LDR     R0, =GPIO_PORTK_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta K
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta K da memória
	LDR     R0, =GPIO_PORTL_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta L
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta L da memória
	; Porta C
	LDR     R0, =GPIO_PORTC_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta C
    LDR     R1, [R0]                        ;Carrega o valor de PCTL no registrador
	MOV		R2, #0x0000
	MOVT	R2, #0xFFFF
	BIC		R1, R2						    ;Limpa somente os bits 16-31
	STR		R1, [R0]						;Guarda o valor no registrador

    LDR     R0, =GPIO_PORTA_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta A
	MOV     R1, #2_11110000					;PA4, PA5, PA6 e PA7 para o SSD
    STR     R1, [R0]						;Guarda no registrador
	
	LDR     R0, =GPIO_PORTB_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta B
	MOV     R1, #2_00110000					;PB4 e PB5 para os transistores
    STR     R1, [R0]						;Guarda no registrador
	
	;Porta C
	LDR     R0, =GPIO_PORTC_AHB_DIR_R		;Carrega o R0 com o endere?o do DIR para a porta C
	MOV     R1, #0x00						;Habilita os pinos C0-C7 como entrada						
    STR     R1, [R0]						;Guarda no registrador
	
	LDR     R0, =GPIO_PORTQ_DIR_R		;Carrega o R0 com o endereço do DIR para a porta Q
	MOV     R1, #2_00001111					;PQ0, PQ1, PQ2 e PQ3 para o SSD
    STR     R1, [R0]						;Guarda no registrador
	
	LDR     R0, =GPIO_PORTP_DIR_R		;Carrega o R0 com o endereço do DIR para a porta P
	MOV     R1, #2_00100000					;PP5 para o transistor
    STR     R1, [R0]						;Guarda no registrador
	
	LDR     R0, =GPIO_PORTM_DIR_R		;Carrega o R0 com o endereço do DIR para a porta M
	MOV     R1, #2_11110111					;PM0, PM1 e PM2 para o LCD
    STR     R1, [R0]						;Guarda no registrador
	
	LDR     R0, =GPIO_PORTK_DIR_R		;Carrega o R0 com o endereço do DIR para a porta K
	MOV     R1, #2_11111111					;PK0, PK1, PK2, PK3, PK4, PK5, PK6 e PK7 para o LCD
    STR     R1, [R0]						;Guarda no registrador
			
    LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
    MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com saída
    STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
	
	LDR     R0, =GPIO_PORTL_DIR_R			;Carrega o R0 com o endereço do DIR para a porta L
	MOV     R1, #2_00001111					;Habilita os pinos L0-L3 como saída						
    STR     R1, [R0]						;Guarda no registrador

    MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
    LDR     R0, =GPIO_PORTA_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta A
	STR     R1, [R0]						;Escreve na porta
    LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
    STR     R1, [R0]                        ;Escreve na porta
	LDR     R0, =GPIO_PORTB_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta B
    STR     R1, [R0]                        ;Escreve na porta
	LDR     R0, =GPIO_PORTQ_AFSEL_R     ;Carrega o endereço do AFSEL da porta Q
    STR     R1, [R0]                        ;Escreve na porta
	LDR     R0, =GPIO_PORTP_AFSEL_R     ;Carrega o endereço do AFSEL da porta P
    STR     R1, [R0]                        ;Escreve na porta
	LDR     R0, =GPIO_PORTM_AFSEL_R     ;Carrega o endereço do AFSEL da porta M
    STR     R1, [R0]                        ;Escreve na porta
	LDR     R0, =GPIO_PORTK_AFSEL_R     ;Carrega o endereço do AFSEL da porta K
    STR     R1, [R0]                        ;Escreve na porta
	LDR     R0, =GPIO_PORTL_AFSEL_R     ;Carrega o endereço do AFSEL da porta L
    STR     R1, [R0]                        ;Escreve na porta
	; Porta C
	LDR     R0, =GPIO_PORTC_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta C
    LDR     R1, [R0]                        ;Carrega o valor do registrador
	BIC		R1, #2_11110000					;Limpa os bits 4-7
	STR		R1, [R0]						;Salva o valor no registrador GPIOAFSEL

    LDR     R0, =GPIO_PORTA_AHB_DEN_R		;Carrega o endereço do DEN
    MOV     R1, #2_11110000                 ;Ativa os pinos PA4, PA5, PA6 e PA7 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da memória funcionalidade digital

	LDR     R0, =GPIO_PORTB_AHB_DEN_R		;Carrega o endereço do DEN
    MOV     R1, #2_00110000                 ;Ativa os pinos PB4 e PB5 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da memória funcionalidade digital
	
	; Porta C
	LDR     R0, =GPIO_PORTC_AHB_DEN_R			;Carrega o endereço do DEN
    LDR     R1, [R0]							;Ler da memória o registrador GPIO_PORTC_AHB_DEN_R
	MOV     R2, #2_11110000						;Habilita os pinos C4-C7 como I/O
    ORR     R1, R2
    STR     R1, [R0]							;Escreve no registrador da mem?ria funcionalidade digital 
	
	LDR     R0, =GPIO_PORTQ_DEN_R		;Carrega o endereço do DEN
    MOV     R1, #2_00001111                 ;Ativa os pinos PQ0, PQ1, PQ2 e PQ3 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da memória funcionalidade digital
	
	LDR     R0, =GPIO_PORTP_DEN_R		;Carrega o endereço do DEN
    MOV     R1, #2_00100000                 ;Ativa o pino PP5 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da memória funcionalidade digital
	
	LDR     R0, =GPIO_PORTM_DEN_R		;Carrega o endereço do DEN
    MOV     R1, #2_11110111                 ;Ativa os pinos PM0, PM1 e PM2 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da memória funcionalidade digital
	
	LDR     R0, =GPIO_PORTK_DEN_R		;Carrega o endereço do DEN
    MOV     R1, #2_11111111                 ;Ativa os pinos PK0, PK1, PK2, PK3, PK4, PK5, PK6 e PK7 como I/O Digital
    STR     R1, [R0]						;Escreve no registrador da memória funcionalidade digital
 
    LDR     R0, =GPIO_PORTJ_AHB_DEN_R		;Carrega o endereço do DEN
	MOV     R1, #2_00000011                 ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
	STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital
	
	LDR     R0, =GPIO_PORTL_DEN_R				;Carrega o endereço do DEN
    LDR     R1, [R0]							;Ler da memória o registrador
	MOV     R2, #2_00001111						;Habilita os pinos L0-L3 como I/O
    ORR     R1, R2
    STR     R1, [R0]							;Escreve no registrador da mem?ria funcionalidade digital
			

	LDR     R0, =GPIO_PORTJ_AHB_PUR_R		;Carrega o endereço do PUR para a porta J
	MOV     R1, #2_00000011					;Habilitar funcionalidade digital de resistor de pull-up 
                                            ;nos bits 0 e 1
    STR     R1, [R0]						;Escreve no registrador da memória do resistor de pull-up
	
	LDR     R0, =GPIO_PORTC_AHB_PUR_R			;Carrega o endereço do PUR para a porta C
	LDR		R1, [R0]
	BIC     R1, #2_11110000
	ORR     R1, R1, #2_11110000					;Habilitar funcionalidade digital de resistor de pull-up 
    STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
	BX      LR
	LTORG
			
	BX LR
; -------------------------------------------------------------------------------
; Função PortA_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortA_Output
; ****************************************
; Escrever função que acende ou apaga os segmentos do SSD
; ****************************************
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os quatro bits do lido da porta R2 = R2 & 00001111
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta A o barramento de dados dos pinos A4, A5, A6 e A7
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortB_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortB_Output
; ****************************************
; Escrever função que ativa ou desativa os transistores
; ****************************************
	LDR	R1, =GPIO_PORTB_AHB_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11001111
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta B o barramento de dados dos pinos B4 e B5
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortC_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortL_Output
; ****************************************
; Escrever função que ativa ou desativa os transistores
; ****************************************
	LDR	R1, =GPIO_PORTL_DATA_R		    	;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11110000
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta B o barramento de dados dos pinos B4 e B5
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortQ_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortQ_Output
; ****************************************
; Escrever função que acende ou apaga os segmentos do SSD
; ****************************************
	LDR	R1, =GPIO_PORTQ_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os quatro bits do lido da porta R2 = R2 & 11110000
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta Q o barramento de dados dos pinos Q0, Q1, Q2 e Q3
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortP_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortP_Output
; ****************************************
; Escrever função que ativa ou desativa o transistor
; ****************************************
	LDR	R1, =GPIO_PORTP_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00100000                     ;Primeiro limpamos o bit do lido da porta R2 = R2 & 11011111
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta P o barramento de dados do pino P5
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortM_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortM_Output
; ****************************************
; Escrever função que ativa ou desativa o LCD
; ****************************************
	LDR	R1, =GPIO_PORTM_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110111                     ;Primeiro limpamos o bit do lido da porta R2 = R2 & 00001000
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta P o barramento de dados do pino P5
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortP_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortK_Output
; ****************************************
; Escrever função que envia dados para o LCD
; ****************************************
	LDR	R1, =GPIO_PORTK_DATA_R		    ;Carrega o valor do offset do data register
											;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11111111                     ;Primeiro limpamos o bit do lido da porta R2 = R2 & 00000000
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta P o barramento de dados do pino P5
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever função que lê a chave e retorna 
; um registrador se está ativada ou não
; ****************************************
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Lê no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Função PortL_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortC_Input
; ****************************************
; Escrever função que lê a chave e retorna 
; um registrador se está ativada ou não
; ****************************************
	LDR	R1, =GPIO_PORTC_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Lê no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo