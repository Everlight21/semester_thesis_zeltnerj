library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


ENTITY XYZtoRGB is
	port(
	
	clk 				: in std_logic;
	newFrame_in			: in std_logic;
	newLine_in			: in std_logic;
	lastPixel_in		: in std_logic;
	dataAvailable_in	: in std_logic;
	X,Y,Z				: in std_logic_vector(9 downto 0);
	newFrame_out			: out std_logic;
	newLine_out			: out std_logic;
	lastPixel_out		: out std_logic;
	dataAvailable_out	: out std_logic;
	R,G,B				: out std_logic_vector(9 downto 0)
	);
end XYZtoRGB;


architecture arch of XYZtoRGB is

	signal ma00,ma01,ma02,ma10,ma11,ma12,ma20,ma21,ma22: std_logic_vector(16 downto 0);--10.7 bits
	
	
	signal multR00,multG10,multB20,multR01,multG11,multB21,multR02,multG12,multB22 : std_logic_vector(33 downto 0);
	
	
		signal pipelinedDataOut1,pipelinedDataOut2	:std_logic;
	signal newFrame1,newFrame2					:std_logic;
	signal newLine1,newLine2					:std_logic;
	signal lastPixel1,lastPixel2				:std_logic;
	
	signal Xin,Yin,Zin: std_logic_vector(9 downto 0);
	
BEGIN

	ma00<="0000000010"&"0000101";--2.04148
	ma01<="1111111111"&"0000100";-- -0.969258
	ma02<="0000000000"&"0000001";--0.0134455 
	
	ma10<="1111111111"&"0111000";---0.564977
	ma11<="0000000001"&"1110000";--1.87599  
	ma12<="1111111111"&"1110001";---0.118373 
	
	ma20<="1111111111"&"1010100";-- -0.344713
	ma21<="0000000000"&"0000101";-- 0.0415557
	ma22<="0000000001"&"0000001";-- 1.01527 

	process(clk)
	begin
	
		if(rising_edge(clk))then
			--3 stage pipeline
			pipelinedDataOut1<=dataAvailable_in;
			pipelinedDataOut2<=pipelinedDataOut1;
			dataAvailable_out<=pipelinedDataOut2;
			
			newFrame1<=newFrame_in;
			newFrame2<=newFrame1;
			newFrame_out<=newFrame2;
			
			
			newLine1<=newLine_in;
			newLine2<=newLine1;
			newLine_out<=newLine2;
			
			lastPixel1<=lastPixel_in;
			lastPixel2<=lastPixel1;
			lastPixel_out<=lastPixel2;
		end if;
		
	end process;


	process(clk)
		variable Rvar,Gvar,Bvar : std_logic_vector(33 downto 0);
		variable Xvar,Yvar,Zvar : std_logic_vector(16 downto 0);
		variable Rout,Gout,Bout	: std_logic_vector(9 downto 0);
	begin
	
		if(rising_edge(clk))then

			
			--compute XYZ
			Xin<=X;
			Yin<=Y;
			Zin<=Z;
			
			Xvar:=Xin&"0000000";--integer value is the R input, after the . it all 0 (integer value in fixed point format used)
			Yvar:=Yin&"0000000";--integer value is the R input, after the . it all 0 (integer value in fixed point format used)
			Zvar:=Zin&"0000000";--integer value is the R input, after the . it all 0 (integer value in fixed point format used)
			
			multR00<=ma00*Xvar;
			multG10<=ma10*Yvar;
			multB20<=ma20*Zvar;
			
			Rvar:=multR00+multG10+multB20;
	
			multR01<=ma01*Xvar;
			multG11<=ma11*Yvar;
			multB21<=ma21*Zvar;
			
			Gvar:=multR01+multG11+multB21;
	
			multR02<=ma02*Xvar;
			multG12<=ma12*Yvar;
			multB22<=ma22*Zvar;
			
			Bvar:=multR02+multG12+multB22;
			
			if(pipelinedDataOut2='1')then
		
				Rout:= Rvar(23 downto 14);
				Gout:= Gvar(23 downto 14);
				Bout:= Bvar(23 downto 14);
				
				if(Rout>255)then
					R<="1111111100";
				else
					R<=Rout(7 downto 0)&"00";
				end if;
				
				if(Gout>255)then
					G<="1111111100";
				else
					G<=Gout(7 downto 0)&"00";
				end if;
				
				if(Bout>255)then
					B<="1111111100";
				else
					B<=Bout(7 downto 0)&"00";
				end if;
				
			end if;
	
		end if;
	
	
	end process;



END arch; 