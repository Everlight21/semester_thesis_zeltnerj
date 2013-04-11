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

ENTITY CameraSync IS 
	port
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		cam_FV :  IN  STD_LOGIC;
		cam_LV :  IN  STD_LOGIC;
		cam_pixclk :  IN  STD_LOGIC;
		cam_pixel :  IN  STD_LOGIC_VECTOR(9 downto 0);
		dataAvailable :  OUT  STD_LOGIC;
		FV :  OUT  STD_LOGIC;
		LV :  OUT  STD_LOGIC;
		pixel :  OUT  STD_LOGIC_VECTOR(9 downto 0)
	);
END CameraSync;

ARCHITECTURE bdf_type OF CameraSync IS 

component camerasynccontroler
GENERIC (pixelBits:INTEGER);
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 fifo_empty : IN STD_LOGIC;
		 fifo_full : IN STD_LOGIC;
		 fifo_data_in : IN STD_LOGIC_VECTOR(11 downto 0);
		 fifo_nbElem : IN STD_LOGIC_VECTOR(2 downto 0);
		 fifo_read : OUT STD_LOGIC;
		 dataAvailable : OUT STD_LOGIC;
		 FV : OUT STD_LOGIC;
		 LV : OUT STD_LOGIC;
		 pixel : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
end component;

component fifosync
	PORT(wrreq : IN STD_LOGIC;
		 wrclk : IN STD_LOGIC;
		 rdreq : IN STD_LOGIC;
		 rdclk : IN STD_LOGIC;
		 aclr : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(11 downto 0);
		 rdfull : OUT STD_LOGIC;
		 rdempty : OUT STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(11 downto 0);
		 rdusedw : OUT STD_LOGIC_VECTOR(2 downto 0)
	);
end component;

signal	data :  STD_LOGIC_VECTOR(11 downto 0);
signal	empty :  STD_LOGIC;
signal	full :  STD_LOGIC;
signal	q :  STD_LOGIC_VECTOR(11 downto 0);
signal	readFifo :  STD_LOGIC;
signal	used :  STD_LOGIC_VECTOR(2 downto 0);
signal	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_0 <= '1';



b2v_inst : camerasynccontroler
GENERIC MAP(pixelBits => 10)
PORT MAP(clk => clk,
		 reset => reset,
		 fifo_empty => empty,
		 fifo_full => full,
		 fifo_data_in => q,
		 fifo_nbElem => used,
		 fifo_read => readFifo,
		 dataAvailable => dataAvailable,
		 FV => FV,
		 LV => LV,
		 pixel => pixel);

b2v_inst1 : fifosync
PORT MAP(wrreq => SYNTHESIZED_WIRE_0,
		 wrclk => cam_pixclk,
		 rdreq => readFifo,
		 rdclk => clk,
		 aclr => reset,
		 data => data,
		 rdfull => full,
		 rdempty => empty,
		 q => q,
		 rdusedw => used);

data(9 downto 0) <= cam_pixel;
data(10) <= cam_FV;
data(11) <= cam_LV;
END; 