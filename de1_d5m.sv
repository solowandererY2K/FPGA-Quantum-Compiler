// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
// --------------------------------------------------------------------

/*****************************************************************************
 * This file implements Lab 4, Part 2
 * **************************************************************************/

`timescale 1ns/1ns
module de1_d5m
  (////////////////////////    Clock Input     ////////////////////////
   input   [1:0]   CLOCK_24,               //  24 MHz
   input   [1:0]   CLOCK_27,               //  27 MHz
   input           CLOCK_50,               //  50 MHz
   input           EXT_CLOCK,              //  External Clock
   ////////////////////////    Push Button     ////////////////////////
   input   [3:0]   KEY,                    //  Pushbutton[3:0]
   ////////////////////////    DPDT Switch     ////////////////////////
   input   [9:0]   SW,                     //  Toggle Switch[9:0]
   ////////////////////////    7-SEG Dispaly   ////////////////////////
   output  [6:0]   HEX0,                   //  Seven Segment Digit 0
   output  [6:0]   HEX1,                   //  Seven Segment Digit 1
   output  [6:0]   HEX2,                   //  Seven Segment Digit 2
   output  [6:0]   HEX3,                   //  Seven Segment Digit 3
   ////////////////////////////    LED     ////////////////////////////
   output  [7:0]   LEDG,                   //  LED Green[7:0]
   output  [9:0]   LEDR,                   //  LED Red[9:0]
   ////////////////////////////    UART    ////////////////////////////
   output          UART_TXD,               //  UART Transmitter
   input           UART_RXD,               //  UART Receiver
   ///////////////////////     SDRAM Interface ////////////////////////
   inout   [15:0]  DRAM_DQ,                //  SDRAM Data bus 16 Bits
   output  [11:0]  DRAM_ADDR,              //  SDRAM Address bus 12 Bits
   output          DRAM_LDQM,              //  SDRAM Low-byte Data Mask 
   output          DRAM_UDQM,              //  SDRAM High-byte Data Mask
   output          DRAM_WE_N,              //  SDRAM Write Enable
   output          DRAM_CAS_N,             //  SDRAM Column Address Strobe
   output          DRAM_RAS_N,             //  SDRAM Row Address Strobe
   output          DRAM_CS_N,              //  SDRAM Chip Select
   output          DRAM_BA_0,              //  SDRAM Bank Address 0
   output          DRAM_BA_1,              //  SDRAM Bank Address 0
   output          DRAM_CLK,               //  SDRAM Clock
   output          DRAM_CKE,               //  SDRAM Clock Enable
   ////////////////////////    Flash Interface ////////////////////////
   inout   [7:0]   FL_DQ,                  //  FLASH Data bus 8 Bits
   output  [21:0]  FL_ADDR,                //  FLASH Address bus 22 Bits
   output          FL_WE_N,                //  FLASH Write Enable
   output          FL_RST_N,               //  FLASH Reset
   output          FL_OE_N,                //  FLASH Output Enable
   output          FL_CE_N,                //  FLASH Chip Enable
   ////////////////////////    SRAM Interface  ////////////////////////
   inout   [15:0]  SRAM_DQ,                //  SRAM Data bus 16 Bits
   output  [17:0]  SRAM_ADDR,              //  SRAM Address bus 18 Bits
   output          SRAM_UB_N,              //  SRAM High-byte Data Mask 
   output          SRAM_LB_N,              //  SRAM Low-byte Data Mask 
   output          SRAM_WE_N,              //  SRAM Write Enable
   output          SRAM_CE_N,              //  SRAM Chip Enable
   output          SRAM_OE_N,              //  SRAM Output Enable
   ////////////////////    SD Card Interface   ////////////////////////
   inout           SD_DAT,                 //  SD Card Data
   inout           SD_DAT3,                //  SD Card Data 3
   inout           SD_CMD,                 //  SD Card Command Signal
   output          SD_CLK,                 //  SD Card Clock
   ////////////////////////    I2C     ////////////////////////////////
   inout           I2C_SDAT,               //  I2C Data
   output          I2C_SCLK,               //  I2C Clock
   ////////////////////////    PS2     ////////////////////////////////
   input           PS2_DAT,                //  PS2 Data
   input           PS2_CLK,                //  PS2 Clock
   ////////////////////    USB JTAG link   ////////////////////////////
   input           TDI,                    // CPLD -> FPGA (data in)
   input           TCK,                    // CPLD -> FPGA (clk)
   input           TCS,                    // CPLD -> FPGA (CS)
   output          TDO,                    // FPGA -> CPLD (data out)
   ////////////////////////    VGA         ////////////////////////////
   output          VGA_HS,                 //  VGA H_SYNC
   output          VGA_VS,                 //  VGA V_SYNC
   output  [3:0]   VGA_R,                  //  VGA Red[3:0]
   output  [3:0]   VGA_G,                  //  VGA Green[3:0]
   output  [3:0]   VGA_B,                  //  VGA Blue[3:0]
   ////////////////////    Audio CODEC     ////////////////////////////
   inout           AUD_ADCLRCK,            //  Audio CODEC ADC LR Clock
   input           AUD_ADCDAT,             //  Audio CODEC ADC Data
   inout           AUD_DACLRCK,            //  Audio CODEC DAC LR Clock
   output          AUD_DACDAT,             //  Audio CODEC DAC Data
   inout           AUD_BCLK,               //  Audio CODEC Bit-Stream Clock
   output          AUD_XCK,                //  Audio CODEC Chip Clock
   ////////////////////////    GPIO    ////////////////////////////////
   inout   [35:0]  GPIO_0,                 //  GPIO Connection 0
   inout   [35:0]  GPIO_1                 //  GPIO Connection 1
   );
   
   /***************************************************************************/
   /*****************************END of Board Interface************************/
   /***************************************************************************/
   //  Set all inout ports to tri-state by default
   assign  FL_DQ       =   8'hzz;
   assign  SRAM_DQ     =   16'hzzzz;
   assign  SD_DAT      =   1'bz;
   assign  I2C_SDAT    =   1'bz;
   assign  AUD_ADCLRCK =   1'bz;
   assign  AUD_DACLRCK =   1'bz;
   assign  AUD_BCLK    =   1'bz;

   parameter SIMULATE=0;    // Top level sets to 1 for simulation
   
   wire 	 DLY_RST_0, DLY_RST_1, DLY_RST_2;
   Reset_Delay rd
	 (.iCLK(CLOCK_50),
      .iRST(KEY[0]),
      .oRST_0(DLY_RST_0),
      .oRST_1(DLY_RST_1),
      .oRST_2(DLY_RST_2)
      );
   wire 	 reset = (SIMULATE==0) ? ~DLY_RST_0 : ~KEY[0];
   wire 	 reset_n = ~reset;

   reg [1:0] clkCnt;

   // Generate 12.5 and 25MHz clocks from the 50MHz clock
   generate if (SIMULATE != 0)
	  initial clkCnt = 0;
   endgenerate
   always@(posedge CLOCK_50)  begin
	  clkCnt <=  clkCnt+1;
   end
   wire 	 CLOCK_25 = clkCnt[0];
   wire 	 CLOCK_12_5 = clkCnt[1];

   /***************************************************************************/
   /*****************************END of Standard Logic ************************/
   /***************************************************************************/   

   assign clk = CLOCK_25;
   assign clk2 = CLOCK_50;

   // UART sender
   // 50,000,000 Hz / 115,200 baud rate = 434.028
   // so we need a 9 bit counter.  Thus, the parameters
   // are #(434,9).
   uart_sender #(434,9) sender(
     .clk(clk2),
     .reset(reset),
     .data_to_send(8'd65),
     .data_to_send_ready(1'b1),
     .txd(UART_TXD));

   // Show a test pattern.
   reg [24:0] counter;
   assign LEDG = counter[24:17];

   always @(posedge CLOCK_25) begin
     if (reset) begin
       counter <= 1;
     end else begin
       counter <= counter + 1;
     end
   end
endmodule // de1_d5m
