library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


ENTITY Color_scaleWhiteBalance is
	port(
	
	clk 				: in std_logic;
	reset				: in std_logic;
	
	--
	changeFactors		: in std_logic;
	factor1				: in std_logic_vector(9 downto 0);
	factor2				: in std_logic_vector(9 downto 0);
	factor3				: in std_logic_vector(9 downto 0);
	
	--
	newFrame_in			: in std_logic;
	newLine_in			: in std_logic;
	lastPixel_in		: in std_logic;
	
	dataAvailable_in	: in std_logic;
	in1,in2,in3			: in std_logic_vector(9 downto 0);
	newFrame_out		: out std_logic;
	newLine_out			: out std_logic;
	lastPixel_out		: out std_logic;
	dataAvailable_out	: out std_logic;
	out1,out2,out3				: out std_logic_vector(9 downto 0)
	);
end Color_scaleWhiteBalance;


architecture arch of Color_scaleWhiteBalance is

	signal ma00,ma01,ma02,ma10,ma11,ma12,ma20,ma21,ma22: std_logic_vector(16 downto 0);--10.7 bits
	
	signal nextMatrice1,nextMatrice2,nextMatrice3 : std_logic_vector(16 downto 0);
	
	signal multin100,multin210,multin320,multin101,multin211,multin321,multin102,multin212,multin322 : std_logic_vector(33 downto 0);
	
	
	signal pipelinedDataOut1,pipelinedDataOut2	:std_logic;
	signal newFrame1,newFrame2					:std_logic;
	signal newLine1,newLine2					:std_logic;
	signal lastPixel1,lastPixel2				:std_logic;
	
	
	signal in1in,in2in,in3in: std_logic_vector(9 downto 0);
	
BEGIN

	--diagonal matrix

	--ma00<="0000000000"&"000000";--  X coeff
	ma01<="0000000000"&"0000000";--0.0 
	ma02<="0000000000"&"0000000";--0.0
	
	ma10<="0000000000"&"0000000";--0.0
	--ma11<="0000000000"&"000000";-- Y coeff
	ma12<="0000000000"&"0000000";--0.0
	
	ma20<="0000000000"&"0000000";-- 0.0
	ma21<="0000000000"&"0000000";-- 0.0
	--ma22<="0000000000"&"000000";-- Z coeff

	process(clk,reset)
	begin
	
		if(reset='1')then
			nextMatrice1<="0000000001"&"0000000";-- X coeff, default is 1.0
			nextMatrice2<="0000000001"&"0000000";-- Y coeff, default is 1.0
			nextMatrice3<="0000000001"&"0000000";-- Z coeff, default is 1.0
			
			ma00<="0000000001"&"0000000";-- X coeff, default is 1.0
			ma11<="0000000001"&"0000000";-- Y coeff, default is 1.0
			ma22<="0000000001"&"0000000";-- Z coeff, default is 1.0
			
		elsif(rising_edge(clk))then
			
			if(changeFactors='1')then
				nextMatrice1<="000000"&factor1(9 downto 6)&factor1(5 downto 0)&'0';
				nextMatrice2<="000000"&factor2(9 downto 6)&factor2(5 downto 0)&'0';
				nextMatrice3<="000000"&factor3(9 downto 6)&factor3(5 downto 0)&'0';
			end if;
			
			if(newFrame_in='1')then
				
				ma00<=nextMatrice1;-- X coeff factor 1
				ma11<=nextMatrice2;-- Y coeff factor 1
				ma22<=nextMatrice3;-- Z coeff factor 1
			
			end if;
	
		end if;
	
	end process;

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
		variable out1var,out2var,out3var : std_logic_vector(33 downto 0);
	begin
	
		if(rising_edge(clk))then

			
	
			in1in<=in1;
			in2in<=in2;
			in3in<=in3;
			
			in1var:=in1in&"0000000";--integer value is the in1 input, after the . it all 0 (integer value in fixed point format used)
			in2var:=in2in&"0000000";--integer value is the in1 input, after the . it all 0 (integer value in fixed point format used)
			in3var:=in3in&"0000000";--integer value is the in1 input, after the . it all 0 (integer value in fixed point format used)
			
			multin100<=ma00*in1var;
			multin210<=ma10*in2var;
			multin320<=ma20*in3var;
			

			out1var:=multin100+multin210+multin320;
	
			multin101<=ma01*in1var;
			multin211<=ma11*in2var;
			multin321<=ma21*in3var;
			

			out2var:=multin101+multin211+multin321;
	
			multin102<=ma02*in1var;
			multin212<=ma12*in2var;
			multin322<=ma22*in3var;
			

			out3var:=multin102+multin212+multin322;
			
			if(pipelinedDataOut2='1')then
		
				out1<= out1var(23 downto 14);
				out2<= out2var(23 downto 14);
				out3<= out3var(23 downto 14);
			end if;
			

			
	
		end if;
	
	
	end process;



END arch; 