// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado da chave USR_SW2 e acende os LEDs 1 e 2 caso esteja pressionada
// Prof. Guilherme Peron

#include <stdint.h>
#include "tm4c1294ncpdt.h"

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);
void GPIO_Init(void);
void EnableInterrupts(void);
void DisableInterrupts(void);
uint32_t PortJ_Input(void);
void PortA_Output(uint32_t UART);
void PortE_Output(uint32_t motor);
void PortF_Output(uint32_t pwm);

uint32_t usrswinter = 0;
uint32_t pwm = 0;
uint32_t periodo;

void GPIO_InterruptInit(void)
{
	GPIO_PORTJ_AHB_IM_R = 0x00;
	GPIO_PORTJ_AHB_IS_R = 0x00;
	GPIO_PORTJ_AHB_IBE_R = 0x00;
	GPIO_PORTJ_AHB_IEV_R = 0x01;
	GPIO_PORTJ_AHB_ICR_R = 0x01;
	GPIO_PORTJ_AHB_IM_R = 0x01;
	NVIC_PRI12_R = 0x20000000;
	NVIC_EN1_R = 0x00080000;
	EnableInterrupts();
}

void GPIOPortJ_Handler(void)
{
	GPIO_PORTJ_AHB_ICR_R = 0x01;
	usrswinter = 1;
}

void Timer_Init(void) 
{
	SYSCTL_RCGCTIMER_R = SYSCTL_RCGCTIMER_R0;
	while(!((SYSCTL_PRTIMER_R & SYSCTL_PRTIMER_R0) == SYSCTL_PRTIMER_R0));
	
	TIMER0_CTL_R = 0x00; 
	
	TIMER0_CFG_R = 0x00;
	
	TIMER0_TAMR_R = 0x2;
	
	TIMER0_TAILR_R = 0x80000;
	
	TIMER0_ICR_R = 0x01;
	
	DisableInterrupts();
	TIMER0_IMR_R = 0x01;
	NVIC_PRI4_R = 3 << 29;
	NVIC_EN0_R |= 0x80000;
	EnableInterrupts();
	TIMER0_CTL_R = 0x01;
}

void Timer0A_Handler(void) 
{
	TIMER0_CTL_R = 0x00;
	TIMER0_ICR_R = 0x01;
	if(pwm) 
	{
		pwm = 0;
		PortF_Output(0x00);
		TIMER0_TAILR_R = (1048576 - periodo);
		TIMER0_CTL_R = 0x01;
	}
	else 
	{
		pwm = 1;
		PortF_Output(0x04);
		TIMER0_TAILR_R = periodo;
		TIMER0_CTL_R = 0x01;
	}
}

void UART_Enable(void)
{
	SYSCTL_RCGCUART_R = 0x01;
	
  while((SYSCTL_PRUART_R & (0x01) ) != (0x01) ){};
		
	UART0_CTL_R = UART0_CTL_R  & 0xFFFFFFFE;
		
	UART0_IBRD_R = 520;
	UART0_FBRD_R = 53;
		
	UART0_LCRH_R = 0x78;
		
	UART0_CC_R = 0;
	
	UART0_CTL_R = UART0_CTL_R | 0x301;
	
	GPIO_PORTA_AHB_AMSEL_R = 0x00;
	GPIO_PORTA_AHB_PCTL_R = 0x11;
	GPIO_PORTA_AHB_AFSEL_R = 0x03;
	GPIO_PORTA_AHB_DEN_R = 0xF3;			
}

uint8_t UART_Receive(void)
{
	while((UART0_FR_R & UART_FR_RXFE)!=0)
	{
		if(usrswinter == 1)
			break;
	}
	return (uint8_t)(UART0_DR_R & 0xFF);
}

void UART_Send(uint8_t data) 
{
	while((UART0_FR_R & UART_FR_TXFF)!=0);
	UART0_DR_R = data;
}

void VelocidadePeriodo(uint8_t velocidade)
{
	if(velocidade == '0')
	{
		PortE_Output(0x00);
	}
	else if(velocidade == '1')
	{
		periodo = (uint32_t)(1048576.0 * (0.5));
		Timer_Init();
	}
	else if(velocidade == '2')
	{
		periodo = (uint32_t)(1048576.0 * (0.6));
		Timer_Init();
	}
	else if(velocidade == '3')
	{
		periodo = (uint32_t)(1048576.0 * (0.7));
		Timer_Init();
	}
	else if(velocidade == '4')
	{
		periodo = (uint32_t)(1048576.0 * (0.8));
		Timer_Init();
	}
	else if(velocidade == '5')
	{
		periodo = (uint32_t)(1048576.0 * (0.9));
		Timer_Init();
	}
	else if(velocidade == '6')
	{
		periodo = 1048576;
		Timer_Init();
	}
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	UART_Enable();
	GPIO_InterruptInit();
	while(1)
	{
		usrswinter = 0;
		PortE_Output(0x00);
		uint8_t str1[] = "Motor Parado\n\r\0";
		uint32_t i = 0;
		while(str1[i] != '\0')
		{
			UART_Send(str1[i]);
			i++;
		}
		uint8_t str2[] = "Informe o sentido de rotacao\n\rHorario: h\n\rAnti-horario: a\n\r\0";
		i = 0;
		while(str2[i] != '\0')
		{
			UART_Send(str2[i]);
			i++;
		}
		uint8_t sentido = UART_Receive();
		UART_Send(sentido);
		UART_Send('\n');
		UART_Send('\r');
		uint8_t str3[] = "Informe a velocidade de rotacao\n\r1 - Executa o comando para deixar o motor girando a 50% de sua velocidade maxima em regime permanente\n\r2 - Executa o comando para deixar o motor girando a 60% de sua velocidade maxima em regime permanente\n\r3 - Executa o comando para deixar o motor girando a 70% de sua velocidade maxima em regime permanente\n\r4 - Executa o comando para deixar o motor girando a 80% de sua velocidade maxima em regime permanente\n\r5 - Executa o comando para deixar o motor girando a 90% de sua velocidade maxima em regime permanente\n\r6 - Executa o comando para deixar o motor girando a 100% (~99,99%) de sua velocidade maxima em regime permanente\n\r\0";
		i = 0;
		while(str3[i] != '\0')
		{
			UART_Send(str3[i]);
			i++;
		}
		uint8_t velocidade = UART_Receive();
		UART_Send(velocidade);
		UART_Send('\n');
		UART_Send('\r');
		VelocidadePeriodo(velocidade);
		if(sentido == 'h')
		{
			PortE_Output(0x0D);
		}
		else if(sentido == 'a')
		{
			PortE_Output(0x0E);
		}
		while(usrswinter == 0)
		{
			uint8_t str4[] = "O motor esta rodando na velocidade \0";
			i = 0;
			while(str4[i] != '\0')
			{
				UART_Send(str4[i]);
				i++;
			}
			UART_Send(velocidade);
			uint8_t str5[] = " e no sentido \0";
			i = 0;
			while(str5[i] != '\0')
			{
				UART_Send(str5[i]);
				i++;
			}
			UART_Send(sentido);
			UART_Send('\n');
			UART_Send('\r');
			sentido = UART_Receive();
			if(sentido == 'h')
			{
				PortE_Output(0x0D);
			}
			else if(sentido == 'a')
			{
				PortE_Output(0x0E);
			}
			else if(sentido == '0')
			{
				PortE_Output(0x00);
			}
		}
		PortE_Output(0x00); 
	}
}