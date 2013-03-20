// ============================================================================
// Copyright (c) 2011 by Terasic Technologies Inc. 
// ============================================================================
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
//
// ============================================================================
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
// Major Functions/Design Description:
//
//   Please refer to DE4_UserManual.pdf in DE4 system CD.
//
//   
// ============================================================================
// Revision History:
// ============================================================================
//   Ver.: |Author:   |Mod. Date:    |Changes Made:
//   V1.0  |Richard   |07/19/2011    |Init, built by Quartus 11.0 SP1 Build 208
//   V2.0  |Dee Zeng  |2012/02/06    |   Porting to Q11.1SP1
// ============================================================================

//`define USE_DDR2_DIMM2 // When switch : 1.Run Analysis & Synthesis 2.Run Tcl 3.Full Compile

module DE4_DDR2(

	//////// CLOCK //////////
	GCLKIN,
	GCLKOUT_FPGA,
	MAX_CONF_D,
	MAX_PLL_D,
	OSC_50_Bank2,
	OSC_50_Bank3,
	OSC_50_Bank4,
	OSC_50_Bank5,
	OSC_50_Bank6,
	OSC_50_Bank7,
	PLL_CLKIN_p,

	//////// LED x 8 //////////
	LED,

	//////// BUTTON x 4 //////////
	BUTTON,
	CPU_RESET_n,
	EXT_IO,

`ifndef USE_DDR2_DIMM2
	//////// DDR2 SODIMM //////////
	M1_DDR2_addr,
	M1_DDR2_ba,
	M1_DDR2_cas_n,
	M1_DDR2_cke,
	M1_DDR2_clk,
	M1_DDR2_clk_n,
	M1_DDR2_cs_n,
	M1_DDR2_dm,
	M1_DDR2_dq,
	M1_DDR2_dqs,
	M1_DDR2_dqsn,
	M1_DDR2_odt,
	M1_DDR2_ras_n,
	M1_DDR2_SA,
	M1_DDR2_SCL,
	M1_DDR2_SDA,
	M1_DDR2_we_n,
	M1_DDR2_oct_rdn,
	M1_DDR2_oct_rup,
	

`else
	//////// DDR2 SODIMM //////////

	M2_DDR2_addr,
	M2_DDR2_ba,
	M2_DDR2_cas_n,
	M2_DDR2_cke,
	M2_DDR2_clk,
	M2_DDR2_clk_n,
	M2_DDR2_cs_n,
	M2_DDR2_dm,
	M2_DDR2_dq,
	M2_DDR2_dqs,
	M2_DDR2_dqsn,
	M2_DDR2_odt,
	M2_DDR2_ras_n,
	M2_DDR2_SA,
	M2_DDR2_SCL,
	M2_DDR2_SDA,
	M2_DDR2_we_n, 
	M2_DDR2_oct_rdn,
	M2_DDR2_oct_rup		
	
`endif	//USE_DDR2_DIMM2

);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input		          		GCLKIN;
output		        		GCLKOUT_FPGA;
inout		     [2:0]		MAX_CONF_D;
output		  [2:0]		MAX_PLL_D;
input		          		OSC_50_Bank2;
input		          		OSC_50_Bank3;
input		          		OSC_50_Bank4;
input		          		OSC_50_Bank5;
input		          		OSC_50_Bank6;
input		          		OSC_50_Bank7;
input		          		PLL_CLKIN_p;

//////////// LED x 8 //////////
output		  [7:0]		LED;

//////////// BUTTON x 4 //////////
input		     [3:0]		BUTTON;
input		          		CPU_RESET_n;
inout		          		EXT_IO;

`ifndef USE_DDR2_DIMM2
//////////// DDR2 SODIMM //////////
output		    [15:0]		M1_DDR2_addr;
output		     [2:0]		M1_DDR2_ba;
output		          		M1_DDR2_cas_n;
output		     [1:0]		M1_DDR2_cke;
inout		        [1:0]		M1_DDR2_clk;
inout		     	  [1:0]		M1_DDR2_clk_n;
output		     [1:0]		M1_DDR2_cs_n;
output		     [7:0]		M1_DDR2_dm;
inout		    	 [63:0]		M1_DDR2_dq;
inout		     	  [7:0]		M1_DDR2_dqs;
inout		    	  [7:0]		M1_DDR2_dqsn;
output		     [1:0]		M1_DDR2_odt;
output		          		M1_DDR2_ras_n;
output		     [1:0]		M1_DDR2_SA;
output		          		M1_DDR2_SCL;
inout		      	    		M1_DDR2_SDA;
output		          		M1_DDR2_we_n;
input                      M1_DDR2_oct_rdn;
input                      M1_DDR2_oct_rup;

`else
//////////// DDR2 SODIMM //////////
output		    [15:0]		M2_DDR2_addr;
output		     [2:0]		M2_DDR2_ba;
output		          		M2_DDR2_cas_n;
output		     [1:0]		M2_DDR2_cke;
inout			     [1:0]		M2_DDR2_clk;
inout		   	  [1:0]		M2_DDR2_clk_n;
output		     [1:0]		M2_DDR2_cs_n;
output		     [7:0]		M2_DDR2_dm;
inout		 	 	 [63:0]		M2_DDR2_dq;
inout		 		  [7:0]		M2_DDR2_dqs;
inout		    	  [7:0]		M2_DDR2_dqsn;
output		     [1:0]		M2_DDR2_odt;
output		          		M2_DDR2_ras_n;
output		     [1:0]		M2_DDR2_SA;
output		          		M2_DDR2_SCL;
inout		       	   		M2_DDR2_SDA;
output		          		M2_DDR2_we_n;
input                      M2_DDR2_oct_rdn;
input                      M2_DDR2_oct_rup;

`endif //`ifndef USE_DDR2_DIMM2

//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

wire reset_n;
assign reset_n = CPU_RESET_n;


    DE4_QSYS u0 (
        .reset_reset_n                                      (reset_n), 
		  
`ifndef USE_DDR2_DIMM2		  
        .clk_clk                                            (OSC_50_Bank3), 
		  
        .memory_mem_a                                       (M1_DDR2_addr),
        .memory_mem_ba                                      (M1_DDR2_ba),
        .memory_mem_ck                                      (M1_DDR2_clk),
        .memory_mem_ck_n                                    (M1_DDR2_clk_n),
        .memory_mem_cke                                     (M1_DDR2_cke),
        .memory_mem_cs_n                                    (M1_DDR2_cs_n),
        .memory_mem_dm                                      (M1_DDR2_dm),
        .memory_mem_ras_n                                   (M1_DDR2_ras_n), 
        .memory_mem_cas_n                                   (M1_DDR2_cas_n),
        .memory_mem_we_n                                    (M1_DDR2_we_n),
        .memory_mem_dq                                      (M1_DDR2_dq),
        .memory_mem_dqs                                     (M1_DDR2_dqs),
        .memory_mem_dqs_n                                   (M1_DDR2_dqsn),
        .memory_mem_odt                                     (M1_DDR2_odt),
        .oct_rdn                                            (M1_DDR2_oct_rdn),
        .oct_rup                                            (M1_DDR2_oct_rup), 
		  
        .ddr2_i2c_scl_export                                (M1_DDR2_SCL),
        .ddr2_i2c_sda_export                                (M1_DDR2_SDA),		  
`else
        .clk_clk                                            (OSC_50_Bank4),
		  
        .memory_mem_a                                       (M2_DDR2_addr),
        .memory_mem_ba                                      (M2_DDR2_ba),
        .memory_mem_ck                                      (M2_DDR2_clk), 
        .memory_mem_ck_n                                    (M2_DDR2_clk_n),
        .memory_mem_cke                                     (M2_DDR2_cke),
        .memory_mem_cs_n                                    (M2_DDR2_cs_n),
        .memory_mem_dm                                      (M2_DDR2_dm), 
        .memory_mem_ras_n                                   (M2_DDR2_ras_n),
        .memory_mem_cas_n                                   (M2_DDR2_cas_n),
        .memory_mem_we_n                                    (M2_DDR2_we_n), 
        .memory_mem_dq                                      (M2_DDR2_dq), 
        .memory_mem_dqs                                     (M2_DDR2_dqs),
        .memory_mem_dqs_n                                   (M2_DDR2_dqsn),
        .memory_mem_odt                                     (M2_DDR2_odt), 
        .oct_rdn                                            (M2_DDR2_oct_rdn), 
        .oct_rup                                            (M2_DDR2_oct_rup),
		  
        .ddr2_i2c_scl_export                                (M2_DDR2_SCL), 
        .ddr2_i2c_sda_export                                (M2_DDR2_SDA),    		  
`endif	  
        .led_export                                         (LED),
        .button_export                                      (BUTTON)   		  
    );

	 
endmodule
	 