-------------------------------------------------------------------------------
-- Title      : Testbench for LVDS Synchroiyation Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lvds_sync_controller_tb.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-18
-- Last update: 2013-03-18
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
      FrameReqInxSI       : in  std_logic;
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
  
   -- If there are multiple architectures compiled in the directory 
   --   for all : acacia use entity work.acacia(structural);
-------------------------------------------------------------------------------
  
  -- declarations of all those signals that do connect to the MUT
  -- most of them are collected in records to facilitate data handling

  type stimuliRecordType is record
    LVDSDataxD : std_logic_vector(lvdsDataWidth-1 downto 0);
    PixelChannel1xD : std_logic_vector(channelWidth-1 downto 0);
    AlignxS : std_logic_vector(noOfDataChannels downto 0);
  end record stimuliRecordType;

  --type respRecordType is record         --record for actual/expected responses
  --      PixelChannel1xD : std_logic_vector(channelWidth-1 downto 0);
  --      AlignxS : std_logic_vector(noOfDataChannels downto 0);
  --end record respRecordType;

  type mutRecordType is record
   DataOutxD : std_logic_vector(channelWidth-1 downto 0);
   ButtonxS : std_logic_vector(3 downto 0);
   FrameReqInxS : std_logic;
   FrameReqOutxS : std_logic;
   PixelValidxS : std_logic;
   RowValidxS :  std_logic;
   FrameValidxS : std_logic;
   LedxS : std_logic_vector(7 downto 0);
  end record mutRecordType;


  signal ActResponsDataxD   : std_logic_vector(channelWidth-1 downto 0);

  signal ClkxC            : std_logic := '1';    -- driving clock
  signal RstxRB           : std_logic := '0';    -- reset
  signal StimuliRecxD     : stimuliRecordType;   -- record of stimuli and expected responses
  signal ActMutRecxD      : mutRecordType;       -- record of the mut signals
--  signal ActRespRecxD     : respRecordType;      -- record of actual responses



  -- timing of clock and simulation events
  constant clk_phase_high            : time := 5 ns;
  constant clk_phase_low             : time := 5 ns;
  constant stimuli_application_time  : time := 1 ns;
  constant response_acquisition_time : time := 9 ns;
  constant resetactive_time          : time := 0.5 ns;
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


  -- declaration of stimuli, expected responses, and simulation report files
  constant stimuli_filename : string := "simvectors/stimuli_lvds_sync_controller.txt";
  constant simrept_filename : string := "simvectors/lvds_sync_controller.rpt";

  -- the files are opened implicitly right here
  file stimulifile : text open read_mode  is stimuli_filename;
  file simreptfile : text open write_mode is simrept_filename;

-------------------------------------------------------------------------------

    -- purpose: get one record worth of stimuli from file.
  impure function GetStimuliRecord (file stimulifile : text)
    return stimuliRecordType
  is
    variable in_line, in_line_tmp : line;
    -- stimuli to default to unknown in case no value is obtained from file
    variable stimulirecord : stimuliRecordType := 
            (
              LVDSDataxD => (others => 'X'),
              PixelChannel1xD => (others => 'X'),
              AlignxS => (others => 'X')
             );
  begin
    -- read a line from the stimuli file
    -- skipping any empty and comment lines encountered
    loop
      readline(stimulifile, in_line);
      -- copy line read to enable meaningful error messages later
      in_line_tmp := new string'(in_line(in_line'low to in_line'high));
      if in_line_tmp'length >= 1 then
        exit when in_line_tmp(1) /= '%';
      end if;
      deallocate(in_line_tmp);
    end loop;
    -- extract all values of a record of stimuli
    GetFileEntry
       (stimulirecord.LVDSDataxD, in_line, in_line_tmp, stimuli_filename);
    GetFileEntry
       (stimulirecord.PixelChannel1xD, in_line, in_line_tmp, stimuli_filename);
     GetFileEntry
       (stimulirecord.AlignxS, in_line, in_line_tmp, stimuli_filename);
    deallocate(in_line_tmp);
    return stimulirecord;
  end GetStimuliRecord;

