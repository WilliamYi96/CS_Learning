;/*****************************************************************************/
;/* S3C2440A.S: Startup file for Samsung S3C440A                              */
;/*****************************************************************************/
;/* <<< Use Configuration Wizard in Context Menu >>>                          */ 
;/*****************************************************************************/
;/* This file is part of the uVision/ARM development tools.                   */
;/* Copyright (c) 2005-2006 Keil Software. All rights reserved.               */
;/* This software may only be used under the terms of a valid, current,       */
;/* end user licence from KEIL for a compatible version of KEIL software      */
;/* development tools. Nothing else gives you the right to use this software. */
;/*****************************************************************************/


; *** Startup Code (executed after Reset) ***
; MMU TranslationTable Addresss
TTB_ADDR		EQU     0x30300000
; Standard definitions of Mode bits and Interrupt (I & F) flags in PSRs

Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F

I_Bit           EQU     0x80            ; when I bit is set, IRQ is disabled
F_Bit           EQU     0x40            ; when F bit is set, FIQ is disabled

;// <h> Stack Configuration (Stack Sizes in Bytes)
;//   <o0> Undefined Mode      <0x0-0xFFFFFFFF:8>
;//   <o1> Supervisor Mode     <0x0-0xFFFFFFFF:8>
;//   <o2> Abort Mode          <0x0-0xFFFFFFFF:8>
;//   <o3> Fast Interrupt Mode <0x0-0xFFFFFFFF:8>
;//   <o4> Interrupt Mode      <0x0-0xFFFFFFFF:8>
;//   <o5> User/System Mode    <0x0-0xFFFFFFFF:8>
;// </h>

UND_Stack_Size  EQU     0x00000400
SVC_Stack_Size  EQU     0x00004000
ABT_Stack_Size  EQU     0x00000400
FIQ_Stack_Size  EQU     0x00001000
IRQ_Stack_Size  EQU     0x00001000
USR_Stack_Size  EQU     0x00003800

Stack_Size      EQU     (UND_Stack_Size + SVC_Stack_Size + ABT_Stack_Size + \
                         FIQ_Stack_Size + IRQ_Stack_Size + USR_Stack_Size)

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size

Stack_Top       EQU     Stack_Mem + Stack_Size


;// <h> Heap Configuration
;//   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF>
;// </h>

Heap_Size       EQU     0x00004800

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
Heap_Mem        SPACE   Heap_Size


;INT CONFIG
INT_BASE        EQU     0x4A000000
SRCPND_OFS      EQU     0x0
INTMSK_OFS      EQU     0x8
INTPND_OFS      EQU     0x10
INTSUBMASK_OFS  EQU     0x1c

INT_SETUP       EQU     1
INTMSK_VAL      EQU     0xFFFFFFFF
INTSUBMASK_VAL	EQU		  0X7FF


; Clock Management definitions
CLK_BASE        EQU     0x4C000000      ; Clock Base Address
LOCKTIME_OFS    EQU     0x00            ; LOCKTIME Offset
MPLLCON_OFS     EQU     0x04            ; MPLLCON Offset
UPLLCON_OFS     EQU     0X08            ; UPLLCON Offset
CLKCON_OFS      EQU     0x0C            ; CLKCON Offset
CLKSLOW_OFS     EQU     0x10            ; CLKSLOW Offset
CLKDIVN_OFS     EQU     0X14            ; CLDKIVN Offset
CAMDIVN_OFS     EQU     0X18            ; CAMDIVN Offset



;// <e> Clock Management
;//   <h> MPLL Settings
;//   <i> Mpll = (m * Fin) / (p * 2^s)
;//     <o1.12..19> MDIV: Main divider <0x0-0xFF>
;//                 <i> m = MDIV + 8
;//     <o1.4..9>   PDIV: Pre-divider  <0x0-0x3F>
;//                 <i> p = PDIV + 2
;//     <o1.0..1>   SDIV: Post Divider <0x0-0x03>
;//                 <i> s = SDIV 
;//   </h>
;//   <h> UPLL Settings
;//   <i> Upll = ( m * Fin) / (p * 2^s),Uclk must be 48MHZ to USB device 
;//     <o2.12..19> MDIV: Main divider <0x1-0xF8>
;//                 <i> m = MDIV + 8,if Fin=12MHZ MDIV could be 0x38   
;//     <o2.4..9>   PDIV: Pre-divider  <0x1-0x3E>
;//                 <i> p = PDIV + 2,if Fin=12MHZ PDIV could be 0x2
;//     <o2.0..1>   SDIV: Post Divider <0x0-0x03>
;//                 <i> s = SDIV ,if Fin=12MHZ SDIV could be 0x2
;//   </h>
;//   <h>LOCK TIME 
;//      <o5.0..11>  LTIME CNT: MPLL Lock Time Count  <0x0-0xFFF>
;//      <o5.12..23>  LTIME CNT: UPLL Lock Time Count  <0x0-0xFFF>
;//   </h>
;//   <h> Master Clock
;//   <i> PLL Clock:  FCLK = FMPLL
;//   <i> Slow Clock: FCLK = Fin / (2 * SLOW_VAL), SLOW_VAL > 0
;//   <i> Slow Clock: FCLK = Fin, SLOW_VAL = 0
;//     <o4.7>      UCLK_ON: UCLK ON
;//                 <i> 0: UCLK ON(UPLL is also turned on) 1: UCLK OFF (UPLL is also turned off) 	 
;//     <o4.5>      MPLL_OFF: Turn off PLL
;//                 <i> 0: Turn on PLL.After PLL stabilization time (minimum 300us), SLOW_BIT can be cleared to 0. 1: Turn off PLL. PLL is turned off only when SLOW_BIT is 1.
;//     <o4.4>      SLOW_BIT: Slow Clock
;//     <o4.0..2>   SLOW_VAL: Slow Clock divider    <0x0-0x7>
;//   </h>
;//   <h> CLOCK DIVIDER CONTROL
;//     <o6.1>   HDIVN                            
;//                  <i> 0: HCLK = FCLK/1, 01 : HCLK = FCLK/2
;//     <o6.0>      PDIVN
;//                  <i> 0: PCLK has the clock same as the HCLK/1,1: PCLK has the clock same as the HCLK/2
;//    </h>
;//  <h> Clock Generation
;//     <o3.18>     SPI          <0=> Disable  <1=> Enable
;//     <o3.17>     IIS          <0=> Disable  <1=> Enable
;//     <o3.16>     IIC          <0=> Disable  <1=> Enable
;//     <o3.15>     ADC          <0=> Disable  <1=> Enable
;//     <o3.14>     RTC          <0=> Disable  <1=> Enable
;//     <o3.13>     GPIO         <0=> Disable  <1=> Enable
;//     <o3.12>     UART2        <0=> Disable  <1=> Enable
;//     <o3.11>     UART1        <0=> Disable  <1=> Enable
;//     <o3.10>     UART0        <0=> Disable  <1=> Enable
;//     <o3.9>      SDI          <0=> Disable  <1=> Enable
;//     <o3.8>      PWMTIMER     <0=> Disable  <1=> Enable
;//     <o3.7>      USB device   <0=> Disable  <1=> Enable
;//     <o3.6>      USB host     <0=> Disable  <1=> Enable
;//     <o3.5>      LCDC         <0=> Disable  <1=> Enable
;//     <o3.4>      NAND FLASH Controller       <0=> Disable  <1=> Enable
;//     <o3.3>      POWER-OFF    <0=> Disable  <1=> Enable
;//     <o3.2>      IDLE BIT     <0=> Disable  <1=> Enable
;//     <O3.0>      SM_BIT       <0=> Disable  <1=> Enable
;//   </h>
;// </e>
CLK_SETUP       EQU     0
MPLLCON_Val     EQU     0x0005C042
UPLLCON_Val     EQU     0x00028080
CLKCON_Val      EQU     0x0007FFF0
CLKSLOW_Val     EQU     0x00000004
LOCKTIME_Val    EQU     0x00FFFFFF
CLKDIVN_Val     EQU     0X00000003



