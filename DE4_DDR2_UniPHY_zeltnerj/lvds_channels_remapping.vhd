-------------------------------------------------------------------------------
-- Title      : LVDS channels remapping
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lvds_channels_remapping.vhd
-- Author     : Joscha Zeltner
-- Company    : Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-- Created    : 2013-04-30
-- Last update: 2013-05-02
-- Platform   : Quartus II, NIOS II 12.1sp1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: The output LVDS channels of the CMV image sensors have a
-- certain order. E.G. if you are in 2 channels mode, the LVDS outputs
-- 1 and 9 are used. In order to make processing easier this entity
-- remapps this channels. In our example, the output LVDS channels
-- in 2 channels mode (1,9) will be remapped to (1,2).
-- 
-- Another example in 4 channels mode:
-- (1,5,9,13)->(1,2,3,4)
--
-- The Ctrl LVDS channel is always channel 0.
-- In case of two cameras, the Ctrl LVDS channel of camera 1 is 0 and the Ctrl
-- LVDS channel of camera 2 is always the highest channel no.
-- 
-- E.G. 2 cameras in 2 channels mode:
-- (0,1,9) and (0,1,9) -> (0,1,2,3,4,5) where 0 and 5 are the ctrl channels
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Computer Vision and Geometry Group, Pixhawk, ETH Zurich
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-04-30  1.0      zeltnerj	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

library work;
use work.configuration_pkg.all;

entity lvds_channels_remapping is
  
  port (
    Cam1ChannelCtrlxDI : in std_logic;
    Cam1Channel1xDI : in std_logic;
    Cam1Channel3xDI : in std_logic;
    Cam1Channel5xDI : in std_logic;
    Cam1Channel7xDI : in std_logic;
    Cam1Channel9xDI : in std_logic;
    Cam1Channel11xDI : in std_logic;
    Cam1Channel13xDI : in std_logic;
    Cam1Channel15xDI : in std_logic;
    DataOutxDO : out std_logic_vector((noOfDataChannels+1)-1 downto 0));

end entity lvds_channels_remapping;


architecture remapping of lvds_channels_remapping is

  
  
begin  -- architecture remapping


      DataOutxDO <= Cam1Channel13xDI &
                    Cam1Channel9xDI &
                    Cam1Channel5xDI &
                    Cam1Channel1xDI &
                    Cam1ChannelCtrlxDI;
    

end architecture remapping;
