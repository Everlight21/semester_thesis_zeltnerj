library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


ENTITY Color_Bradford is
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
	out1,out2,out3		: out std_logic_vector(9 downto 0)
	);
end Color_Bradford;


architecture arch of Color_Bradford is

	signal ma00,ma01,ma02,ma10,ma11,ma12,ma20,ma21,ma22: std_logic_vector(16 downto 0);--10.16 bits
	
	
	signal multX00,multY10,multZ20,multX01,multY11,multZ21,multX02,multY12,multZ22 : std_logic_vector(33 downto 0);
	
	signal addX,addY,addZ : std_logic_vector(51 downto 0);
	
	signal pipelinedDataOut1,pipelinedDataOut2	:std_logic;
	signal newFrame1,newFrame2					:std_logic;
	signal newLine1,newLine2					:std_logic;
	signal lastPixel1,lastPixel2				:std_logic;
	
	signal Xin,Yin,Zin: std_logic_vector(9 downto 0);
	
BEGIN

	ma00<="0000000000"&"1110010";--0.8951
	ma01<="1111111111"&"0100000";---0.7502
	ma02<="0000000000"&"0000100";--0.0389
	
	ma10<="0000000000"&"0100010";--0.2664
	ma11<="0000000001"&"1011011";--1.7135
	ma12<="1111111111"&"1111000";---0.0685
	
	ma20<="1111111111"&"1101100";-- -0.1614
	ma21<="0000000000"&"0000100";-- 0.0367
	ma22<="0000000001"&"0000011";-- 1.0296

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
		variable Xvar,Yvar,Zvar : std_logic_vector(16 downto 0);
		variable Out1var,Out2var,Out3var : std_logic_vector(33 downto 0);
	begin
	
		if(rising_edge(clk))then

			
			--compute XYZ
			Xin<=X;
			Yin<=Y;
			Zin<=Z;
			
			Xvar:=Xin&"0000000";--integer value is the X input, after the . it all 0 (integer value in fixed point format used)
			Yvar:=Yin&"0000000";--integer value is the Y input, after the . it all 0 (integer value in fixed point format used)
			Zvar:=Zin&"0000000";--integer value is the Z input, after the . it all 0 (integer value in fixed point format used)
			
			multX00<=ma00*Xvar;
			multY10<=ma10*Yvar;
			multZ20<=ma20*Zvar;
			
	
			Out1var:=multX00+multY10+multZ20;
	
			multX01<=ma01*Xvar;
			multY11<=ma11*Yvar;
			multZ21<=ma21*Zvar;
			
		
			Out2var:=multX01+multY11+multZ21;
	
			multX02<=ma02*Xvar;
			multY12<=ma12*Yvar;
			multZ22<=ma22*Zvar;
			
		
			Out3var:=multX02+multY12+multZ22;
			
			if(pipelinedDataOut2='1')then
		
				Out1<= Out1var(23 downto 14);
				Out2<= Out2var(23 downto 14);
				Out3<= Out3var(23 downto 14);
			end if;
			

			
	
		end if;
	
	
	end process;



END arch; 