;Interrupt  definitions
INTOFFSET          EQU    0X4A000014                      ;Address of Interrupt offset Register

;//<e> Interrupt Vector Table
;//  <o1.0..31> Interrupt Vector address     <0x20-0x3fffff78>
;//            <i> You could define Interuupt Vctor Table address.  
;//            <i> The Interrupt Vector Table address must be word aligned adress. 
;//</e>  
IntVT_SETUP      EQU     1
IntVTAddress    EQU     0x33FFFF20

; Watchdog Timer definitions
WT_BASE         EQU     0x53000000      ; WT Base Address
WTCON_OFS       EQU     0x00            ; WTCON Offset
WTDAT_OFS       EQU     0x04            ; WTDAT Offset
WTCNT_OFS       EQU     0x08            ; WTCNT Offset

;// <e> Watchdog Timer
;//   <o1.5>      Watchdog Timer Enable/Disable
;//   <o1.0>      Reset Enable/Disable
;//   <o1.2>      Interrupt Enable/Disable
;//   <o1.3..4>   Clock Select  
;//               <0=> 1/16  <1=> 1/32  <2=> 1/64  <3=> 1/128
;//               <i> Clock Division Factor
;//   <o1.8..15>  Prescaler Value <0x0-0xFF>
;//   <o2.0..15>  Time-out Value  <0x0-0xFFFF>
;// </e>
WT_SETUP        EQU     1
WTCON_Val       EQU     0x00000000
WTDAT_Val       EQU     0x00008000


; Memory Controller definitions
MC_BASE         EQU     0x48000000      ; Memory Controller Base Address

;// <e> Memory Controller
MC_SETUP        EQU     1

