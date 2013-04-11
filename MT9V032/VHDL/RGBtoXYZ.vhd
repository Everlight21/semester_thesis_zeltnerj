library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


ENTITY RGBtoXYZ is
	port(
	
	clk 				: in std_logic;
	newFrame_in			: in std_logic;
	newLine_in			: in std_logic;
	lastPixel_in		: in std_logic;
	dataAvailable_in	: in std_logic;
	R,G,B				: in std_logic_vector(9 downto 0);
	newFrame_out			: out std_logic;
	newLine_out			: out std_logic;
	lastPixel_out		: out std_logic;
	dataAvailable_out	: out std_logic;
	X,Y,Z				: out std_logic_vector(9 downto 0)
	);
end RGBtoXYZ;


architecture arch of RGBtoXYZ is

	signal ma00,ma01,ma02,ma10,ma11,ma12,ma20,ma21,ma22: std_logic_vector(16 downto 0);--10.7 bits
	
	
	signal multR00,multG10,multB20,multR01,multG11,multB21,multR02,multG12,multB22 : std_logic_vector(33 downto 0);
	
	
	signal pipelinedDataOut1,pipelinedDataOut2	:std_logic;
	signal newFrame1,newFrame2					:std_logic;
	signal newLine1,newLine2					:std_logic;
	signal lastPixel1,lastPixel2				:std_logic;
	
	signal Rin,Gin,Bin: std_logic_vector(9 downto 0);
	
BEGIN

	ma00<="0000000000"&"1001001";--0.5767
	ma01<="0000000000"&"0100110";--0.297361 
	ma02<="0000000000"&"0000011";--0.0270328
	
	ma10<="0000000000"&"0010111";--0.185556
	ma11<="0000000000"&"1010000";--0.627355 
	ma12<="0000000000"&"0001001";--0.0706879
	
	ma20<="0000000000"&"0011000";-- 0.188212
	ma21<="0000000000"&"0001001";-- 0.0752847
	ma22<="0000000000"&"1111110";-- 0.991248


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
		variable Rvar,Gvar,Bvar : std_logic_vector(16 downto 0);
		variable Xvar,Yvar,Zvar : std_logic_vector(33 downto 0);
	begin
	
		if(rising_edge(clk))then
			
			--compute XYZ
			Rin<="00" & R(9 downto 2);
			Bin<="00" & B(9 downto 2);
			Gin<="00" & G(9 downto 2);
			
			Rvar:=Rin&"0000000";--integer value is the R input, after the . it all 0 (integer value in fixed point format used)
			Gvar:=Gin&"0000000";--integer value is the R input, after the . it all 0 (integer value in fixed point format used)
			Bvar:=Bin&"0000000";--integer value is the R input, after the . it all 0 (integer value in fixed point format used)
			
			multR00<=ma00*Rvar;
			multG10<=ma10*Gvar;
			multB20<=ma20*Bvar;
			
			--addX<=multR00+multG10;
			Xvar:=multR00+multG10+multB20;
	
			multR01<=ma01*Rvar;
			multG11<=ma11*Gvar;
			multB21<=ma21*Bvar;
			
			--addY<=multR01+multG11;
			Yvar:=multR01+multG11+multB21;
	
			multR02<=ma02*Rvar;
			multG12<=ma12*Gvar;
			multB22<=ma22*Bvar;
			
			--addZ<=multR02+multG12;
			Zvar:=multR02+multG12+multB22;
			
			if(pipelinedDataOut2='1')then
		
				X<= Xvar(23 downto 14);
				Y<= Yvar(23 downto 14);
				Z<= Zvar(23 downto 14);
			end if;
			

			
	
		end if;
	
	
	end process;



END arch; 