library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


ENTITY Color_BradfordInv is
	port(
	
	clk 				: in std_logic;
	newFrame_in			: in std_logic;
	newLine_in			: in std_logic;
	lastPixel_in		: in std_logic;
	dataAvailable_in	: in std_logic;
	in1,in2,in3			: in std_logic_vector(9 downto 0);
	newFrame_out		: out std_logic;
	newLine_out			: out std_logic;
	lastPixel_out		: out std_logic;
	dataAvailable_out	: out std_logic;
	X,Y,Z				: out std_logic_vector(9 downto 0)
	);
end Color_BradfordInv;


architecture arch of Color_BradfordInv is

	signal ma00,ma01,ma02,ma10,ma11,ma12,ma20,ma21,ma22: std_logic_vector(16 downto 0);--10.6 bits
	
	
	signal multin100,multin210,multin320,multin101,multin211,multin321,multin102,multin212,multin322 : std_logic_vector(33 downto 0);
	

	signal pipelinedDataOut1,pipelinedDataOut2	:std_logic;
	signal newFrame1,newFrame2					:std_logic;
	signal newLine1,newLine2					:std_logic;
	signal lastPixel1,lastPixel2				:std_logic;
	
	signal in1in,in2in,in3in: std_logic_vector(9 downto 0);
	
BEGIN

	ma00<="0000000000"&"1111110";--0.986993
	ma01<="0000000000"&"0110111";--0.432305
	ma02<="0000000000"&"0000000";---.0008529
	
	ma10<="1111111111"&"1101110";---0.147054
	ma11<="0000000000"&"1000010";--0.518360 
	ma12<="0000000000"&"0000101";--0.040043
	
	ma20<="0000000000"&"0010100";-- 0.159963
	ma21<="0000000000"&"0000110";-- 0.049291
	ma22<="0000000000"&"1111011";-- 0.968487

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
		variable in1var,in2var,in3var : std_logic_vector(16 downto 0);
		variable Xvar,Yvar,Zvar : std_logic_vector(33 downto 0);
	begin
	
		if(rising_edge(clk))then
			
			--compute XYZ
			in1in<=in1;
			in3in<=in3;
			in2in<=in2;
			
			in1var:=in1in&"0000000";--integer value is the in1 input, after the . it all 0 (integer value in fixed point format used)
			in2var:=in2in&"0000000";--integer value is the in1 input, after the . it all 0 (integer value in fixed point format used)
			in3var:=in3in&"0000000";--integer value is the in1 input, after the . it all 0 (integer value in fixed point format used)
			
			multin100<=ma00*in1var;
			multin210<=ma10*in2var;
			multin320<=ma20*in3var;
			
	
			Xvar:=multin100+multin210+multin320;
	
			multin101<=ma01*in1var;
			multin211<=ma11*in2var;
			multin321<=ma21*in3var;
			
	
			Yvar:=multin101+multin211+multin321;
	
			multin102<=ma02*in1var;
			multin212<=ma12*in2var;
			multin322<=ma22*in3var;
			

			Zvar:=multin102+multin212+multin322;
			
			if(pipelinedDataOut2='1')then
		
				X<= Xvar(23 downto 14);
				Y<= Yvar(23 downto 14);
				Z<= Zvar(23 downto 14);
			end if;
			

			
	
		end if;
	
	
	end process;



END arch; 