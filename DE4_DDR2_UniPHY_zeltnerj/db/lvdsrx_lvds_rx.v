//altlvds_rx BUFFER_IMPLEMENTATION="RAM" CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" COMMON_RX_TX_PLL="OFF" CYCLONEII_M4K_COMPATIBILITY="ON" DATA_ALIGN_ROLLOVER=10 DATA_RATE="100.0 Mbps" DESERIALIZATION_FACTOR=10 DEVICE_FAMILY="Stratix IV" DPA_INITIAL_PHASE_VALUE=0 DPLL_LOCK_COUNT=0 DPLL_LOCK_WINDOW=0 ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY="OFF" ENABLE_DPA_CALIBRATION="ON" ENABLE_DPA_INITIAL_PHASE_SELECTION="OFF" ENABLE_DPA_MODE="OFF" ENABLE_DPA_PLL_CALIBRATION="OFF" ENABLE_SOFT_CDR_MODE="OFF" IMPLEMENT_IN_LES="OFF" INCLOCK_BOOST=0 INCLOCK_DATA_ALIGNMENT="EDGE_ALIGNED" INCLOCK_PERIOD=20000 INCLOCK_PHASE_SHIFT=0 INPUT_DATA_RATE=100 NUMBER_OF_CHANNELS=18 OUTCLOCK_RESOURCE="AUTO" PORT_RX_CHANNEL_DATA_ALIGN="PORT_USED" PORT_RX_DATA_ALIGN="PORT_UNUSED" REGISTERED_OUTPUT="ON" RX_ALIGN_DATA_REG="RISING_EDGE" SIM_DPA_IS_NEGATIVE_PPM_DRIFT="OFF" SIM_DPA_NET_PPM_VARIATION=0 SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT=0 STRATIXIV_DPA_COMPATIBILITY="OFF" USE_CORECLOCK_INPUT="OFF" USE_DPLL_RAWPERROR="OFF" USE_EXTERNAL_PLL="OFF" USE_NO_PHASE_SHIFT="ON" X_ON_BITSLIP="ON" pll_areset rx_channel_data_align rx_in rx_inclock rx_out rx_outclock ACF_BLOCK_RAM_AND_MLAB_EQUIVALENT_PAUSED_READ_CAPABILITIES="CARE" CARRY_CHAIN="MANUAL" CARRY_CHAIN_LENGTH=48 LOW_POWER_MODE="AUTO" ALTERA_INTERNAL_OPTIONS=AUTO_SHIFT_REGISTER_RECOGNITION=OFF
//VERSION_BEGIN 12.1SP1 cbx_altaccumulate 2013:01:31:18:04:58:SJ cbx_altclkbuf 2013:01:31:18:04:58:SJ cbx_altddio_in 2013:01:31:18:04:58:SJ cbx_altddio_out 2013:01:31:18:04:58:SJ cbx_altiobuf_bidir 2013:01:31:18:04:58:SJ cbx_altiobuf_in 2013:01:31:18:04:58:SJ cbx_altiobuf_out 2013:01:31:18:04:58:SJ cbx_altlvds_rx 2013:01:31:18:04:58:SJ cbx_altpll 2013:01:31:18:04:59:SJ cbx_altsyncram 2013:01:31:18:04:59:SJ cbx_arriav 2013:01:31:18:04:59:SJ cbx_cyclone 2013:01:31:18:04:59:SJ cbx_cycloneii 2013:01:31:18:04:59:SJ cbx_lpm_add_sub 2013:01:31:18:04:59:SJ cbx_lpm_compare 2013:01:31:18:04:59:SJ cbx_lpm_counter 2013:01:31:18:04:59:SJ cbx_lpm_decode 2013:01:31:18:04:59:SJ cbx_lpm_mux 2013:01:31:18:04:59:SJ cbx_lpm_shiftreg 2013:01:31:18:04:59:SJ cbx_maxii 2013:01:31:18:04:59:SJ cbx_mgl 2013:01:31:18:08:27:SJ cbx_stratix 2013:01:31:18:04:59:SJ cbx_stratixii 2013:01:31:18:04:59:SJ cbx_stratixiii 2013:01:31:18:05:00:SJ cbx_stratixv 2013:01:31:18:05:00:SJ cbx_util_mgl 2013:01:31:18:04:59:SJ  VERSION_END
//CBXI_INSTANCE_NAME="cmv4000design_lvdsrx_inst7_altlvds_rx_ALTLVDS_RX_component"
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2012 Altera Corporation
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, Altera MegaCore Function License 
//  Agreement, or other applicable license agreement, including, 
//  without limitation, that your use is for the sole purpose of 
//  programming logic devices manufactured by Altera and sold by 
//  Altera or its authorized distributors.  Please refer to the 
//  applicable agreement for further details.




