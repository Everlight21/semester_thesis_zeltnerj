-- Copyright (C) 1991-2007 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM "Quartus II"
-- VERSION "Version 7.2 Build 207 03/18/2008 Service Pack 3 SJ Full Version"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Camera_Interface IS 
	port
	(
		reset :  IN  STD_LOGIC;
		am_WaitRequest :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		cam_FV :  IN  STD_LOGIC;
		cam_LV :  IN  STD_LOGIC;
		cam_pixclk :  IN  STD_LOGIC;
		as_chipselect :  IN  STD_LOGIC;
		as_read :  IN  STD_LOGIC;
		as_write :  IN  STD_LOGIC;
		cam_Feedback :  IN  STD_LOGIC;
		as_address :  IN  STD_LOGIC_VECTOR(2 downto 0);
		as_writeData :  IN  STD_LOGIC_VECTOR(31 downto 0);
		cam_pixel :  IN  STD_LOGIC_VECTOR(9 downto 0);
		am_write :  OUT  STD_LOGIC;
		as_irq :  OUT  STD_LOGIC;
		master_fifo_full :  OUT  STD_LOGIC;
		cam_exposure :  OUT  STD_LOGIC;
		am_address :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		am_burstcount :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		am_byteEnable :  OUT  STD_LOGIC_VECTOR(3 downto 0);
		am_dataWrite :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		as_readData :  OUT  STD_LOGIC_VECTOR(31 downto 0)
	);
END Camera_Interface;

ARCHITECTURE bdf_type OF Camera_Interface IS 

component controlercamera
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 newFrame_in : IN STD_LOGIC;
		 newLine_in : IN STD_LOGIC;
		 dataAvailable_in : IN STD_LOGIC;
		 lastPixel_in : IN STD_LOGIC;
		 as_start : IN STD_LOGIC;
		 as_stop : IN STD_LOGIC;
		 as_mode : IN STD_LOGIC;
		 as_BGR : IN STD_LOGIC;
		 as_8bits : IN STD_LOGIC;
		 pixel_in : IN STD_LOGIC_VECTOR(31 downto 0);
		 am_newData : OUT STD_LOGIC;
		 am_newFrame : OUT STD_LOGIC;
		 am_lastPixel : OUT STD_LOGIC;
		 am_Data : OUT STD_LOGIC_VECTOR(31 downto 0);
		 as_nbPixels : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component camera_slave_part
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 avalon_chipselect : IN STD_LOGIC;
		 avalon_read : IN STD_LOGIC;
		 avalon_write : IN STD_LOGIC;
		 camInt_frame_finished : IN STD_LOGIC;
		 am_transfert_frame_finished : IN STD_LOGIC;
		 cam_Feedback : IN STD_LOGIC;
		 am_bufferUsed : IN STD_LOGIC_VECTOR(31 downto 0);
		 avalon_address : IN STD_LOGIC_VECTOR(2 downto 0);
		 avalon_writeData : IN STD_LOGIC_VECTOR(31 downto 0);
		 camInt_nbPixels : IN STD_LOGIC_VECTOR(31 downto 0);
		 am_addressChanged : OUT STD_LOGIC;
		 am_begin : OUT STD_LOGIC;
		 am_24bits : OUT STD_LOGIC;
		 camInt_start : OUT STD_LOGIC;
		 camInt_mode : OUT STD_LOGIC;
		 camInt_stop : OUT STD_LOGIC;
		 camInt_BGR : OUT STD_LOGIC;
		 camInt_8bits : OUT STD_LOGIC;
		 avalon_irq : OUT STD_LOGIC;
		 WB_newValue : OUT STD_LOGIC;
		 pixelSelector_color : OUT STD_LOGIC;
		 cam_Exposure : OUT STD_LOGIC;
		 am_startAddress1 : OUT STD_LOGIC_VECTOR(31 downto 0);
		 am_startAddress2 : OUT STD_LOGIC_VECTOR(31 downto 0);
		 avalon_readData : OUT STD_LOGIC_VECTOR(31 downto 0);
		 IC_inputControlMode : OUT STD_LOGIC_VECTOR(1 downto 0);
		 WB_factor1 : OUT STD_LOGIC_VECTOR(9 downto 0);
		 WB_factor2 : OUT STD_LOGIC_VECTOR(9 downto 0);
		 WB_factor3 : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
end component;