;//   <h> Bank 0
;//     <o0.0..1>   PMC: Page Mode Configuration
;//                 <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//     <o0.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//     <o0.4..5>   Tcah: Address Holding Time after nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o0.6..7>   Toch: Chip Select Hold on nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o0.8..10>  Tacc: Access Cycle
;//                 <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                 <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//     <o0.11..12> Tcos: Chip Select Set-up nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o0.13..14> Tacs: Address Set-up before nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//   </h>
;//
;//   <h> Bank 1
;//     <o8.4..5>   DW: Data Bus Width
;//                 <0=> 8-bit   <1=> 16-bit  <2=> 32-bit  <3=> Rsrvd
;//     <o8.6>      WS: WAIT Status
;//                 <0=> WAIT Disable
;//                 <1=> WAIT Enable
;//     <o8.7>      ST: SRAM Type
;//                 <0=> Not using UB/LB
;//                 <1=> Using UB/LB
;//     <o1.0..1>   PMC: Page Mode Configuration
;//                 <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//     <o1.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//     <o1.4..5>   Tcah: Address Holding Time after nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o1.6..7>   Toch: Chip Select Hold on nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o1.8..10>  Tacc: Access Cycle
;//                 <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                 <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//     <o1.11..12> Tcos: Chip Select Set-up nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o1.13..14> Tacs: Address Set-up before nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//   </h>
;//
;//   <h> Bank 2
;//     <o8.8..9>   DW: Data Bus Width
;//                 <0=> 8-bit   <1=> 16-bit  <2=> 32-bit  <3=> Rsrvd
;//     <o8.10>     WS: WAIT Status
;//                 <0=> WAIT Disable
;//                 <1=> WAIT Enable
;//     <o8.11>     ST: SRAM Type
;//                 <0=> Not using UB/LB
;//                 <1=> Using UB/LB
;//     <o2.0..1>   PMC: Page Mode Configuration
;//                 <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//     <o2.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//     <o2.4..5>   Tcah: Address Holding Time after nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o2.6..7>   Toch: Chip Select Hold on nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o2.8..10>  Tacc: Access Cycle
;//                 <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                 <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//     <o2.11..12> Tcos: Chip Select Set-up nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o2.13..14> Tacs: Address Set-up before nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//   </h>
;//
;//   <h> Bank 3
;//     <o8.12..13> DW: Data Bus Width
;//                 <0=> 8-bit   <1=> 16-bit  <2=> 32-bit  <3=> Rsrvd
;//     <o8.14>     WS: WAIT Status
;//                 <0=> WAIT Disable
;//                 <1=> WAIT Enable
;//     <o8.15>     ST: SRAM Type
;//                 <0=> Not using UB/LB
;//                 <1=> Using UB/LB
;//     <o3.0..1>   PMC: Page Mode Configuration
;//                 <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//     <o3.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//     <o3.4..5>   Tcah: Address Holding Time after nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o3.6..7>   Toch: Chip Select Hold on nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o3.8..10>  Tacc: Access Cycle
;//                 <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                 <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//     <o3.11..12> Tcos: Chip Select Set-up nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o3.13..14> Tacs: Address Set-up before nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//   </h>
;//
;//   <h> Bank 4
;//     <o8.16..17> DW: Data Bus Width
;//                 <0=> 8-bit   <1=> 16-bit  <2=> 32-bit  <3=> Rsrvd
;//     <o8.18>     WS: WAIT Status
;//                 <0=> WAIT Disable
;//                 <1=> WAIT Enable
;//     <o8.19>     ST: SRAM Type
;//                 <0=> Not using UB/LB
;//                 <1=> Using UB/LB
;//     <o4.0..1>   PMC: Page Mode Configuration
;//                 <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//     <o4.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//     <o4.4..5>   Tcah: Address Holding Time after nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o4.6..7>   Toch: Chip Select Hold on nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o4.8..10>  Tacc: Access Cycle
;//                 <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                 <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//     <o4.11..12> Tcos: Chip Select Set-up nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o4.13..14> Tacs: Address Set-up before nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//   </h>
;//
;//   <h> Bank 5
;//     <o8.20..21> DW: Data Bus Width
;//                 <0=> 8-bit   <1=> 16-bit  <2=> 32-bit  <3=> Rsrvd
;//     <o8.22>     WS: WAIT Status
;//                 <0=> WAIT Disable
;//                 <1=> WAIT Enable
;//     <o8.23>     ST: SRAM Type
;//                 <0=> Not using UB/LB
;//                 <1=> Using UB/LB
;//     <o5.0..1>   PMC: Page Mode Configuration
;//                 <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//     <o5.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//     <o5.4..5>   Tcah: Address Holding Time after nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o5.6..7>   Toch: Chip Select Hold on nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o5.8..10>  Tacc: Access Cycle
;//                 <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                 <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//     <o5.11..12> Tcos: Chip Select Set-up nOE
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     <o5.13..14> Tacs: Address Set-up before nGCSn
;//                 <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//   </h>
;//
;//   <h> Bank 6
;//     <o10.0..2>  BK76MAP: Bank 6/7 Memory Map
;//                 <0=> 32M  <1=> 64M <2=> 128M <4=> 2M   <5=> 4M   <6=> 8M   <7=> 16M
;//     <o8.24..25> DW: Data Bus Width
;//                 <0=> 8-bit   <1=> 16-bit  <2=> 32-bit  <3=> Rsrvd
;//     <o8.26>     WS: WAIT Status
;//                 <0=> WAIT Disable
;//                 <1=> WAIT Enable
;//     <o8.27>     ST: SRAM Type
;//                 <0=> Not using UB/LB
;//                 <1=> Using UB/LB
;//     <o6.15..16> MT: Memory Type
;//                 <0=> ROM or SRAM
;//                 <3=> SDRAM
;//     <h> ROM or SRAM
;//       <o6.0..1>   PMC: Page Mode Configuration
;//                   <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//       <o6.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//       <o6.4..5>   Tcah: Address Holding Time after nGCSn
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//       <o6.6..7>   Toch: Chip Select Hold on nOE
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//       <o6.8..10>  Tacc: Access Cycle
;//                   <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                   <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//       <o6.11..12> Tcos: Chip Select Set-up nOE
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//       <o6.13..14> Tacs: Address Set-up before nGCSn
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     </h>
;//     <h> SDRAM
;//       <o6.0..1>   SCAN: Columnn Address Number
;//                   <0=> 8-bit   <1=> 9-bit   <2=> 10-bit  <3=> Rsrvd
;//       <o6.2..3>   Trcd: RAS to CAS Delay
;//                   <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> Rsrvd
;//       <o10.4>     SCKEEN: SCLK Selection (Bank 6/7)
;//                   <0=> Normal
;//                   <1=> Reduced Power   
;//       <o10.5>     SCLKEN: SDRAM power down mode (Bank 6/7)
;//                   <0=> DISABLE
;//                   <1=> ENABLE 
;//       <o10.7>     BURST_EN: ARM core burst operation (Bank 6/7)
;//                   <0=> DISABLE
;//                   <1=> ENABLE 
;//       <o11.0..2>  BL: Burst Length
;//                   <0=> 1
;//       <o11.3>     BT: Burst Type
;//                   <0=> Sequential
;//       <o11.4..6>  CL: CAS Latency
;//                   <0=> 1 clk   <1=> 2 clks  <2=> 3 clks
;//       <o11.7..8>  TM: Test Mode
;//                   <0=> Mode Register Set
;//       <o11.9>     WBL: Write Burst Length
;//                   <0=> 0
;//     </h>
;//   </h>
;//
;//   <h> Bank 7
;//     <o10.0..2>  BK76MAP: Bank 6/7 Memory Map
;//                 <0=> 32M  <1=> 64M <2=> 128M <4=> 2M   <5=> 4M   <6=> 8M   <7=> 16M
;//     <o8.28..29> DW: Data Bus Width
;//                 <0=> 8-bit   <1=> 16-bit  <2=> 32-bit  <3=> Rsrvd
;//     <o8.30>     WS: WAIT Status
;//                 <0=> WAIT Disable
;//                 <1=> WAIT Enable
;//     <o8.31>     ST: SRAM Type
;//                 <0=> Not using UB/LB
;//                 <1=> Using UB/LB
;//     <o7.15..16> MT: Memory Type
;//                 <0=> ROM or SRAM
;//                 <3=> SDRAM
;//     <h> ROM or SRAM
;//       <o7.0..1>   PMC: Page Mode Configuration
;//                   <0=> 1 Data  <1=> 4 Data  <2=> 8 Data  <3=> 16 Data
;//       <o7.2..3>   Tpac: Page Mode Access Cycle
;//                 <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> 6 clks
;//       <o7.4..5>   Tcah: Address Holding Time after nGCSn
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//       <o7.6..7>   Toch: Chip Select Hold on nOE
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//       <o7.8..10>  Tacc: Access Cycle
;//                   <0=> 1 clk   <1=> 2 clks  <2=> 3 clks  <3=> 4 clks
;//                   <4=> 6 clk   <5=> 8 clks  <6=> 10 clks <7=> 14 clks
;//       <o7.11..12> Tcos: Chip Select Set-up nOE
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//       <o7.13..14> Tacs: Address Set-up before nGCSn
;//                   <0=> 0 clk   <1=> 1 clk   <2=> 2 clks  <3=> 4 clks
;//     </h>
;//     <h> SDRAM
;//       <o7.0..1>   SCAN: Columnn Address Number
;//                   <0=> 8-bit   <1=> 9-bit   <2=> 10-bit  <3=> Rsrvd
;//       <o7.2..3>   Trcd: RAS to CAS Delay
;//                   <0=> 2 clks  <1=> 3 clks  <2=> 4 clks  <3=> Rsrvd
;//       <o10.4>     SCLKEN: SCLK Selection (Bank 6/7)
;//                   <0=> Normal
;//                   <1=> Reduced Power 
;//       <o10.5>     SCLKEN: SDRAM power down mode (Bank 6/7)
;//                   <0=> DISABLE
;//                   <1=> ENABLE 
;//       <o10.7>     BURST_EN: ARM core burst operation (Bank 6/7)
;//                   <0=> DISABLE
;//                   <1=> ENABLE 
;//       <o12.0..2>  BL: Burst Length
;//                   <0=> 1
;//       <o12.3>     BT: Burst Type
;//                   <0=> Sequential
;//       <o12.4..6>  CL: CAS Latency
;//                   <0=> 1 clk   <1=> 2 clks  <2=> 3 clks
;//       <o12.7..8>  TM: Test Mode
;//                   <0=> Mode Register Set
;//       <o12.9>     WBL: Write Burst Length
;//                   <0=> 0
;//     </h>
;//   </h>
;//
;//   <h> Refresh
;//     <o9.23>     REFEN: SDRAM Refresh
;//                 <0=> Disable <1=> Enable
;//     <o9.22>     TREFMD: SDRAM Refresh Mode
;//                 <0=> CBR/Auto Refresh
;//                 <1=> Self Refresh
;//     <o9.20..21> Trp: SDRAM RAS Pre-charge Time
;//                 <0=> 2 clks 
;//                 <1=> 3 clks 
;//                 <2=> 4 clks 
;//                 <3=> Rsrvd 
;//     <o9.18..19> Tsrc: SDRAM Semi Row cycle time
;//                <i> SDRAM Row cycle time: Trc=Tsrc+Trp
;//                 <0=> 4 clks  <1=> 5 clks  <2=> 6 clks  <3=> 7 clks
;//     <o9.0..10>  Refresh Counter <0x0-0x07FF>
;//                 <i> Refresh Period = (2^11 - Refresh Count + 1) / HCLK
;//   </h>
BANKCON0_Val    EQU     0x00000700
BANKCON1_Val    EQU     0x00000700
BANKCON2_Val    EQU     0x00000700
BANKCON3_Val    EQU     0x00000700
BANKCON4_Val    EQU     0x00000700
BANKCON5_Val    EQU     0x00000700
BANKCON6_Val    EQU     0x00018005
BANKCON7_Val    EQU     0x00018005
BWSCON_Val      EQU     0X22119120;0x22111110	 
REFRESH_Val     EQU     0x008e0459
BANKSIZE_Val    EQU     0x00000032;0x000000b2
MRSRB6_Val      EQU     0x00000030
MRSRB7_Val      EQU     0x00000030

