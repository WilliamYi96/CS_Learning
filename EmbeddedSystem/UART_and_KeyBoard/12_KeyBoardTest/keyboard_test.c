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
void keyboard_init(void)					//进行键盘的初始化
{
	int i;
	iic_init_8led();	
	for(i=0; i<8; i++)
	{
		//将数据写入ZLG7290显示缓存寄存器中, 其中0x70为IIC总线的从地址，0x10为第一个显示缓存寄存器的地址值。
		iic_write_keybd(0x70, 0x10+i, 0xFF);						// write data to DpRam0~DpRam7(Register of ZLG7290)
		delay(5);
	}                        

	//初始化IIC同时设置中断有效
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
			ucChar = key_set(ucChar);			// key map for EduKitII，将其转变为ASCII码的值，是一种
		    if(ucChar < 10) ucChar += 0x30;	   	、//如果为数字那么直接+48转变为数字
		    else if(ucChar < 16) ucChar += 0x37;	  //如果为大于9的字母，那么直接+55转变为字母
		    if(ucChar < 255)						//小于255说明是ascii码表，说明该值有效直接进行输出
			uart_printf("press key %c\n", ucChar);
		    if(ucChar == 0xFF)	  //在这种映射关系中，0xFF对应于fun，相当于退出
	     	{
		      uart_printf(" press key FUN (exit now)\n\r");
		     	return;
		    }
		}
		}
	}
//	uart_printf(" end.\n");
}

//完成的是ASCII码表的转换功能
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
    ClearPending(BIT_EINT1);	 	//清除源中断挂起寄存器
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

//此为该实验平台设置的一种规范，实际按键接收到的值
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
