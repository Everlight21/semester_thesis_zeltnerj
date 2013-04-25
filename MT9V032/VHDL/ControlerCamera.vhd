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
	pixel_in			: in std_logic_vector(31 downto 0);--final pixel input RBG or greyscale (or any othertype like YUV)
	dataAvailable_in	: in std_logic;
	lastPixel_in		: in std_logic;--indicates that this pixel is the last of the frame
	
	-- from avalon slave part
	as_start			: IN std_logic;
	as_stop				: IN std_logic;
	as_mode				: IN std_logic; -- video/snapshot_n (1=> video, 0=> snapshot, one image only)
	as_BGR				: IN std_logic;-- BGR/RGB_n
	as_8bits			: IN std_logic;-- 8bits/10bits_n
				
		-- outputs:
	--to avalon master part
	am_Data				: OUT std_logic_vector(31 downto 0);
	am_newData			: OUT std_logic;
	am_newFrame			: OUT std_logic;
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
	
	
	
	signal BGR_reg				: std_logic;
	signal to8bits_reg			: std_logic;
	
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
							BGR_reg<=as_BGR;
							to8bits_reg<=as_8bits;
							startCnt:=startCnt+1;
							
						end if;
	
					
					when waitFrame =>
					
						if(newFrame_in='1')then
						
							state<=dataAcquisition;
							am_newFrame<='1';
						end if;

						
					when dataAcquisition =>
					
	

						if(dataAvailable_in='1')then
							
							if(to8bits_reg='1')then--if we want to store 8 bits, change from 10 to 8 bits
								
								if(BGR_reg='1')then
									pixelData(7 downto 0):=pixel_in(29 downto 22);--R
									pixelData(15 downto 8):=pixel_in(19 downto 12);--G
									pixelData(23 downto 16):=pixel_in( 9 downto 2);--B
								else
									pixelData(7 downto 0):=pixel_in(9 downto 2);--B
									pixelData(15 downto 8):=pixel_in(19 downto 12);--G
									pixelData(23 downto 16):=pixel_in(29 downto 22);--R
								end if;
							else--10 bits
								if(BGR_reg='1')then
									pixelData(9 downto 0):=pixel_in(29 downto 20);--R
									pixelData(19 downto 10):=pixel_in(19 downto 10);--G
									pixelData(29 downto 20):=pixel_in( 9 downto 0);--B
								else
									pixelData:=pixel_in;--don't change anything
								end if;
							end if;
			
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