;// </e> End of MC



; I/O Ports definitions
PIO_BASE        EQU     0x56000000      ; PIO Base Address
PCONA_OFS       EQU     0x00            ; PCONA Offset
PCONB_OFS       EQU     0x10            ; PCONB Offset
PCONC_OFS       EQU     0x20            ; PCONC Offset
PCOND_OFS       EQU     0x30            ; PCOND Offset
PCONE_OFS       EQU     0x40            ; PCONE Offset
PCONF_OFS       EQU     0x50            ; PCONF Offset
PCONG_OFS       EQU     0x60            ; PCONG Offset
PCONH_OFS       EQU     0x70            ; PCONH Offset
PCONJ_OFS       EQU     0xD0            ; PCONJ Offset
PUPB_OFS        EQU     0x18            ; PUPB Offset
PUPC_OFS        EQU     0x28            ; PUPC Offset
PUPD_OFS        EQU     0x38            ; PUPD Offset
PUPE_OFS        EQU     0x48            ; PUPE Offset
PUPF_OFS        EQU     0x58            ; PUPF Offset
PUPG_OFS        EQU     0x68            ; PUPG Offset
PUPH_OFS        EQU     0x78            ; PUPH Offset
PUPJ_OFS        EQU     0xD8            ; PUPJ Offset


;// <e> I/O Configuration
PIO_SETUP       EQU     1

;//   <e> Port A
;//     <o1.0>      PA0  <0=> Output   <1=> ADDR0
;//     <o1.1>      PA1  <0=> Output   <1=> ADDR16
;//     <o1.2>      PA2  <0=> Output   <1=> ADDR17
;//     <o1.3>      PA3  <0=> Output   <1=> ADDR18
;//     <o1.4>      PA4  <0=> Output   <1=> ADDR19
;//     <o1.5>      PA5  <0=> Output   <1=> ADDR20
;//     <o1.6>      PA6  <0=> Output   <1=> ADDR21
;//     <o1.7>      PA7  <0=> Output   <1=> ADDR22
;//     <o1.8>      PA8  <0=> Output   <1=> ADDR23
;//     <o1.9>      PA9  <0=> Output   <1=> ADDR24
;//     <o1.10>      PA0  <0=> Output   <1=> ADDR25
;//     <o1.11>      PA1  <0=> Output   <1=> ADDR26
;//     <o1.12>      PA2  <0=> Output   <1=> nGCS[1]
;//     <o1.13>      PA3  <0=> Output   <1=> nGCS[2]
;//     <o1.14>      PA4  <0=> Output   <1=> nGCS[3]
;//     <o1.15>      PA5  <0=> Output   <1=> nGCS[4]
;//     <o1.16>      PA6  <0=> Output   <1=> nGCS[5]
;//     <o1.17>      PA7  <0=> Output   <1=> CLE
;//     <o1.18>      PA8  <0=> Output   <1=> ALE
;//     <o1.19>      PA9  <0=> Output   <1=> nFWE
;//     <o1.20>      PA0  <0=> Output   <1=> nFRE
;//     <o1.21>      PA1  <0=> Output   <1=> nRSTOUT
;//     <o1.22>      PA2  <0=> Output   <1=> nFCE
;//   </e>
PIOA_SETUP      EQU     0
PCONA_Val       EQU     0x000003FF