-------------------------------------------------------------------------------
  
  -- purpose: writing stimuli and actual responses to the report file.
  procedure PutSimulationReportTrace
    (file simreptfile :    text;
     stimuliRecord    : in stimuliRecordType;
     actResp          : in std_logic_vector(channelWidth-1 downto 0);
     simRepLineCount  : inout natural)
  is
    constant N        : natural := 60;
    variable out_line : line;
  begin
    -- every N-th line, [re]write the signal caption to the simulation report
    if simRepLineCount mod N = 0 then
      write(out_line, 
        string'("Time    "));
      write(out_line, ht);
      write(out_line, string'("LVDSDataxD"));
      writeline(simreptfile, out_line);
    end if;
    simRepLineCount := simRepLineCount + 1;
    
    -- begin with simulation time
    write(out_line, string'("at "));
    write(out_line, now);
    -- add stimuli
    write(out_line, ht);
    write(out_line, stimuliRecord.LVDSDataxD, 1);
    write(out_line, ht);
    -- add actual response 
    write(out_line, actResp, 1);
    
    -- write the output line to the report file
    writeline(simreptfile, out_line);
  end PutSimulationReportTrace;


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
      LVDSDataxDI       => StimuliRecxD.LVDSDataxD,
      ButtonxSI         => ActMutRecxD.ButtonxS,
      FrameReqInxSI       => ActMutRecxD.FrameReqInxS,
      AlignxSO          => StimuliRecxD.AlignxS,
      PixelChannel1xDO  => StimuliRecxD.PixelChannel1xD,
      PixelChannel5xDO  => StimuliRecxD.PixelChannel1xD ,
      PixelChannel9xDO  => StimuliRecxD.PixelChannel1xD ,
      PixelChannel13xDO => StimuliRecxD.PixelChannel1xD,
      FrameReqOutxSO       => ActMutRecxD.FrameReqOutxS,
      PixelValidxSO     => ActMutRecxD.PixelValidxS,
      RowValidxSO       => ActMutRecxD.RowValidxS,
      FrameValidxSO     => ActMutRecxD.FrameValidxS,
      LedxSO            => ActMutRecxD.LedxS);
  
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


  -- acquire actual response from MUT and have it checked
  -----------------------------------------------------------------------------
  AppliAcquiTb : process
    
    -- variables for accounting of mismatching responses
    variable respmatch : respmatchtype;
    variable respaccount : respaccounttype := (0, 0, 0, 0, 0, 0);
    variable simRepLineCount  : natural := 0;  -- variable for counting the lines written to the simulation report
    variable StimJunkCount    : integer := 0;  -- variable for the counting stimuli junk

  begin
   
    ActMutRecxD.FrameReqInxS <= '0';
    
    AcquiLoop : while not (endfile(stimulifile)) loop

      --appli stimulis
      -------------------------------------------------------------------------
     -- if not (DataInReqxS = '1' and DataInAckxS = '1') then
        --wait until ClkxC'event and ClkxC = '1';
        --else
        -- in burst mode (i.e. req=1 and ack=1),
        -- don't wait but apply new data directly after stimuli_application_time
      --end if
        -- wait until time has come for stimulus application
        wait for stimuli_application_time;
        StimuliRecxD <= GetStimuliRecord(stimulifile);
       --stimulicnt <= stimulicnt+1;
    --  ActMutRecxD.DataInReqxS   <= '1';
      wait until ClkxC'event and ClkxC = '1';
      wait for stimuli_application_time;
      -------------------------------------------------------------------------
        
      --get actual response
      -------------------------------------------------------------------------
      wait until ClkxC'event and ClkxC = '1';
      wait for response_acquisition_time;  -- wait until the right time
    

        -- valid output data
        ActResponsDataxD <= ActMutRecxD.DataOutxD;

                 
      -------------------------------------------------------------------------

      -- add a trace line to report file
      PutSimulationReportTrace(simreptfile, StimuliRecxD, ActResponsDataxD, simRepLineCount);
      
      -- compare the actual with the expected responses
      CheckValue(ActResponsDataxD, StimuliRecxD.LVDSDataxD,
                  respmatch, respaccount);
      PutSimulationReportFailure(simreptfile,"PixelChannel1xD - ", StimuliRecxD.LVDSDataxD, respmatch, 1);

    end loop AcquiLoop;

    -- when the present clock cycle is the final one of this run
    -- then establish a simulation report summary and write it to file and simulater
    PutSimulationReportSummary(simreptfile, respaccount);
    PutSimulationReportSummary(output, respaccount);
    -- tell clock generator to stop at the end of current cycle
    -- because stimuli have been exhausted
    EndOfSimxS <= true;
    -- close the file
    file_close(simreptfile);
    file_close(stimulifile);
    report "Simulation run completed!";
    wait;    
  end process AppliAcquiTb;

end architecture Behavioral;  -- of aes_top_tb
