-------------------------------------------------------------------------------
-- Title      : LVDS Synchronization Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lvds_sync_controller.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-15
-- Last update: 2013-04-23
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
-- 2013-03-15  1.0      zeltnerj	Created
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
    ClkxCI           : in  std_logic;
    RstxRBI          : in  std_logic;
    -- lvds signal enter in reversed order, e.g. DVAL bit is Bit [9] not Bit [0]
    LVDSDataxDI          : in  std_logic_vector(lvdsDataWidth-1 downto 0);
    ButtonxSI        : in  std_logic_vector (3 downto 0);
    FrameReqInxSI : in std_logic;
    AlignxSO         : out  std_logic_vector(noOfDataChannels downto 0);
    PixelChannel1xDO : out std_logic_vector(channelWidth-1 downto 0);
    PixelChannel5xDO : out std_logic_vector(channelWidth-1 downto 0);
    PixelChannel9xDO : out std_logic_vector(channelWidth-1 downto 0);
    PixelChannel13xDO : out std_logic_vector(channelWidth-1 downto 0);
    FrameReqOutxSO : out std_logic;
    PixelValidxSO : out std_logic;
    RowValidxSO      : out std_logic;
    FrameValidxSO    : out std_logic;
    LedxSO : out std_logic_vector(7 downto 0);
    NoOfDataChannelsxDI : in std_logic_vector(3 downto 0));
    
  
end entity lvds_sync_controller;

