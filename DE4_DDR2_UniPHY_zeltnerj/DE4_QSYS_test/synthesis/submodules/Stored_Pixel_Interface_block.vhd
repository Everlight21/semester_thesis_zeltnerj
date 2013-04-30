-- Copyright (C) 1991-2012 Altera Corporation
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

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 12.1 Build 177 11/07/2012 SJ Full Version"
-- CREATED		"Wed Feb 20 13:45:58 2013"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Stored_Pixel_Interface_block IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		am_WaitRequest :  IN  STD_LOGIC;
		am_readdatavalid :  IN  STD_LOGIC;
		DVI_FV :  IN  STD_LOGIC;
		DVI_LV :  IN  STD_LOGIC;
		DVI_dataav :  IN  STD_LOGIC;
		DVI_CLK :  IN  STD_LOGIC;
		am_readdata :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		am_read :  OUT  STD_LOGIC;
		am_address :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		am_burstcount :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		pixelb :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		pixelg :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		pixelr :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Stored_Pixel_Interface_block;

ARCHITECTURE bdf_type OF Stored_Pixel_Interface_block IS 

COMPONENT stored_master
	PORT(clk : IN STD_LOGIC;
		 clkdvi : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 DVI_newFrame : IN STD_LOGIC;
		 DVI_newLine : IN STD_LOGIC;
		 DVI_Pixelav : IN STD_LOGIC;
		 am_WaitRequest : IN STD_LOGIC;
		 am_readdatavalid : IN STD_LOGIC;
		 am_readdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 am_read : OUT STD_LOGIC;
		 am_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 am_burstcount : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 DVI_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	pixel :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 



b2v_inst : stored_master
PORT MAP(clk => clk,
		 clkdvi => DVI_CLK,
		 reset => reset,
		 DVI_newFrame => DVI_FV,
		 DVI_newLine => DVI_LV,
		 DVI_Pixelav => DVI_dataav,
		 am_WaitRequest => am_WaitRequest,
		 am_readdatavalid => am_readdatavalid,
		 am_readdata => am_readdata,
		 am_read => am_read,
		 am_address => am_address,
		 am_burstcount => am_burstcount,
		 DVI_data => pixel);

pixelb(7 DOWNTO 0) <= pixel(7 DOWNTO 0);
pixelg(7 DOWNTO 0) <= pixel(15 DOWNTO 8);
pixelr(7 DOWNTO 0) <= pixel(23 DOWNTO 16);

END bdf_type;