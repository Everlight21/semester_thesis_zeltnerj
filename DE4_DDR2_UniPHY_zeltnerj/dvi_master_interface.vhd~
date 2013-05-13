-------------------------------------------------------------------------------
-- Title      : DVI Master Interface
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dvi_master_interface.init.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-05-10
-- Last update: 2013-05-10
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Interface for QSYS
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-10  1.0      zeltnerj	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


entity dvi_master_interface is
	port (
		ClkxCI             : in  std_logic                     := '0';             --    clock_main.clk
		RstxRBI            : in  std_logic                     := '0';             --       reset_n.reset_n
		AmWaitReqxSI       : in  std_logic                     := '0';             -- avalon_master.waitrequest
		AmAddressxDO       : out std_logic_vector(31 downto 0);                    --              .address
		AmReadDataxDI      : in  std_logic_vector(15 downto 0) := (others => '0'); --              .readdata
		AmReadxSO          : out std_logic;                                        --              .read
		AmReadDataValidxSI : in  std_logic                     := '0';             --              .readdatavalid
		AmBurstCountxDO    : out std_logic_vector(7 downto 0);                     --              .burstcount
		ClkDvixCI          : in  std_logic                     := '0';             --   conduit_end.export
		DviNewLinexDI      : in  std_logic                     := '0';             --              .export
		DviNewFramexDI     : in  std_logic                     := '0';             --              .export
		DviPixelAvxSI      : in  std_logic                     := '0';             --              .export
		DviDataOutxDO      : out std_logic_vector(15 downto 0)                     --              .export
	);
end entity dvi_master_interface;

architecture rtl of dvi_master_interface is

  component dvi_master is
    port (
      ClkxCI             : in  std_logic;
      ClkDvixCI          : in  std_logic;
      RstxRBI            : in  std_logic;
      DviDataOutxDO      : out std_logic_vector(15 downto 0);
      DviNewLinexDI      : in  std_logic;
      DviNewFramexDI     : in  std_logic;
      DviPixelAvxSI      : in  std_logic;
      AmWaitReqxSI       : in  std_logic;
      AmAddressxDO       : out std_logic_vector(31 downto 0);
      AmReadDataxDI      : in  std_logic_vector(15 downto 0);
      AmReadxSO          : out std_logic;
      AmReadDataValidxSI : in  std_logic;
      AmBurstCountxDO    : out std_logic_vector(7 downto 0));
  end component dvi_master;
  
begin  -- architecture rtl

  dvi_master_1: dvi_master
    port map (
      ClkxCI             => ClkxCI,
      ClkDvixCI          => ClkDvixCI,
      RstxRBI            => RstxRBI,
      DviDataOutxDO      => DviDataOutxDO,
      DviNewLinexDI      => DviNewLinexDI,
      DviNewFramexDI     => DviNewFramexDI,
      DviPixelAvxSI      => DviPixelAvxSI,
      AmWaitReqxSI       => AmWaitReqxSI,
      AmAddressxDO       => AmAddressxDO,
      AmReadDataxDI      => AmReadDataxDI,
      AmReadxSO          => AmReadxSO,
      AmReadDataValidxSI => AmReadDataValidxSI,
      AmBurstCountxDO    => AmBurstCountxDO);

end architecture rtl;
