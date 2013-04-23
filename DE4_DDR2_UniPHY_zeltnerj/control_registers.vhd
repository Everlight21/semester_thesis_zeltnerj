-------------------------------------------------------------------------------
-- Title      : Control Registers
-- Project    : 
-------------------------------------------------------------------------------
-- File       : control_registers.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-04-22
-- Last update: 2013-04-22
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: This entity provides shared register between Nios II and
--              VHDL blocks
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-04-22  1.0      zeltnerj	Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

entity control_registers is
  
  port (
    ClkxCI                  : in  std_logic;
    RstxRBI                 : in  std_logic;
    TestxDI : in std_logic_vector(15 downto 0);
    TestxDO : out std_logic_vector(15 downto 0));

end entity control_registers;

architecture behavioral of control_registers is

  signal TestInxDP, TestInxDN : std_logic_vector(15 downto 0);
  signal TestOutxDP, TestOutxDN : std_logic_vector(15 downto 0);
begin  -- architecture behavioral

  TestxDO <= TestOutxDP;
  TestInxDN <= TestxDI;

  memory: process (ClkxCI, RstxRBI) is
  begin  -- process memory
    if RstxRBI = '0' then               -- asynchronous reset (active low)
      TestInxDP <= (others => '1');
      TestOutxDP <= (others => '0');
    elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
      TestInxDP <= TestInxDN;
      TestOutxDP <= TestOutxDN;
    end if;
  end process memory;

end architecture behavioral;
