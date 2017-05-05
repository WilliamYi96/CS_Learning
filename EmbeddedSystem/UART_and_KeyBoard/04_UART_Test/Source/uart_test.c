/*********************************************************************************************
* File£º	uart_test.c
* Author:	emboard
* Desc£º	UART_Test
* History:	
*********************************************************************************************/
/*------------------------------------------------------------------------------------------*/
/*                                     include files	                                    */
/*------------------------------------------------------------------------------------------*/
#include "uart_test.h"

/*********************************************************************************************
* name:		uart1_test
* func:		uart test function
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void uart1_test(void)
{
	char cInput[256];
	UINT8T ucInNo=0;
	UINT32T	g_nKeyPress;
	char c;
	uart_printf("\n UART1 Communication Test Example\n");	
	uart_printf(" Please input words, then press Enter:\n");
	uart_printf(" />");
	uart_printf(" ");
	g_nKeyPress = 1;
	while(g_nKeyPress==1)			// only for board test to exit
	{
		c=uart_getch();
		
		//uart_printf("%c",c);
		if(c!='\n')
			cInput[ucInNo++]=c;
		else
		{
			cInput[ucInNo]='\0';
			break;
		}
	}
	delay(1000);	

	uart_printf("\n The words that you input are: %s\n",cInput);		
	uart_printf(" End.\n"); 
}