;//   <e> Port B
;//     <o1.0..1>        PB0  <0=> Input   <1=> Output  <2=> TOUT0    <3=> Reserved 
;//     <o1.2..3>        PB1  <0=> Input   <1=> Output  <2=> TOUT1    <3=> Reserved 
;//     <o1.4..5>        PB2  <0=> Input   <1=> Output  <2=> TOUT2    <3=> Reserved 
;//     <o1.6..7>        PB3  <0=> Input   <1=> Output  <2=> TOUT3    <3=> Reserved 
;//     <o1.8..9>        PB4  <0=> Input   <1=> Output  <2=> TCLK[0]  <3=> Reserved 
;//     <o1.10..11>      PB5  <0=> Input   <1=> Output  <2=> nXBACK   <3=> Reserved 
;//     <o1.12..13>      PB6  <0=> Input   <1=> Output  <2=> nXBREQ   <3=> Reserved 
;//     <o1.14..15>      PB7  <0=> Input   <1=> Output  <2=> nXDACK1  <3=> Reserved 
;//     <o1.16..17>      PB8  <0=> Input   <1=> Output  <2=> nXDREQ1  <3=> Reserved 
;//     <o1.18..19>      PB9  <0=> Input   <1=> Output  <2=> nXDACK0  <3=> Reserved 
;//     <o1.20..21>      PB10 <0=> Input   <1=> Output  <2=> nXDREQ0  <3=> Reserved 
;//     <h> Pull-up Resistors                                        
;//       <o2.0>    PB0 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.1>    PB1 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.2>    PB2 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.3>    PB3 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.4>    PB4 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.5>    PB5 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.6>    PB6 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.7>    PB7 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.8>    PB8 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.9>    PB9 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.10>   PB10 Pull-up       <0=> Enabled  <1=> Disabled   
;//     </h>                                                         
;//   </e>
PIOB_SETUP      EQU     0
PCONB_Val       EQU     0x000007FF
PUPB_Val        EQU     0x00000000 

;//   <e> Port C
;//     <o1.0..1>          PC0  <0=> Input    <1=> Output  <2=> LEND          <3=> Reserved 
;//     <o1.2..3>          PC1  <0=> Input    <1=> Output  <2=> VCLK          <3=> Reserved 
;//     <o1.4..5>          PC2  <0=> Input    <1=> Output  <2=> VLINE         <3=> Reserved 
;//     <o1.6..7>          PC3  <0=> Input    <1=> Output  <2=> VFRAME        <3=> Reserved 
;//     <o1.8..9>          PC4  <0=> Input    <1=> Output  <2=> VM            <3=> Reserved 
;//     <o1.10..11>        PC5  <0=> Input    <1=> Output  <2=> LCDVF2     <3=> Reserved 
;//     <o1.12..13>        PC6  <0=> Input    <1=> Output  <2=> LCDVF1    <3=> Reserved 
;//     <o1.14..15>        PC7  <0=> Input    <1=> Output  <2=> LCDVF0   <3=> Reserved 
;//     <o1.16..17>        PC8  <0=> Input    <1=> Output  <2=> VD[0]         <3=> Reserved 
;//     <o1.18..19>        PC9  <0=> Input    <1=> Output  <2=> VD[1]         <3=> Reserved 
;//     <o1.20..21>        PC10 <0=> Input    <1=> Output  <2=> VD[2]         <3=> Reserved 
;//     <o1.22..23>        PC11  <0=> Input   <1=> Output  <2=> VD[3]         <3=> Reserved 
;//     <o1.24..25>        PC12  <0=> Input   <1=> Output  <2=> VD[4]         <3=> Reserved 
;//     <o1.26..27>        PC13  <0=> Input   <1=> Output  <2=> VD[5]         <3=> Reserved 
;//     <o1.28..29>        PC14  <0=> Input   <1=> Output  <2=> VD[6]         <3=> Reserved 
;//     <o1.30..31>        PC15  <0=> Input   <1=> Output  <2=> VD[7]         <3=> Reserved 
;//     <h> Pull-up Resistors                                        
;//       <o2.0>     PC0 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.1>     PC1 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.2>     PC2 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.3>     PC3 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.4>     PC4 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.5>     PC5 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.6>     PC6 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.7>     PC7 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.8>     PC8 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.9>     PC9 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.10>    PC10 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.11>    PC11 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.12>    PC12 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.13>    PC13 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.14>    PC14 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.15>    PC15 Pull-up        <0=> Enabled  <1=> Disabled  
;//     </h>                                                         
;//   </e>
PIOC_SETUP      EQU     0
PCONC_Val       EQU     0xAAAAAAAA
PUPC_Val        EQU     0x00000000

;//   <e> Port D
;//     <o1.0..1>          PD0  <0=> Input    <1=> Output  <2=> VD[8]         <3=> Reserved 
;//     <o1.2..3>          PD1  <0=> Input    <1=> Output  <2=> VD[9]         <3=> Reserved 
;//     <o1.4..5>          PD2  <0=> Input    <1=> Output  <2=> VD[10]         <3=> Reserved 
;//     <o1.6..7>          PD3  <0=> Input    <1=> Output  <2=> VD[11]         <3=> Reserved 
;//     <o1.8..9>          PD4  <0=> Input    <1=> Output  <2=> VD[12]         <3=> Reserved 
;//     <o1.10..11>        PD5  <0=> Input    <1=> Output  <2=> VD[13]         <3=> Reserved 
;//     <o1.12..13>        PD6  <0=> Input    <1=> Output  <2=> VD[14]         <3=> Reserved 
;//     <o1.14..15>        PD7  <0=> Input    <1=> Output  <2=> VD[15]         <3=> Reserved 
;//     <o1.16..17>        PD8  <0=> Input    <1=> Output  <2=> VD[16]         <3=> Reserved  
;//     <o1.18..19>        PD9  <0=> Input    <1=> Output  <2=> VD[17]         <3=> Reserved 
;//     <o1.20..21>        PD10 <0=> Input    <1=> Output  <2=> VD[18]         <3=> Reserved 
;//     <o1.22..23>        PD11  <0=> Input   <1=> Output  <2=> VD[19]         <3=> Reserved 
;//     <o1.24..25>        PD12  <0=> Input   <1=> Output  <2=> VD[20]         <3=> Reserved 
;//     <o1.26..27>        PD13  <0=> Input   <1=> Output  <2=> VD[21]         <3=> Reserved 
;//     <o1.28..29>        PD14  <0=> Input   <1=> Output  <2=> VD[22]          <3=> nSS1
;//     <o1.30..31>        PD15  <0=> Input   <1=> Output  <2=> VD[23]          <3=> nSS0 
;//     <h> Pull-up Resistors                                        
;//       <o2.0>     PD0 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.1>     PD1 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.2>     PD2 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.3>     PD3 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.4>     PD4 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.5>     PD5 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.6>     PD6 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.7>     PD7 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.8>     PD8 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.9>     PD9 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.10>    PD10 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.11>    PD11 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.12>    PD12 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.13>    PD13 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.14>    PD14 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.15>    PD15 Pull-up        <0=> Enabled  <1=> Disabled  
;//     </h>         
;//   </e>
PIOD_SETUP      EQU     0
PCOND_Val       EQU     0x00000000
PUPD_Val        EQU     0x00000000

