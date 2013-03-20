//altlvds_rx BUFFER_IMPLEMENTATION="RAM" CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" COMMON_RX_TX_PLL="OFF" CYCLONEII_M4K_COMPATIBILITY="ON" DATA_ALIGN_ROLLOVER=10 DATA_RATE="480.0 Mbps" DESERIALIZATION_FACTOR=10 DEVICE_FAMILY="Stratix IV" DPA_INITIAL_PHASE_VALUE=0 DPLL_LOCK_COUNT=0 DPLL_LOCK_WINDOW=0 ENABLE_DPA_ALIGN_TO_RISING_EDGE_ONLY="OFF" ENABLE_DPA_CALIBRATION="ON" ENABLE_DPA_INITIAL_PHASE_SELECTION="OFF" ENABLE_DPA_MODE="OFF" ENABLE_DPA_PLL_CALIBRATION="OFF" ENABLE_SOFT_CDR_MODE="OFF" IMPLEMENT_IN_LES="OFF" INCLOCK_BOOST=0 INCLOCK_DATA_ALIGNMENT="EDGE_ALIGNED" INCLOCK_PERIOD=4167 INCLOCK_PHASE_SHIFT=0 INPUT_DATA_RATE=480 NUMBER_OF_CHANNELS=5 OUTCLOCK_RESOURCE="AUTO" PORT_RX_CHANNEL_DATA_ALIGN="PORT_USED" PORT_RX_DATA_ALIGN="PORT_UNUSED" REGISTERED_OUTPUT="ON" RX_ALIGN_DATA_REG="RISING_EDGE" SIM_DPA_IS_NEGATIVE_PPM_DRIFT="OFF" SIM_DPA_NET_PPM_VARIATION=0 SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT=0 STRATIXIV_DPA_COMPATIBILITY="OFF" USE_CORECLOCK_INPUT="OFF" USE_DPLL_RAWPERROR="OFF" USE_EXTERNAL_PLL="OFF" USE_NO_PHASE_SHIFT="ON" X_ON_BITSLIP="ON" rx_channel_data_align rx_in rx_inclock rx_out rx_outclock ACF_BLOCK_RAM_AND_MLAB_EQUIVALENT_PAUSED_READ_CAPABILITIES="CARE" CARRY_CHAIN="MANUAL" CARRY_CHAIN_LENGTH=48 LOW_POWER_MODE="AUTO" ALTERA_INTERNAL_OPTIONS=AUTO_SHIFT_REGISTER_RECOGNITION=OFF
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

//synthesis_resources = clkctrl 1 lut 1 reg 50 stratixiv_lvds_receiver 5 stratixiv_pll 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"AUTO_SHIFT_REGISTER_RECOGNITION=OFF;REMOVE_DUPLICATE_REGISTERS=OFF;{-to ground_lcell1} ADV_NETLIST_OPT_ALLOWED = NEVER_ALLOW;{-to ground_lcell1} IGNORE_LCELL_BUFFERS = OFF;{-to ground_lcell1} REMOVE_REDUNDANT_LOGIC_CELLS = OFF;{-to pll} AUTO_MERGE_PLLS=OFF;-name SOURCE_MULTICYCLE 10 -from wire_rx_dataout* -to rxreg*;-name SOURCE_MULTICYCLE_HOLD 10 -from wire_rx_dataout* -to rxreg*"} *)
module  lvdsrx_lvds_rx
	( 
	rx_channel_data_align,
	rx_in,
	rx_inclock,
	rx_out,
	rx_outclock) /* synthesis synthesis_clearbox=1 */;
	input   [4:0]  rx_channel_data_align;
	input   [4:0]  rx_in;
	input   rx_inclock;
	output   [49:0]  rx_out;
	output   rx_outclock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [4:0]  rx_channel_data_align;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  wire_rx_outclock_buf_outclk;
	(* ALTERA_ATTRIBUTE = {"PRESERVE_REGISTER=ON"} *)
	reg	[49:0]	rxreg;
	wire  wire_ground_lcell1_out;
	wire  [4:0]   wire_rx_bitslip;
	wire  [4:0]   wire_rx_clk0;
	wire  [4:0]   wire_rx_datain;
	wire  [49:0]   wire_rx_dataout;
	wire  [4:0]   wire_rx_enable0;
	wire  [9:0]   wire_pll_clk;
	wire  wire_pll_fbout;
	wire  wire_pll_locked;
	wire  outclock;
	wire pll_areset;

	lvdsrx_altclkctrl   rx_outclock_buf
	( 
	.inclk({{3{1'b0}}, wire_pll_clk[2]}),
	.outclk(wire_rx_outclock_buf_outclk));
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
	assign
		wire_rx_bitslip = rx_channel_data_align,
		wire_rx_clk0 = {5{wire_pll_clk[0]}},
		wire_rx_datain = rx_in,
		wire_rx_enable0 = {5{wire_pll_clk[1]}};
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
		pll.clk0_phase_shift = "-1041",
		pll.clk1_divide_by = 10,
		pll.clk1_duty_cycle = 10,
		pll.clk1_multiply_by = 2,
		pll.clk1_phase_shift = "16656",
		pll.clk2_divide_by = 10,
		pll.clk2_multiply_by = 2,
		pll.clk2_phase_shift = "-1041",
		pll.compensate_clock = "lvdsclk",
		pll.inclk0_input_frequency = 4167,
		pll.operation_mode = "source_synchronous",
		pll.pll_type = "fast",
		pll.lpm_type = "stratixiv_pll";
	assign
		outclock = wire_rx_outclock_buf_outclk,
		pll_areset = 1'b0,
		rx_out = rxreg,
		rx_outclock = outclock;
endmodule //lvdsrx_lvds_rx
//VALID FILE
