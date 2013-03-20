-------------------------------------------------------------------------------
-- Title      : Testbench for LVDS Synchroiyation Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lvds_sync_controller_tb.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-18
-- Last update: 2013-03-20
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-03-18  1.0      zeltnerj	Created
-------------------------------------------------------------------------------

use std.textio.all;
library ieee;
use ieee.std_logic_textio.all;  -- read and write overloaded for std_logic
use ieee.std_logic_1164.all;
use work.tb_util.all;
use work.configuration_pkg.all;
use work.all;
-----------------------------------------------------------------------------

entity lvds_sync_controller_tb is
  -- a testbench does not connect to any higher level of hierarchy
end lvds_sync_controller_tb;

-------------------------------------------------------------------------------

architecture Behavioral of lvds_sync_controller_tb is

  -- declaration of model under test (MUT) and functional
  -- reference (expected response pickup)


  component lvds_sync_controller is
    port (
      ClkxCI            : in  std_logic;
      RstxRBI           : in  std_logic;
      LVDSDataxDI       : in  std_logic_vector(lvdsDataWidth-1 downto 0);
      ButtonxSI         : in  std_logic_vector (3 downto 0);
      FrameReqInxS      : in  std_logic;
      AlignxSO          : out std_logic_vector(noOfDataChannels downto 0);
      PixelChannel1xDO  : out std_logic_vector(channelWidth-1 downto 0);
      PixelChannel5xDO  : out std_logic_vector(channelWidth-1 downto 0);
      PixelChannel9xDO  : out std_logic_vector(channelWidth-1 downto 0);
      PixelChannel13xDO : out std_logic_vector(channelWidth-1 downto 0);
      FrameReqOutxSO       : out std_logic;
      PixelValidxSO     : out std_logic;
      RowValidxSO       : out std_logic;
      FrameValidxSO     : out std_logic;
      LedxSO            : out std_logic_vector(7 downto 0));
  end component lvds_sync_controller;
  
 
  signal ClkxC            : std_logic;
  signal RstxRB           : std_logic;
  signal LVDSDataxD       : std_logic_vector(lvdsDataWidth-1 downto 0);
  signal ButtonxS         : std_logic_vector (3 downto 0);
  signal FrameReqInxS     : std_logic;
  signal AlignxS          : std_logic_vector(noOfDataChannels downto 0);
  signal PixelChannel1xD  : std_logic_vector(channelWidth-1 downto 0);
  signal PixelChannel5xD  : std_logic_vector(channelWidth-1 downto 0);
  signal PixelChannel9xD  : std_logic_vector(channelWidth-1 downto 0);
  signal PixelChannel13xD : std_logic_vector(channelWidth-1 downto 0);
  signal FrameReqOutxS    : std_logic;
  signal PixelValidxS     : std_logic;
  signal RowValidxS       : std_logic;
  signal FrameValidxS     : std_logic;
  signal LedxS            : std_logic_vector(7 downto 0);


  -- reverse order because of parallel to serial converter block
  type parallelInType is array (0 to noOfDataChannels) of std_logic_vector(channelWidth-1 downto 0);
  signal DataInxDP, DataInxDN : parallelInType;

  -----------------------------------------------------------------------------
  -- counters
  -----------------------------------------------------------------------------
  signal TogglexSP, TogglexSN : std_logic := '0';
  

  -- timing of clock and simulation events
  constant clk_phase_high            : time := 5 ns;
  constant clk_phase_low             : time := 5 ns;
  constant stimuli_application_time  : time := 1 ns;
  constant response_acquisition_time : time := 9 ns;
  constant resetactive_time          : time := 5 ns;
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


  begin                                 --behavoural


  -- instantiate MUT and functional reference and connect them to the
  -- testbench signals
  -- note: any bidirectional must connect to both stimuli and responses
  -----------------------------------------------------------------------------



    lvds_sync_controller_1: entity work.lvds_sync_controller
      port map (
        ClkxCI            => ClkxC,
        RstxRBI           => RstxRB,
        LVDSDataxDI       => LVDSDataxD,
        ButtonxSI         => ButtonxS,
        FrameReqInxSI     => FrameReqInxS,
        AlignxSO          => AlignxS,
        PixelChannel1xDO  => PixelChannel1xD,
        PixelChannel5xDO  => PixelChannel5xD,
        PixelChannel9xDO  => PixelChannel9xD,
        PixelChannel13xDO => PixelChannel13xD,
        FrameReqOutxSO    => FrameReqOutxS,
        PixelValidxSO     => PixelValidxS,
        RowValidxSO       => RowValidxS,
        FrameValidxSO     => FrameValidxS,
        LedxSO            => LedxS);
  
  -- pausable clock generator with programmable mark and space widths
  -----------------------------------------------------------------------------
  -- The procedure ClockGenerator is defined in the package tb_util.
  -- This concurrent procedure call is a process that calls the procedure,
  -- with a syntax that looks like a "process instance".
  
  ClkGen : ClockGenerator(
     ClkxC        => ClkxC,	       
     clkphaselow  => clk_phase_low,     
     clkphasehigh => clk_phase_high );
  
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
      ButtonxS <= (others => '1');
      FrameReqInxS <= '1';
      DataInxDP(0) <= b"00_0000_1000";
      DataInxDP(1) <= b"00_0000_1000";
      DataInxDP(2) <= b"00_0000_0100";
      DataInxDP(3) <= b"00_0000_0010";
      DataInxDP(4) <= b"00_0000_0001";

      TogglexSP <= '0';
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
      DataInxDP <= DataInxDN;
      TogglexSP <= TogglexSN;
    end if;
  end process memory;

  LVDSDataxD <= DataInxDP(4)&DataInxDP(3)&DataInxDP(2)&DataInxDP(1)&DataInxDP(0);

  process (AlignxS, DataInxDP,TogglexSP) is
  begin  -- process

    DataInxDN <= DataInxDP;
    
    for i in 0 to noOfDataChannels loop
      if AlignxS(i) = '1' then
        DataInxDN(i) <= DataInxDP(i)(0) & DataInxDP(i)(channelWidth-1 downto 1);
      else
        DataInxDN(i) <= DataInxDP(i);
      end if;
    end loop;  -- i

    if TogglexSP = '1' then
      DataInxDN(0)(9) <= '1';
    else
      DataInxDN(0)(9) <= '0';
    end if;
    
    TogglexSN <= not TogglexSP;
    
  end process;

 

  
 
               

end architecture Behavioral;  