;//   <e> Port E
;//     <o1.0..1>          PE0  <0=> Input    <1=> Output  <2=> I2SLRCK       <3=> Reserved 
;//     <o1.2..3>          PE1  <0=> Input    <1=> Output  <2=> I2SSCLK       <3=> Reserved  
;//     <o1.4..5>          PE2  <0=> Input    <1=> Output  <2=> CDCLK         <3=> Reserved 
;//     <o1.6..7>          PE3  <0=> Input    <1=> Output  <2=> I2SDI         <3=> nSS0 
;//     <o1.8..9>          PE4  <0=> Input    <1=> Output  <2=> I2SDO         <3=> I2SSDI 
;//     <o1.10..11>        PE5  <0=> Input    <1=> Output  <2=> SDCLK         <3=> Reserved 
;//     <o1.12..13>        PE6  <0=> Input    <1=> Output  <2=> SDCMD         <3=> Reserved 
;//     <o1.14..15>        PE7  <0=> Input    <1=> Output  <2=> SDDAT0        <3=> Reserved 
;//     <o1.16..17>        PE8  <0=> Input    <1=> Output  <2=> SDDAT1        <3=> Reserved
;//     <o1.18..19>        PE9  <0=> Input    <1=> Output  <2=> SDDAT2        <3=> Reserved
;//     <o1.20..21>        PE10 <0=> Input    <1=> Output  <2=> SDDAT3        <3=> Reserved
;//     <o1.22..23>        PE11  <0=> Input   <1=> Output  <2=> SPIMISO0      <3=> Reserved 
;//     <o1.24..25>        PE12  <0=> Input   <1=> Output  <2=> SPIMOSI0      <3=> Reserved 
;//     <o1.26..27>        PE13  <0=> Input   <1=> Output  <2=> SPICLK0       <3=> Reserved 
;//     <o1.28..29>        PE14  <0=> Input   <1=> Output  <2=> IICSCL        <3=> Reserved
;//     <o1.30..31>        PE15  <0=> Input   <1=> Output  <2=> IICSDA        <3=> Reserved
;//     <h> Pull-up Resistors                                                      
;//       <o2.0>     PE0 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.1>     PE1 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.2>     PE2 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.3>     PE3 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.4>     PE4 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.5>     PE5 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.6>     PE6 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.7>     PE7 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.8>     PE8 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.9>     PE9 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.10>    PE10 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.11>    PE11 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.12>    PE12 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.13>    PE13 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.14>    PE14 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.15>    PE15 Pull-up        <0=> Enabled  <1=> Disabled  
;//     </h>         
;//   </e>
PIOE_SETUP      EQU     0
PCONE_Val       EQU     0x00000000
PUPE_Val        EQU     0x00000000

;//   <e> Port F
;//     <o1.0..1>        PF0  <0=> Input   <1=> Output  <2=> EINT[0]  <3=> Reserved 
;//     <o1.2..3>        PF1  <0=> Input   <1=> Output  <2=> EINT[1]  <3=> Reserved 
;//     <o1.4..5>        PF2  <0=> Input   <1=> Output  <2=> EINT[2]  <3=> Reserved 
;//     <o1.6..7>        PF3  <0=> Input   <1=> Output  <2=> EINT[3]  <3=> Reserved 
;//     <o1.8..9>        PF4  <0=> Input   <1=> Output  <2=> EINT[4]  <3=> Reserved 
;//     <o1.10..11>      PF5  <0=> Input   <1=> Output  <2=> EINT[5]  <3=> Reserved 
;//     <o1.12..13>      PF6  <0=> Input   <1=> Output  <2=> EINT[6]  <3=> Reserved 
;//     <o1.14..15>      PF7  <0=> Input   <1=> Output  <2=> EINT[7]  <3=> Reserved 
;//     <h> Pull-up Resistors                                        
;//       <o2.0>    PF0 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.1>    PF1 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.2>    PF2 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.3>    PF3 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.4>    PF4 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.5>    PF5 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.6>    PF6 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.7>    PF7 Pull-up        <0=> Enabled  <1=> Disabled   
;//     </h> 
;//   </e>
PIOF_SETUP      EQU     1
PCONF_Val       EQU     0x000055aa
PUPF_Val        EQU     0x000000ff

;//   <e> Port G
;//     <o1.0..1>          PG0  <0=> Input    <1=> Output  <2=> EINT[8]   <3=> Reserved 
;//     <o1.2..3>          PG1  <0=> Input    <1=> Output  <2=> EINT[9]   <3=> Reserved 
;//     <o1.4..5>          PG2  <0=> Input    <1=> Output  <2=> EINT[10]   <3=> nSS0 
;//     <o1.6..7>          PG3  <0=> Input    <1=> Output  <2=> EINT[11]   <3=> nSS1 
;//     <o1.8..9>          PG4  <0=> Input    <1=> Output  <2=> EINT[12]   <3=> LCD_PWRDN 
;//     <o1.10..11>        PG5  <0=> Input    <1=> Output  <2=> EINT[13]   <3=> SPIMISO1 
;//     <o1.12..13>        PG6  <0=> Input    <1=> Output  <2=> EINT[14]   <3=> SPIMOSI1
;//     <o1.14..15>        PG7  <0=> Input    <1=> Output  <2=> EINT[15]   <3=> SPICLK1 
;//     <o1.16..17>        PG8  <0=> Input    <1=> Output  <2=> EINT[16]   <3=> Reserved 
;//     <o1.18..19>        PG9  <0=> Input    <1=> Output  <2=> EINT[17]   <3=> Reserved 
;//     <o1.20..21>        PG10 <0=> Input    <1=> Output  <2=> EINT[18]   <3=> Reserved 
;//     <o1.22..23>        PG11  <0=> Input   <1=> Output  <2=> EINT[19]   <3=> TCLK1
;//     <o1.24..25>        PG12  <0=> Input   <1=> Output  <2=> EINT[20]   <3=> XMON
;//     <o1.26..27>        PG13  <0=> Input   <1=> Output  <2=> EINT[21]   <3=> nXPON 
;//     <o1.28..29>        PG14  <0=> Input   <1=> Output  <2=> EINT[22]   <3=> YMON
;//     <o1.30..31>        PG15  <0=> Input   <1=> Output  <2=> EINT[23]   <3=> nYPON
;//     <h> Pull-up Resistors                                        
;//       <o2.0>     PG0 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.1>     PG1 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.2>     PG2 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.3>     PG3 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.4>     PG4 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.5>     PG5 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.6>     PG6 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.7>     PG7 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.8>     PG8 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.9>     PG9 Pull-up         <0=> Enabled  <1=> Disabled   
;//       <o2.10>    PG10 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.11>    PG11 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.12>    PG12 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.13>    PG13 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.14>    PG14 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.15>    PG15 Pull-up        <0=> Enabled  <1=> Disabled  
;//     </h>                                                    
;//   </e>
PIOG_SETUP      EQU     0
PCONG_Val       EQU     0x00000000
PUPG_Val        EQU     0x00000000

