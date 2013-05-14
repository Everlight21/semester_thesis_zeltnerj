-------------------------------------------------------------------------------
-- Title      : DVI Master
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dvi_master.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-05-10
-- Last update: 2013-05-14
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Reads out data from RAM and streams it to the DVI module via a
-- fifo buffer (ram_dvi_fifo).
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-10  1.0      zeltnerj	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

library work;
use work.configuration_pkg.all;

entity dvi_master is
  
  port (
    ClkxCI             : in  std_logic;
    ClkDvixCI          : in  std_logic;
    RstxRBI            : in  std_logic;
    DviDataOutxDO      : out  std_logic_vector(31 downto 0);
    DviNewLinexDI      : in  std_logic;
    DviNewFramexDI     : in  std_logic;
    DviPixelAvxSI      : in  std_logic;
    AmWaitReqxSI       : in  std_logic;
    AmAddressxDO       : out std_logic_vector(31 downto 0);
    AmReadDataxDI      : in  std_logic_vector(31 downto 0);
    AmReadxSO          : out std_logic;
    AmReadDataValidxSI : in  std_logic;
    AmBurstCountxDO    : out std_logic_vector(7 downto 0));

end entity dvi_master;

architecture behavioral of dvi_master is

  component ram_dvi_fifo is
    port (
      aclr    : IN  STD_LOGIC := '0';
      data    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      rdclk   : IN  STD_LOGIC;
      rdreq   : IN  STD_LOGIC;
      wrclk   : IN  STD_LOGIC;
      wrreq   : IN  STD_LOGIC;
      q       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      rdempty : OUT STD_LOGIC;
      wrusedw : OUT STD_LOGIC_VECTOR (11 DOWNTO 0));
  end component ram_dvi_fifo;


  -----------------------------------------------------------------------------
  -- interconnection signals
  -----------------------------------------------------------------------------
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

  
  -----------------------------------------------------------------------------
  -- buffer signals
  -----------------------------------------------------------------------------
  signal BufDataInxD : std_logic_vector(31 downto 0);
  signal BufDataOutxD : std_logic_vector(31 downto 0);
  signal BufReadReqxS : std_logic;
  signal BufWriteEnxS : std_logic;
  signal BufNoOfWordsxS : std_logic_vector(11 downto 0);
  signal BufEmptyxS : std_logic;
  signal BufClearxS : std_logic;

  -----------------------------------------------------------------------------
  -- control signals
  -----------------------------------------------------------------------------
  signal PendingReadOutsxDP, PendingReadOutsxDN : integer range 0 to 4096;
  signal ReadAddressxDP, ReadAddressxDN : std_logic_vector(31 downto 0);

  -----------------------------------------------------------------------------
  -- fsm signals
  -----------------------------------------------------------------------------
  type fsmState is (idle, fifoWait, burst, finishBurst);
  signal StatexDP, StatexDN : fsmState;
  
  