//altclkctrl CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" CLOCK_TYPE="AUTO" DEVICE_FAMILY="Stratix IV" inclk outclk
//VERSION_BEGIN 12.1SP1 cbx_altclkbuf 2013:01:31:18:04:58:SJ cbx_cycloneii 2013:01:31:18:04:59:SJ cbx_lpm_add_sub 2013:01:31:18:04:59:SJ cbx_lpm_compare 2013:01:31:18:04:59:SJ cbx_lpm_decode 2013:01:31:18:04:59:SJ cbx_lpm_mux 2013:01:31:18:04:59:SJ cbx_mgl 2013:01:31:18:08:27:SJ cbx_stratix 2013:01:31:18:04:59:SJ cbx_stratixii 2013:01:31:18:04:59:SJ cbx_stratixiii 2013:01:31:18:05:00:SJ cbx_stratixv 2013:01:31:18:05:00:SJ  VERSION_END

//synthesis_resources = clkctrl 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  lvdsrx_altclkctrl
	( 
	inclk,
	outclk) /* synthesis synthesis_clearbox=1 */;
	input   [3:0]  inclk;
	output   outclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [3:0]  inclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  wire_sd4_outclk;
	wire [1:0]  clkselect;
	wire ena;

	stratixiv_clkena   sd4
	( 
	.ena(ena),
	.enaout(),
	.inclk(inclk[0]),
	.outclk(wire_sd4_outclk)
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		sd4.clock_type = "AUTO",
		sd4.ena_register_mode = "falling edge",
		sd4.lpm_type = "stratixiv_clkena";
	assign
		clkselect = {2{1'b0}},
		ena = 1'b1,
		outclk = wire_sd4_outclk;
endmodule //lvdsrx_altclkctrl

//synthesis_resources = clkctrl 1 lut 1 reg 181 stratixiv_lvds_receiver 18 stratixiv_pll 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"AUTO_SHIFT_REGISTER_RECOGNITION=OFF;REMOVE_DUPLICATE_REGISTERS=OFF;SUPPRESS_DA_RULE_INTERNAL=C104;{-to ground_lcell1} ADV_NETLIST_OPT_ALLOWED = NEVER_ALLOW;{-to ground_lcell1} IGNORE_LCELL_BUFFERS = OFF;{-to ground_lcell1} REMOVE_REDUNDANT_LOGIC_CELLS = OFF;{-to pll} AUTO_MERGE_PLLS=OFF;-name SOURCE_MULTICYCLE 10 -from wire_rx_dataout* -to rxreg*;-name SOURCE_MULTICYCLE_HOLD 10 -from wire_rx_dataout* -to rxreg*"} *)
module  lvdsrx_lvds_rx
	( 
	pll_areset,
	rx_channel_data_align,
	rx_in,
	rx_inclock,
	rx_out,
	rx_outclock) /* synthesis synthesis_clearbox=1 */;
	input   pll_areset;
	input   [17:0]  rx_channel_data_align;
	input   [17:0]  rx_in;
	input   rx_inclock;
	output   [179:0]  rx_out;
	output   rx_outclock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   pll_areset;
	tri0   [17:0]  rx_channel_data_align;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  wire_rx_outclock_buf_outclk;
	reg	pll_lock_sync;
	(* ALTERA_ATTRIBUTE = {"PRESERVE_REGISTER=ON"} *)
	reg	[179:0]	rxreg;
	wire  wire_ground_lcell1_out;
	wire  [17:0]   wire_rx_bitslip;
	wire  [17:0]   wire_rx_clk0;
	wire  [17:0]   wire_rx_datain;
	wire  [179:0]   wire_rx_dataout;
	wire  [17:0]   wire_rx_enable0;
	wire  [9:0]   wire_pll_clk;
	wire  wire_pll_fbout;
	wire  wire_pll_locked;
	wire  outclock;

	lvdsrx_altclkctrl   rx_outclock_buf
	( 
	.inclk({{3{1'b0}}, wire_pll_clk[2]}),
	.outclk(wire_rx_outclock_buf_outclk));
	// synopsys translate_off
	initial
		pll_lock_sync = 0;
	// synopsys translate_on
	always @ ( posedge wire_pll_locked or  posedge pll_areset)
		if (pll_areset == 1'b1) pll_lock_sync <= 1'b0;
		else  pll_lock_sync <= 1'b1;
	// synopsys translate_off
	initial
		rxreg = 0;
	// synopsys translate_on
	always @ ( posedge outclock)
		  rxreg <= wire_rx_dataout;
	lcell   ground_lcell1
	( 
	.in(1'b0),
	.out(wire_ground_lcell1_out));
	stratixiv_lvds_receiver   rx_0
	( 
	.bitslip(wire_rx_bitslip[0:0]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[0:0]),
	.datain(wire_rx_datain[0:0]),
	.dataout(wire_rx_dataout[9:0]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[0:0]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_0.align_to_rising_edge_only = "on",
		rx_0.channel_width = 10,
		rx_0.data_align_rollover = 10,
		rx_0.enable_dpa = "off",
		rx_0.x_on_bitslip = "on",
		rx_0.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_1
	( 
	.bitslip(wire_rx_bitslip[1:1]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[1:1]),
	.datain(wire_rx_datain[1:1]),
	.dataout(wire_rx_dataout[19:10]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[1:1]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_1.align_to_rising_edge_only = "on",
		rx_1.channel_width = 10,
		rx_1.data_align_rollover = 10,
		rx_1.enable_dpa = "off",
		rx_1.x_on_bitslip = "on",
		rx_1.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_2
	( 
	.bitslip(wire_rx_bitslip[2:2]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[2:2]),
	.datain(wire_rx_datain[2:2]),
	.dataout(wire_rx_dataout[29:20]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[2:2]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_2.align_to_rising_edge_only = "on",
		rx_2.channel_width = 10,
		rx_2.data_align_rollover = 10,
		rx_2.enable_dpa = "off",
		rx_2.x_on_bitslip = "on",
		rx_2.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_3
	( 
	.bitslip(wire_rx_bitslip[3:3]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[3:3]),
	.datain(wire_rx_datain[3:3]),
	.dataout(wire_rx_dataout[39:30]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[3:3]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_3.align_to_rising_edge_only = "on",
		rx_3.channel_width = 10,
		rx_3.data_align_rollover = 10,
		rx_3.enable_dpa = "off",
		rx_3.x_on_bitslip = "on",
		rx_3.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_4
	( 
	.bitslip(wire_rx_bitslip[4:4]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[4:4]),
	.datain(wire_rx_datain[4:4]),
	.dataout(wire_rx_dataout[49:40]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[4:4]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_4.align_to_rising_edge_only = "on",
		rx_4.channel_width = 10,
		rx_4.data_align_rollover = 10,
		rx_4.enable_dpa = "off",
		rx_4.x_on_bitslip = "on",
		rx_4.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_5
	( 
	.bitslip(wire_rx_bitslip[5:5]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[5:5]),
	.datain(wire_rx_datain[5:5]),
	.dataout(wire_rx_dataout[59:50]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[5:5]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_5.align_to_rising_edge_only = "on",
		rx_5.channel_width = 10,
		rx_5.data_align_rollover = 10,
		rx_5.enable_dpa = "off",
		rx_5.x_on_bitslip = "on",
		rx_5.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_6
	( 
	.bitslip(wire_rx_bitslip[6:6]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[6:6]),
	.datain(wire_rx_datain[6:6]),
	.dataout(wire_rx_dataout[69:60]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[6:6]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_6.align_to_rising_edge_only = "on",
		rx_6.channel_width = 10,
		rx_6.data_align_rollover = 10,
		rx_6.enable_dpa = "off",
		rx_6.x_on_bitslip = "on",
		rx_6.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_7
	( 
	.bitslip(wire_rx_bitslip[7:7]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[7:7]),
	.datain(wire_rx_datain[7:7]),
	.dataout(wire_rx_dataout[79:70]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[7:7]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_7.align_to_rising_edge_only = "on",
		rx_7.channel_width = 10,
		rx_7.data_align_rollover = 10,
		rx_7.enable_dpa = "off",
		rx_7.x_on_bitslip = "on",
		rx_7.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_8
	( 
	.bitslip(wire_rx_bitslip[8:8]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[8:8]),
	.datain(wire_rx_datain[8:8]),
	.dataout(wire_rx_dataout[89:80]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[8:8]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_8.align_to_rising_edge_only = "on",
		rx_8.channel_width = 10,
		rx_8.data_align_rollover = 10,
		rx_8.enable_dpa = "off",
		rx_8.x_on_bitslip = "on",
		rx_8.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_9
	( 
	.bitslip(wire_rx_bitslip[9:9]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[9:9]),
	.datain(wire_rx_datain[9:9]),
	.dataout(wire_rx_dataout[99:90]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[9:9]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_9.align_to_rising_edge_only = "on",
		rx_9.channel_width = 10,
		rx_9.data_align_rollover = 10,
		rx_9.enable_dpa = "off",
		rx_9.x_on_bitslip = "on",
		rx_9.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_10
	( 
	.bitslip(wire_rx_bitslip[10:10]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[10:10]),
	.datain(wire_rx_datain[10:10]),
	.dataout(wire_rx_dataout[109:100]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[10:10]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_10.align_to_rising_edge_only = "on",
		rx_10.channel_width = 10,
		rx_10.data_align_rollover = 10,
		rx_10.enable_dpa = "off",
		rx_10.x_on_bitslip = "on",
		rx_10.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_11
	( 
	.bitslip(wire_rx_bitslip[11:11]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[11:11]),
	.datain(wire_rx_datain[11:11]),
	.dataout(wire_rx_dataout[119:110]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[11:11]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_11.align_to_rising_edge_only = "on",
		rx_11.channel_width = 10,
		rx_11.data_align_rollover = 10,
		rx_11.enable_dpa = "off",
		rx_11.x_on_bitslip = "on",
		rx_11.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_12
	( 
	.bitslip(wire_rx_bitslip[12:12]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[12:12]),
	.datain(wire_rx_datain[12:12]),
	.dataout(wire_rx_dataout[129:120]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[12:12]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_12.align_to_rising_edge_only = "on",
		rx_12.channel_width = 10,
		rx_12.data_align_rollover = 10,
		rx_12.enable_dpa = "off",
		rx_12.x_on_bitslip = "on",
		rx_12.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_13
	( 
	.bitslip(wire_rx_bitslip[13:13]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[13:13]),
	.datain(wire_rx_datain[13:13]),
	.dataout(wire_rx_dataout[139:130]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[13:13]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_13.align_to_rising_edge_only = "on",
		rx_13.channel_width = 10,
		rx_13.data_align_rollover = 10,
		rx_13.enable_dpa = "off",
		rx_13.x_on_bitslip = "on",
		rx_13.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_14
	( 
	.bitslip(wire_rx_bitslip[14:14]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[14:14]),
	.datain(wire_rx_datain[14:14]),
	.dataout(wire_rx_dataout[149:140]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[14:14]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_14.align_to_rising_edge_only = "on",
		rx_14.channel_width = 10,
		rx_14.data_align_rollover = 10,
		rx_14.enable_dpa = "off",
		rx_14.x_on_bitslip = "on",
		rx_14.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_15
	( 
	.bitslip(wire_rx_bitslip[15:15]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[15:15]),
	.datain(wire_rx_datain[15:15]),
	.dataout(wire_rx_dataout[159:150]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[15:15]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_15.align_to_rising_edge_only = "on",
		rx_15.channel_width = 10,
		rx_15.data_align_rollover = 10,
		rx_15.enable_dpa = "off",
		rx_15.x_on_bitslip = "on",
		rx_15.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_16
	( 
	.bitslip(wire_rx_bitslip[16:16]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[16:16]),
	.datain(wire_rx_datain[16:16]),
	.dataout(wire_rx_dataout[169:160]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[16:16]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_16.align_to_rising_edge_only = "on",
		rx_16.channel_width = 10,
		rx_16.data_align_rollover = 10,
		rx_16.enable_dpa = "off",
		rx_16.x_on_bitslip = "on",
		rx_16.lpm_type = "stratixiv_lvds_receiver";
	stratixiv_lvds_receiver   rx_17
	( 
	.bitslip(wire_rx_bitslip[17:17]),
	.bitslipmax(),
	.clk0(wire_rx_clk0[17:17]),
	.datain(wire_rx_datain[17:17]),
	.dataout(wire_rx_dataout[179:170]),
	.divfwdclk(),
	.dpaclkout(),
	.dpalock(),
	.dpaswitch(wire_ground_lcell1_out),
	.enable0(wire_rx_enable0[17:17]),
	.postdpaserialdataout(),
	.serialdataout()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bitslipreset(1'b0),
	.dpahold(1'b0),
	.dpareset(1'b0),
	.fiforeset(1'b0),
	.serialfbk(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		rx_17.align_to_rising_edge_only = "on",
		rx_17.channel_width = 10,
		rx_17.data_align_rollover = 10,
		rx_17.enable_dpa = "off",
		rx_17.x_on_bitslip = "on",
		rx_17.lpm_type = "stratixiv_lvds_receiver";
	assign
		wire_rx_bitslip = rx_channel_data_align,
		wire_rx_clk0 = {18{wire_pll_clk[0]}},
		wire_rx_datain = rx_in,
		wire_rx_enable0 = {18{wire_pll_clk[1]}};
	stratixiv_pll   pll
	( 
	.activeclock(),
	.areset(pll_areset),
	.clk(wire_pll_clk),
	.clkbad(),
	.fbin(wire_pll_fbout),
	.fbout(wire_pll_fbout),
	.inclk({{1{1'b0}}, rx_inclock}),
	.locked(wire_pll_locked),
	.phasedone(),
	.scandataout(),
	.scandone(),
	.vcooverrange(),
	.vcounderrange()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clkswitch(1'b0),
	.configupdate(1'b0),
	.pfdena(1'b1),
	.phasecounterselect({4{1'b0}}),
	.phasestep(1'b0),
	.phaseupdown(1'b0),
	.scanclk(1'b0),
	.scanclkena(1'b1),
	.scandata(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		pll.clk0_divide_by = 1,
		pll.clk0_multiply_by = 2,
		pll.clk0_phase_shift = "-5000",
		pll.clk1_divide_by = 10,
		pll.clk1_duty_cycle = 10,
		pll.clk1_multiply_by = 2,
		pll.clk1_phase_shift = "80000",
		pll.clk2_divide_by = 10,
		pll.clk2_multiply_by = 2,
		pll.clk2_phase_shift = "-5000",
		pll.compensate_clock = "lvdsclk",
		pll.inclk0_input_frequency = 20000,
		pll.operation_mode = "source_synchronous",
		pll.pll_type = "fast",
		pll.lpm_type = "stratixiv_pll";
	assign
		outclock = wire_rx_outclock_buf_outclk,
		rx_out = rxreg,
		rx_outclock = outclock;
endmodule //lvdsrx_lvds_rx
//VALID FILE