component camera_master_part
GENERIC (bufferSizerLog:INTEGER);
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 am_WaitRequest : IN STD_LOGIC;
		 as_addressChanged : IN STD_LOGIC;
		 as_begin : IN STD_LOGIC;
		 as_24bits : IN STD_LOGIC;
		 camInt_newData : IN STD_LOGIC;
		 camInt_newFrame : IN STD_LOGIC;
		 camInt_lastPixel : IN STD_LOGIC;
		 as_startAddress1 : IN STD_LOGIC_VECTOR(31 downto 0);
		 as_startAddress2 : IN STD_LOGIC_VECTOR(31 downto 0);
		 camInt_data : IN STD_LOGIC_VECTOR(31 downto 0);
		 am_write : OUT STD_LOGIC;
		 as_transfert_frame_finished : OUT STD_LOGIC;
		 fifo_full : OUT STD_LOGIC;
		 am_address : OUT STD_LOGIC_VECTOR(31 downto 0);
		 am_burstcount : OUT STD_LOGIC_VECTOR(31 downto 0);
		 am_byteEnable : OUT STD_LOGIC_VECTOR(3 downto 0);
		 am_dataWrite : OUT STD_LOGIC_VECTOR(31 downto 0);
		 as_lastBufferUsed : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component inputcontrol
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 dataAvailable_in : IN STD_LOGIC;
		 FV : IN STD_LOGIC;
		 LV : IN STD_LOGIC;
		 data_in : IN STD_LOGIC_VECTOR(9 downto 0);
		 inputMode : IN STD_LOGIC_VECTOR(1 downto 0);
		 newFrame : OUT STD_LOGIC;
		 newLine : OUT STD_LOGIC;
		 dataAvailable_out : OUT STD_LOGIC;
		 lastPixel_out : OUT STD_LOGIC;
		 data_out : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
end component;

