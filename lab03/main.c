// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado da chave USR_SW2 e acende os LEDs 1 e 2 caso esteja pressionada
// Prof. Guilherme Peron

#include <stdint.h>
#include "tm4c1294ncpdt.h"

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
void EnableInterrupts(void);
void inicializa_LCD(void);
void mostra_LCD(uint8_t str[]);
uint8_t verifica_teclado(void);
uint32_t PortJ_Input(void);
uint32_t PortC_Input(void);
void PortA_Output(uint32_t leds14);
void PortQ_Output(uint32_t leds58);
void PortM_Output(uint32_t trans_leds_LCD);
void PortK_Output(uint32_t LCD_data);
void PortL_Output(uint32_t teclado);
void PortH_Output(uint32_t motor_passo);
void PortN_Output(uint32_t leds);

uint32_t interrupcao = 0;

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
	interrupcao = 1;
}

void lento_hora(uint8_t num_voltas)
{
	uint32_t int_voltas = num_voltas - '0';
	uint32_t i;
	uint32_t j = 0;
	uint32_t aux;
	uint32_t aux2;
	uint32_t aux3;
	uint32_t aux4;
	uint32_t aux5;
	uint8_t ledsQ = 0x00;
	uint8_t ledsA = 0x0F;
	if(int_voltas == 0)
	{
		int_voltas = 10;
	}
	for(i = 0; i < 512*int_voltas; i++)
	{
		if(interrupcao == 1)
		{
			break;
		}
		aux2 = i;
		aux4 = ledsQ;
		aux5 = ledsA;
		if(!(i%512))
		{
			uint8_t str1[8] = "Faltam:";
			inicializa_LCD();
			aux = num_voltas;
			mostra_LCD(str1);
			aux3 = j;
			num_voltas = aux;
			uint32_t int_str2 = int_voltas - j;
			uint8_t str2[1];
			str2[0] = int_str2 + '0';
			uint8_t straux[2];
			straux[0] = '1';
			straux[1] = '0';
			aux = num_voltas;
			if(str2[0] == ':')
			{
				mostra_LCD(straux);
			}
			else
			{
				mostra_LCD(str2);
			}
			j = aux3;
			num_voltas = aux;
			uint8_t str3[8] = " voltas";
			aux = num_voltas;
			mostra_LCD(str3);
			num_voltas = aux;
			j++;
		}
		ledsQ = aux4;
		ledsA = aux5;
		if(!(i%28))
		{
			if(ledsA == 0xFF)
			{
				ledsQ = 0x00;
				ledsA = 0x0F;
			}
			if(ledsQ < 0x0F)
			{
				ledsQ = ledsQ << 1;
				ledsQ++;
				PortQ_Output(ledsQ);
				PortA_Output(ledsA);
			}
			else
			{
				ledsA = ledsA << 1;
				ledsA++;
				PortA_Output(ledsA);
				PortQ_Output(ledsQ);
			}
		}
		i = aux2;
		PortH_Output(0x08);
		SysTick_Wait1ms(2);
		PortH_Output(0x0C);
		SysTick_Wait1ms(2);
		PortH_Output(0x04);
		SysTick_Wait1ms(2);
		PortH_Output(0x06);
		SysTick_Wait1ms(2);
		PortH_Output(0x02);
		SysTick_Wait1ms(2);
		PortH_Output(0x03);
		SysTick_Wait1ms(2);
		PortH_Output(0x01);
		SysTick_Wait1ms(2);
		PortH_Output(0x09);
		SysTick_Wait1ms(2);
	}
}

void lento_anti(uint8_t num_voltas)
{
	uint32_t int_voltas = num_voltas - '0';
	uint32_t i;
	uint32_t j = 0;
	uint32_t aux;
	uint32_t aux2;
	uint32_t aux3;
	uint32_t aux4;
	uint32_t aux5;
	uint32_t aux6;
	uint8_t ledsQ = 0x00;
	uint8_t ledsA = 0x0F;
	uint8_t ledsoma = 0x80;
	if(int_voltas == 0)
	{
		int_voltas = 10;
	}
	for(i = 0; i < 512*int_voltas; i++)
	{
		if(interrupcao == 1)
		{
			break;
		}
		aux2 = i;
		aux4 = ledsQ;
		aux5 = ledsA;
		aux6 = ledsoma;
		if(!(i%512))
		{
			uint8_t str1[8] = "Faltam:";
			inicializa_LCD();
			aux = num_voltas;
			mostra_LCD(str1);
			aux3 = j;
			num_voltas = aux;
			uint32_t int_str2 = int_voltas - j;
			uint8_t str2[1];
			str2[0] = int_str2 + '0';
			uint8_t straux[2];
			straux[0] = '1';
			straux[1] = '0';
			aux = num_voltas;
			if(str2[0] == ':')
			{
				mostra_LCD(straux);
			}
			else
			{
				mostra_LCD(str2);
			}
			num_voltas = aux;
			uint8_t str3[8] = " voltas";
			aux = num_voltas;
			mostra_LCD(str3);
			num_voltas = aux;
			j++;
		}
		ledsQ = aux4;
		ledsA = aux5;
		ledsoma = aux6;
		if(!(i%28))
		{
			if(ledsQ == 0x0F)
			{
				ledsQ = 0x00;
				ledsA = 0x0F;
				ledsoma = 0x80;
			}
			if(ledsA < 0xFF)
			{
				ledsA += ledsoma;
				ledsoma = ledsoma >> 1;
				PortQ_Output(ledsQ);
				PortA_Output(ledsA);
			}
			else
			{
				ledsQ += ledsoma;
				ledsoma = ledsoma >> 1;
				PortQ_Output(ledsQ);
				PortA_Output(ledsA);
			}
		}
		i = aux2;
		PortH_Output(0x09);
		SysTick_Wait1ms(2);
		PortH_Output(0x01);
		SysTick_Wait1ms(2);
		PortH_Output(0x03);
		SysTick_Wait1ms(2);
		PortH_Output(0x02);
		SysTick_Wait1ms(2);
		PortH_Output(0x06);
		SysTick_Wait1ms(2);
		PortH_Output(0x04);
		SysTick_Wait1ms(2);
		PortH_Output(0x0C);
		SysTick_Wait1ms(2);
		PortH_Output(0x08);
		SysTick_Wait1ms(2);
	}
}

