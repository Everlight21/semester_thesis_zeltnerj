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
-- CREATED		"Fri Dec 21 14:25:13 2012"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Camera_Interface_block IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		am_WaitRequest :  IN  STD_LOGIC;
		clkcamera :  IN  STD_LOGIC;
		cam_dataav :  IN  STD_LOGIC;
		cam_FV :  IN  STD_LOGIC;
		cam_LV :  IN  STD_LOGIC;
		channel_1 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		channel_2 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		channel_3 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		channel_4 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		channel_5 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		channel_6 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		channel_7 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		channel_8 :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		am_write :  OUT  STD_LOGIC;
		am_address :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		am_burstcount :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		am_dataWrite :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END Camera_Interface_block;

ARCHITECTURE bdf_type OF Camera_Interface_block IS 

COMPONENT camera_master_part
	PORT(clk : IN STD_LOGIC;
		 clkcamera : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 am_WaitRequest : IN STD_LOGIC;
		 camInt_newData : IN STD_LOGIC;
		 camInt_newFrame : IN STD_LOGIC;
		 camInt_newLine : IN STD_LOGIC;
		 camInt_data1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 camInt_data2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 camInt_data3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 camInt_data4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 camInt_data5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 camInt_data6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 camInt_data7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 camInt_data8 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 am_write : OUT STD_LOGIC;
		 am_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 am_burstcount : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 am_dataWrite : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	cam1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	cam2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	cam3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	cam4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	cam5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	cam6 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	cam7 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	cam8 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 



b2v_inst1 : camera_master_part
PORT MAP(clk => clk,
		 clkcamera => clkcamera,
		 reset => reset,
		 am_WaitRequest => am_WaitRequest,
		 camInt_newData => cam_dataav,
		 camInt_newFrame => cam_FV,
		 camInt_newLine => cam_LV,
		 camInt_data1 => cam1,
		 camInt_data2 => cam2,
		 camInt_data3 => cam3,
		 camInt_data4 => cam4,
		 camInt_data5 => cam5,
		 camInt_data6 => cam6,
		 camInt_data7 => cam7,
		 camInt_data8 => cam8,
		 am_write => am_write,
		 am_address => am_address,
		 am_burstcount => am_burstcount,
		 am_dataWrite => am_dataWrite);

cam1 <= channel_1;
cam2 <= channel_2;
cam3 <= channel_3;
cam4 <= channel_4;
cam5 <= channel_5;
cam6 <= channel_6;
cam7 <= channel_7;
cam8 <= channel_8;

END bdf_type;