-------------------------------------------------------------------------------
-- Title      : Configuration Registers Slave
-- Project    : 
-------------------------------------------------------------------------------
-- File       : config_registers_slave.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-06-06
-- Last update: 2013-06-06
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: An avalon slave containing several registers for storing and
--              accessing configuration data.
--              Configuration data transfer between Nios2 and hardware blocks.
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06-06  1.0      zeltnerj    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity config_registers_slave is

  port (
    ClkxCI          : in  std_logic;
    RstxRBI         : in  std_logic;
    ASChipSelectxSI : in  std_logic;
    ASAddressxDI    : in  std_logic_vector(7 downto 0);
    ASReadxSI       : in  std_logic;
    ASWriteDataxDI  : in  std_logic_vector(31 downto 0);
    ASWritexSI      : in  std_logic;
    ASReadDataxDO   : out std_logic_vector(31 downto 0);
    ConfigInxDI     : in  std_logic_vector(2047 downto 0);  -- 256*8bit registers
    ConfigOutxDO    : out std_logic_vector(2047 downto 0));


end entity config_registers_slave;


architecture behavioral of config_registers_slave is

  -----------------------------------------------------------------------------
  -- interconnection signals
  -----------------------------------------------------------------------------
  signal ClkxC          : std_logic;
  signal RstxRB         : std_logic;
  signal ASChipSelectxS : std_logic;
  signal ASAddressxD    : std_logic_vector(7 downto 0);
  signal ASReadxS       : std_logic;
  signal ASWriteDataxD  : std_logic_vector(31 downto 0);
  signal ASWritexS      : std_logic;
  signal ASReadDataxD   : std_logic_vector(31 downto 0);
  signal ConfigInxD     : std_logic_vector(2047 downto 0);
  signal ConfigOutxD    : std_logic_vector(2047 downto 0);

  -----------------------------------------------------------------------------
  -- register signals
  -----------------------------------------------------------------------------
  signal ConfigRegistersxDP, ConfigRegistersxDN : std_logic_vector(2047 downto 0);

begin  -- architecture behavioral

  -----------------------------------------------------------------------------
  -- interconnections
  -----------------------------------------------------------------------------
  ClkxC           <= ClkxCI;
  RstxRB          <= RstxRBI;
  ASChipSelectxS  <= ASChipSelectxSI;
  ASAddressxD     <= ASAddressxDI;
  ASReadxS        <= ASReadxSI;
  ASWriteDataxD   <= ASWriteDataxDI;
  ASWritexS       <= ASWritexSI;
  ASReadDataxDO   <= ASReadDataxD;
  ConfigInxD      <= ConfigInxDI;
  ConfigOutxDO    <= ConfigOutxD;

  -----------------------------------------------------------------------------
  -- outputs
  -----------------------------------------------------------------------------
  ConfigOutxD <= ConfigRegistersxDP;

  -----------------------------------------------------------------------------
  -- sequential processes
  -----------------------------------------------------------------------------
  memory : process (ClkxC, RstxRB) is
  begin  -- process memory
    if RstxRB = '0' then                    -- asynchronous reset (active low)
      ConfigRegistersxDP <= (others => '0');
    elsif ClkxC'event and ClkxC = '1' then  -- rising clock edge
      ConfigRegistersxDP <= ConfigRegistersxDN;
    end if;
  end process memory;

  -----------------------------------------------------------------------------
  -- combinational processes
  -----------------------------------------------------------------------------
  write2reg : process (ASChipSelectxS, ASWritexS, ASAddressxD, ASWriteDataxD) is
  begin  -- process reg_select

    if ASChipSelectxS = '1' and ASWritexS = '1' then

      for i in 0 to 255 loop
        if ASAddressxD = i then
          ConfigRegistersxDN(i*8-1 downto (i-1)*8) <= ASWriteDataxD;
        end if;
      end loop;  -- i
    end if;

  end process write2reg;

  
  readFromReg: process (ASChipSelectxS, ASReadxS, ASAddressxD, ConfigRegistersxDP) is
  begin  -- process readFromReg

    for i in 0 to 255 loop
      if ASAddressxD = i then
        ASReadDataxD <= ConfigRegistersxDP(i*8-1 downto (i-1)*8);
      end if;
    end loop;  -- i
    
  end process readFromReg;

end architecture behavioral;
