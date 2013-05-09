// DE4_QSYS_mem_if_ddr2_emif.v

// This file was auto-generated from alt_mem_if_ddr2_emif_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 12.1sp1 243 at 2013.05.09.18:02:11

`timescale 1 ps / 1 ps
module DE4_QSYS_mem_if_ddr2_emif (
		input  wire         pll_ref_clk,       //  pll_ref_clk.clk
		input  wire         global_reset_n,    // global_reset.reset_n
		input  wire         soft_reset_n,      //   soft_reset.reset_n
		output wire         afi_clk,           //      afi_clk.clk
		output wire         afi_half_clk,      // afi_half_clk.clk
		output wire         afi_reset_n,       //    afi_reset.reset_n
		output wire [13:0]  mem_a,             //       memory.mem_a
		output wire [2:0]   mem_ba,            //             .mem_ba
		output wire [1:0]   mem_ck,            //             .mem_ck
		output wire [1:0]   mem_ck_n,          //             .mem_ck_n
		output wire [0:0]   mem_cke,           //             .mem_cke
		output wire [0:0]   mem_cs_n,          //             .mem_cs_n
		output wire [7:0]   mem_dm,            //             .mem_dm
		output wire [0:0]   mem_ras_n,         //             .mem_ras_n
		output wire [0:0]   mem_cas_n,         //             .mem_cas_n
		output wire [0:0]   mem_we_n,          //             .mem_we_n
		inout  wire [63:0]  mem_dq,            //             .mem_dq
		inout  wire [7:0]   mem_dqs,           //             .mem_dqs
		inout  wire [7:0]   mem_dqs_n,         //             .mem_dqs_n
		output wire [0:0]   mem_odt,           //             .mem_odt
		output wire         avl_ready,         //          avl.waitrequest_n
		input  wire         avl_burstbegin,    //             .beginbursttransfer
		input  wire [24:0]  avl_addr,          //             .address
		output wire         avl_rdata_valid,   //             .readdatavalid
		output wire [255:0] avl_rdata,         //             .readdata
		input  wire [255:0] avl_wdata,         //             .writedata
		input  wire [31:0]  avl_be,            //             .byteenable
		input  wire         avl_read_req,      //             .read
		input  wire         avl_write_req,     //             .write
		input  wire [7:0]   avl_size,          //             .burstcount
		output wire         local_init_done,   //       status.local_init_done
		output wire         local_cal_success, //             .local_cal_success
		output wire         local_cal_fail,    //             .local_cal_fail
		input  wire         oct_rdn,           //          oct.rdn
		input  wire         oct_rup            //             .rup
	);

	wire          p0_addr_cmd_clk_clk;                         // p0:addr_cmd_clk -> m0:clk
	wire   [27:0] m0_phy_mux_afi_addr;                         // m0:phy_mux_addr -> p0:afi_addr
	wire    [1:0] m0_phy_mux_afi_odt;                          // m0:phy_mux_odt -> p0:afi_odt
	wire    [5:0] p0_afi_afi_wlat;                             // p0:afi_wlat -> m0:phy_mux_wlat
	wire    [1:0] p0_afi_afi_rdata_valid;                      // p0:afi_rdata_valid -> m0:phy_mux_rdata_valid
	wire    [1:0] m0_phy_mux_afi_rdata_en_full;                // m0:phy_mux_rdata_en_full -> p0:afi_rdata_en_full
	wire    [1:0] m0_phy_mux_afi_we_n;                         // m0:phy_mux_we_n -> p0:afi_we_n
	wire    [5:0] m0_phy_mux_afi_ba;                           // m0:phy_mux_ba -> p0:afi_ba
	wire    [1:0] m0_phy_mux_afi_cke;                          // m0:phy_mux_cke -> p0:afi_cke
	wire    [1:0] m0_phy_mux_afi_cs_n;                         // m0:phy_mux_cs_n -> p0:afi_cs_n
	wire  [255:0] m0_phy_mux_afi_wdata;                        // m0:phy_mux_wdata -> p0:afi_wdata
	wire    [1:0] m0_phy_mux_afi_rdata_en;                     // m0:phy_mux_rdata_en -> p0:afi_rdata_en
	wire    [1:0] m0_phy_mux_afi_cas_n;                        // m0:phy_mux_cas_n -> p0:afi_cas_n
	wire          p0_afi_afi_cal_success;                      // p0:afi_cal_success -> m0:phy_mux_cal_success
	wire    [1:0] m0_phy_mux_afi_ras_n;                        // m0:phy_mux_ras_n -> p0:afi_ras_n
	wire    [5:0] p0_afi_afi_rlat;                             // p0:afi_rlat -> m0:phy_mux_rlat
	wire  [255:0] p0_afi_afi_rdata;                            // p0:afi_rdata -> m0:phy_mux_rdata
	wire          p0_afi_afi_cal_fail;                         // p0:afi_cal_fail -> m0:phy_mux_cal_fail
	wire   [15:0] m0_phy_mux_afi_wdata_valid;                  // m0:phy_mux_wdata_valid -> p0:afi_wdata_valid
	wire   [15:0] m0_phy_mux_afi_dqs_burst;                    // m0:phy_mux_dqs_burst -> p0:afi_dqs_burst
	wire   [31:0] m0_phy_mux_afi_dm;                           // m0:phy_mux_dm -> p0:afi_dm
	wire    [5:0] m0_afi_afi_wlat;                             // m0:afi_wlat -> c0:afi_wlat
	wire    [1:0] m0_afi_afi_rdata_valid;                      // m0:afi_rdata_valid -> c0:afi_rdata_valid
	wire          m0_afi_afi_cal_success;                      // m0:afi_cal_success -> c0:afi_cal_success
	wire    [5:0] m0_afi_afi_rlat;                             // m0:afi_rlat -> c0:afi_rlat
	wire  [255:0] m0_afi_afi_rdata;                            // m0:afi_rdata -> c0:afi_rdata
	wire          m0_afi_afi_cal_fail;                         // m0:afi_cal_fail -> c0:afi_cal_fail
	wire          p0_avl_clk_clk;                              // p0:avl_clk -> s0:avl_clk
	wire          p0_avl_reset_reset;                          // p0:avl_reset_n -> s0:avl_reset_n
	wire          p0_scc_clk_clk;                              // p0:scc_clk -> s0:scc_clk
	wire          p0_scc_reset_reset;                          // p0:scc_reset_n -> s0:reset_n_scc_clk
	wire   [27:0] s0_afi_afi_addr;                             // s0:afi_addr -> m0:seq_mux_addr
	wire    [1:0] s0_afi_afi_odt;                              // s0:afi_odt -> m0:seq_mux_odt
	wire    [1:0] m0_seq_mux_afi_rdata_valid;                  // m0:seq_mux_rdata_valid -> s0:afi_rdata_valid
	wire    [1:0] s0_afi_afi_rdata_en_full;                    // s0:afi_rdata_en_full -> m0:seq_mux_rdata_en_full
	wire    [1:0] s0_afi_afi_we_n;                             // s0:afi_we_n -> m0:seq_mux_we_n
	wire    [5:0] s0_afi_afi_ba;                               // s0:afi_ba -> m0:seq_mux_ba
	wire    [1:0] s0_afi_afi_cke;                              // s0:afi_cke -> m0:seq_mux_cke
	wire    [1:0] s0_afi_afi_cs_n;                             // s0:afi_cs_n -> m0:seq_mux_cs_n
	wire  [255:0] s0_afi_afi_wdata;                            // s0:afi_wdata -> m0:seq_mux_wdata
	wire    [1:0] s0_afi_afi_rdata_en;                         // s0:afi_rdata_en -> m0:seq_mux_rdata_en
	wire    [1:0] s0_afi_afi_cas_n;                            // s0:afi_cas_n -> m0:seq_mux_cas_n
	wire    [1:0] s0_afi_afi_ras_n;                            // s0:afi_ras_n -> m0:seq_mux_ras_n
	wire  [255:0] m0_seq_mux_afi_rdata;                        // m0:seq_mux_rdata -> s0:afi_rdata
	wire   [15:0] s0_afi_afi_wdata_valid;                      // s0:afi_wdata_valid -> m0:seq_mux_wdata_valid
	wire   [15:0] s0_afi_afi_dqs_burst;                        // s0:afi_dqs_burst -> m0:seq_mux_dqs_burst
	wire   [31:0] s0_afi_afi_dm;                               // s0:afi_dm -> m0:seq_mux_dm
	wire          s0_mux_sel_mux_sel;                          // s0:phy_mux_sel -> m0:mux_sel
	wire          s0_phy_phy_cal_success;                      // s0:phy_cal_success -> p0:phy_cal_success
	wire          p0_phy_phy_reset_n;                          // p0:phy_reset_n -> s0:phy_reset_n
	wire          s0_phy_phy_cal_fail;                         // s0:phy_cal_fail -> p0:phy_cal_fail
	wire    [7:0] s0_phy_phy_read_increment_vfifo_qr;          // s0:phy_read_increment_vfifo_qr -> p0:phy_read_increment_vfifo_qr
	wire          p0_phy_phy_clk;                              // p0:phy_clk -> s0:phy_clk
	wire    [5:0] s0_phy_phy_afi_rlat;                         // s0:phy_afi_rlat -> p0:phy_afi_rlat
	wire    [7:0] s0_phy_phy_read_increment_vfifo_hr;          // s0:phy_read_increment_vfifo_hr -> p0:phy_read_increment_vfifo_hr
	wire    [7:0] s0_phy_phy_vfifo_rd_en_override;             // s0:phy_vfifo_rd_en_override -> p0:phy_vfifo_rd_en_override
	wire  [255:0] p0_phy_phy_read_fifo_q;                      // p0:phy_read_fifo_q -> s0:phy_read_fifo_q
	wire    [3:0] s0_phy_phy_read_latency_counter;             // s0:phy_read_latency_counter -> p0:phy_read_latency_counter
	wire    [7:0] s0_phy_phy_read_fifo_reset;                  // s0:phy_read_fifo_reset -> p0:phy_read_fifo_reset
	wire    [7:0] s0_phy_phy_read_increment_vfifo_fr;          // s0:phy_read_increment_vfifo_fr -> p0:phy_read_increment_vfifo_fr
	wire   [31:0] s0_phy_phy_cal_debug_info;                   // s0:phy_cal_debug_info -> p0:phy_cal_debug_info
	wire          s0_phy_phy_reset_mem_stable;                 // s0:phy_reset_mem_stable -> p0:phy_reset_mem_stable
	wire    [5:0] s0_phy_phy_afi_wlat;                         // s0:phy_afi_wlat -> p0:phy_afi_wlat
	wire    [7:0] p0_calib_calib_skip_steps;                   // p0:calib_skip_steps -> s0:calib_skip_steps
	wire    [7:0] s0_scc_scc_dm_ena;                           // s0:scc_dm_ena -> p0:scc_dm_ena
	wire   [63:0] s0_scc_scc_dq_ena;                           // s0:scc_dq_ena -> p0:scc_dq_ena
	wire    [7:0] s0_scc_scc_dqs_ena;                          // s0:scc_dqs_ena -> p0:scc_dqs_ena
	wire    [0:0] s0_scc_scc_upd;                              // s0:scc_upd -> p0:scc_upd
	wire    [7:0] p0_scc_capture_strobe_tracking;              // p0:capture_strobe_tracking -> s0:capture_strobe_tracking
	wire    [7:0] s0_scc_scc_dqs_io_ena;                       // s0:scc_dqs_io_ena -> p0:scc_dqs_io_ena
	wire          s0_scc_scc_data;                             // s0:scc_data -> p0:scc_data
	wire   [27:0] c0_afi_afi_addr;                             // c0:afi_addr -> m0:afi_addr
	wire    [1:0] c0_afi_afi_odt;                              // c0:afi_odt -> m0:afi_odt
	wire          c0_afi_afi_cal_req;                          // c0:afi_cal_req -> s0:afi_cal_req
	wire    [1:0] c0_afi_afi_rdata_en_full;                    // c0:afi_rdata_en_full -> m0:afi_rdata_en_full
	wire    [1:0] c0_afi_afi_we_n;                             // c0:afi_we_n -> m0:afi_we_n
	wire    [5:0] c0_afi_afi_ba;                               // c0:afi_ba -> m0:afi_ba
	wire    [1:0] c0_afi_afi_cke;                              // c0:afi_cke -> m0:afi_cke
	wire    [1:0] c0_afi_afi_cs_n;                             // c0:afi_cs_n -> m0:afi_cs_n
	wire  [255:0] c0_afi_afi_wdata;                            // c0:afi_wdata -> m0:afi_wdata
	wire    [1:0] c0_afi_afi_rdata_en;                         // c0:afi_rdata_en -> m0:afi_rdata_en
	wire    [1:0] c0_afi_afi_cas_n;                            // c0:afi_cas_n -> m0:afi_cas_n
	wire    [1:0] c0_afi_afi_ras_n;                            // c0:afi_ras_n -> m0:afi_ras_n
	wire    [1:0] c0_afi_afi_mem_clk_disable;                  // c0:afi_mem_clk_disable -> p0:afi_mem_clk_disable
	wire          c0_afi_afi_init_req;                         // c0:afi_init_req -> s0:afi_init_req
	wire   [15:0] c0_afi_afi_wdata_valid;                      // c0:afi_wdata_valid -> m0:afi_wdata_valid
	wire   [15:0] c0_afi_afi_dqs_burst;                        // c0:afi_dqs_burst -> m0:afi_dqs_burst
	wire   [31:0] c0_afi_afi_dm;                               // c0:afi_dm -> m0:afi_dm
	wire   [13:0] oct0_oct_sharing_parallelterminationcontrol; // oct0:parallelterminationcontrol -> p0:parallelterminationcontrol
	wire   [13:0] oct0_oct_sharing_seriesterminationcontrol;   // oct0:seriesterminationcontrol -> p0:seriesterminationcontrol
	wire          pll0_pll_sharing_pll_avl_clk;                // pll0:pll_avl_clk -> p0:pll_avl_clk
	wire          pll0_pll_sharing_pll_config_clk;             // pll0:pll_config_clk -> p0:pll_config_clk
	wire          pll0_pll_sharing_pll_addr_cmd_clk;           // pll0:pll_addr_cmd_clk -> p0:pll_addr_cmd_clk
	wire          pll0_pll_sharing_pll_mem_clk;                // pll0:pll_mem_clk -> p0:pll_mem_clk
	wire          pll0_pll_sharing_pll_locked;                 // pll0:pll_locked -> p0:pll_locked
	wire          pll0_pll_sharing_pll_write_clk_pre_phy_clk;  // pll0:pll_write_clk_pre_phy_clk -> p0:pll_write_clk_pre_phy_clk
	wire          pll0_pll_sharing_pll_write_clk;              // pll0:pll_write_clk -> p0:pll_write_clk
	wire          p0_dll_clk_clk;                              // p0:dll_clk -> dll0:clk
	wire          p0_dll_sharing_dll_pll_locked;               // p0:dll_pll_locked -> dll0:dll_pll_locked
	wire    [5:0] dll0_dll_sharing_dll_delayctrl;              // dll0:dll_delayctrl -> p0:dll_delayctrl

	DE4_QSYS_mem_if_ddr2_emif_pll0 pll0 (
		.global_reset_n            (global_reset_n),                             // global_reset.reset_n
		.afi_clk                   (afi_clk),                                    //      afi_clk.clk
		.afi_half_clk              (afi_half_clk),                               // afi_half_clk.clk
		.pll_ref_clk               (pll_ref_clk),                                //  pll_ref_clk.clk
		.pll_mem_clk               (pll0_pll_sharing_pll_mem_clk),               //  pll_sharing.pll_mem_clk
		.pll_write_clk             (pll0_pll_sharing_pll_write_clk),             //             .pll_write_clk
		.pll_write_clk_pre_phy_clk (pll0_pll_sharing_pll_write_clk_pre_phy_clk), //             .pll_write_clk_pre_phy_clk
		.pll_addr_cmd_clk          (pll0_pll_sharing_pll_addr_cmd_clk),          //             .pll_addr_cmd_clk
		.pll_locked                (pll0_pll_sharing_pll_locked),                //             .pll_locked
		.pll_avl_clk               (pll0_pll_sharing_pll_avl_clk),               //             .pll_avl_clk
		.pll_config_clk            (pll0_pll_sharing_pll_config_clk)             //             .pll_config_clk
	);

	DE4_QSYS_mem_if_ddr2_emif_p0 p0 (
		.global_reset_n              (global_reset_n),                              //        global_reset.reset_n
		.soft_reset_n                (soft_reset_n),                                //          soft_reset.reset_n
		.afi_reset_n                 (afi_reset_n),                                 //           afi_reset.reset_n
		.afi_clk                     (afi_clk),                                     //             afi_clk.clk
		.afi_half_clk                (afi_half_clk),                                //        afi_half_clk.clk
		.addr_cmd_clk                (p0_addr_cmd_clk_clk),                         //        addr_cmd_clk.clk
		.avl_clk                     (p0_avl_clk_clk),                              //             avl_clk.clk
		.avl_reset_n                 (p0_avl_reset_reset),                          //           avl_reset.reset_n
		.scc_clk                     (p0_scc_clk_clk),                              //             scc_clk.clk
		.scc_reset_n                 (p0_scc_reset_reset),                          //           scc_reset.reset_n
		.dll_clk                     (p0_dll_clk_clk),                              //             dll_clk.clk
		.afi_addr                    (m0_phy_mux_afi_addr),                         //                 afi.afi_addr
		.afi_ba                      (m0_phy_mux_afi_ba),                           //                    .afi_ba
		.afi_ras_n                   (m0_phy_mux_afi_ras_n),                        //                    .afi_ras_n
		.afi_we_n                    (m0_phy_mux_afi_we_n),                         //                    .afi_we_n
		.afi_cas_n                   (m0_phy_mux_afi_cas_n),                        //                    .afi_cas_n
		.afi_odt                     (m0_phy_mux_afi_odt),                          //                    .afi_odt
		.afi_cke                     (m0_phy_mux_afi_cke),                          //                    .afi_cke
		.afi_cs_n                    (m0_phy_mux_afi_cs_n),                         //                    .afi_cs_n
		.afi_dqs_burst               (m0_phy_mux_afi_dqs_burst),                    //                    .afi_dqs_burst
		.afi_wdata_valid             (m0_phy_mux_afi_wdata_valid),                  //                    .afi_wdata_valid
		.afi_wdata                   (m0_phy_mux_afi_wdata),                        //                    .afi_wdata
		.afi_dm                      (m0_phy_mux_afi_dm),                           //                    .afi_dm
		.afi_rdata                   (p0_afi_afi_rdata),                            //                    .afi_rdata
		.afi_rdata_en                (m0_phy_mux_afi_rdata_en),                     //                    .afi_rdata_en
		.afi_rdata_en_full           (m0_phy_mux_afi_rdata_en_full),                //                    .afi_rdata_en_full
		.afi_rdata_valid             (p0_afi_afi_rdata_valid),                      //                    .afi_rdata_valid
		.afi_cal_success             (p0_afi_afi_cal_success),                      //                    .afi_cal_success
		.afi_cal_fail                (p0_afi_afi_cal_fail),                         //                    .afi_cal_fail
		.afi_wlat                    (p0_afi_afi_wlat),                             //                    .afi_wlat
		.afi_rlat                    (p0_afi_afi_rlat),                             //                    .afi_rlat
		.phy_clk                     (p0_phy_phy_clk),                              //                 phy.phy_clk
		.phy_reset_n                 (p0_phy_phy_reset_n),                          //                    .phy_reset_n
		.phy_read_latency_counter    (s0_phy_phy_read_latency_counter),             //                    .phy_read_latency_counter
		.phy_afi_wlat                (s0_phy_phy_afi_wlat),                         //                    .phy_afi_wlat
		.phy_afi_rlat                (s0_phy_phy_afi_rlat),                         //                    .phy_afi_rlat
		.phy_read_increment_vfifo_fr (s0_phy_phy_read_increment_vfifo_fr),          //                    .phy_read_increment_vfifo_fr
		.phy_read_increment_vfifo_hr (s0_phy_phy_read_increment_vfifo_hr),          //                    .phy_read_increment_vfifo_hr
		.phy_read_increment_vfifo_qr (s0_phy_phy_read_increment_vfifo_qr),          //                    .phy_read_increment_vfifo_qr
		.phy_reset_mem_stable        (s0_phy_phy_reset_mem_stable),                 //                    .phy_reset_mem_stable
		.phy_cal_success             (s0_phy_phy_cal_success),                      //                    .phy_cal_success
		.phy_cal_fail                (s0_phy_phy_cal_fail),                         //                    .phy_cal_fail
		.phy_cal_debug_info          (s0_phy_phy_cal_debug_info),                   //                    .phy_cal_debug_info
		.phy_read_fifo_reset         (s0_phy_phy_read_fifo_reset),                  //                    .phy_read_fifo_reset
		.phy_vfifo_rd_en_override    (s0_phy_phy_vfifo_rd_en_override),             //                    .phy_vfifo_rd_en_override
		.phy_read_fifo_q             (p0_phy_phy_read_fifo_q),                      //                    .phy_read_fifo_q
		.calib_skip_steps            (p0_calib_calib_skip_steps),                   //               calib.calib_skip_steps
		.scc_data                    (s0_scc_scc_data),                             //                 scc.scc_data
		.scc_dqs_ena                 (s0_scc_scc_dqs_ena),                          //                    .scc_dqs_ena
		.scc_dqs_io_ena              (s0_scc_scc_dqs_io_ena),                       //                    .scc_dqs_io_ena
		.scc_dq_ena                  (s0_scc_scc_dq_ena),                           //                    .scc_dq_ena
		.scc_dm_ena                  (s0_scc_scc_dm_ena),                           //                    .scc_dm_ena
		.capture_strobe_tracking     (p0_scc_capture_strobe_tracking),              //                    .capture_strobe_tracking
		.scc_upd                     (s0_scc_scc_upd),                              //                    .scc_upd
		.afi_mem_clk_disable         (c0_afi_afi_mem_clk_disable),                  // afi_mem_clk_disable.afi_mem_clk_disable
		.pll_mem_clk                 (pll0_pll_sharing_pll_mem_clk),                //         pll_sharing.pll_mem_clk
		.pll_write_clk               (pll0_pll_sharing_pll_write_clk),              //                    .pll_write_clk
		.pll_write_clk_pre_phy_clk   (pll0_pll_sharing_pll_write_clk_pre_phy_clk),  //                    .pll_write_clk_pre_phy_clk
		.pll_addr_cmd_clk            (pll0_pll_sharing_pll_addr_cmd_clk),           //                    .pll_addr_cmd_clk
		.pll_locked                  (pll0_pll_sharing_pll_locked),                 //                    .pll_locked
		.pll_avl_clk                 (pll0_pll_sharing_pll_avl_clk),                //                    .pll_avl_clk
		.pll_config_clk              (pll0_pll_sharing_pll_config_clk),             //                    .pll_config_clk
		.dll_pll_locked              (p0_dll_sharing_dll_pll_locked),               //         dll_sharing.dll_pll_locked
		.dll_delayctrl               (dll0_dll_sharing_dll_delayctrl),              //                    .dll_delayctrl
		.seriesterminationcontrol    (oct0_oct_sharing_seriesterminationcontrol),   //         oct_sharing.seriesterminationcontrol
		.parallelterminationcontrol  (oct0_oct_sharing_parallelterminationcontrol), //                    .parallelterminationcontrol
		.mem_a                       (mem_a),                                       //              memory.mem_a
		.mem_ba                      (mem_ba),                                      //                    .mem_ba
		.mem_ck                      (mem_ck),                                      //                    .mem_ck
		.mem_ck_n                    (mem_ck_n),                                    //                    .mem_ck_n
		.mem_cke                     (mem_cke),                                     //                    .mem_cke
		.mem_cs_n                    (mem_cs_n),                                    //                    .mem_cs_n
		.mem_dm                      (mem_dm),                                      //                    .mem_dm
		.mem_ras_n                   (mem_ras_n),                                   //                    .mem_ras_n
		.mem_cas_n                   (mem_cas_n),                                   //                    .mem_cas_n
		.mem_we_n                    (mem_we_n),                                    //                    .mem_we_n
		.mem_dq                      (mem_dq),                                      //                    .mem_dq
		.mem_dqs                     (mem_dqs),                                     //                    .mem_dqs
		.mem_dqs_n                   (mem_dqs_n),                                   //                    .mem_dqs_n
		.mem_odt                     (mem_odt),                                     //                    .mem_odt
		.csr_soft_reset_req          (1'b0)                                         //         (terminated)
	);

	afi_mux_ddrx #(
		.AFI_RATE_RATIO      (2),
		.AFI_ADDR_WIDTH      (28),
		.AFI_BANKADDR_WIDTH  (6),
		.AFI_CONTROL_WIDTH   (2),
		.AFI_CS_WIDTH        (2),
		.AFI_CLK_EN_WIDTH    (2),
		.AFI_DM_WIDTH        (32),
		.AFI_DQ_WIDTH        (256),
		.AFI_ODT_WIDTH       (2),
		.AFI_WRITE_DQS_WIDTH (16),
		.AFI_RLAT_WIDTH      (6),
		.AFI_WLAT_WIDTH      (6)
	) m0 (
		.clk                   (p0_addr_cmd_clk_clk),          //     clk.clk
		.afi_addr              (c0_afi_afi_addr),              //     afi.afi_addr
		.afi_ba                (c0_afi_afi_ba),                //        .afi_ba
		.afi_ras_n             (c0_afi_afi_ras_n),             //        .afi_ras_n
		.afi_we_n              (c0_afi_afi_we_n),              //        .afi_we_n
		.afi_cas_n             (c0_afi_afi_cas_n),             //        .afi_cas_n
		.afi_odt               (c0_afi_afi_odt),               //        .afi_odt
		.afi_cke               (c0_afi_afi_cke),               //        .afi_cke
		.afi_cs_n              (c0_afi_afi_cs_n),              //        .afi_cs_n
		.afi_dqs_burst         (c0_afi_afi_dqs_burst),         //        .afi_dqs_burst
		.afi_wdata_valid       (c0_afi_afi_wdata_valid),       //        .afi_wdata_valid
		.afi_wdata             (c0_afi_afi_wdata),             //        .afi_wdata
		.afi_dm                (c0_afi_afi_dm),                //        .afi_dm
		.afi_rdata             (m0_afi_afi_rdata),             //        .afi_rdata
		.afi_rdata_en          (c0_afi_afi_rdata_en),          //        .afi_rdata_en
		.afi_rdata_en_full     (c0_afi_afi_rdata_en_full),     //        .afi_rdata_en_full
		.afi_rdata_valid       (m0_afi_afi_rdata_valid),       //        .afi_rdata_valid
		.afi_cal_success       (m0_afi_afi_cal_success),       //        .afi_cal_success
		.afi_cal_fail          (m0_afi_afi_cal_fail),          //        .afi_cal_fail
		.afi_wlat              (m0_afi_afi_wlat),              //        .afi_wlat
		.afi_rlat              (m0_afi_afi_rlat),              //        .afi_rlat
		.seq_mux_addr          (s0_afi_afi_addr),              // seq_mux.afi_addr
		.seq_mux_ba            (s0_afi_afi_ba),                //        .afi_ba
		.seq_mux_ras_n         (s0_afi_afi_ras_n),             //        .afi_ras_n
		.seq_mux_we_n          (s0_afi_afi_we_n),              //        .afi_we_n
		.seq_mux_cas_n         (s0_afi_afi_cas_n),             //        .afi_cas_n
		.seq_mux_odt           (s0_afi_afi_odt),               //        .afi_odt
		.seq_mux_cke           (s0_afi_afi_cke),               //        .afi_cke
		.seq_mux_cs_n          (s0_afi_afi_cs_n),              //        .afi_cs_n
		.seq_mux_dqs_burst     (s0_afi_afi_dqs_burst),         //        .afi_dqs_burst
		.seq_mux_wdata_valid   (s0_afi_afi_wdata_valid),       //        .afi_wdata_valid
		.seq_mux_wdata         (s0_afi_afi_wdata),             //        .afi_wdata
		.seq_mux_dm            (s0_afi_afi_dm),                //        .afi_dm
		.seq_mux_rdata         (m0_seq_mux_afi_rdata),         //        .afi_rdata
		.seq_mux_rdata_en      (s0_afi_afi_rdata_en),          //        .afi_rdata_en
		.seq_mux_rdata_en_full (s0_afi_afi_rdata_en_full),     //        .afi_rdata_en_full
		.seq_mux_rdata_valid   (m0_seq_mux_afi_rdata_valid),   //        .afi_rdata_valid
		.phy_mux_addr          (m0_phy_mux_afi_addr),          // phy_mux.afi_addr
		.phy_mux_ba            (m0_phy_mux_afi_ba),            //        .afi_ba
		.phy_mux_ras_n         (m0_phy_mux_afi_ras_n),         //        .afi_ras_n
		.phy_mux_we_n          (m0_phy_mux_afi_we_n),          //        .afi_we_n
		.phy_mux_cas_n         (m0_phy_mux_afi_cas_n),         //        .afi_cas_n
		.phy_mux_odt           (m0_phy_mux_afi_odt),           //        .afi_odt
		.phy_mux_cke           (m0_phy_mux_afi_cke),           //        .afi_cke
		.phy_mux_cs_n          (m0_phy_mux_afi_cs_n),          //        .afi_cs_n
		.phy_mux_dqs_burst     (m0_phy_mux_afi_dqs_burst),     //        .afi_dqs_burst
		.phy_mux_wdata_valid   (m0_phy_mux_afi_wdata_valid),   //        .afi_wdata_valid
		.phy_mux_wdata         (m0_phy_mux_afi_wdata),         //        .afi_wdata
		.phy_mux_dm            (m0_phy_mux_afi_dm),            //        .afi_dm
		.phy_mux_rdata         (p0_afi_afi_rdata),             //        .afi_rdata
		.phy_mux_rdata_en      (m0_phy_mux_afi_rdata_en),      //        .afi_rdata_en
		.phy_mux_rdata_en_full (m0_phy_mux_afi_rdata_en_full), //        .afi_rdata_en_full
		.phy_mux_rdata_valid   (p0_afi_afi_rdata_valid),       //        .afi_rdata_valid
		.phy_mux_cal_success   (p0_afi_afi_cal_success),       //        .afi_cal_success
		.phy_mux_cal_fail      (p0_afi_afi_cal_fail),          //        .afi_cal_fail
		.phy_mux_wlat          (p0_afi_afi_wlat),              //        .afi_wlat
		.phy_mux_rlat          (p0_afi_afi_rlat),              //        .afi_rlat
		.mux_sel               (s0_mux_sel_mux_sel)            // mux_sel.mux_sel
	);

	DE4_QSYS_mem_if_ddr2_emif_s0 s0 (
		.avl_clk                     (p0_avl_clk_clk),                     //          avl_clk.clk
		.avl_reset_n                 (p0_avl_reset_reset),                 //        avl_reset.reset_n
		.scc_clk                     (p0_scc_clk_clk),                     //          scc_clk.clk
		.reset_n_scc_clk             (p0_scc_reset_reset),                 //        scc_reset.reset_n
		.scc_data                    (s0_scc_scc_data),                    //              scc.scc_data
		.scc_dqs_ena                 (s0_scc_scc_dqs_ena),                 //                 .scc_dqs_ena
		.scc_dqs_io_ena              (s0_scc_scc_dqs_io_ena),              //                 .scc_dqs_io_ena
		.scc_dq_ena                  (s0_scc_scc_dq_ena),                  //                 .scc_dq_ena
		.scc_dm_ena                  (s0_scc_scc_dm_ena),                  //                 .scc_dm_ena
		.capture_strobe_tracking     (p0_scc_capture_strobe_tracking),     //                 .capture_strobe_tracking
		.scc_upd                     (s0_scc_scc_upd),                     //                 .scc_upd
		.afi_init_req                (c0_afi_afi_init_req),                // afi_init_cal_req.afi_init_req
		.afi_cal_req                 (c0_afi_afi_cal_req),                 //                 .afi_cal_req
		.phy_clk                     (p0_phy_phy_clk),                     //              phy.phy_clk
		.phy_reset_n                 (p0_phy_phy_reset_n),                 //                 .phy_reset_n
		.phy_read_latency_counter    (s0_phy_phy_read_latency_counter),    //                 .phy_read_latency_counter
		.phy_afi_wlat                (s0_phy_phy_afi_wlat),                //                 .phy_afi_wlat
		.phy_afi_rlat                (s0_phy_phy_afi_rlat),                //                 .phy_afi_rlat
		.phy_read_increment_vfifo_fr (s0_phy_phy_read_increment_vfifo_fr), //                 .phy_read_increment_vfifo_fr
		.phy_read_increment_vfifo_hr (s0_phy_phy_read_increment_vfifo_hr), //                 .phy_read_increment_vfifo_hr
		.phy_read_increment_vfifo_qr (s0_phy_phy_read_increment_vfifo_qr), //                 .phy_read_increment_vfifo_qr
		.phy_reset_mem_stable        (s0_phy_phy_reset_mem_stable),        //                 .phy_reset_mem_stable
		.phy_cal_success             (s0_phy_phy_cal_success),             //                 .phy_cal_success
		.phy_cal_fail                (s0_phy_phy_cal_fail),                //                 .phy_cal_fail
		.phy_cal_debug_info          (s0_phy_phy_cal_debug_info),          //                 .phy_cal_debug_info
		.phy_read_fifo_reset         (s0_phy_phy_read_fifo_reset),         //                 .phy_read_fifo_reset
		.phy_vfifo_rd_en_override    (s0_phy_phy_vfifo_rd_en_override),    //                 .phy_vfifo_rd_en_override
		.phy_read_fifo_q             (p0_phy_phy_read_fifo_q),             //                 .phy_read_fifo_q
		.calib_skip_steps            (p0_calib_calib_skip_steps),          //            calib.calib_skip_steps
		.phy_mux_sel                 (s0_mux_sel_mux_sel),                 //          mux_sel.mux_sel
		.afi_clk                     (afi_clk),                            //          afi_clk.clk
		.afi_reset_n                 (afi_reset_n),                        //        afi_reset.reset_n
		.afi_addr                    (s0_afi_afi_addr),                    //              afi.afi_addr
		.afi_ba                      (s0_afi_afi_ba),                      //                 .afi_ba
		.afi_ras_n                   (s0_afi_afi_ras_n),                   //                 .afi_ras_n
		.afi_we_n                    (s0_afi_afi_we_n),                    //                 .afi_we_n
		.afi_cas_n                   (s0_afi_afi_cas_n),                   //                 .afi_cas_n
		.afi_odt                     (s0_afi_afi_odt),                     //                 .afi_odt
		.afi_cke                     (s0_afi_afi_cke),                     //                 .afi_cke
		.afi_cs_n                    (s0_afi_afi_cs_n),                    //                 .afi_cs_n
		.afi_dqs_burst               (s0_afi_afi_dqs_burst),               //                 .afi_dqs_burst
		.afi_wdata_valid             (s0_afi_afi_wdata_valid),             //                 .afi_wdata_valid
		.afi_wdata                   (s0_afi_afi_wdata),                   //                 .afi_wdata
		.afi_dm                      (s0_afi_afi_dm),                      //                 .afi_dm
		.afi_rdata                   (m0_seq_mux_afi_rdata),               //                 .afi_rdata
		.afi_rdata_en                (s0_afi_afi_rdata_en),                //                 .afi_rdata_en
		.afi_rdata_en_full           (s0_afi_afi_rdata_en_full),           //                 .afi_rdata_en_full
		.afi_rdata_valid             (m0_seq_mux_afi_rdata_valid),         //                 .afi_rdata_valid
		.phy_write_fr_cycle_shifts   ()                                    //      (terminated)
	);

	DE4_QSYS_mem_if_ddr2_emif_c0 c0 (
		.afi_reset_n         (afi_reset_n),                //    afi_reset.reset_n
		.afi_clk             (afi_clk),                    //      afi_clk.clk
		.afi_half_clk        (afi_half_clk),               // afi_half_clk.clk
		.local_init_done     (local_init_done),            //       status.local_init_done
		.local_cal_success   (local_cal_success),          //             .local_cal_success
		.local_cal_fail      (local_cal_fail),             //             .local_cal_fail
		.afi_addr            (c0_afi_afi_addr),            //          afi.afi_addr
		.afi_ba              (c0_afi_afi_ba),              //             .afi_ba
		.afi_ras_n           (c0_afi_afi_ras_n),           //             .afi_ras_n
		.afi_we_n            (c0_afi_afi_we_n),            //             .afi_we_n
		.afi_cas_n           (c0_afi_afi_cas_n),           //             .afi_cas_n
		.afi_odt             (c0_afi_afi_odt),             //             .afi_odt
		.afi_cke             (c0_afi_afi_cke),             //             .afi_cke
		.afi_cs_n            (c0_afi_afi_cs_n),            //             .afi_cs_n
		.afi_dqs_burst       (c0_afi_afi_dqs_burst),       //             .afi_dqs_burst
		.afi_wdata_valid     (c0_afi_afi_wdata_valid),     //             .afi_wdata_valid
		.afi_wdata           (c0_afi_afi_wdata),           //             .afi_wdata
		.afi_dm              (c0_afi_afi_dm),              //             .afi_dm
		.afi_rdata           (m0_afi_afi_rdata),           //             .afi_rdata
		.afi_mem_clk_disable (c0_afi_afi_mem_clk_disable), //             .afi_mem_clk_disable
		.afi_init_req        (c0_afi_afi_init_req),        //             .afi_init_req
		.afi_cal_req         (c0_afi_afi_cal_req),         //             .afi_cal_req
		.afi_rdata_en        (c0_afi_afi_rdata_en),        //             .afi_rdata_en
		.afi_rdata_en_full   (c0_afi_afi_rdata_en_full),   //             .afi_rdata_en_full
		.afi_rdata_valid     (m0_afi_afi_rdata_valid),     //             .afi_rdata_valid
		.afi_cal_success     (m0_afi_afi_cal_success),     //             .afi_cal_success
		.afi_cal_fail        (m0_afi_afi_cal_fail),        //             .afi_cal_fail
		.afi_wlat            (m0_afi_afi_wlat),            //             .afi_wlat
		.afi_rlat            (m0_afi_afi_rlat),            //             .afi_rlat
		.avl_ready           (avl_ready),                  //          avl.waitrequest_n
		.avl_burstbegin      (avl_burstbegin),             //             .beginbursttransfer
		.avl_addr            (avl_addr),                   //             .address
		.avl_rdata_valid     (avl_rdata_valid),            //             .readdatavalid
		.avl_rdata           (avl_rdata),                  //             .readdata
		.avl_wdata           (avl_wdata),                  //             .writedata
		.avl_be              (avl_be),                     //             .byteenable
		.avl_read_req        (avl_read_req),               //             .read
		.avl_write_req       (avl_write_req),              //             .write
		.avl_size            (avl_size)                    //             .burstcount
	);

	altera_mem_if_oct_stratixiv #(
		.OCT_TERM_CONTROL_WIDTH (14)
	) oct0 (
		.oct_rdn                    (oct_rdn),                                     //         oct.rdn
		.oct_rup                    (oct_rup),                                     //            .rup
		.seriesterminationcontrol   (oct0_oct_sharing_seriesterminationcontrol),   // oct_sharing.seriesterminationcontrol
		.parallelterminationcontrol (oct0_oct_sharing_parallelterminationcontrol)  //            .parallelterminationcontrol
	);

	altera_mem_if_dll_stratixiv #(
		.DLL_DELAY_CTRL_WIDTH       (6),
		.DLL_OFFSET_CTRL_WIDTH      (6),
		.DELAY_BUFFER_MODE          ("HIGH"),
		.DELAY_CHAIN_LENGTH         (8),
		.DLL_INPUT_FREQUENCY_PS_STR ("2500 ps")
	) dll0 (
		.clk            (p0_dll_clk_clk),                 //         clk.clk
		.dll_pll_locked (p0_dll_sharing_dll_pll_locked),  // dll_sharing.dll_pll_locked
		.dll_delayctrl  (dll0_dll_sharing_dll_delayctrl)  //            .dll_delayctrl
	);

endmodule
