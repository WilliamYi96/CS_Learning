/*********************************************************************************************
* File name:	iic.c
* Author:		Embest
* Descript:		iic source code. 
* History:
*				Y.J.Guo, Programming start, April 4, 2005
*********************************************************************************************/

/*------------------------------------------------------------------------------------------*/
/*	 								include files						 				    */
/*------------------------------------------------------------------------------------------*/
#include "2410lib.h"
//#include "iic_keybd.h"

/*------------------------------------------------------------------------------------------*/
/*	 								global variables					 				    */
/*------------------------------------------------------------------------------------------*/
extern int f_nGetACK;

/*------------------------------------------------------------------------------------------*/
/*	 								function declare					 				    */
/*------------------------------------------------------------------------------------------*/
void __irq iic_int_keybd(void) ;
void iic_init_keybd(void);
void iic_write_keybd(UINT32T unSlaveAddr, UINT32T unAddr, UINT8T ucData);
void iic_read_keybd(UINT32T unSlaveAddr, UINT32T unAddr, UINT8T *pData);

/*********************************************************************************************
* name:		iic_init_keybd
* func:		initialize iic
* para:		none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void iic_init_keybd(void)
{
	f_nGetACK = 0;

    // Enable interrupt
	rINTMOD = 0x0;
    rSRCPND = rSRCPND;                 // clear all interrupt
    rINTPND = rINTPND;                 // clear all interrupt
	rINTMSK &= ~(BIT_IIC|BIT_EINT1);
    pISR_IIC= (unsigned)iic_int_keybd;

	// Initialize iic
	rIICADD = 0x10;												// S3C2410X slave address 
    rIICCON = 0xaf;												// Enable ACK, interrupt, set IICCLK=MCLK/16
    rIICSTAT= 0x10;												// Enable TX/RX 
}

/*********************************************************************************************
* name:		iic_write_keybd
* func:		write data to iic
* para:		unSlaveAddr --- input, chip slave address
*			unAddr		--- input, data address
*			ucData    	--- input, data value
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void iic_write_keybd(UINT32T unSlaveAddr,UINT32T unAddr,UINT8T ucData)
{
	f_nGetACK = 0;
    
    // Send control byte
    rIICDS = unSlaveAddr;										// 0x70
    rIICSTAT = 0xf0;											// Master Tx,Start
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;
    
    // Send address
    rIICDS = unAddr;
    rIICCON = 0xaf;												// Resumes IIC operation.
	while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;
    
    // Send data
    rIICDS = ucData;
    rIICCON = 0xaf;												// Resumes IIC operation.
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;
    
    // End send
    rIICSTAT = 0xd0;											// Stop Master Tx condition
    rIICCON = 0xaf;												// Resumes IIC operation.
	while(rIICSTAT & 0x20 == 1);								// Wait until stop condtion is in effect.
}
	
/*********************************************************************************************
* name:		iic_read_keybd
* func:		read data from iic
* para:		unSlaveAddr --- input, chip slave address
*			unAddr		--- input, data address
*			pData    	--- output, data pointer
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void iic_read_keybd(UINT32T unSlaveAddr,UINT32T unAddr,UINT8T *pData)
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
    rIICCON = 0xaf;												// Resumes IIC operation.
    while(f_nGetACK == 0);										// Wait ACK
    f_nGetACK = 0;

    // Send control byte
    rIICDS = unSlaveAddr;										// 0x70
    rIICSTAT = 0xb0;											// Master Rx,Start
	rIICCON = 0xaf;												// Resumes IIC operation.   
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
	rIICCON = 0xaf;												// Resumes IIC operation.
	delay(5);													// Wait until stop condtion is in effect.
	
    *pData = cRecvByte;
}

/*********************************************************************************************
* name:		   iic_int_keybd
* func:		   IIC interrupt handler
* para:		  none
* ret:		none
* modify:
* comment:		
*********************************************************************************************/
void __irq iic_int_keybd(void)
{
    ClearPending(BIT_IIC);
	f_nGetACK = 1;
}
