-------------------------------------------------------------------------------
-- Title      : CMV Master Interface
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cmv_master_interface_2.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-05-09
-- Last update: 2013-07-25
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Interface for using cmv_master.vhd in QSYS
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-09  1.0      zeltnerj	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


entity cmv_master_interface is
	port (
		ClkxCI          : in  std_logic                     := '0';             --           clock_main.clk
		RstxRBI         : in  std_logic                     := '0';             --              reset_n.reset_n
		AMWritexSO      : out std_logic;                                        --        avalon_master.write
		AMWriteDataxDO  : out std_logic_vector(127 downto 0);                    --                     .writedata
		AMAddressxDO    : out std_logic_vector(31 downto 0);                    --                     .address
		AMBurstCountxSO : out std_logic_vector(7 downto 0);                     --                     .burstcount
		AMWaitReqxSI    : in  std_logic                     := '0';             --                     .waitrequest
		ClkLvdsRxxCI    : in  std_logic                     := '0';             --          conduit_end.export
		PixelValidxSI   : in  std_logic                     := '0';             --                     .export
		RowValidxSI     : in  std_logic                     := '0';             --                     .export
		FrameValidxSI   : in  std_logic                     := '0';             --                     .export
        CameraReadyxSI : in std_logic;
        DataInxDI       : in  std_logic_vector(159 downto 0) := (others => '0')  --                     .export
        );
end entity cmv_master_interface;


architecture rtl of cmv_master_interface is

  component cmv_master is
    port (
      ClkxCI          : in  std_logic;
      ClkLvdsRxxCI    : in  std_logic;
      RstxRBI         : in  std_logic;
      PixelValidxSI   : in  std_logic;
      RowValidxSI     : in  std_logic;
      FrameValidxSI   : in  std_logic;
      CameraReadyxSI  : in  std_logic;
      DataInxDI       : in  std_logic_vector(159 downto 0);
      AMWaitReqxSI    : in  std_logic;
      AMAddressxDO    : out std_logic_vector(31 downto 0);
      AMWriteDataxDO  : out std_logic_vector(127 downto 0);
      AMWritexSO      : out std_logic;
      AMBurstCountxSO : out std_logic_vector(7 downto 0));
  end component cmv_master;
  
begin  -- architecture rtl

  cmv_master_1: cmv_master
    port map (
      ClkxCI          => ClkxCI,
      ClkLvdsRxxCI    => ClkLvdsRxxCI,
      RstxRBI         => RstxRBI,
      PixelValidxSI   => PixelValidxSI,
      RowValidxSI     => RowValidxSI,
      FrameValidxSI   => FrameValidxSI,
      CameraReadyxSI => CameraReadyxSI,
      DataInxDI       => DataInxDI,
      AMWaitReqxSI    => AMWaitReqxSI,
      AMAddressxDO    => AMAddressxDO,
      AMWriteDataxDO  => AMWriteDataxDO,
      AMWritexSO      => AMWritexSO,
      AMBurstCountxSO => AMBurstCountxSO);

  

end architecture rtl;
