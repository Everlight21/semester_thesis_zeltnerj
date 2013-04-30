-------------------------------------------------------------------------------
-- Title      : CMV Master
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cmv_master.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-22
-- Last update: 2013-04-30
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
-- 2013-03-22  1.0      zeltnerj	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.configuration_pkg.all;

entity cmv_master is
  
  port (
    ClkxCI          : in std_logic;     -- main clock
    ClkLvdsRxxCI    : in std_logic;     -- lvds_rx clock
    RstxRBI         : in std_logic;     -- active low
    -- cmv interface
    PixelValidxSI : in std_logic;
    RowValidxSI : in std_logic;
    FrameValidxSI : in std_logic;
    DataInxDI : in std_logic_vector(camDataWidth-1 downto 0);
    -- avalon mm master interface
    AMWaitReqxSI : in std_logic;
    AMAddressxDO : out std_logic_vector(31 downto 0);
    AMWriteDataxDO : out std_logic_vector(31 downto 0);
    AMWritexSO : out std_logic;
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
  signal DataInxD       : std_logic_vector(DataInxDI'high downto 0);
  signal AMWaitReqxS    : std_logic;
  signal AMAddressxD    : std_logic_vector(AMAddressxDO'high downto 0);
  signal AMWriteDataxD : std_logic_vector(AMWriteDataxDO'high downto 0);
  signal AMWritexS      : std_logic;
  signal AMBurstCountxS : std_logic_vector(AMBurstCountxSO'high downto 0);

  
  -----------------------------------------------------------------------------
  -- components
  -----------------------------------------------------------------------------
  component fifocamera is
    port (
      aclr    : IN  STD_LOGIC := '0';
      data    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      rdclk   : IN  STD_LOGIC;
      rdreq   : IN  STD_LOGIC;
      wrclk   : IN  STD_LOGIC;
      wrreq   : IN  STD_LOGIC;
      q       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      rdusedw : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
      wrfull  : OUT STD_LOGIC);
  end component fifocamera;

  -----------------------------------------------------------------------------
  -- signals
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- buffer
  -----------------------------------------------------------------------------
  type bufferData is array (1 to noOfDataChannels) of std_logic_vector(31 downto 0);
  signal BufDataInxD : bufferData;
  signal BufDataOutxD : bufferData;
  
  type bufferReadRequest is array (1 to noOfDataChannels) of std_logic;
  signal BufReadReqxS : bufferReadRequest := (others => '0');

  type bufferNoOfWords is array (1 to noOfDataChannels) of std_logic_vector(9 downto 0);
  signal BufNoOfWordsxS : bufferNoOfWords;

  type bufferFull is array (1 to noOfDataChannels) of std_logic;
  signal BufFullxS : bufferFull;

  signal BufWriteReqxS : std_logic;

  signal BufClearxS : std_logic;

  signal ChannelSelectxSP, ChannelSelectxSN : integer range 1 to noOfDataChannels;

  signal NoOfPacketsInRowxDP, NoOfPacketsInRowxDN : integer;
  -----------------------------------------------------------------------------
  -- avalon
  -----------------------------------------------------------------------------
  signal AMWriteAddressxDP, AMWriteAddressxDN : std_logic_vector(31 downto 0);

  -----------------------------------------------------------------------------
  -- counter
  -----------------------------------------------------------------------------
  signal BurstWordCountxDP, BurstWordCountxDN : integer range 0 to 31;
  
  -----------------------------------------------------------------------------
  -- fsm
  -----------------------------------------------------------------------------
  type fsmState is (idle, fifoWait, burst);
  signal StatexDP, StatexDN : fsmState;
  


  
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


    ---------------------------------------------------------------------------
    -- output
    ---------------------------------------------------------------------------
    AMAddressxD <= AMWriteAddressxDP;
    buf_output: process (ChannelSelectxSP, BufDataOutxD) is
    begin  -- process buf_output
      for i in 1 to noOfDataChannels loop
        if ChannelSelectxSP = i then
          AMWriteDataxD <= BufDataOutxD(i);
        end if;
      end loop;  -- i
    end process buf_output;

    ---------------------------------------------------------------------------
    -- Processes driven by ClkLvdsRxxCI
    ---------------------------------------------------------------------------
    -- purpose: writes into buffers when according buffer isnt full and input changes
    -- type   : combinational
    -- inputs : DataInxD
    -- outputs: BufDataInxD(i)
    write_into_buffers: process (DataInxD) is
    begin  -- process write_into_buffers
      for i in 1 to noOfDataChannels loop
        if PixelValidxS = '1' and BufFullxS(i) = '0' then
          BufWriteReqxS <= '1';
          BufDataInxD(i) <= (BufDataInxD'high downto channelWidth => '0') & DataInxD(channelWidth*i-1 downto channelWidth*(i-1));
        end if;
      end loop;  -- i
    end process write_into_buffers;
    
    ---------------------------------------------------------------------------
    -- Processes driven by ClkxCI
    ---------------------------------------------------------------------------
    memory: process (ClkxC, RstxRB) is
    begin  -- process memory
      if RstxRB = '0' then              -- asynchronous reset (active low)
        StatexDP <= idle;
        AMWriteAddressxDP <= (others => '0');
        BurstWordCountxDP <= 0;
        NoOfPacketsInRowxDP <= 0;
        ChannelSelectxSP <= 1;
      elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
        StatexDP <= StatexDN;
        AMWriteAddressxDP <= AMWriteAddressxDN;
        BurstWordCountxDP <= BurstWordCountxDN;
        NoOfPacketsInRowxDP <= NoOfPacketsInRowxDN;
        ChannelSelectxSP <= ChannelSelectxSN;
      end if;
    end process memory;

    


    
    ---------------------------------------------------------------------------
    -- FSM
    ---------------------------------------------------------------------------
    fsm: process (StatexDP,AMWriteAddressxDP,BurstWordCountxDP,NoOfPacketsInRowxDP,
             ChannelSelectxSP,BufClearxS,AMWaitReqxS) is
    begin  -- process fsm
       StatexDN <= StatexDP;
      AMWriteAddressxDN <= AMWriteAddressxDP;
      BurstWordCountxDN <= BurstWordCountxDP;
      NoOfPacketsInRowxDN <= NoOfPacketsInRowxDP;
      ChannelSelectxSN <= ChannelSelectxSP;
      AMBurstCountxS <= std_logic_vector(to_unsigned(fifoBurstCountxC,8));  -- 1
      AMWritexS <= '0';
      
      if BufClearxS = '1' then
        AMWriteAddressxDN <= (others => '0');
        NoOfPacketsInRowxDN <= 0;  
      end if;
      
      

      case StatexDP is
        when idle =>
          StatexDN <= fifoWait;
          BurstWordCountxDN <= 0;

        when fifoWait =>
          
          StatexDN <= burst;
          
          for i in 1 to noOfDataChannels loop
            if BufNoOfWordsxS(i) < 1 then
              StatexDN <= fifoWait;
            end if;
          end loop;  -- i

        when burst =>

          AMWritexS <= '1';
          for i in 1 to noOfDataChannels loop
            if AMWaitReqxS = '0' and ChannelSelectxSP = i then
              BufReadReqxS(i) <= '1';
            else
              BufReadReqxS(i) <= '0';
            end if;
          end loop;  -- i
          
          if AMWaitReqxS /= '1' then
            if BurstWordCountxDP = fifoBurstCountxC then
              BurstWordCountxDN <= 0;
              case NoOfPacketsInRowxDP is
                when 15 =>
                  ChannelSelectxSN <= 5;
                  AMWriteAddressxDN <= AMWriteAddressxDP + 128;
                when 31 =>
                  ChannelSelectxSN <= 9;
                  AMWriteAddressxDN <= AMWriteAddressxDP + 128;
                when 47 =>
                  ChannelSelectxSN <= 13;
                  AMWriteAddressxDN <= AMWriteAddressxDP + 128;
                when 63 =>
                  ChannelSelectxSN <= 1;
                  AMWriteAddressxDN <= AMWriteAddressxDP + 1664;  --128*47+1664=1920
                  BurstWordCountxDN <= 0;
                when others => null;
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
    fifo_instances: for i in 1 to noOfDataChannels generate
      fifocamera_i: fifocamera
        port map (
          aclr    => BufClearxS,
          data    => BufDataInxD(i),
          rdclk   => ClkxC,
          rdreq   => BufReadReqxS(i),
          wrclk   => ClkLvdsRxxC,
          wrreq   => BufWriteReqxS,
          q       => BufDataOutxD(i),
          rdusedw => BufNoOfWordsxS(i),
          wrfull  => BufFullxS(i));
    end generate fifo_instances;

    

end architecture behavioral;


