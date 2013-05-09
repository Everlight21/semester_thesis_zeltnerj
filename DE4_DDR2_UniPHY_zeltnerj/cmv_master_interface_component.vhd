-- cmv_master_interface_component.vhd

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

entity cmv_master_interface_component is
	port (
		ClkxCI          : in  std_logic                     := '0';             --           clock_main.clk
		ClkLvdsRxxCI    : in  std_logic                     := '0';             --         clock_lvdsrx.export
		RstxRBI         : in  std_logic                     := '0';             --              reset_n.reset_n
		AMWritexSO      : out std_logic;                                        --        avalon_master.write
		AMWriteDataxDO  : out std_logic_vector(31 downto 0);                    --                     .writedata
		AMAddressxDO    : out std_logic_vector(31 downto 0);                    --                     .address
		AMBurstCountxSO : out std_logic_vector(7 downto 0);                     --                     .burstcount
		AMWaitReqxSI    : in  std_logic                     := '0';             --                     .waitrequest
		PixelValidxSI   : in  std_logic                     := '0';             -- conduit_ctrl_signals.export
		RowValidxSI     : in  std_logic                     := '0';             --                     .export
		FrameValidxSI   : in  std_logic                     := '0';             --                     .export
		DataInxDI       : in  std_logic_vector(79 downto 0) := (others => '0')  --         conduit_data.export
	);
end entity cmv_master_interface_component;

architecture rtl of cmv_master_interface_component is
begin

	-- TODO: Auto-generated HDL template

	AMBurstCountxSO <= "00000000";

	AMAddressxDO <= "00000000000000000000000000000000";

	AMWriteDataxDO <= "00000000000000000000000000000000";

	AMWritexSO <= '0';

end architecture rtl; -- of cmv_master_interface_component