void rapido_hora(uint8_t num_voltas)
{
	uint32_t int_voltas = num_voltas - '0';
	uint32_t i;
	uint32_t j = 0;
	uint32_t aux;
	uint32_t aux2;
	uint32_t aux3;
	uint32_t aux4;
	uint32_t aux5;
	uint8_t ledsQ = 0x00;
	uint8_t ledsA = 0x0F;
	if(int_voltas == 0)
	{
		int_voltas = 10;
	}
	for(i = 0; i < 512*int_voltas; i++)
	{
		if(interrupcao == 1)
		{
			break;
		}
		aux2 = i;
		aux4 = ledsQ;
		aux5 = ledsA;
		if(!(i%512))
		{
			uint8_t str1[8] = "Faltam:";
			inicializa_LCD();
			aux = num_voltas;
			mostra_LCD(str1);
			aux3 = j;
			num_voltas = aux;
			uint32_t int_str2 = int_voltas - j;
			uint8_t str2[1];
			str2[0] = int_str2 + '0';
			uint8_t straux[2];
			straux[0] = '1';
			straux[1] = '0';
			aux = num_voltas;
			if(str2[0] == ':')
			{
				mostra_LCD(straux);
			}
			else
			{
				mostra_LCD(str2);
			}
			num_voltas = aux;
			uint8_t str3[8] = " voltas";
			aux = num_voltas;
			mostra_LCD(str3);
			num_voltas = aux;
			j++;
		}
		ledsQ = aux4;
		ledsA = aux5;
		if(!(i%28))
		{
			if(ledsA == 0xFF)
			{
				ledsQ = 0x00;
				ledsA = 0x0F;
			}
			if(ledsQ < 0x0F)
			{
				ledsQ = ledsQ << 1;
				ledsQ++;
				PortQ_Output(ledsQ);
				PortA_Output(ledsA);
			}
			else
			{
				ledsA = ledsA << 1;
				ledsA++;
				PortA_Output(ledsA);
				PortQ_Output(ledsQ);
			}
		}
		i = aux2;
		PortH_Output(0x08);
		SysTick_Wait1ms(2);
		PortH_Output(0x04);
		SysTick_Wait1ms(2);
		PortH_Output(0x02);
		SysTick_Wait1ms(2);
		PortH_Output(0x01);
		SysTick_Wait1ms(2);
	}
}

