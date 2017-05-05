/*********************************************************************************************
* File:		iic.c
* Author:	Embest
* Desc:		iic source code
* History:	
*			Y.J.Guo, Programming modify, April 2, 2005
*********************************************************************************************/

/*------------------------------------------------------------------------------------------*/
/*									include files											*/
/*------------------------------------------------------------------------------------------*/
#include "2410lib.h"
//#include "iic_8led.h"

/*------------------------------------------------------------------------------------------*/
/*	 								global variables										*/
/*------------------------------------------------------------------------------------------*/
int f_nGetACK;

/*------------------------------------------------------------------------------------------*/
/*	 								function declare								*/
/*------------------------------------------------------------------------------------------*/
void __irq  iic_int_8led(void); 
void iic_init_8led(void);
void iic_write_8led(UINT32T unSlaveAddr, UINT32T unAddr, UINT8T ucData);
void iic_read_8led(UINT32T unSlaveAddr, UINT32T unAddr, UINT8T *pData);

/*********************************************************************************************
* name:		iic_init_8led()
* func:		initialize iic
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/

//总线初始化，并且允许中断
void iic_init_8led(void)
{
	f_nGetACK = 0;

    // Enable interrupt
	rINTMOD = 0x0;
    rSRCPND = rSRCPND;                 // clear all interrupt
    rINTPND = rINTPND;                 // clear all interrupt
	rINTMSK &= ~BIT_IIC;
    pISR_IIC= (unsigned)iic_int_8led;

	// Initialize iic
	rIICADD = 0x10;												// S3C2410X slave address 
    rIICCON = 0xef;												// Enable ACK, interrupt, set IICCLK=MCLK/512
    rIICSTAT= 0x10;												// Enable TX/RX 
}

//进行总线的写入操作

/*********************************************************************************************
* name:		iic_write_8led()
* func:		write data to iic
* para:		unSlaveAddr --- input, chip slave address
*			unAddr	--- input, data address
*			ucData	--- input, data value
* ret:		none
* modify:
* comment:		
********************************************************************************************/
void iic_write_8led(UINT32T unSlaveAddr,UINT32T unAddr,UINT8T ucData)
{
	f_nGetACK = 0;
    
    // Send control byte
    rIICDS = unSlaveAddr;										// 0x70
    rIICSTAT = 0xf0;											// Master Tx,Start
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;
    
    // Send address
    rIICDS = unAddr;
    rIICCON = 0xef;												// Resumes IIC operation.
	while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;
    
    // Send data
    rIICDS = ucData;
    rIICCON = 0xef;												// Resumes IIC operation.
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;
    
    // End send
    rIICSTAT = 0xd0;											// Stop Master Tx condition
    rIICCON = 0xef;												// Resumes IIC operation.
    delay(5);													// Wait until stop condtion is in effect.
}

//进行总线的写操作，ZLG7290对于数据的控制与状态查询等都是通过读写寄存器进行实现的，
//此过程即为从总线中读取数据，slave address 应该翻译为从地址
//从地址就是IIC总线数据传输协议的一种规范
//unAddr是键值寄存器地址,表示读取键值对应的地址
//pdata是读取到的键值数据的指针
	
/*********************************************************************************************
* name:		iic_read_8led()
* func:		read data from iic
* para:		unSlaveAddr	--- input, chip slave address
*			unAddr		--- input, data address
*			pData		--- output, data pointer
* ret:		none
* modify:
* comment:		
********************************************************************************************/
void iic_read_8led(UINT32T unSlaveAddr,UINT32T unAddr,UINT8T *pData)
{
	char cRecvByte;
	
	f_nGetACK = 0;

    // Send control byte 
    rIICDS = unSlaveAddr;										// Write slave address to IICDS
    rIICSTAT = 0xf0;											// Master Tx,Start
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;

    // Send address 
    rIICDS = unAddr;
    rIICCON = 0xef;												// Resumes IIC operation.
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;

    // Send control byte
    rIICDS = unSlaveAddr;										// 0x70
    rIICSTAT = 0xb0;											// Master Rx,Start
	rIICCON = 0xef;												// Resumes IIC operation.   
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;
    
    // Get data
    cRecvByte = rIICDS;
    rIICCON = 0x2f;
    delay(1);
    
    // Get data 
    cRecvByte = rIICDS;
    
    // End receive 
    rIICSTAT = 0x90;											// Stop Master Rx condition 
	rIICCON = 0xef;												// Resumes IIC operation.
	delay(5);													// Wait until stop condtion is in effect.
	
    *pData = cRecvByte;
}

/*********************************************************************************************
* name:		iic_int_8led()
* func:		IIC interrupt handler
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void __irq  iic_int_8led(void)
{
    ClearPending(BIT_IIC);
	f_nGetACK = 1;
}
