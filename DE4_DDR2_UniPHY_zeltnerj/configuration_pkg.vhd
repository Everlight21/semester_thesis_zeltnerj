-------------------------------------------------------------------------------
-- Title      : Configuration Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : configuration_pkg.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-03-15
-- Last update: 2013-05-02
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: In this package all needed functions and constants are declared
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

package configuration_pkg is

  constant noOfDataChannels : integer;  
  constant channelWidth : integer;  
  constant lvdsDataWidth : integer;
  constant camDataWidth : integer;
  constant trainingPattern : std_logic_vector;
  constant frequency : integer;         -- in [MHz]
  constant period : integer;            -- in [ns]
  constant delay : integer;             -- in [us]

  function reverseBitOrder (
    signal input : std_logic_vector)
    return std_logic_vector;

end package configuration_pkg;

package body configuration_pkg is

  -----------------------------------------------------------------------------
  -- deferred constants
  -----------------------------------------------------------------------------
  constant noOfDataChannels : integer := 4;  -- no. of data channels, 2,4,8,16
  constant channelWidth : integer := 10;  -- no. of bits per pixel,  10, 12
  -- noOfDataChannels+1 = DataChannels + Ctrl Channel
  constant lvdsDataWidth : integer := (noOfDataChannels+1)*channelWidth;
  constant camDataWidth : integer := noOfDataChannels*channelWidth;
  constant trainingPattern : std_logic_vector(0 to 15) := x"ff01";
  constant frequency : integer := 5;
  constant period : integer := 200;
  constant delay : integer := 10*frequency;

  -- purpose: reverses order of bits in std_logic_vector
  function reverseBitOrder (
    signal input : std_logic_vector)
    return std_logic_vector is
    
    variable temp : std_logic_vector(input'range);
    
  begin  -- function reverseBitOrder
    for i in 0 to (input'high - input'low) loop
      temp(input'low + i) := input(input'high -i);
    end loop;  -- i
    return temp;
  end function reverseBitOrder;

  

end package body configuration_pkg;
