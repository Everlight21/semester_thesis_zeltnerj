-------------------------------------------------------------------------------
-- Title      : LVDS Synchronization Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lvds_sync_controller.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-15
-- Last update: 2013-05-09
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: This entity synchronizes the image sensor output with the
--              receiving components.
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-03-15  1.0      zeltnerj    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

library work;
use work.configuration_pkg.all;


entity lvds_sync_controller is

  port (
    ClkxCI              : in  std_logic;
    RstxRBI             : in  std_logic;
    -- lvds signal enter in reversed order, e.g. DVAL bit is Bit [9] not Bit [0]
    --LVDSDataxDI         : in  std_logic_vector(lvdsDataWidth-1 downto 0);
    LVDSDataxDI         : in  std_logic_vector((8+1)*channelWidth-1 downto 0);
    ButtonxSI           : in  std_logic_vector (3 downto 0);
    FrameReqInxSI       : in  std_logic;
    AlignxSO            : out std_logic_vector(9-1 downto 0);
    PixelDataxDO        : out std_logic_vector(79 downto 0);
    FrameReqOutxSO      : out std_logic;
    PixelValidxSO       : out std_logic;
    RowValidxSO         : out std_logic;
    FrameValidxSO       : out std_logic;
    LedxSO              : out std_logic_vector(7 downto 0);
    NoOfDataChannelsxDI : in  std_logic_vector(3 downto 0));


end entity lvds_sync_controller;