component camerasync_block
	PORT(cam_pixclk : IN STD_LOGIC;
		 cam_FV : IN STD_LOGIC;
		 cam_LV : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 cam_pixel : IN STD_LOGIC_VECTOR(9 downto 0);
		 dataAvailable : OUT STD_LOGIC;
		 FV : OUT STD_LOGIC;
		 LV : OUT STD_LOGIC;
		 pixel : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
end component;

component debayeriser
GENERIC (bitsPerPixel:INTEGER;
			bufferLineSize:INTEGER;
			nbLines:INTEGER;
			nbPixelPerLine:INTEGER);
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 newframe : IN STD_LOGIC;
		 newline : IN STD_LOGIC;
		 pixelAvailable : IN STD_LOGIC;
		 pixel_in : IN STD_LOGIC_VECTOR(9 downto 0);
		 newframe_out : OUT STD_LOGIC;
		 newline_out : OUT STD_LOGIC;
		 pixelAvailable_out : OUT STD_LOGIC;
		 lastPixel_out : OUT STD_LOGIC;
		 pixel_out : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component camera_pixelselector
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 selectColor_in : IN STD_LOGIC;
		 colorPixel_newFrame_in : IN STD_LOGIC;
		 colorPixel_newLine_in : IN STD_LOGIC;
		 colorPixel_dataAvailable_in : IN STD_LOGIC;
		 colorPixel_lastPixel_in : IN STD_LOGIC;
		 bwPixel_newFrame_in : IN STD_LOGIC;
		 bwPixel_newLine_in : IN STD_LOGIC;
		 bwPixel_dataAvailable_in : IN STD_LOGIC;
		 bwPixel_lastPixel_in : IN STD_LOGIC;
		 bwPixel_pixel_in : IN STD_LOGIC_VECTOR(9 downto 0);
		 colorPixel_pixel_in : IN STD_LOGIC_VECTOR(31 downto 0);
		 newFrame_out : OUT STD_LOGIC;
		 newLine_out : OUT STD_LOGIC;
		 dataAvailable_out : OUT STD_LOGIC;
		 lastPixel_out : OUT STD_LOGIC;
		 pixel_out : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component colortreatment_block
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 WB_changeFactors : IN STD_LOGIC;
		 newFrame_in : IN STD_LOGIC;
		 newLine_in : IN STD_LOGIC;
		 dataAvailable_in : IN STD_LOGIC;
		 lastPixel_in : IN STD_LOGIC;
		 Pixel_in : IN STD_LOGIC_VECTOR(31 downto 0);
		 WB_factor1 : IN STD_LOGIC_VECTOR(9 downto 0);
		 WB_factor2 : IN STD_LOGIC_VECTOR(9 downto 0);
		 WB_factor3 : IN STD_LOGIC_VECTOR(9 downto 0);
		 newFrame_out : OUT STD_LOGIC;
		 newLine_out : OUT STD_LOGIC;
		 dataAvailable_out : OUT STD_LOGIC;
		 lastPixel_out : OUT STD_LOGIC;
		 Pixel_out : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

signal	am_begin :  STD_LOGIC;
signal	am_Data :  STD_LOGIC_VECTOR(31 downto 0);
signal	am_newData :  STD_LOGIC;
signal	am_newFrame :  STD_LOGIC;
signal	am_transfert_finished :  STD_LOGIC;
signal	as_24bits :  STD_LOGIC;
signal	as_8bits :  STD_LOGIC;
signal	as_BGR :  STD_LOGIC;
signal	as_mode :  STD_LOGIC;
signal	as_start :  STD_LOGIC;
signal	as_startAddress1 :  STD_LOGIC_VECTOR(31 downto 0);
signal	as_startAddress2 :  STD_LOGIC_VECTOR(31 downto 0);
signal	as_stop :  STD_LOGIC;
signal	asM_addessChanged :  STD_LOGIC;
signal	dataAv :  STD_LOGIC;
signal	IC_data :  STD_LOGIC_VECTOR(9 downto 0);
signal	IC_dataAvailable :  STD_LOGIC;
signal	IC_lastPixel :  STD_LOGIC;
signal	IC_newFrame :  STD_LOGIC;
signal	IC_newLine :  STD_LOGIC;
signal	inputControlMode :  STD_LOGIC_VECTOR(1 downto 0);
signal	lastBufferUsed :  STD_LOGIC_VECTOR(31 downto 0);
signal	lastPixelCamera :  STD_LOGIC;
signal	nbPixels :  STD_LOGIC_VECTOR(31 downto 0);
signal	selectRawPixel :  STD_LOGIC;
signal	WB_factor1 :  STD_LOGIC_VECTOR(9 downto 0);
signal	WB_factor2 :  STD_LOGIC_VECTOR(9 downto 0);
signal	WB_factor3 :  STD_LOGIC_VECTOR(9 downto 0);
signal	WB_newValue :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(31 downto 0);
signal	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(9 downto 0);
signal	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(31 downto 0);
signal	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(31 downto 0);


BEGIN 



b2v_inst : controlercamera
PORT MAP(clk => clk,
		 reset => reset,
		 newFrame_in => SYNTHESIZED_WIRE_0,
		 newLine_in => SYNTHESIZED_WIRE_1,
		 dataAvailable_in => SYNTHESIZED_WIRE_2,
		 lastPixel_in => SYNTHESIZED_WIRE_3,
		 as_start => as_start,
		 as_stop => as_stop,
		 as_mode => as_mode,
		 as_BGR => as_BGR,
		 as_8bits => as_8bits,
		 pixel_in => SYNTHESIZED_WIRE_4,
		 am_newData => am_newData,
		 am_newFrame => am_newFrame,
		 am_lastPixel => lastPixelCamera,
		 am_Data => am_Data,
		 as_nbPixels => nbPixels);

b2v_inst1 : camera_slave_part
PORT MAP(clk => clk,
		 reset => reset,
		 avalon_chipselect => as_chipselect,
		 avalon_read => as_read,
		 avalon_write => as_write,
		 camInt_frame_finished => lastPixelCamera,
		 am_transfert_frame_finished => am_transfert_finished,
		 cam_Feedback => cam_Feedback,
		 am_bufferUsed => lastBufferUsed,
		 avalon_address => as_address,
		 avalon_writeData => as_writeData,
		 camInt_nbPixels => nbPixels,
		 am_addressChanged => asM_addessChanged,
		 am_begin => am_begin,
		 am_24bits => as_24bits,
		 camInt_start => as_start,
		 camInt_mode => as_mode,
		 camInt_stop => as_stop,
		 camInt_BGR => as_BGR,
		 camInt_8bits => as_8bits,
		 avalon_irq => as_irq,
		 WB_newValue => WB_newValue,
		 pixelSelector_color => selectRawPixel,
		 cam_Exposure => cam_exposure,
		 am_startAddress1 => as_startAddress1,
		 am_startAddress2 => as_startAddress2,
		 avalon_readData => as_readData,
		 IC_inputControlMode => inputControlMode,
		 WB_factor1 => WB_factor1,
		 WB_factor2 => WB_factor2,
		 WB_factor3 => WB_factor3);

b2v_inst2 : camera_master_part
GENERIC MAP(bufferSizerLog => 10)
PORT MAP(clk => clk,
		 reset => reset,
		 am_WaitRequest => am_WaitRequest,
		 as_addressChanged => asM_addessChanged,
		 as_begin => am_begin,
		 as_24bits => as_24bits,
		 camInt_newData => am_newData,
		 camInt_newFrame => am_newFrame,
		 camInt_lastPixel => lastPixelCamera,
		 as_startAddress1 => as_startAddress1,
		 as_startAddress2 => as_startAddress2,
		 camInt_data => am_Data,
		 am_write => am_write,
		 as_transfert_frame_finished => am_transfert_finished,
		 fifo_full => master_fifo_full,
		 am_address => am_address,
		 am_burstcount => am_burstcount,
		 am_byteEnable => am_byteEnable,
		 am_dataWrite => am_dataWrite,
		 as_lastBufferUsed => lastBufferUsed);

b2v_inst3 : inputcontrol
PORT MAP(clk => clk,
		 reset => reset,
		 dataAvailable_in => dataAv,
		 FV => SYNTHESIZED_WIRE_5,
		 LV => SYNTHESIZED_WIRE_6,
		 data_in => SYNTHESIZED_WIRE_7,
		 inputMode => inputControlMode,
		 newFrame => IC_newFrame,
		 newLine => IC_newLine,
		 dataAvailable_out => IC_dataAvailable,
		 lastPixel_out => IC_lastPixel,
		 data_out => IC_data);

b2v_inst4 : camerasync_block
PORT MAP(cam_pixclk => cam_pixclk,
		 cam_FV => cam_FV,
		 cam_LV => cam_LV,
		 clk => clk,
		 reset => reset,
		 cam_pixel => cam_pixel,
		 dataAvailable => dataAv,
		 FV => SYNTHESIZED_WIRE_5,
		 LV => SYNTHESIZED_WIRE_6,
		 pixel => SYNTHESIZED_WIRE_7);

b2v_inst5 : debayeriser
GENERIC MAP(bitsPerPixel => 10,bufferLineSize => 1024,nbLines => 480,nbPixelPerLine => 752)
PORT MAP(clk => clk,
		 reset => reset,
		 newframe => IC_newFrame,
		 newline => IC_newLine,
		 pixelAvailable => IC_dataAvailable,
		 pixel_in => IC_data,
		 newframe_out => SYNTHESIZED_WIRE_13,
		 newline_out => SYNTHESIZED_WIRE_14,
		 pixelAvailable_out => SYNTHESIZED_WIRE_15,
		 lastPixel_out => SYNTHESIZED_WIRE_16,
		 pixel_out => SYNTHESIZED_WIRE_17);

b2v_inst7 : camera_pixelselector
PORT MAP(clk => clk,
		 reset => reset,
		 selectColor_in => selectRawPixel,
		 colorPixel_newFrame_in => SYNTHESIZED_WIRE_8,
		 colorPixel_newLine_in => SYNTHESIZED_WIRE_9,
		 colorPixel_dataAvailable_in => SYNTHESIZED_WIRE_10,
		 colorPixel_lastPixel_in => SYNTHESIZED_WIRE_11,
		 bwPixel_newFrame_in => IC_newFrame,
		 bwPixel_newLine_in => IC_newLine,
		 bwPixel_dataAvailable_in => IC_dataAvailable,
		 bwPixel_lastPixel_in => IC_lastPixel,
		 bwPixel_pixel_in => IC_data,
		 colorPixel_pixel_in => SYNTHESIZED_WIRE_12,
		 newFrame_out => SYNTHESIZED_WIRE_0,
		 newLine_out => SYNTHESIZED_WIRE_1,
		 dataAvailable_out => SYNTHESIZED_WIRE_2,
		 lastPixel_out => SYNTHESIZED_WIRE_3,
		 pixel_out => SYNTHESIZED_WIRE_4);

b2v_inst8 : colortreatment_block
PORT MAP(clk => clk,
		 reset => reset,
		 WB_changeFactors => WB_newValue,
		 newFrame_in => SYNTHESIZED_WIRE_13,
		 newLine_in => SYNTHESIZED_WIRE_14,
		 dataAvailable_in => SYNTHESIZED_WIRE_15,
		 lastPixel_in => SYNTHESIZED_WIRE_16,
		 Pixel_in => SYNTHESIZED_WIRE_17,
		 WB_factor1 => WB_factor1,
		 WB_factor2 => WB_factor2,
		 WB_factor3 => WB_factor3,
		 newFrame_out => SYNTHESIZED_WIRE_8,
		 newLine_out => SYNTHESIZED_WIRE_9,
		 dataAvailable_out => SYNTHESIZED_WIRE_10,
		 lastPixel_out => SYNTHESIZED_WIRE_11,
		 Pixel_out => SYNTHESIZED_WIRE_12);

END; 