;//   <e> Port H
;//     <o1.0..1>        PH0  <0=> Input   <1=> Output  <2=> nCTS0    <3=> Reserved 
;//     <o1.2..3>        PH1  <0=> Input   <1=> Output  <2=> nRTS0    <3=> Reserved 
;//     <o1.4..5>        PH2  <0=> Input   <1=> Output  <2=> TXD[0]    <3=> Reserved 
;//     <o1.6..7>        PH3  <0=> Input   <1=> Output  <2=> RXD[0]    <3=> Reserved 
;//     <o1.8..9>        PH4  <0=> Input   <1=> Output  <2=> TXD[1]  <3=> Reserved 
;//     <o1.10..11>      PH5  <0=> Input   <1=> Output  <2=> RXD[1]   <3=> Reserved 
;//     <o1.12..13>      PH6  <0=> Input   <1=> Output  <2=> TXD[2]   <3=> nRTS1
;//     <o1.14..15>      PH7  <0=> Input   <1=> Output  <2=> RXD[2]  <3=> nCTS1 
;//     <o1.16..17>      PH8  <0=> Input   <1=> Output  <2=> UCLK    <3=> Reserved 
;//     <o1.18..19>      PH9  <0=> Input   <1=> Output  <2=> CLKOUT0  <3=> Reserved 
;//     <o1.20..21>      PH10 <0=> Input   <1=> Output  <2=> CLKOUT1  <3=> Reserved 
;//     <h> Pull-up Resistors                                        
;//       <o2.0>    PH0 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.1>    PH1 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.2>    PH2 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.3>    PH3 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.4>    PH4 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.5>    PH5 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.6>    PH6 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.7>    PH7 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.8>    PH8 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.9>    PH9 Pull-up        <0=> Enabled  <1=> Disabled   
;//       <o2.10>   PH10 Pull-up       <0=> Enabled  <1=> Disabled   
;//     </h>                                                         
;//   </e>
PIOH_SETUP      EQU     0
PCONH_Val       EQU     0x000007FF
PUPH_Val        EQU     0x00000000 

;// </e>




                PRESERVE8
                

; Area Definition and Entry Point
;  Startup Code must be linked first at Address at which it expects to run.

                AREA    RESET, CODE, READONLY
                ARM


; Exception Vectors
;  Mapped to Address 0.
;  Absolute addressing mode must be used.
;  Dummy Handlers are implemented as infinite loops which can be modified.

Vectors         LDR     PC, Reset_Addr         
                LDR     PC, Undef_Addr
                LDR     PC, SWI_Addr
                LDR     PC, PAbt_Addr
                LDR     PC, DAbt_Addr
                NOP                            ; Reserved Vector 
                LDR     PC, IRQ_Addr
                LDR     PC, FIQ_Addr


                IF      IntVT_SETUP <> 0

;Interrupt Vector Table Address                
HandleEINT0		  EQU    IntVTAddress           
HandleEINT1		  EQU    IntVTAddress +4
HandleEINT2		  EQU    IntVTAddress +4*2
HandleEINT3		  EQU    IntVTAddress +4*3
HandleEINT4_7	  EQU    IntVTAddress +4*4
HandleEINT8_23    EQU    IntVTAddress +4*5
HandleReserved	  EQU    IntVTAddress +4*6
HandleBATFLT	  EQU    IntVTAddress +4*7
HandleTICK		  EQU    IntVTAddress +4*8
HandleWDT		  EQU    IntVTAddress +4*9
HandleTIMER0 	  EQU    IntVTAddress +4*10
HandleTIMER1 	  EQU    IntVTAddress +4*11
HandleTIMER2 	  EQU    IntVTAddress +4*12
HandleTIMER3 	  EQU    IntVTAddress +4*13
HandleTIMER4 	  EQU    IntVTAddress +4*14
HandleUART2  	  EQU    IntVTAddress +4*15
HandleLCD 		  EQU    IntVTAddress +4*16
HandleDMA0		  EQU    IntVTAddress +4*17
HandleDMA1		  EQU    IntVTAddress +4*18
HandleDMA2		  EQU    IntVTAddress +4*19
HandleDMA3		  EQU    IntVTAddress +4*20
HandleMMC		  EQU    IntVTAddress +4*21
HandleSPI0		  EQU    IntVTAddress +4*22
HandleUART1		  EQU    IntVTAddress +4*23
;HandleReserved		  EQU    IntVTAddress +4*24
HandleUSBD		  EQU    IntVTAddress +4*25
HandleUSBH		  EQU    IntVTAddress +4*26
HandleIIC		  EQU    IntVTAddress +4*27
HandleUART0 	  EQU    IntVTAddress +4*28
HandleSPI1 		  EQU    IntVTAddress +4*39
HandleRTC 		  EQU    IntVTAddress +4*30
HandleADC 		  EQU    IntVTAddress +4*31


