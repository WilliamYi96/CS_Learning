/*********************************************************************************************
* File name:	main.c
* Author:		Embest
* Descript:		C code entry. 
* History:
*				Y.J.Guo, Programming start, April 4, 2005
*********************************************************************************************/

/*------------------------------------------------------------------------------------------*/
/*	 								include files						 				    */
/*------------------------------------------------------------------------------------------*/
#include "2410lib.h"
//#include "iic_keybd.h"

/*------------------------------------------------------------------------------------------*/
/*	 								function declare						 				    */
/*------------------------------------------------------------------------------------------*/
int main(void);
extern void keyboard_test(void); 					、//声明外部引用的keyboard_test
/*********************************************************************************************
* name:		main
* func:		c code entry
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
int main(void)
{
    sys_init();													//Initial 2410X's Interrupt,Port and UART
    												//进行中断、端口、串口等的初始化
	
//	g_nTimeout=10;
	keyboard_test();  								//固定模式，进入键盘测试界面
	while(1);
}

