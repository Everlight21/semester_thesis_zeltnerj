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

ENTITY InputControl is
	port(
	clk					: in std_logic;
	reset				: in std_logic;
	
	data_in				: in std_logic_vector(9 downto 0);
	dataAvailable_in	: in std_logic;
	FV					: in std_logic;
	LV					: in std_logic;
	inputMode			: in std_logic_vector(1 downto 0);--	0=> parallel version, FV and LV must be used
									   --	1=> serial version, 8 bits of data, 1 bit FV and 1 bit for LV
									   --	2=> serial version, 10 bits of data,FV and LV
	newFrame			: out std_logic;
	newLine				: out std_logic;
	data_out			: out std_logic_vector(9 downto 0);
	dataAvailable_out	: out std_logic;
	lastPixel_out		: out std_logic
	);
end InputControl; 

architecture arch of InputControl is 

	signal previous_FV : std_logic;
	signal previous_LV : std_logic;
	signal pixelCounter: integer range 0 to 360960;--752*480
	
	signal internal_dataAvailable: std_logic;
	signal internal_FV : std_logic;
	signal internal_LV : std_logic;
	signal internal_data: std_logic_vector(9 downto 0);
	signal internal_mode: std_logic_vector(1 downto 0);
begin
	
	process(clk)
	begin
	
		if(rising_edge(clk))then
		
			internal_mode<=inputMode;
		
		end if;
	
	end process;
	
	--decoder
	process(clk,reset)
	begin
	
		if(rising_edge(clk))then
			
			case internal_mode is
				
				when "00" => --parallel input mode
								internal_dataAvailable<=dataAvailable_in;
								internal_FV<=FV;
								internal_LV<=LV;
								internal_data<=data_in;
				
				when "01" => --serial input mode, 8 bits data, 1 FV 1 LV
								internal_dataAvailable<=dataAvailable_in;
								internal_FV<=data_in(9);
								internal_LV<=data_in(8);
								internal_data<=data_in(7 downto 0)&"00";--8 bits data input to 10 bits data
				--when "10" =>	--todo	
				when others=>	internal_dataAvailable<=dataAvailable_in;
								internal_FV<=FV;
								internal_LV<=LV;
								internal_data<=data_in;
			end case;
	
		end if;
	
	end process;
	
	--this process received the internal signals decoded by the decoder process
	process(clk,reset)
	begin
	
		if(reset='1')then
	
			newFrame<='0';
			newLine<='0';
			data_out<=(others=>'0');
			dataAvailable_out<='0';
			lastPixel_out<='0';
			pixelCounter<=0;
			
		elsif(rising_edge(clk))then
	
			lastPixel_out<='0';
			
			if(previous_FV='0' and internal_FV='1')then--new frame
				newFrame<='1';
				pixelCounter<=0;--reset the counter of pixels
			else
				newFrame<='0';
			end if;
			
			if(previous_LV='0' and internal_LV='1')then--new line
				newLine<='1';
			else
				newLine<='0';
			end if;
	
			if(internal_FV='1' and internal_LV='1' and internal_dataAvailable='1')then--new pixel received
				
				data_out<=internal_data;
				dataAvailable_out<='1';
				pixelCounter<=pixelCounter+1;--count the number of pixel in this frame
			else
				dataAvailable_out<='0';
			end if;
			
			if(pixelCounter=360959)then--last pixel of the frame
				lastPixel_out<='1';
			end if;
			
			previous_FV<=internal_FV;
			previous_LV<=internal_LV;
			
		end if;
	
	end process;

end arch; 