void rapido_anti(uint8_t num_voltas)
{
	uint32_t int_voltas = num_voltas - '0';
	uint32_t i;
	uint32_t j = 0;
	uint32_t aux;
	uint32_t aux2;
	uint32_t aux3;
	uint32_t aux4;
	uint32_t aux5;
	uint32_t aux6;
	uint8_t ledsQ = 0x00;
	uint8_t ledsA = 0x0F;
	uint8_t ledsoma = 0x80;
	if(int_voltas == 0)
	{
		int_voltas = 10;
	}
	for(i = 0; i < 512*int_voltas; i++)
	{
		if(interrupcao == 1)
		{
			break;
		}
		aux2 = i;
		aux4 = ledsQ;
		aux5 = ledsA;
		aux6 = ledsoma;
		if(!(i%512))
		{
			uint8_t str1[8] = "Faltam:";
			inicializa_LCD();
			aux = num_voltas;
			aux3 = j;
			mostra_LCD(str1);
			j = aux3;
			num_voltas = aux;
			uint32_t int_str2 = int_voltas - j;
			uint8_t str2[1];
			str2[0] = int_str2 + '0';
			uint8_t straux[2];
			straux[0] = '1';
			straux[1] = '0';
			aux = num_voltas;
			aux3 = j;
			if(str2[0] == ':')
			{
				mostra_LCD(straux);
			}
			else
			{
				mostra_LCD(str2);
			}
			j = aux3;
			num_voltas = aux;
			uint8_t str3[8] = " voltas";
			aux = num_voltas;
			aux3 = j;
			mostra_LCD(str3);
			j = aux3;
			num_voltas = aux;
			j++;
		}
		ledsQ = aux4;
		ledsA = aux5;
		ledsoma = aux6;
		if(!(i%28))
		{
			if(ledsQ == 0x0F)
			{
				ledsQ = 0x00;
				ledsA = 0x0F;
				ledsoma = 0x80;
			}
			if(ledsA < 0xFF)
			{
				ledsA += ledsoma;
				ledsoma = ledsoma >> 1;
				PortQ_Output(ledsQ);
				PortA_Output(ledsA);
			}
			else
			{
				ledsQ += ledsoma;
				ledsoma = ledsoma >> 1;
				PortQ_Output(ledsQ);
				PortA_Output(ledsA);
			}
		}
		i = aux2;
		PortH_Output(0x01);
		SysTick_Wait1ms(2);
		PortH_Output(0x02);
		SysTick_Wait1ms(2);
		PortH_Output(0x04);
		SysTick_Wait1ms(2);
		PortH_Output(0x08);
		SysTick_Wait1ms(2);
	}
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	GPIO_InterruptInit();
	while(1)
	{
		while(1)
		{
			PortM_Output(0x40);
			uint8_t voltas[50] = "Escolha o numero                        de voltas:";
			inicializa_LCD();
			mostra_LCD(voltas);
			uint8_t volta1[1];
			uint8_t volta2[1];
			uint8_t volta3[1];
			volta1[0] = verifica_teclado();
			while(volta1[0] == '*')
			{
				volta1[0] = verifica_teclado();
			}
			if(volta1[0] == '1')
			{
				volta2[0] = verifica_teclado();
				while(volta2[0] != '0')
				{
					if(volta2[0] == '*')
					{
						break;
					}
					volta2[0] = verifica_teclado();
				}
				if(volta2[0] == '0')
				{
					volta3[0] = verifica_teclado();
					while(volta3[0] != '*')
					{
						volta3[0] = verifica_teclado();
					}
					mostra_LCD(volta1);
					mostra_LCD(volta2);
				}
				else
				{
					mostra_LCD(volta1);
				}
			}
			else
			{
				volta2[0] = verifica_teclado();
				while(volta2[0] != '*')
				{
					volta2[0] = verifica_teclado();
				}
				mostra_LCD(volta1);
			}
			SysTick_Wait1ms(2000);
			uint8_t sentido[54] = "Sentido: Horar=0                        Anti-horar=1:";
			inicializa_LCD();
			mostra_LCD(sentido);
			uint8_t sentido1[1];
			uint8_t sentido2[1];
			sentido1[0] = verifica_teclado();
			while(sentido1[0] != '0')
			{
				sentido1[0] = verifica_teclado();
				if(sentido1[0] == '1')
				{
					break;
				}
			}
			sentido2[0] = verifica_teclado();
			while(sentido2[0] != '*')
			{
				sentido2[0] = verifica_teclado();
			}
			mostra_LCD(sentido1);
			SysTick_Wait1ms(2000);
			uint8_t velocidade[54] = "Velocid: compl=0                        meio-passo=1:";
			inicializa_LCD();
			mostra_LCD(velocidade);
			uint8_t veloc1[1];
			uint8_t veloc2[1];
			veloc1[0] = verifica_teclado();
			while(veloc1[0] != '0')
			{
				veloc1[0] = verifica_teclado();
				if(veloc1[0] == '1')
				{
					break;
				}
			}
			veloc2[0] = verifica_teclado();
			while(veloc2[0] != '*')
			{
				veloc2[0] = verifica_teclado();
			}
			mostra_LCD(veloc1);
			SysTick_Wait1ms(2000);
			if(sentido1[0] == '0')
			{
				if(veloc1[0] == '0')
				{
					if(volta2[0] == '0')
					{
						rapido_hora(volta2[0]);
					}
					else
					{
						rapido_hora(volta1[0]);
					}
				}
				else
				{
					if(volta2[0] == '0')
					{
						lento_hora(volta2[0]);
					}
					else
					{
						lento_hora(volta1[0]);
					}
				}
			}
			else
			{
				if(veloc1[0] == '0')
				{
					if(volta2[0] == '0')
					{
						rapido_anti(volta2[0]);
					}
					else
					{
						rapido_anti(volta1[0]);
					}
				}
				else
				{
					if(volta2[0] == '0')
					{
						lento_anti(volta2[0]);
					}
					else
					{
						lento_anti(volta1[0]);
					}
				}
			}
			if(interrupcao == 0)
			{
				uint8_t fim[54] = "      FIM                               pressione '*'";
				inicializa_LCD();
				PortA_Output(0x0F);
				PortQ_Output(0x00);
				mostra_LCD(fim);
				uint8_t final[1];
				final[0] = verifica_teclado();
				while(final[0] != '*')
				{
					final[0] = verifica_teclado();
				}
			}
			else
			{
				PortA_Output(0x0F);
				PortQ_Output(0x00);
				interrupcao = 0;
				break;
			}
		}
	}
}