-------------------------------------------------------------------------------
-- Title      : CMV Master
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cmv_master.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-22
-- Last update: 2013-07-30
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: This entity fetches the incoming data from the CMV image
--              sensor. It feeds a FIFO buffer with the data and writes the
--              data to the AVALON bus in bursts.
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-03-22  1.0      zeltnerj    Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

library work;
use work.all;
use work.configuration_pkg.all;

entity cmv_master is

  port (
    ClkxCI          : in  std_logic;    -- main clock
    ClkLvdsRxxCI    : in  std_logic;    -- lvds_rx clock
    RstxRBI         : in  std_logic;    -- active low
    -- cmv interface
    PixelValidxSI   : in  std_logic;
    RowValidxSI     : in  std_logic;
    FrameValidxSI   : in  std_logic;
    DataInxDI       : in  std_logic_vector(159 downto 0);
    -- avalon mm master interface
    AMWaitReqxSI    : in  std_logic;
    AMAddressxDO    : out std_logic_vector(31 downto 0);
    AMWriteDataxDO  : out std_logic_vector(127 downto 0);
    AMWritexSO      : out std_logic;
    AMBurstCountxSO : out std_logic_vector(7 downto 0));

end entity cmv_master;

architecture behavioral of cmv_master is


  -----------------------------------------------------------------------------
  -- interconnection signals
  -----------------------------------------------------------------------------
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


  -----------------------------------------------------------------------------
  -- components
  -----------------------------------------------------------------------------


  component cmv_ram_fifo is
    port (
      aclr    : in  std_logic := '0';
      data    : in  std_logic_vector (31 downto 0);
      rdclk   : in  std_logic;
      rdreq   : in  std_logic;
      wrclk   : in  std_logic;
      wrreq   : in  std_logic;
      q       : out std_logic_vector (127 downto 0);
      rdusedw : out std_logic_vector (7 downto 0);
      wrfull  : out std_logic);
  end component cmv_ram_fifo;

  -----------------------------------------------------------------------------
  -- signals
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- buffer
  -----------------------------------------------------------------------------
  type bufferDataIn is array (1 to 16) of std_logic_vector(31 downto 0);
  signal BufDataInxD : bufferDataIn;

  type bufferDataOut is array (1 to noOfDataChannels) of std_logic_vector(127 downto 0);
  signal BufDataOutxD : bufferDataOut;

  signal BufReadReqxS : std_logic_vector(noOfDataChannels downto 1);
  signal BufWriteEnxS : std_logic_vector(noOfDataChannels downto 1);

  type bufferNoOfWords is array (1 to noOfDataChannels) of std_logic_vector(7 downto 0);
  signal BufNoOfWordsxS : bufferNoOfWords;


  signal BufFullxS : std_logic_vector(noOfDataChannels downto 1);


  signal BufClearxS : std_logic;

  signal ChannelSelectxSP, ChannelSelectxSN : integer range 1 to noOfDataChannels;

  signal NoOfPacketsInRowxDP, NoOfPacketsInRowxDN : integer;
  -----------------------------------------------------------------------------
  -- avalon
  -----------------------------------------------------------------------------
  signal AMWriteAddressxDP, AMWriteAddressxDN     : std_logic_vector(31 downto 0);

  -----------------------------------------------------------------------------
  -- counter
  -----------------------------------------------------------------------------
  signal BurstWordCountxDP, BurstWordCountxDN : integer range 0 to 31;
  signal RowCounterxDP, RowCounterxDN         : integer range 0 to 1088;

  -----------------------------------------------------------------------------
  -- fsm
  -----------------------------------------------------------------------------
  type fsmState is (idle, fifoWait, setReadReq, burst);
  signal StatexDP, StatexDN : fsmState;

  type getCmvDataStates is (init, idle, waitForData, writeDataToBuffer);
  signal StateCmvxDP, StateCmvxDN : getCmvDataStates;


  -----------------------------------------------------------------------------
  -- control
  -----------------------------------------------------------------------------
  signal FrameRunningxSP, FrameRunningxSN : std_logic;

