-------------------------------------------------------------------------------
-- Title      : Testbench for CMV master
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cmv_master_tb.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-05-03
-- Last update: 2013-05-23
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-03  1.0      zeltnerj	Created
-------------------------------------------------------------------------------



use std.textio.all;
library ieee;
use ieee.std_logic_textio.all;  -- read and write overloaded for std_logic
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_util.all;
use work.configuration_pkg.all;
use work.all;
-----------------------------------------------------------------------------

entity cmv_master_tb is
  -- a testbench does not connect to any higher level of hierarchy
end cmv_master_tb;

-------------------------------------------------------------------------------

architecture Behavioral of cmv_master_tb is

  -- declaration of model under test (MUT) and functional
  -- reference (expected response pickup)
  component cmv_master is
    port (
      ClkxCI          : in  std_logic;
      ClkLvdsRxxCI    : in  std_logic;
      RstxRBI         : in  std_logic;
      PixelValidxSI   : in  std_logic;
      RowValidxSI     : in  std_logic;
      FrameValidxSI   : in  std_logic;
      DataInxDI       : in  std_logic_vector(159 downto 0);
      AMWaitReqxSI    : in  std_logic;
      AMAddressxDO    : out std_logic_vector(31 downto 0);
      AMWriteDataxDO  : out std_logic_vector(127 downto 0);
      AMWritexSO      : out std_logic;
      AMBurstCountxSO : out std_logic_vector(7 downto 0));
  end component cmv_master;

  signal ClkxC          : std_logic;
  signal ClkLvdsRxxC    : std_logic;
  signal RstxRB         : std_logic;
  signal PixelValidxS   : std_logic;
  signal RowValidxS     : std_logic;
  signal FrameValidxS   : std_logic;
  signal DataInxD       : std_logic_vector(159 downto 0);
  signal AMWaitReqxS    : std_logic;
  signal AMAddressxD    : std_logic_vector(31 downto 0);
  signal AMWriteDataxD  : std_logic_vector(127 downto 0);
  signal AMWritexS      : std_logic;
  signal AMBurstCountxS : std_logic_vector(7 downto 0);
  
  

  -- timing of clock and simulation events
  constant clk_phase_high            : time := 5 ns;
  constant clk_phase_low             : time := 5 ns;
  constant stimuli_application_time  : time := 1 ns;
  constant response_acquisition_time : time := 9 ns;
  constant resetactive_time          : time := 100 ns;

  constant clk_lvds_phase_high : time := 25 ns;
  constant clk_lvds_phase_low : time := 25 ns;
  constant lvds_stimuli_application_time  : time := 1 ns;
  constant lvds_response_acquisition_time : time := 49 ns;

  
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

  signal PixelValidCounterxDP, PixelValidCounterxDN : integer range 0 to 2048;
  signal FrameValidCounterxDP, FrameValidCounterxDN : integer range 0 to 2048*1088;
  signal DataCounterxDP, DataCounterxDN : integer;
  signal TogglexDP, TogglexDN : integer range 0 to 2;
  signal Zeros : std_logic_vector(DataInxD'high downto 0) := (others => '0');
  signal DataRegxDP, DataRegxDN : unsigned(DataInxD'high downto 0) := (others => '0');
  
  

  begin                                 --behavoural


  -- instantiate MUT and functional reference and connect them to the
  -- testbench signals
  -- note: any bidirectional must connect to both stimuli and responses
  -----------------------------------------------------------------------------


    cmv_master_1: cmv_master
      port map (
        ClkxCI          => ClkxC,
        ClkLvdsRxxCI    => ClkLvdsRxxC,
        RstxRBI         => RstxRB,
        PixelValidxSI   => PixelValidxS,
        RowValidxSI     => RowValidxS,
        FrameValidxSI   => FrameValidxS,
        DataInxDI       => DataInxD,
        AMWaitReqxSI    => AMWaitReqxS,
        AMAddressxDO    => AMAddressxD,
        AMWriteDataxDO  => AMWriteDataxD,
        AMWritexSO      => AMWritexS,
        AMBurstCountxSO => AMBurstCountxS);

  
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
    ClkxC => ClkLvdsRxxC,
    clkphaselow => clk_lvds_phase_low,
    clkphasehigh => clk_lvds_phase_high);
  
  -- reset geerashen
  -----------------------------------------------------------------------------
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
      
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
     
    end if;
  end process memory;

  memory_clk_lvds: process (ClkLvdsRxxC, RstxRB) is
  begin  -- process memory_clk_lvds
    if RstxRB = '0' then                -- asynchronous reset (active low)
      TogglexDP <= 0;
      PixelValidCounterxDP <= 0;
      FrameValidCounterxDP <= 0;
      DataCounterxDP <= 0;
      DataRegxDP <= (others => '0');
    elsif ClkLvdsRxxC'event and ClkLvdsRxxC = '1' then  -- rising clock edge
      TogglexDP <= TogglexDN;
      PixelValidCounterxDP <= PixelValidCounterxDN;
      FrameValidCounterxDP <= FrameValidCounterxDN;
      DataCounterxDP <= DataCounterxDN;
      DataRegxDP <= DataRegxDN;
    end if;
  end process memory_clk_lvds;


  process (PixelValidCounterxDP, FrameValidCounterxDP, TogglexDP, DataRegxDP) is
  begin  -- process

    
    if PixelValidCounterxDP = 0 then
      PixelValidxS <= '0';
      PixelValidCounterxDN <= PixelValidCounterxDP + 16;
      FrameValidxS <= '0';
    else
      PixelValidxS <= '1';
      FrameValidxS <= '1';
      if PixelValidCounterxDP = 2048 then
        PixelValidCounterxDN <= 0;
        if FrameValidCounterxDP = 1087 then
          FrameValidCounterxDN <= 0;
        else
          FrameValidCounterxDN <= FrameValidCounterxDP + 1;
        end if;
      else
        PixelValidCounterxDN <= PixelValidCounterxDP + 16;
      end if;
     
      
    end if;

    
    --PixelValidxS <= '1';
    RowValidxS <= '1';
    --FrameValidxS <= '1';
    AMWaitReqxS <= '0';
    DataRegxDN <= (others => '0');
    if TogglexDP = 2 then
      TogglexDN <= 0;
    else
      TogglexDN <= TogglexDP + 1;
    end if;

    DataRegxDN <= DataRegxDP(DataRegxDP'high-1 downto 0) & '1';
    --DataRegxDN <= DataRegxDP + 1;
    DataInxD <= std_logic_vector(DataRegxDP); 

    --if TogglexDP = 0 then
    --  DataInxD <= (others => '0');
    --elsif TogglexDP = 1 then
    --  DataInxD <= (others => '1');
    --else
    --  DataInxD <= (DataInxD'high downto 2 => '1') & "00";
    --end if;
    
    
  end process;
  

 

  
 
               

end architecture Behavioral;  
