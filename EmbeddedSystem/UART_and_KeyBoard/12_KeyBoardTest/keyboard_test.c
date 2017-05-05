/*********************************************************************************************
* File name:	keyboard.c
* Author:		Embest
* Descript:		keyboard source code. 
* History:
*				Y.J.Guo, Programming start, April 4, 2005
*********************************************************************************************/

/*------------------------------------------------------------------------------------------*/
/*	 								include files						 				    */
/*------------------------------------------------------------------------------------------*/
#include "2410lib.h"
//#include "iic_keybd.h"

/*------------------------------------------------------------------------------------------*/
/*	 								function declare										*/
/*------------------------------------------------------------------------------------------*/
void keyboard_test(void);
void __irq keyboard_int(void);
UINT8T key_set(UINT8T ucChar);

extern void iic_init_8led(void);
extern void iic_write_keybd(UINT32T unSlaveAddr, UINT32T unAddr, UINT8T ucData);
extern void iic_read_keybd(UINT32T unSlaveAddr, UINT32T unAddr, UINT8T *pData);
extern void iic_init_keybd(void);

UINT32T g_nKeyPress;
/*********************************************************************************************
* name:		keyboard_init
* func:		keyboard initialize
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void keyboard_init(void)					//���м��̵ĳ�ʼ��
{
	int i;
	iic_init_8led();	
	for(i=0; i<8; i++)
	{
		//������д��ZLG7290��ʾ����Ĵ�����, ����0x70ΪIIC���ߵĴӵ�ַ��0x10Ϊ��һ����ʾ����Ĵ����ĵ�ֵַ��
		iic_write_keybd(0x70, 0x10+i, 0xFF);						// write data to DpRam0~DpRam7(Register of ZLG7290)
		delay(5);
	}                        

	//��ʼ��IICͬʱ�����ж���Ч
	iic_init_keybd();												// enable IIC and EINT1 int
    pISR_EINT1 = (int)keyboard_int;
}

/*********************************************************************************************
* name:		keyboard_test
* func:		test keyboard
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void keyboard_test(void)
{
	UINT8T ucChar;
	
	uart_printf("\n Keyboard Test Example\n");
	keyboard_init();
	while(1)
	{  
	    while(g_nKeyPress--)
	    {
	   	g_nKeyPress = 0;
		while(g_nKeyPress == 0);
		iic_read_keybd(0x70, 0x1, &ucChar);						// get data from Key(register of ZLG7290)
		if(ucChar != 0)
		{
			ucChar = key_set(ucChar);			// key map for EduKitII������ת��ΪASCII���ֵ����һ��
		    if(ucChar < 10) ucChar += 0x30;	   	��//���Ϊ������ôֱ��+48ת��Ϊ����
		    else if(ucChar < 16) ucChar += 0x37;	  //���Ϊ����9����ĸ����ôֱ��+55ת��Ϊ��ĸ
		    if(ucChar < 255)						//С��255˵����ascii���˵����ֵ��Чֱ�ӽ������
			uart_printf("press key %c\n", ucChar);
		    if(ucChar == 0xFF)	  //������ӳ���ϵ�У�0xFF��Ӧ��fun���൱���˳�
	     	{
		      uart_printf(" press key FUN (exit now)\n\r");
		     	return;
		    }
		}
		}
	}
//	uart_printf(" end.\n");
}

//��ɵ���ASCII����ת������
/*********************************************************************************************
* name:		keyboard_int
* func:		keyboard interrupt handler
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void __irq keyboard_int(void)
{
    ClearPending(BIT_EINT1);	 	//���Դ�жϹ���Ĵ���
    g_nKeyPress = 1;
}
/*********************************************************************************************
* name:		key_set
* func:		keyboard setting
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/

//��Ϊ��ʵ��ƽ̨���õ�һ�ֹ淶��ʵ�ʰ������յ���ֵ
UINT8T key_set(UINT8T ucChar)
{
	switch(ucChar)
	{
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
				ucChar-=1; break;
		case 9:
		case 10:
		case 11:
		case 12:
		case 13:
				ucChar-=4; break;
		case 17:
		case 18:
		case 19:
		case 20:
		case 21:
					ucChar-=7; break;
		case 25: ucChar = 0xF; break;
		case 26: ucChar = '+'; break;
		case 27: ucChar = '-'; break;
		case 28: ucChar = '*'; break;
		case 29: ucChar = 0xFF; break;
		default: ucChar = 0;
	}
	return ucChar;
}