architecture behavioral of lvds_sync_controller is
  -----------------------------------------------------------------------------
  -- interconnection signals
  -----------------------------------------------------------------------------
  signal ClkxC           : std_logic;
  signal RstxRB          : std_logic;
  signal LVDSDataxD      : std_logic_vector(LVDSDataxDI'high downto 0);
  signal ButtonxS        : std_logic_vector (3 downto 0);
  signal FrameReqInxS : std_logic;
  signal FrameReqOutxS : std_logic := '0';
  signal AlignxS         : std_logic_vector(AlignxSO'high downto 0);
  signal PixelValidxS : std_logic;
  signal RowValidxS      : std_logic;
  signal FrameValidxS    : std_logic;
  signal LedxS : std_logic_vector(7 downto 0);
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Pixel Channel type and signal declaration
  -----------------------------------------------------------------------------
  type channelArray is array (0 to noOfDataChannels) of std_logic_vector(channelWidth-1 downto 0);
  signal PixelChannelxD : channelArray;
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- FSM type and signal declaration
  -----------------------------------------------------------------------------
  type fsmState is (resetDelay,initCtr,pulseChannelDataAlign,idle,streamingData, checkTrainingPattern, alignData);  -- states
  signal StatexDP, StatexDN : fsmState;  -- state register
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- counters
  -----------------------------------------------------------------------------
  signal InitCounterxDP, InitCounterxDN : integer range 0 to 64000;
  signal DelayCounterxDP, DelayCounterxDN : integer range 0 to 64000;

  -----------------------------------------------------------------------------
  -- control signals
  -----------------------------------------------------------------------------
  signal CameraReadyxSP, CameraReadyxSN : std_logic;
  signal AlignxDP, AlignxDN : std_logic;


  --signal test : std_logic_vector(conv_integer(NoOfDataChannelsxDI-1) downto 0) := NoOfDataChannelsxDI;
  

begin  -- architecture behavioral
  -------------------------------------------------------------------------------
  -- interconnections
  -------------------------------------------------------------------------------
  ClkxC <= ClkxCI;
  RstxRB <= RstxRBI;
  LVDSDataxD <= LVDSDataxDI(LVDSDataxDI'high downto 0); 
  ButtonxS <= ButtonxSI;
  FrameReqInxS <= FrameReqInxSI;
  AlignxSO <= AlignxS;
  PixelChannel1xDO <= PixelChannelxD(1);
  PixelChannel5xDO <= PixelChannelxD(2);
  PixelChannel9xDO <= PixelChannelxD(3);
  PixelChannel13xDO <= PixelChannelxD(4);
  FrameReqOutxSO <= FrameReqInxS and CameraReadyxSP;
  PixelValidxSO <= PixelValidxS;
  RowValidxSO <= RowValidxS;
  FrameValidxSO <= FrameValidxS;
  LedxSO <= LedxS;
  -----------------------------------------------------------------------------

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
  -----------------------------------------------------------------------------
  -- lvds control channel signals
  -----------------------------------------------------------------------------
  -- read out control signals, see CMV2000/4000 datasheet for reference
  PixelValidxS <= PixelChannelxD(0)(0);        -- DVAL
  RowValidxS <= PixelChannelxD(0)(1);          -- LVAL
  FrameValidxS <= PixelChannelxD(0)(2);        -- RVAL
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

  --LedxS(0) <= PixelChannelxD(0)(0);
  --LedxS(1) <= PixelChannelxD(0)(1);
  --LedxS(2) <= PixelChannelxD(0)(2);
  --LedxS(3) <= PixelChannelxD(0)(3);
  --LedxS(4) <= PixelChannelxD(0)(4);
  --LedxS(5) <= PixelChannelxD(0)(5);
  --LedxS(6) <= PixelChannelxD(0)(8);
  --LedxS(7) <= PixelChannelxD(0)(9);
  
  LedxS(3 downto 0) <= NoOfDataChannelsxDI;
  LedxS(4) <= '0';
  LedxS(5) <= '0';
  LedxS(6) <= '0';
  LedxS(7) <= '0';
  

  memory: process (ClkxC, RstxRB) is
  begin  -- process memory
    if RstxRB = '0' then                -- asynchronous reset (active low)
      StatexDP <= resetDelay;
      InitCounterxDP <= 0;
      DelayCounterxDP <= 0;
      CameraReadyxSP <= '0';
      AlignxDP <= '0';
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
      StatexDP <= StatexDN;
      InitCounterxDP <= InitCounterxDN;
      DelayCounterxDP <= DelayCounterxDN;
      CameraReadyxSP <= CameraReadyxSN;
      AlignxDP <= AlignxDN;
    end if;
  end process memory;


  -- purpose: checks if incoming stream of data is correctly aligned and corrects the alignement if not
  -- type   : combinational
  -- inputs : 
  -- outputs: 
  fsm: process (AlignxS, ButtonxS, CameraReadyxSP, InitCounterxDP, DelayCounterxDP,
                PixelChannelxD, StatexDP, AlignxDP) is
  begin  -- process fsm
    StatexDN <= StatexDP;
    InitCounterxDN <= InitCounterxDP;
    DelayCounterxDN <= DelayCounterxDP;
    CameraReadyxSN <= CameraReadyxSP;
    AlignxS <= (others => '0');

    
    
    case StatexDP is

      when resetDelay =>
        if FrameReqInxS = '1' then
          StatexDN <= initCtr;
        end if;
        
      when initCtr =>
        if InitCounterxDP < 10 then
          -- if PixelChannelxD(0)(9) = trainingPattern(15) and PixelChannelxD(0)(8) = trainingPattern(14) then
          if PixelChannelxD(0)(9) = '1' and PixelChannelxD(0)(8) = '0' then
            InitCounterxDN <= InitCounterxDP + 1;  
          else
            InitCounterxDN <= 0;
            AlignxS(0) <= '1';
            StatexDN <= pulseChannelDataAlign;
          end if;
        else
          CameraReadyxSN <= '1';
          StatexDN <= idle;
        end if;

      when pulseChannelDataAlign =>
        if CameraReadyxSP = '0' then
          StatexDN <= initCtr;
        else
          StatexDN <= idle;
        end if;

      --when pulseChannelDataAlign =>
      --  if PixelValidxS = '1' then
      --    StatexDN <= idle;
      --  end if;
      --  for i in 1 to noOfDataChannels loop
      --    --if PixelChannelxD(i)(9) = trainingPattern(15) and PixelChannelxD(i)(8) = trainingPattern(14) then
      --    if PixelChannelxD(i)(9) = '1' and PixelChannelxD(i)(8) = '0' then
      --        AlignxS(i) <= '0';
      --    else
      --        AlignxS(i) <= '1';
      --    end if;
      --  end loop;  -- i
        
      when idle =>

        for i in 1 to noOfDataChannels loop
          if PixelChannelxD(i)(9) = '1' and PixelChannelxD(i)(8) = '0' then
            AlignxS(i) <= '1';
          end if;
        end loop;  -- i
        
        --for i in 0 to 2 loop
        --  if ButtonxS(i) = '0' then
        --    AlignxS(i+1) <= '1';
        --  end if;
        --end loop;  -- i
       

      when others => null;
    end case;
  end process fsm;
  

end architecture behavioral;


