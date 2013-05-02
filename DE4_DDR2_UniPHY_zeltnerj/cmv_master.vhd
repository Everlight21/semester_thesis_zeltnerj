-------------------------------------------------------------------------------
-- Title      : CMV Master
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cmv_master.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-22
-- Last update: 2013-05-02
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
    DataInxDI : in std_logic_vector(noOfDataChannels*channelWidth-1 downto 0);
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
  signal DataInxD       : std_logic_vector(noOfDataChannels*channelWidth-1 downto 0);
  signal AMWaitReqxS    : std_logic;
  signal AMAddressxD    : std_logic_vector(31 downto 0);
  signal AMWriteDataxD : std_logic_vector(31 downto 0);
  signal AMWritexS      : std_logic;
  signal AMBurstCountxS : std_logic_vector(7 downto 0);

  
  -----------------------------------------------------------------------------
  -- components
  -----------------------------------------------------------------------------
  component cmv_ram_fifo is
    port (
      aclr    : IN  STD_LOGIC := '0';
      data    : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
      rdclk   : IN  STD_LOGIC;
      rdreq   : IN  STD_LOGIC;
      wrclk   : IN  STD_LOGIC;
      wrreq   : IN  STD_LOGIC;
      q       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      rdusedw : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
      wrfull  : OUT STD_LOGIC);
  end component cmv_ram_fifo;

  -----------------------------------------------------------------------------
  -- signals
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- buffer
  -----------------------------------------------------------------------------
  type bufferDataIn is array (1 to 16) of std_logic_vector(15 downto 0);
  signal BufDataInxD : bufferDataIn;
  
  type bufferDataOut is array (1 to noOfDataChannels) of std_logic_vector(31 downto 0);
  signal BufDataOutxD : bufferDataOut;
  
  type bufferControlSignals is array (1 to noOfDataChannels) of std_logic;
  signal BufReadReqxS : bufferControlSignals := (others => '0');
  signal BufWriteEnxS : bufferControlSignals := (others => '0');

  type bufferNoOfWords is array (1 to noOfDataChannels) of std_logic_vector(8 downto 0);
  signal BufNoOfWordsxS : bufferNoOfWords;

  type bufferFull is array (1 to noOfDataChannels) of std_logic;
  signal BufFullxS : bufferFull;


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
    -- input
    ---------------------------------------------------------------------------
    buffer_input: process (DataInxD) is
    begin  -- process buffer_input
      
      for i in 1 to noOfDataChannels loop
        BufWriteEnxS(i) <= '0';
      end loop;  -- i
      
      for i in 1 to 16 loop
        BufDataInxD(i) <= (others => '0');
      end loop;  -- i
      
      if PixelValidxS = '1' and RowValidxS = '1' and FrameValidxS = '1' then
        
          for i in 1 to noOfDataChannels loop
            if BufFullxS(i) /= '1' then
              BufWriteEnxS(i) <= '1';
              BufDataInxD(i) <= (15 downto 10 => '0') & DataInxD(i*channelWidth-1 downto (i-1)*channelWidth); 
            end if;
          end loop;  -- i
          
      end if;
      
    end process buffer_input;
    
    ---------------------------------------------------------------------------
    -- memory processes
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

    memory_ClkLvdsRxxD: process (ClkLvdsRxxC, RstxRB) is
    begin  -- process memory_ClkLvdsRxxD
      if RstxRB = '0' then              -- asynchronous reset (active low)
        BufClearxS <= '1';
      elsif ClkLvdsRxxC'event and ClkLvdsRxxC = '1' then  -- rising clock edge
        
      end if;
    end process memory_ClkLvdsRxxD;

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
      AMBurstCountxS <= "00000010";  -- 2
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
            if BufNoOfWordsxS(i) < 32 then
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
            if BurstWordCountxDP = 31 then
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
    

    fifo_instances : for i in 1 to noOfDataChannels generate
    cmv_ram_fifo_1: cmv_ram_fifo
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


