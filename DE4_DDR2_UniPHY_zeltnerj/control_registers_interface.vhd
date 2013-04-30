-- control_registers_interface.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_registers_interface is
	port (
		ClkxCI     : in  std_logic                     := '0';             --         ClkxCI.clk
		RstxRBI    : in  std_logic                     := '0';             --        RstxRBI.reset_n
		DataOutxDO : out std_logic_vector(15 downto 0);                    -- avalon_slave_1.readdata
		ReadEnxSI  : in  std_logic                     := '0';             --               .read
		WriteEnxSI : in  std_logic                     := '0';             --               .write
		DataInxDI  : in  std_logic_vector(15 downto 0) := (others => '0')  --               .writedata
	);
end entity control_registers_interface;

architecture rtl of control_registers_interface is
begin

	-- TODO: Auto-generated HDL template

	DataOutxDO <= "0000000000000000";

end architecture rtl; -- of control_registers_interface
