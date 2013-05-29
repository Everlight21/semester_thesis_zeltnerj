-------------------------------------------------------------------------------
-- Title      : DVI Master Testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dvi_master_tb.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-05-13
-- Last update: 2013-05-29
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-13  1.0      zeltnerj	Created
-------------------------------------------------------------------------------

use std.textio.all;
library ieee;
use ieee.std_logic_textio.all;  -- read and write overloaded for std_logic
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.tb_util.all;
use work.configuration_pkg.all;
use work.all;
-----------------------------------------------------------------------------

entity dvi_master_tb is
  
end entity dvi_master_tb;

-------------------------------------------------------------------------------

architecture Behavioral of dvi_master_tb is

  -- declaration of model under test (MUT) and functional
  -- reference (expected response pickup)

  component dvi_master is
    port (
      ClkxCI             : in  std_logic;
      ClkDvixCI          : in  std_logic;
      RstxRBI            : in  std_logic;
      DviDataOutxDO      : out std_logic_vector(31 downto 0);
      DviNewLinexDI      : in  std_logic;
      DviNewFramexDI     : in  std_logic;
      DviPixelAvxSI      : in  std_logic;
      AmWaitReqxSI       : in  std_logic;
      AmAddressxDO       : out std_logic_vector(31 downto 0);
      AmReadDataxDI      : in  std_logic_vector(31 downto 0);
      AmReadxSO          : out std_logic;
      AmReadDataValidxSI : in  std_logic;
      AmBurstCountxDO    : out std_logic_vector(7 downto 0));
  end component dvi_master;

  signal ClkxC             : std_logic;
  signal ClkDvixC          : std_logic;
  signal RstxRB            : std_logic;
  signal DviDataOutxD      : std_logic_vector(31 downto 0);
  signal DviNewLinexD      : std_logic;
  signal DviNewFramexD     : std_logic;
  signal DviPixelAvxS      : std_logic;
  signal AmWaitReqxS       : std_logic;
  signal AmAddressxD       : std_logic_vector(31 downto 0);
  signal AmReadDataxD      : std_logic_vector(31 downto 0);
  signal AmReadxS          : std_logic;
  signal AmReadDataValidxS : std_logic;
  signal AmBurstCountxD    : std_logic_vector(7 downto 0);
  

 -- timing of clock and simulation events
  constant clk_phase_high            : time := 2.5 ns;
  constant clk_phase_low             : time := 2.5 ns;
  constant stimuli_application_time  : time := 0.5 ns;
  constant response_acquisition_time : time := 4.5 ns;
  constant resetactive_time          : time := 100 ns;

  constant clk_dvi_phase_high : time := 5 ns;
  constant clk_dvi_phase_low : time := 5 ns;
  constant lvds_stimuli_application_time  : time := 0.5 ns;
  constant lvds_response_acquisition_time : time := 9.5 ns;

  
