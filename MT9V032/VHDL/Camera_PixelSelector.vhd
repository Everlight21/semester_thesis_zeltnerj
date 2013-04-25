----------------------------------------------------------
--
--	Iván Muñoz - IN - LAP - EPFL
--
--	4.12.08
--
----------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


--select between the pixel derecly received from the camra (if black and white), or treated (if colored)

ENTITY Camera_PixelSelector is	
	port(
	clk					: in std_logic;
	reset				: in std_logic;
	
	selectColor_in				: in std_logic;--the selector. Select the treated pixel or the raw pixel.
	
	--camera color
	colorPixel_newFrame_in		: in std_logic;
	colorPixel_newLine_in		: in std_logic;
	colorPixel_pixel_in			: in std_logic_vector(31 downto 0);
	colorPixel_dataAvailable_in	: in std_logic;
	colorPixel_lastPixel_in		: in std_logic;
	
	--camera direct(B/W)
	bwPixel_newFrame_in			: in std_logic;
	bwPixel_newLine_in			: in std_logic;
	bwPixel_pixel_in			: in std_logic_vector(9 downto 0);
	bwPixel_dataAvailable_in	: in std_logic;
	bwPixel_lastPixel_in		: in std_logic;
		

	newFrame_out				: out std_logic;
	newLine_out					: out std_logic;
	pixel_out					: out std_logic_vector(31 downto 0);--RGB 10 bits ouputs. If black and white, outputs grey color RGB with same color for R,G and B
	dataAvailable_out			: out std_logic;
	lastPixel_out				: out std_logic
		

	);
end Camera_PixelSelector; 

architecture arch of Camera_PixelSelector is 


begin
	
	process(clk,reset)
	begin
	
		if(reset='1')then
			newFrame_out<='0';
			newLine_out<='0';
			pixel_out<=(others=>'0');
			dataAvailable_out<='0';
			lastPixel_out<='0';
		elsif(rising_edge(clk))then
		
			case selectColor_in is
		
				when '0' =>--treated pixel, used for color
						newFrame_out		<=colorPixel_newFrame_in;
						newLine_out			<=colorPixel_newLine_in;
						pixel_out			<=colorPixel_pixel_in;
						dataAvailable_out	<=colorPixel_dataAvailable_in;
						lastPixel_out		<=colorPixel_lastPixel_in;
						
				when '1' =>--not treated pixel, used for black and white
						newFrame_out		<=bwPixel_newFrame_in;
						newLine_out			<=bwPixel_newLine_in;
						pixel_out			<="00"&bwPixel_pixel_in&bwPixel_pixel_in&bwPixel_pixel_in;--R,G and B with the grey value in 10 bits per color
						dataAvailable_out	<=bwPixel_dataAvailable_in;
						lastPixel_out		<=bwPixel_lastPixel_in;
						
			end case;
		
		end if;
	
	end process;

end arch; 