begin  -- architecture behavioral

  -----------------------------------------------------------------------------
  -- interconnection
  -----------------------------------------------------------------------------
  ClkxC <= ClkxCI;
  ClkDvixC <= ClkDvixCI;
  RstxRB <= RstxRBI;
  DviNewLinexD <= DviNewLinexDI;
  DviNewFramexD <= DviNewFramexDI;
  DviPixelAvxS <= DviPixelAvxSI;
  AmWaitReqxS <= AmWaitReqxSI;
  AmReadDataxD <= AmReadDataxDI;
  AmReadDataValidxS <= AmReadDataValidxSI;
  
  DviDataOutxDO <= DviDataOutxD;
  AmAddressxDO <= AmAddressxD;
  AmReadxSO <= AmReadxS;
  AmBurstCountxDO <= AmBurstCountxD;

  -----------------------------------------------------------------------------
  -- inputs
  -----------------------------------------------------------------------------
  BufDataInxD <= AmReadDataxD;
  -----------------------------------------------------------------------------
  -- outputs
  -----------------------------------------------------------------------------
  AmAddressxD <= ReadAddressxDP;
  AmBurstCountxD <= "10000000";         -- 128d (each channel has 128 pixels
                                        -- per row
  

  -----------------------------------------------------------------------------
  -- control
  -----------------------------------------------------------------------------

  
  -----------------------------------------------------------------------------
  -- memory processes (sequential)
  -----------------------------------------------------------------------------
  memory: process (ClkxC, RstxRB) is
  begin  -- process memory
    if RstxRB = '0' then                -- asynchronous reset (active low)
      ReadAddressxDP <= (others => '0');
      StatexDP <= idle;
      PendingReadOutsxDP <= 0;
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
      ReadAddressxDP <= ReadAddressxDN;
      StatexDP <= StatexDN;
      PendingReadOutsxDP <= PendingReadOutsxDN;
    end if;
  end process memory;

  memory_ClkDvi: process (ClkDvixC, RstxRB) is
  begin  -- process memory_ClkDvi
    if RstxRB = '0' then                -- asynchronous reset (active low)
      
    elsif ClkDvixC'event and ClkDvixC = '1' then  -- rising clock edge
      
    end if;
  end process memory_ClkDvi;
  

  -----------------------------------------------------------------------------
  -- combinational processes
  -----------------------------------------------------------------------------
  fsm: process (AmReadDataValidxS, AmWaitReqxS, BufNoOfWordsxS, DviNewFramexD,
                PendingReadOutsxDP, ReadAddressxDP, StatexDP) is
  begin  -- process fsm
    StatexDN <= StatexDP;
    ReadAddressxDN <= ReadAddressxDP;
    PendingReadOutsxDN <= PendingReadOutsxDP;
    AmReadxS <= '0';
    BufWriteEnxS <= AmReadDataValidxS;

    if RstxRB = '0' then
      BufClearxS <= '1';
    else
      BufClearxS <= '0';
    end if;

    if DviNewFramexD = '0' then
      ReadAddressxDN <= (others => '0');
    end if;

    if AmReadDataValidxS = '1' then
      if PendingReadOutsxDP > 0 then
        PendingReadOutsxDN <= PendingReadOutsxDP - 1;
      end if;
      
    end if;

    case StatexDP is
      when idle =>
        StatexDN <= fifoWait;
        PendingReadOutsxDN <= 0;

      when fifoWait =>
        if BufNoOfWordsxS < 4096-128 then  -- size of buffer is defined in ram_dvi_fifo.vhd
                                           -- 128 = 4*32 (pixel per row per channel)
          StatexDN <= burst;
          if AmReadDataValidxS = '0' then
            PendingReadOutsxDN <= PendingReadOutsxDP + 128;  
          else
            PendingReadOutsxDN <= PendingReadOutsxDP + 127;  -- if datavalid is
                                                            -- set ???
          end if;
        end if;

      when burst =>
        AmReadxS <= '1';
        ReadAddressxDN <= ReadAddressxDP + 512;  -- 128*4byte
        if AmWaitReqxS /= '1' then
          StatexDN <= finishBurst;
        end if;

      when finishBurst =>
        if AmReadDataValidxS = '1' then
          if PendingReadOutsxDP = 1 then
            StatexDN <= idle;
          end if;
        end if;
        
      when others => null;
    end case;
    
  end process fsm;

  
  -- purpose: determines DVI data signal each time a word is read out from ram_dvi_fifo
  -- type   : combinational
  -- inputs : BufDataOutxD
  -- outputs: DviDataOutxD
  DVI: process (BufDataOutxD, BufEmptyxS, DviNewFramexD, DviNewLinexD,
                DviPixelAvxS) is
  begin  -- process DVI
    DviDataOutxD <= (others => '0');
    BufReadReqxS <= '0';

    if DviPixelAvxS = '1' and DviNewLinexD = '1' and DviNewFramexD = '1' then
      if BufEmptyxS = '0' then
        BufReadReqxS <= '1';
        DviDataOutxD <= BufDataOutxD;
      else
        DviDataOutxD <= (others => '0');
      end if;
    end if;
  end process DVI;

  -----------------------------------------------------------------------------
  -- instances
  -----------------------------------------------------------------------------
  ram_dvi_fifo_1: ram_dvi_fifo
    port map (
      aclr    => BufClearxS,
      data    => BufDataInxD,
      rdclk   => ClkDvixCI,
      rdreq   => BufReadReqxS,
      wrclk   => ClkxC,
      wrreq   => BufWriteEnxS,
      q       => BufDataOutxD,
      rdempty => BufEmptyxS,
      wrusedw => BufNoOfWordsxS);

end architecture behavioral;