architecture behavioral of lvds_sync_controller is
  -----------------------------------------------------------------------------
  -- interconnection signals
  -----------------------------------------------------------------------------
  signal ClkxC                            : std_logic;
  signal RstxRB                           : std_logic;
  signal LVDSDataxD                       : std_logic_vector(LVDSDataxDI'high downto 0);
  signal ButtonxS                         : std_logic_vector (3 downto 0);
  signal FrameReqInxS                     : std_logic;
  signal FrameReqOutxS                    : std_logic := '0';
  signal AlignxS                          : std_logic_vector(AlignxSO'high downto 0);
  signal PixelValidxS                     : std_logic;
  signal RowValidxS                       : std_logic;
  signal FrameValidxS                     : std_logic;
  signal LedxS                            : std_logic_vector(7 downto 0);
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- DataOutput
  -----------------------------------------------------------------------------
  signal PixelDataxD                      : std_logic_vector(PixelDataxDO'high downto 0);
  -----------------------------------------------------------------------------
  -- Pixel Channel type and signal declaration
  -----------------------------------------------------------------------------
  type channelArray is array (0 to 8) of std_logic_vector(channelWidth-1 downto 0);
  signal PixelChannelxD                   : channelArray;
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- FSM type and signal declaration
  -----------------------------------------------------------------------------
  type fsmState is (resetDelay, initCtr, pulseChannelDataAlign, idle, streamingData, checkTrainingPattern, alignData);  -- states
  signal StatexDP, StatexDN               : fsmState;  -- state register
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- counters
  -----------------------------------------------------------------------------
  signal InitCounterxDP, InitCounterxDN   : integer range 0 to 64000;
  signal DelayCounterxDP, DelayCounterxDN : integer range 0 to 64000;

  -----------------------------------------------------------------------------
  -- control signals
  -----------------------------------------------------------------------------
  signal InitReadyxS : std_logic;
  signal CameraReadyxSP, CameraReadyxSN : std_logic;
  signal AlignxDP, AlignxDN             : std_logic;


  --signal test : std_logic_vector(conv_integer(NoOfDataChannelsxDI-1) downto 0) := NoOfDataChannelsxDI;


begin  -- architecture behavioral
  -------------------------------------------------------------------------------
  -- interconnections
  -------------------------------------------------------------------------------
  ClkxC             <= ClkxCI;
  RstxRB            <= RstxRBI;
  LVDSDataxD        <= LVDSDataxDI(LVDSDataxDI'high downto 0);
  ButtonxS          <= ButtonxSI;
  FrameReqInxS      <= FrameReqInxSI;
  AlignxSO          <= AlignxS;
  PixelDataxDO      <= PixelDataxD;
  FrameReqOutxSO    <= FrameReqInxS and CameraReadyxSP;
  PixelValidxSO     <= PixelValidxS;
  RowValidxSO       <= RowValidxS;
  FrameValidxSO     <= FrameValidxS;
  LedxSO            <= LedxS;
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- control signals
  -----------------------------------------------------------------------------
  InitReadyxS <= NoOfDataChannelsxDI(0);

  
  -----------------------------------------------------------------------------
  -- lvds data channel signals
  -----------------------------------------------------------------------------
  -- split lvds data input into appropriate amount of data channels and
  -- reverse bit order to match bit order described in datasheet
  -- see CMV2000/4000 datasheet for reference

 
  -- control channel
  PixelChannelxD(0) <= reverseBitOrder(LVDSDataxD(channelWidth*1-1 downto 0));
  -- data channels
  PixelChannelxD(1) <= reverseBitOrder(LVDSDataxD(channelWidth*2-1 downto channelWidth*1));
  PixelChannelxD(2) <= reverseBitOrder(LVDSDataxD(channelWidth*3-1 downto channelWidth*2));
  PixelChannelxD(3) <= reverseBitOrder(LVDSDataxD(channelWidth*4-1 downto channelWidth*3));
  PixelChannelxD(4) <= reverseBitOrder(LVDSDataxD(channelWidth*5-1 downto channelWidth*4));
  PixelChannelxD(5) <= reverseBitOrder(LVDSDataxD(channelWidth*6-1 downto channelWidth*5));
  PixelChannelxD(6) <= reverseBitOrder(LVDSDataxD(channelWidth*7-1 downto channelWidth*6));
  PixelChannelxD(7) <= reverseBitOrder(LVDSDataxD(channelWidth*8-1 downto channelWidth*7));
  PixelChannelxD(8) <= reverseBitOrder(LVDSDataxD(channelWidth*9-1 downto channelWidth*8));
  --PixelChannelxD(9) <= reverseBitOrder(LVDSDataxD(channelWidth*10-1 downto channelWidth*9));
  --PixelChannelxD(10) <= reverseBitOrder(LVDSDataxD(channelWidth*11-1 downto channelWidth*10));
  --PixelChannelxD(11) <= reverseBitOrder(LVDSDataxD(channelWidth*12-1 downto channelWidth*11));
  --PixelChannelxD(12) <= reverseBitOrder(LVDSDataxD(channelWidth*13-1 downto channelWidth*12));
  --PixelChannelxD(13) <= reverseBitOrder(LVDSDataxD(channelWidth*14-1 downto channelWidth*13));
  --PixelChannelxD(14) <= reverseBitOrder(LVDSDataxD(channelWidth*15-1 downto channelWidth*14));
  --PixelChannelxD(15) <= reverseBitOrder(LVDSDataxD(channelWidth*16-1 downto channelWidth*15));
  --PixelChannelxD(16) <= reverseBitOrder(LVDSDataxD(channelWidth*17-1 downto channelWidth*16));

  -----------------------------------------------------------------------------
  -- Pixel Data Output
  -----------------------------------------------------------------------------
  -- purpose: maps pixel data to output signal
  -- type   : combinational
  -- inputs : PixelChannelxD
  -- outputs: PixelDataxD
  output_signal_mapping: process (PixelChannelxD) is
  begin  -- process output_signal_mapping
    for i in 1 to 8 loop
      if i <= noOfDataChannels then
        PixelDataxD(channelWidth*i-1 downto channelWidth*(i-1)) <= PixelChannelxD(i);
      else
        PixelDataxD(channelWidth*i-1 downto channelWidth*(i-1)) <= (others => '0');
      end if;
      
    end loop;  -- i
  end process output_signal_mapping;
  
  -----------------------------------------------------------------------------
  -- lvds control channel signals
  -----------------------------------------------------------------------------
  -- read out control signals, see CMV2000/4000 datasheet for reference
  PixelValidxS <= PixelChannelxD(0)(0);  -- DVAL
  RowValidxS   <= PixelChannelxD(0)(1);  -- LVAL
  FrameValidxS <= PixelChannelxD(0)(2);  -- RVAL
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- LED Outputs (leds are inverted)
  -----------------------------------------------------------------------------
  --LedxS(0) <= CameraReadyxSP;
  --LedxS(1) <= FrameReqInxS;
  --LedxS(2) <= PixelValidxS;
  --LedxS(3) <= FrameValidxS;
  --LedxS(4) <= '1' when StatexDP = idle else
  --            '0';
  --LedxS(5) <= '1' when StatexDP = pulseChannelDataAlign else
  --            '0';
  --LedxS(6) <= '1' when StatexDP = initCtr else
  --            '0';
  --LedxS(7) <= AlignxS(0);

  LedxS(0) <= PixelChannelxD(0)(0);
  LedxS(1) <= PixelChannelxD(0)(1);
  LedxS(2) <= PixelChannelxD(0)(2);
  LedxS(3) <= PixelChannelxD(0)(3);
  LedxS(4) <= PixelChannelxD(0)(4);
  LedxS(5) <= PixelChannelxD(0)(5);
  LedxS(6) <= PixelChannelxD(0)(8);
  LedxS(7) <= PixelChannelxD(0)(9);

  --LedxS(3 downto 0) <= NoOfDataChannelsxDI;
  --LedxS(4)          <= '0';
  --LedxS(5)          <= '0';
  --LedxS(6)          <= '0';
  --LedxS(7)          <= '0';

  -----------------------------------------------------------------------------
  -- Register update process
  -----------------------------------------------------------------------------
  memory : process (ClkxC, RstxRB) is
  begin  -- process memory
    if RstxRB = '0' then                    -- asynchronous reset (active low)
      StatexDP        <= resetDelay;
      InitCounterxDP  <= 0;
      DelayCounterxDP <= 0;
      CameraReadyxSP  <= '0';
      AlignxDP        <= '0';
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
      StatexDP        <= StatexDN;
      InitCounterxDP  <= InitCounterxDN;
      DelayCounterxDP <= DelayCounterxDN;
      CameraReadyxSP  <= CameraReadyxSN;
      AlignxDP        <= AlignxDN;
    end if;
  end process memory;

  -----------------------------------------------------------------------------
  -- FSM
  -----------------------------------------------------------------------------
  -- purpose: checks if incoming stream of data is correctly aligned and corrects the alignement if not
  -- type   : combinational
  -- inputs : 
  -- outputs: 
  fsm : process (AlignxS, ButtonxS, CameraReadyxSP, InitCounterxDP, DelayCounterxDP,
                 PixelChannelxD, StatexDP, AlignxDP) is
  begin  -- process fsm
    StatexDN        <= StatexDP;
    InitCounterxDN  <= InitCounterxDP;
    DelayCounterxDN <= DelayCounterxDP;
    CameraReadyxSN  <= CameraReadyxSP;
    AlignxS         <= (others => '0');

    case StatexDP is

      when resetDelay =>
        if InitReadyxS = '1' then
          StatexDN <= initCtr;
        end if;

      when initCtr =>
        if InitCounterxDP < 10 then
          -- if PixelChannelxD(0)(9) = trainingPattern(15) and PixelChannelxD(0)(8) = trainingPattern(14) then
          if PixelChannelxD(0)(9) = '1' and PixelChannelxD(0)(8) = '0' then
            InitCounterxDN <= InitCounterxDP + 1;
          else
            InitCounterxDN <= 0;
            AlignxS(0)     <= '1';
            StatexDN       <= pulseChannelDataAlign;
          end if;
        else
          CameraReadyxSN <= '1';
          StatexDN       <= idle;
        end if;

      when pulseChannelDataAlign =>
        if CameraReadyxSP = '0' then
          StatexDN <= initCtr;
        else
          StatexDN <= idle;
        end if;

      when idle =>

        if PixelChannelxD(0)(0) = '0' then
          for i in 1 to noOfDataChannels loop
            if PixelChannelxD(i)(9) /= '1' or PixelChannelxD(i)(8) /= '0' then
              AlignxS(i) <= '1';
              StatexDN <= pulseChannelDataAlign;
            end if;
          end loop;  -- i
        end if;
        

        for i in 0 to 3 loop
          if ButtonxS(i) = '0' then
            AlignxS(i+1) <= '1';
          end if;
        end loop;  -- i
        
      when others => null;
                     
    end case;
    
  end process fsm;


end architecture behavioral;