begin

  ---------------------------------------------------------------------------
  -- port initializations
  ---------------------------------------------------------------------------
  ClkxC        <= ClkxCI;
  ClkLvdsRxxC  <= ClkLvdsRxxCI;
  RstxRB       <= RstxRBI;
  PixelValidxS <= PixelValidxSI;
  RowValidxS   <= RowValidxSI;
  FrameValidxS <= FrameValidxSI;
  DataInxD     <= DataInxDI;
  AMWaitReqxS  <= AMWaitReqxSI;

  AMAddressxDO    <= AMAddressxD;
  AMWriteDataxDO  <= AMWriteDataxD;
  AMWritexSO      <= AMWritexS;
  AMBurstCountxSO <= AMBurstCountxS;


  ---------------------------------------------------------------------------
  -- output
  ---------------------------------------------------------------------------
  AMAddressxD <= AMWriteAddressxDP;

  buf_output : process (ChannelSelectxSP, BufDataOutxD) is
  begin  -- process buf_output
    AMWriteDataxD <= (others => '0');
    for i in 1 to noOfDataChannels loop
      if ChannelSelectxSP = i then
        AMWriteDataxD <= BufDataOutxD(i);
      end if;
    end loop;  -- i
  end process buf_output;

  ---------------------------------------------------------------------------
  -- control
  ---------------------------------------------------------------------------
  FrameRunningxSN <= FrameValidxS;


  ---------------------------------------------------------------------------
  -- input
  ---------------------------------------------------------------------------
  buffer_input : process (DataInxD, PixelValidxS, RowValidxS, FrameValidxS,
                          FrameRunningxSN, FrameRunningxSP, BufFullxS,
                          BufNoOfWordsxS, StateCmvxDP, BufClearxS, RstxRB) is
  begin  -- process buffer_input



    StateCmvxDN  <= StateCmvxDP;
    BufClearxS   <= '0';
    BufWriteEnxS <= (others => '0');

    for i in 1 to noOfDataChannels loop
      BufDataInxD(i) <= (others => '0');
    end loop;  -- i

    if RstxRB = '0' then
      BufClearxS <= '1';
    end if;

    case StateCmvxDP is

      --when init =>
      --  BufClearxS <= '1';
      --  StateCmvxDN <= idle;

      --when idle =>
      --  if PixelValidxS = '0' and RowValidxS = '0' and FrameValidxS = '0' then
      --    StateCmvxDN <= waitForData;
      --  end if;

      --when waitForData =>
      --  if PixelValidxS = '1' and RowValidxS = '1' and FrameValidxS = '1' then

      --    StateCmvxDN <= writeDataToBuffer;

      --    for i in 1 to noOfDataChannels loop
      --      if BufFullxS(i) /= '1' then
      --        BufWriteEnxS(i) <= '1';
      --        -- this is only the raw pixel data
      --        -- if a rgb camera is used, the buffer input has to be changed accordingly
      --        BufDataInxD(i)  <= (31 downto 24 => '0') &
      --                          DataInxD(i*channelWidth-1 downto (i-1)*channelWidth+2) &
      --                          DataInxD(i*channelWidth-1 downto (i-1)*channelWidth+2) &
      --                          DataInxD(i*channelWidth-1 downto (i-1)*channelWidth+2);
      --      end if;
      --    end loop;  -- i
      --  end if;

      when writeDataToBuffer =>

        if PixelValidxS = '1' and RowValidxS = '1' and FrameValidxS = '1' then

          for i in 1 to noOfDataChannels loop
            if BufFullxS(i) /= '1' then
              BufWriteEnxS(i) <= '1';
              -- this is only the raw pixel data
              -- if a rgb camera is used, the buffer input has to be changed accordingly
              BufDataInxD(i)  <= (31 downto 24 => '0') &
                                DataInxD(i*channelWidth-1 downto (i-1)*channelWidth+2) &
                                DataInxD(i*channelWidth-1 downto (i-1)*channelWidth+2) &
                                DataInxD(i*channelWidth-1 downto (i-1)*channelWidth+2);
            end if;
          end loop;  -- i

        end if;

      when others => null;
    end case;








  end process buffer_input;

  ---------------------------------------------------------------------------
  -- memory processes
  ---------------------------------------------------------------------------
  memory : process (ClkxC, RstxRB) is
  begin  -- process memory
    if RstxRB = '0' then                    -- asynchronous reset (active low)
      StatexDP            <= idle;
      AMWriteAddressxDP   <= (others => '0');
      BurstWordCountxDP   <= 0;
      RowCounterxDP       <= 0;
      NoOfPacketsInRowxDP <= 0;
      ChannelSelectxSP    <= 1;
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
      StatexDP            <= StatexDN;
      AMWriteAddressxDP   <= AMWriteAddressxDN;
      BurstWordCountxDP   <= BurstWordCountxDN;
      RowCounterxDP       <= RowCounterxDN;
      NoOfPacketsInRowxDP <= NoOfPacketsInRowxDN;
      ChannelSelectxSP    <= ChannelSelectxSN;
    end if;
  end process memory;

  memory_ClkLvdsRxxD : process (ClkLvdsRxxC, RstxRB) is
  begin  -- process memory_ClkLvdsRxxD
    if RstxRB = '0' then                -- asynchronous reset (active low)
      FrameRunningxSP <= '0';
      StateCmvxDP     <= writeDataToBuffer;
    elsif ClkLvdsRxxC'event and ClkLvdsRxxC = '1' then  -- rising clock edge
      FrameRunningxSP <= FrameRunningxSN;
      StateCmvxDP     <= StateCmvxDN;
    end if;
  end process memory_ClkLvdsRxxD;

  ---------------------------------------------------------------------------
  -- FSM
  ---------------------------------------------------------------------------
  fsm : process (StatexDP, AMWriteAddressxDP, BurstWordCountxDP, NoOfPacketsInRowxDP,
                 ChannelSelectxSP, AMWaitReqxS, BufNoOfWordsxS, RowCounterxDP) is
  begin  -- process fsm
    StatexDN            <= StatexDP;
    AMWriteAddressxDN   <= AMWriteAddressxDP;
    BurstWordCountxDN   <= BurstWordCountxDP;
    RowCounterxDN       <= RowCounterxDP;
    NoOfPacketsInRowxDN <= NoOfPacketsInRowxDP;
    ChannelSelectxSN    <= ChannelSelectxSP;
    AMBurstCountxS      <= "00001000";  -- 8 (8*128bit = 8*4pixel = 32pixel)
    AMWritexS           <= '0';


    BufReadReqxS <= (others => '0');






    case StatexDP is
      when idle =>
        StatexDN          <= fifoWait;
        BurstWordCountxDN <= 0;

      when fifoWait =>

        StatexDN <= setReadReq;

        for i in 1 to noOfDataChannels loop
          if ChannelSelectxSP = i then

            if BufNoOfWordsxS(i) < 8 then  -- fifo has 4*32=128 bit output (4
                                           -- pixel each 32bit) and
                                           -- rdwuse counts 128bit words. After
                                           -- 8*128=1024bit or 8*4pixel=32pixel
                                           -- a read-out should be performed
              StatexDN <= fifoWait;

            end if;

          end if;
        end loop;  -- i

      when setReadReq =>

        for i in 1 to noOfDataChannels loop

          if AMWaitReqxS = '0' and ChannelSelectxSP = i then
            BufReadReqxS(i) <= '1';
            StatexDN        <= burst;
          else
            BufReadReqxS(i) <= '0';
          end if;
        end loop;  -- i



      when burst =>

        AMWritexS <= '1';
        
        if AMWaitReqxS /= '1' then
          
          for i in 1 to noOfDataChannels loop
            if ChannelSelectxSP = i then
              BufReadReqxS(i) <= '1';
            else
              BufReadReqxS(i) <= '0';
            end if;
          end loop;  -- i


        ---------------------------------------------------------------------
        -- This section needs to be adjusted according to the no of channels.
        -- Each channel provides a multiple of 128pixel PER ROW according to
        -- the no of channels.
        -- 16 channels: 1 * 128 pixels
        --  8 channels: 2 * 128 pixels
        --  4 channels: 4 * 128 pixels = 16 * 32 pixels
        --  2 channels: 8 * 128 pixels
        ---------------------------------------------------------------------


          if BurstWordCountxDP = 7 then  -- for each burstcount 4pixels are
                                         -- read out. After 8 read-outs, a
                                         -- packet of 32pixels have been read
                                         -- out.
            BurstWordCountxDN <= 0;


            BufReadReqxS <= (others => '0');

            case NoOfPacketsInRowxDP is
              when 15 =>                -- each channel provides 4*128pixels =
                                        -- 16*32pixels per row.
                ChannelSelectxSN    <= 2;
                AMWriteAddressxDN   <= AMWriteAddressxDP + 128;
                NoOfPacketsInRowxDN <= NoOfPacketsInRowxDP + 1;
              when 31 =>
                ChannelSelectxSN    <= 3;
                AMWriteAddressxDN   <= AMWriteAddressxDP + 128;
                NoOfPacketsInRowxDN <= NoOfPacketsInRowxDP + 1;
              when 47 =>
                ChannelSelectxSN    <= 4;
                AMWriteAddressxDN   <= AMWriteAddressxDP + 128;
                NoOfPacketsInRowxDN <= NoOfPacketsInRowxDP + 1;
              when 63 =>                -- row has been read-out, switch to
                                        -- next row.
                ChannelSelectxSN    <= 1;
                AMWriteAddressxDN   <= AMWriteAddressxDP + 128;
                NoOfPacketsInRowxDN <= 0;
                if RowCounterxDP = 1087 then
                  RowCounterxDN     <= 0;
                  AMWriteAddressxDN <= (others => '0');
                else
                  RowCounterxDN <= RowCounterxDP + 1;
                end if;

              when others =>
                AMWriteAddressxDN   <= AMWriteAddressxDP + 128;  -- after each
                                                                 -- burst
                                                                 -- 32pixels
                                                                 -- have been
                                                                 -- read-out.
                                                                 -- Address is
                                                                 -- in bytes: 32pixel*32bit/8bit=128bytes
                NoOfPacketsInRowxDN <= NoOfPacketsInRowxDP + 1;
            end case;
            StatexDN <= idle;
          else
            BurstWordCountxDN <= BurstWordCountxDP + 1;
          end if;

        end if;



      when others => null;
    end case;
  end process fsm;




  ---------------------------------------------------------------------------
  -- instances
  ---------------------------------------------------------------------------


  fifo_instances : for i in 1 to noOfDataChannels generate
    cmv_ram_fifo_1 : cmv_ram_fifo
      port map (
        aclr    => BufClearxS,
        data    => BufDataInxD(i),
        rdclk   => ClkxC,
        rdreq   => BufReadReqxS(i),
        wrclk   => ClkLvdsRxxC,
        wrreq   => BufWriteEnxS(i),
        q       => BufDataOutxD(i),
        rdusedw => BufNoOfWordsxS(i),
        wrfull  => BufFullxS(i));

  end generate fifo_instances;




end architecture behavioral;