-------------------------------------------------------------------------------
--
--            clk_period
--  <------------------------->
--  --------------            --------------
--  |  A         |        T   |            |
-- --            --------------            --------------
--  <-->
--  stimuli_application_time
--  <--------------------->
--        response_acquisition_time
-------------------------------------------------------------------------------


  signal DataRegxDP, DataRegxDN : std_logic_vector(AmReadDataxD'high downto 0) := (others => '0');
  signal PixelCounterxDP, PixelCounterxDN : integer range 0 to 2048;
  signal RowCounterxDP, RowCounterxDN : integer range 0 to 2048;
  signal BurstCounterxDP, BurstCounterxDN : integer range 0 to 127;
  signal Ones : std_logic_vector(DataRegxDP'high downto 0) := (others => '1');

  begin                                 --behavioural


  -- instantiate MUT and functional reference and connect them to the
  -- testbench signals
  -- note: any bidirectional must connect to both stimuli and responses
  -----------------------------------------------------------------------------

    dvi_master_1: dvi_master
      port map (
        ClkxCI             => ClkxC,
        ClkDvixCI          => ClkDvixC,
        RstxRBI            => RstxRB,
        DviDataOutxDO      => DviDataOutxD,
        DviNewLinexDI      => DviNewLinexD,
        DviNewFramexDI     => DviNewFramexD,
        DviPixelAvxSI      => DviPixelAvxS,
        AmWaitReqxSI       => AmWaitReqxS,
        AmAddressxDO       => AmAddressxD,
        AmReadDataxDI      => AmReadDataxD,
        AmReadxSO          => AmReadxS,
        AmReadDataValidxSI => AmReadDataValidxS,
        AmBurstCountxDO    => AmBurstCountxD);

    
  
  -- pausable clock generator with programmable mark and space widths
  -----------------------------------------------------------------------------
  -- The procedure ClockGenerator is defined in the package tb_util.
  -- This concurrent procedure call is a process that calls the procedure,
  -- with a syntax that looks like a "process instance".
  
  ClkGen : ClockGenerator(
     ClkxC        => ClkxC,	       
     clkphaselow  => clk_phase_low,     
     clkphasehigh => clk_phase_high );

  LvdsClkGen : ClockGenerator(
    ClkxC => ClkDvixC,
    clkphaselow => clk_dvi_phase_low,
    clkphasehigh => clk_dvi_phase_high);

 ------------------------------------------------------------------------------
 -- Reset generator
 ------------------------------------------------------------------------------
  ResetGen : process
  begin
    RstxRB      <= '0';
    wait for resetactive_time;
    RstxRB      <= '1';
    wait;

  end process ResetGen;


  memory: process (ClkxC, RstxRB) is
  begin  -- process memory
    if RstxRB = '0' then                -- asynchronous reset (active low)
      DataRegxDP <= (others => '0');
      PixelCounterxDP <= 0;
      RowCounterxDP <= 0;
      BurstCounterxDP <= 0;
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
      DataRegxDP <= DataRegxDN;
      PixelCounterxDP <= PixelCounterxDN;
      RowCounterxDP <= RowCounterxDN;
      BurstCounterxDP <= BurstCounterxDN;
    end if;
  end process memory;

  memory_clk_dvi: process (ClkDvixC, RstxRB) is
  begin  -- process memory_clk_dvi
    if RstxRB = '0' then                -- asynchronous reset (active low)
      
    elsif ClkDvixC'event and ClkDvixC = '1' then  -- rising clock edge
      
    end if;
  end process memory_clk_dvi;
  
  process (AmReadDataxD, AmReadxS, AmReadDataValidxS, AmWaitReqxS, DviNewLinexD, DviNewFramexD,
           DviPixelAvxS, PixelCounterxDP, RowCounterxDP, BurstCounterxDP) is
  begin  -- process

    AmReadDataValidxS <= '1';
    AmWaitReqxS <= '0';
    DviNewLinexD <= '1';
    DviNewFramexD <= '1';
    DviPixelAvxS <= '1';
    DataRegxDN <= DataRegxDP;
    PixelCounterxDN <= PixelCounterxDP;
    RowCounterxDN <= RowCounterxDP;
    BurstCounterxDN <= BurstCounterxDP;
    AmReadDataxD <= DataRegxDP;

    

    if BurstCounterxDP > 0 then
      BurstCounterxDN <= BurstCounterxDP - 1;
      PixelCounterxDN <= PixelCounterxDP + 1;
      DataRegxDN <= DataRegxDP + 1;
    elsif AmReadxS = '1' then
      BurstCounterxDN <= 127;
      PixelCounterxDN <= PixelCounterxDP + 1;
      DataRegxDN <= DataRegxDP + 1;
    else
      BurstCounterxDN <= 0;
    end if;

    if PixelCounterxDP = 2047 then
      DviNewLinexD <= '0';
      PixelCounterxDN <= 0;
      DataRegxDN <= (others => '0');
      if RowCounterxDP = 1088 then
        DviNewFramexD <= '0';
        RowCounterxDN <= 0;
      else
        RowCounterxDN <= RowCounterxDP + 1;
      end if;
    end if;

    
    --if DataRegxDP = 2047 then
    --  DataRegxDN <= (others => '0');
    --else
    --  DataRegxDN <= DataRegxDP + 1; 
    --end if;
    
    
  end process;

  
  
       

end architecture Behavioral;  
