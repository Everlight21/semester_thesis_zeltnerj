----------------------------------------------------------
--
--	Iván Muñoz - IN - LAP - EPFL
--
--	17.05.08
--
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


--this block is responsable to privide all the data from the camera synchronously on clk rising edge

ENTITY ControlerCamera is

	port(
		--inputs
	clk					: in std_logic;
	reset				: in std_logic;
	
	--camera
	newFrame_in			: in std_logic;
	newLine_in			: in std_logic;
	pixel0_in				: in std_logic_vector(7 downto 0);
	pixel1_in				: in std_logic_vector(7 downto 0);
	pixel2_in				: in std_logic_vector(7 downto 0);
	pixel3_in				: in std_logic_vector(7 downto 0);--final pixel input RBG or greyscale (or any othertype like YUV)
	dataAvailable_in	: in std_logic;
	lastPixel_in		: in std_logic;--indicates that this pixel is the last of the frame
	
	-- from avalon slave part
	as_start			: IN std_logic;
	as_stop				: IN std_logic;
	as_mode				: IN std_logic; -- video/snapshot_n (1=> video, 0=> snapshot, one image only)
				
		-- outputs:
	--to avalon master part
	am_Data				: OUT std_logic_vector(31 downto 0);
	am_newData			: OUT std_logic;
	am_newFrame			: OUT std_logic;
	am_newLine			: OUT std_logic;
	am_lastPixel		: OUT std_logic;
	-- to slave
	as_nbPixels			: OUT std_logic_vector(31 downto 0)
	

	
	
	);
end ControlerCamera; 

architecture arch of ControlerCamera is 

	type StateType is 			(stopped,waitFrame,dataAcquisition);
	signal state 				: StateType;
	
	signal mode_reg				: std_logic; -- video/snapshot_n. If snapshot, when image finished don't treat next incoming image, stop.
	signal stopped_reg			: std_logic;
	
	
begin
	
	
	
	
	process(clk,reset)
		variable pixelData		: std_logic_vector(31 downto 0);
		variable nbPixels_reg	: std_logic_vector(31 downto 0);
		variable startCnt		: std_logic_vector(1 downto 0);--debug
	begin
	
		
		
		if(reset='1')then
	
			state<=stopped;
			stopped_reg<='1';--the system is stopped
			nbPixels_reg:=(others=>'0');

			startCnt:=(others=>'0');
			
		elsif(rising_edge(clk))then
	
			am_newFrame<='0';
			am_newLine<='0';
			am_newData<='0';
			am_lastPixel<='0';

			
			if(as_stop='1')then
				stopped_reg<='1';
			end if;
	
			case state is
					when stopped =>
					
						if(as_start='1')then
							state<=waitFrame;
							mode_reg<=as_mode;
							stopped_reg<='0';--the system is not stopped
							startCnt:=startCnt+1;
							
						end if;
	
					
					when waitFrame =>
					
						if(newFrame_in='1')then
						
							state<=dataAcquisition;
							am_newFrame<='1';
						end if;
						
						if(newLine_in='1')then
							am_newLine<='1';
						end if;
						
					when dataAcquisition =>
					
						if(newLine_in='1')then
							am_newLine<='1';
						end if;

						if(dataAvailable_in='1')then
							
								pixelData(7 downto 0):=pixel0_in(7 downto 0);
								pixelData(15 downto 8):=pixel1_in(7 downto 0);
								pixelData(23 downto 16):=pixel2_in(7 downto 0);
								pixelData(31 downto 24):=pixel3_in(7 downto 0);
			
							am_newData<='1';
							nbPixels_reg:=nbPixels_reg+1;
											
							am_Data(31 downto 0)<=pixelData;
							am_lastPixel<=lastPixel_in;--propagate the last pixel information
							
							if(lastPixel_in='1')then--if it is the last pixel, indicate the number of pixels, and decide in which state to go
								as_nbPixels<=nbPixels_reg;
								nbPixels_reg:=(others=>'0');
								
								if(mode_reg='0' or stopped_reg='1')then--snapshot or user stopped the process, must wait next start
									state<=stopped;
								else--if the mode is video and not stopped, wait next frame
									state<=waitFrame;
								end if;
							end if;
							
						end if;
					
					
			end case;
	
		end if;
	
	end process;

end arch; 