IRQ_Entry
                sub	sp,sp,#4       ;reserved for PC
	            stmfd	sp!,{r8-r9}
                
	            ldr	r9,=INTOFFSET
	            ldr	r9,[r9]
	            ldr	r8,=HandleEINT0
	            add	r8,r8,r9,lsl #2
	            ldr	r8,[r8]
	            str	r8,[sp,#8]
	            ldmfd	sp!,{r8-r9,pc}                
                
				ENDIF

Reset_Addr      DCD     Reset_Handler
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
                DCD     0                      ; Reserved Address 
IRQ_Addr        DCD     IRQ_Handler
FIQ_Addr        DCD     FIQ_Handler

Undef_Handler   B       Undef_Handler
SWI_Handler     B       SWI_Handler
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
                
                IF      IntVT_SETUP <> 1
IRQ_Handler     B       IRQ_Handler
                ENDIF
                
                IF      IntVT_SETUP <> 0
IRQ_Handler     B       IRQ_Entry
                ENDIF
                
FIQ_Handler     B       FIQ_Handler



; Memory Controller Configuration
                IF      MC_SETUP <> 0
MC_CFG
                DCD     BWSCON_Val
                DCD     BANKCON0_Val
                DCD     BANKCON1_Val
                DCD     BANKCON2_Val
                DCD     BANKCON3_Val
                DCD     BANKCON4_Val
                DCD     BANKCON5_Val
                DCD     BANKCON6_Val
                DCD     BANKCON7_Val
                DCD     REFRESH_Val
                DCD     BANKSIZE_Val
                DCD     MRSRB6_Val
                DCD     MRSRB7_Val
                ENDIF


; Clock Management Configuration
                IF      CLK_SETUP <> 0
CLK_CFG
                DCD     LOCKTIME_Val     
                DCD     CLKDIVN_Val 
                DCD     MPLLCON_Val 
                DCD     UPLLCON_Val 
                DCD     CLKSLOW_Val 
                DCD     CLKCON_Val 
                ENDIF 



; I/O Configuration
                IF      PIO_SETUP <> 0
PIOA_CFG     
                DCD     PCONA_Val
PIOB_CFG        DCD     PCONB_Val
                DCD     PUPB_Val
PIOC_CFG        DCD     PCONC_Val
                DCD     PUPC_Val
PIOD_CFG        DCD     PCOND_Val
                DCD     PUPD_Val
PIOE_CFG        DCD     PCONE_Val
                DCD     PUPE_Val
PIOF_CFG        DCD     PCONF_Val
                DCD     PUPF_Val
PIOG_CFG        DCD     PCONG_Val
                DCD     PUPG_Val
PIOH_CFG        DCD     PCONH_Val
                DCD     PUPH_Val
                ENDIF

; Reset Handler

                EXPORT  Reset_Handler
Reset_Handler   

                IF      WT_SETUP <> 0
                LDR     R0, =WT_BASE
                LDR     R1, =WTCON_Val
                LDR     R2, =WTDAT_Val
                STR     R2, [R0, #WTCNT_OFS]
                STR     R2, [R0, #WTDAT_OFS]
                STR     R1, [R0, #WTCON_OFS]
                ENDIF
                
                IF		INT_SETUP <> 0
				LDR	    R0,	=INT_BASE
				LDR		R1,	=INTMSK_VAL
				LDR		R2,	=INTSUBMASK_VAL
				STR		R1,	[R0,#INTMSK_OFS]
				STR		R2,	[R0,#INTSUBMASK_OFS]
				ENDIF
                
                IF      CLK_SETUP <> 0         
                LDR     R0, =CLK_BASE            
                ADR     R8, CLK_CFG
                LDMIA   R8, {R1-R6}            
                STR     R1, [R0, #LOCKTIME_OFS]
                STR     R2, [R0, #CLKDIVN_OFS]  
                STR     R3, [R0, #MPLLCON_OFS] 
                STR     R4, [R0, #UPLLCON_OFS]  
                STR     R5, [R0, #CLKSLOW_OFS]
                STR     R6, [R0, #CLKCON_OFS]
                ENDIF                          

               	                  
                IF      MC_SETUP <> 0
                ADR     R13, MC_CFG
                LDMIA   R13, {R0-R12}
                LDR     R13, =MC_BASE
                STMIA   R13, {R0-R12}
                ENDIF          	              
                                
              
                IF      PIO_SETUP <> 0
                LDR     R13, =PIO_BASE

                IF      PIOA_SETUP <> 0
                ADR     R0, PIOA_CFG
                STR     R0, [R13, #PCONA_OFS]
                ENDIF

                IF      PIOB_SETUP <> 0
                ADR     R0, PIOB_CFG
                LDR     R1, [R0,#4]
                STR     R0, [R13, #PCONB_OFS]
                STR     R1, [R13, #PUPB_OFS]
                ENDIF

                IF      PIOC_SETUP <> 0
                ADR     R0, PIOC_CFG
                LDR     R1, [R0,#4]
                STR     R0, [R13, #PCONC_OFS]
                STR     R1, [R13, #PUPC_OFS]
                ENDIF

                IF      PIOD_SETUP <> 0
                ADR     R0, PIOD_CFG
                LDR     R1, [R0,#4]
                STR     R0, [R13, #PCOND_OFS]
                STR     R1, [R13, #PUPD_OFS]
                ENDIF

                IF      PIOE_SETUP <> 0
                ADR     R0, PIOE_CFG
                LDR     R1, [R0,#4]
                STR     R0, [R13, #PCONE_OFS]
                STR     R1, [R13, #PUPE_OFS]
                ENDIF

                IF      PIOF_SETUP <> 0
                ADR     R0, PIOF_CFG
                LDR     R1, [R0,#4]
                STR     R0, [R13, #PCONF_OFS]
                STR     R1, [R13, #PUPF_OFS]
                ENDIF

                IF      PIOG_SETUP <> 0
                ADR     R0, PIOG_CFG
                LDR     R1, [R0,#4]
                STR     R0, [R13, #PCONG_OFS]
                STR     R1, [R13, #PUPG_OFS]
                ENDIF
  
                IF      PIOH_SETUP <> 0
                ADR     R0, PIOH_CFG
                LDR     R1, [R0,#4]
                STR     R0, [R13, #PCONH_OFS]
                STR     R1, [R13, #PUPH_OFS]
                ENDIF
               
                ENDIF
                
                
; Setup Stack for each mode

                LDR     R0, =Stack_Top

;  Enter Undefined Instruction Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_UND:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #UND_Stack_Size

;  Enter Abort Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_ABT:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #ABT_Stack_Size

;  Enter FIQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #FIQ_Stack_Size

;  Enter IRQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #IRQ_Stack_Size

;  Enter Supervisor Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_SVC:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #SVC_Stack_Size

;  Enable MMU Map Address 0x00 to 0x300000000,So if have no norflash the interrupt can also work!
                IF      :DEF:ENABLEMMU
				IMPORT 	InitMMU
				STMFD	SP!,{R0}
				LDR 	R0, =TTB_ADDR
				BL   	InitMMU
				LDMFD  SP!,{R0}
			    ENDIF

;  Enter User Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_USR
                MOV     SP, R0
                SUB     SL, SP, #USR_Stack_Size
; Enter the C code

                IMPORT  __main
                LDR     R0, =__main
                BX      R0


; User Initial Stack & Heap
                AREA    |.text|, CODE, READONLY

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + USR_Stack_Size)
                LDR     R2, = (Heap_Mem +      Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR


                END
