----------------------------------------------------------
--
--	Iván Muñoz - IN - LAP - EPFL
--
--	18.10.08
--
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Camera_Color_Treatment is
        port (
				-- inputs:
                clk 			: IN std_logic;
				reset			: IN std_logic;
				
				
				--slave part in
				as_newValue_in		: in std_logic;--indicates that a new pixel correctio value is available, to be apply for next frame
				as_correctionFactor1	: in std_logic_vector(7 downto 0);
				as_correctionFactor2	: in std_logic_vector(7 downto 0);
				as_correctionFactor3	: in std_logic_vector(7 downto 0);

				--camera in
				newFrame_in			: in std_logic;
				newLine_in			: in std_logic;
				pixel_in			: in std_logic_vector(31 downto 0);--pixel input RGB 10 bits
				dataAvailable_in	: in std_logic;
				lastPixel_in		: in std_logic;--indicates that this pixel is the last of the frame
				
				
				
				--out
				newFrame_out		: out std_logic;
				newLine_out			: out std_logic;
				pixel_out			: out std_logic_vector(31 downto 0);--final pixel input RBG 10 bits
				dataAvailable_out	: out std_logic;
				lastPixel_out		: out std_logic--indicates that this pixel is the last of the frame


             
              );
end entity Camera_Color_Treatment;


architecture arch of Camera_Color_Treatment is

	signal coeff_R_reg		: std_logic_vector(7 downto 0);--1.7 bits
	signal coeff_G_reg		: std_logic_vector(7 downto 0);--1.7 bits
	signal coeff_B_reg		: std_logic_vector(7 downto 0);--1.7 bits

	signal coeff_nextFrame_reg	: std_logic_vector(23 downto 0);--the coeff value for the next frame (X,B,G,R)

begin

	process(clk,reset)--process to manage new value of the coeff_X_reg
	begin
		
		if(reset='1')then
			coeff_nextFrame_reg<=(others=>'0');
			coeff_R_reg<=(others=>'0');
			coeff_G_reg<=(others=>'0');
			coeff_B_reg<=(others=>'0');
			
		elsif(rising_edge(clk))then
	
			if(as_newValue_in='1')then--if a new value is set, it will be used in the next frame
				
				coeff_nextFrame_reg<=as_correctionFactor3 & as_correctionFactor2 & as_correctionFactor1;
			end if;
			
			if(newFrame_in='1')then--if there is new frame, update the value of the coefficients
			
				coeff_R_reg<=coeff_nextFrame_reg(7 downto 0);
				coeff_G_reg<=coeff_nextFrame_reg(15 downto 8);
				coeff_B_reg<=coeff_nextFrame_reg(23 downto 16);
				
			end if;
	
		end if;
	
	end process;
	
	process(clk,reset)
	
		variable pixel_R_var: std_logic_vector(16 downto 0);
		variable pixel_R_mult_var: std_logic_vector(33 downto 0);
		
		variable pixel_G_var: std_logic_vector(16 downto 0);
		variable pixel_G_mult_var: std_logic_vector(33 downto 0);
		
		variable pixel_B_var: std_logic_vector(16 downto 0);
		variable pixel_B_mult_var: std_logic_vector(33 downto 0);
		
	begin
	
		if(reset='1')then
	
			pixel_out<=(others=>'0');
			newFrame_out<='0';
			newLine_out<='0';
			lastPixel_out<='0';
			dataAvailable_out<='0';
			
		elsif(rising_edge(clk))then
	
			dataAvailable_out<='0';
			newFrame_out<=newFrame_in;
			newLine_out<=newLine_in;
			lastPixel_out<='0';
			
			if(dataAvailable_in='1')then
		
				

								pixel_R_var:=pixel_in(9 downto 0)&"0000000";-- 10.7 bits fixed point format
								pixel_R_mult_var:=(pixel_R_var*("000000000"&coeff_R_reg));
								
								if(pixel_R_mult_var(32 downto 14)>1023)then--if there is an overflow, set the value to the max
									pixel_out(9 downto 0)<=(others =>'1');
								else--otherwise set the correct value
									pixel_out(9 downto 0)<=pixel_R_mult_var(23 downto 14);
								end if;
								
								--Green color
								pixel_G_var:=pixel_in(19 downto 10)&"0000000";-- 10.7 bits fixed point format
								pixel_G_mult_var:=(pixel_G_var*("000000000"&coeff_G_reg));
								
								if(pixel_G_mult_var(32 downto 14)>1023)then--if there is an overflow, set the value to the max
									pixel_out(19 downto 10)<=(others =>'1');
								else--otherwise set the correct value
									pixel_out(19 downto 10)<=pixel_G_mult_var(23 downto 14);
								end if;
								
								--Blue color
								pixel_B_var:=pixel_in(29 downto 20)&"0000000";-- 10.7 bits fixed point format
								pixel_B_mult_var:=(pixel_B_var*("000000000"&coeff_B_reg));
								
								if(pixel_B_mult_var(32 downto 14)>1023)then--if there is an overflow, set the value to the max
									pixel_out(29 downto 20)<=(others =>'1');
								else--otherwise set the correct value
									pixel_out(29 downto 20)<=pixel_B_mult_var(23 downto 14);
								end if;
								
	
		
				
				dataAvailable_out<='1';
				lastPixel_out<=lastPixel_in;
			end if;
	
		end if;
		
	
	end process;


end arch;