

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity RectUndist_Slave is 
        port (
				-- inputs:
				clk 		: IN std_logic;
				reset		: IN std_logic;

				-- avalon bus:
				avalon_chipselect	: IN std_logic;
				avalon_address		: IN std_logic_vector(4 downto 0);--32 registers used
				avalon_read			: IN std_logic;
				avalon_writeData	: IN std_logic_vector(31 downto 0);
				avalon_write		: IN std_logic;
				avalon_readData 	: OUT std_logic_vector(31 downto 0);				
				
				-- outputs:		
				left_k1	: OUT std_logic_vector(17 downto 0);
				left_k2	: OUT std_logic_vector(17 downto 0);
				left_ccx :OUT std_logic_vector(19 downto 0);
				left_ccy :OUT std_logic_vector(19 downto 0);
				left_fcx	: OUT std_logic_vector(19 downto 0);
				left_fcy	: OUT std_logic_vector(19 downto 0);
				
				left_r11: OUT std_logic_vector(17 downto 0);
				left_r12: OUT std_logic_vector(17 downto 0);
				left_r13: OUT std_logic_vector(27 downto 0);
				left_r21: OUT std_logic_vector(17 downto 0);
				left_r22: OUT std_logic_vector(17 downto 0);
				left_r23: OUT std_logic_vector(27 downto 0);
				left_r31: OUT std_logic_vector(17 downto 0);
				left_r32: OUT std_logic_vector(17 downto 0);
				left_r33: OUT std_logic_vector(19 downto 0);
				
				right_k1	: OUT std_logic_vector(17 downto 0);
				right_k2	: OUT std_logic_vector(17 downto 0);
				right_ccx :OUT std_logic_vector(19 downto 0);
				right_ccy :OUT std_logic_vector(19 downto 0);
				right_fcx	: OUT std_logic_vector(19 downto 0);
				right_fcy	: OUT std_logic_vector(19 downto 0);
				
				right_r11: OUT std_logic_vector(17 downto 0);
				right_r12: OUT std_logic_vector(17 downto 0);
				right_r13: OUT std_logic_vector(27 downto 0);
				right_r21: OUT std_logic_vector(17 downto 0);
				right_r22: OUT std_logic_vector(17 downto 0);
				right_r23: OUT std_logic_vector(27 downto 0);
				right_r31: OUT std_logic_vector(17 downto 0);
				right_r32: OUT std_logic_vector(17 downto 0);
				right_r33: OUT std_logic_vector(19 downto 0)


             );
end entity RectUndist_Slave;


architecture arch of RectUndist_Slave is

	signal left_k1_reg: std_logic_vector(17 downto 0);
	signal left_k2_reg: std_logic_vector(17 downto 0);	
	signal right_k1_reg: std_logic_vector(17 downto 0);
	signal right_k2_reg: std_logic_vector(17 downto 0);
	
	signal left_ccx_reg: std_logic_vector(19 downto 0);
	signal left_ccy_reg: std_logic_vector(19 downto 0);	
	signal left_fcx_reg: std_logic_vector(19 downto 0);
	signal left_fcy_reg: std_logic_vector(19 downto 0);
	
	signal right_ccx_reg: std_logic_vector(19 downto 0);
	signal right_ccy_reg: std_logic_vector(19 downto 0);	
	signal right_fcx_reg: std_logic_vector(19 downto 0);
	signal right_fcy_reg: std_logic_vector(19 downto 0);		
	
	signal h11l_reg: std_logic_vector(17 downto 0);	
	signal h12l_reg: std_logic_vector(17 downto 0);	
	signal h13l_reg: std_logic_vector(27 downto 0);
	signal h21l_reg: std_logic_vector(17 downto 0);	
	signal h22l_reg: std_logic_vector(17 downto 0);	
	signal h23l_reg: std_logic_vector(27 downto 0);	
	signal h31l_reg: std_logic_vector(17 downto 0);	
	signal h32l_reg: std_logic_vector(17 downto 0);	
	signal h33l_reg: std_logic_vector(19 downto 0);	

	signal h11r_reg: std_logic_vector(17 downto 0);	
	signal h12r_reg: std_logic_vector(17 downto 0);	
	signal h13r_reg: std_logic_vector(27 downto 0);
	signal h21r_reg: std_logic_vector(17 downto 0);	
	signal h22r_reg: std_logic_vector(17 downto 0);	
	signal h23r_reg: std_logic_vector(27 downto 0);	
	signal h31r_reg: std_logic_vector(17 downto 0);	
	signal h32r_reg: std_logic_vector(17 downto 0);	
	signal h33r_reg: std_logic_vector(19 downto 0);		


	---------------------------------
	
begin		

	--write process
	process(clk,reset)
		--variable exposureTimeCounter: integer range 0 to 2500009; --the counter to know how many clock cylcles we must set to 1 the exposure signal
	begin
	
		if(reset='1')then
			left_k1_reg<=(others=>'0');
			left_k2_reg<=(others=>'0');
			right_k1_reg<=(others=>'0');
			right_k2_reg<=(others=>'0');
			
			left_ccx_reg<=(others=>'0');
			left_ccy_reg<=(others=>'0');
			left_fcx_reg<=(others=>'0');
			left_fcy_reg<=(others=>'0');
			
			right_ccx_reg<=(others=>'0');
			right_ccy_reg<=(others=>'0');
			right_fcx_reg<=(others=>'0');
			right_fcy_reg<=(others=>'0');
			
			h11l_reg<=(others=>'0');
			h12l_reg<=(others=>'0');
			h13l_reg<=(others=>'0');
			h21l_reg<=(others=>'0');
			h22l_reg<=(others=>'0');
			h23l_reg<=(others=>'0');
			h31l_reg<=(others=>'0');
			h32l_reg<=(others=>'0');
			h33l_reg<=(others=>'0');			
			
			h11r_reg<=(others=>'0');
			h12r_reg<=(others=>'0');
			h13r_reg<=(others=>'0');
			h21r_reg<=(others=>'0');
			h22r_reg<=(others=>'0');
			h23r_reg<=(others=>'0');
			h31r_reg<=(others=>'0');
			h32r_reg<=(others=>'0');
			h33r_reg<=(others=>'0');			
			
		elsif(rising_edge(clk))then
		
		
			--want to write something
			if(avalon_chipselect='1' and avalon_write='1')then
				
				case avalon_address is
					when "00000" =>
								left_k1_reg<=avalon_writeData(17 downto 0);
					when "00001" =>
								left_k2_reg<=avalon_writeData(17 downto 0);
					when "00010" =>
								right_k1_reg<=avalon_writeData(17 downto 0);
					when "00011" =>
								right_k2_reg<=avalon_writeData(17 downto 0);	
	
					when "00100" =>
								left_ccx_reg<=avalon_writeData(19 downto 0);
					when "00101" =>
								left_ccy_reg<=avalon_writeData(19 downto 0);	
					when "00110" =>
								left_fcx_reg<=avalon_writeData(19 downto 0);	
					when "00111" =>
								left_fcy_reg<=avalon_writeData(19 downto 0);	

					when "01000" =>
								right_ccx_reg<=avalon_writeData(19 downto 0);
					when "01001" =>
								right_ccy_reg<=avalon_writeData(19 downto 0);	
					when "01010" =>
								right_fcx_reg<=avalon_writeData(19 downto 0);	
					when "01011" =>
								right_fcy_reg<=avalon_writeData(19 downto 0);

					when "01100" =>								
								h11l_reg<=avalon_writeData(17 downto 0);
					when "01101" =>								
								h12l_reg<=avalon_writeData(17 downto 0);
					when "01110" =>								
								h13l_reg<=avalon_writeData(27 downto 0);
					when "01111" =>								
								h21l_reg<=avalon_writeData(17 downto 0);
					when "10000" =>								
								h22l_reg<=avalon_writeData(17 downto 0);
					when "10001" =>								
								h23l_reg<=avalon_writeData(27 downto 0);	
					when "10010" =>								
								h31l_reg<=avalon_writeData(17 downto 0);
					when "10011" =>								
								h32l_reg<=avalon_writeData(17 downto 0);
					when "10100" =>								
								h33l_reg<=avalon_writeData(19 downto 0);	
								

					when "10101" =>								
								h11r_reg<=avalon_writeData(17 downto 0);
					when "10110" =>								
								h12r_reg<=avalon_writeData(17 downto 0);
					when "10111" =>								
								h13r_reg<=avalon_writeData(27 downto 0);
					when "11000" =>								
								h21r_reg<=avalon_writeData(17 downto 0);
					when "11001" =>								
								h22r_reg<=avalon_writeData(17 downto 0);
					when "11010" =>								
								h23r_reg<=avalon_writeData(27 downto 0);	
					when "11011" =>								
								h31r_reg<=avalon_writeData(17 downto 0);
					when "11100" =>								
								h32r_reg<=avalon_writeData(17 downto 0);
					when "11101" =>								
								h33r_reg<=avalon_writeData(19 downto 0);									
								
								
					when others=>
					
				end case;
				
			end if;
			
		end if;
		
		left_k1<=left_k1_reg;
		left_k2<=left_k2_reg;
		left_ccx<=left_ccx_reg;
		left_ccy<=left_ccy_reg;
		left_fcx<=left_fcx_reg;
		left_fcy<=left_fcy_reg;
		
		right_k1<=right_k1_reg;
		right_k2<=right_k2_reg;
		right_ccx<=right_ccx_reg;
		right_ccy<=right_ccy_reg;
		right_fcx<=right_fcx_reg;
		right_fcy<=right_fcy_reg;
		
		left_r11<=h11l_reg;
		left_r12<=h12l_reg;
		left_r13<=h13l_reg;
		left_r21<=h21l_reg;
		left_r22<=h22l_reg;
		left_r23<=h23l_reg;
		left_r31<=h31l_reg;
		left_r32<=h32l_reg;
		left_r33<=h33l_reg;

		right_r11<=h11r_reg;
		right_r12<=h12r_reg;
		right_r13<=h13r_reg;
		right_r21<=h21r_reg;
		right_r22<=h22r_reg;
		right_r23<=h23r_reg;
		right_r31<=h31r_reg;
		right_r32<=h32r_reg;
		right_r33<=h33r_reg;				
	
		
	end process;
	
	--read process
	process(clk)
	begin
	
		if(rising_edge(clk))then
	
			--want to read
			if(avalon_chipselect='1' and avalon_read='1')then
	
				case avalon_address is
					when "00000" => avalon_readData(17 downto 0)<=left_k1_reg;
					when "00001" => avalon_readData(17 downto 0)<=left_k2_reg;
					when "00010" => avalon_readData(17 downto 0)<=right_k1_reg;		
					when "00011" => avalon_readData(17 downto 0)<=right_k2_reg;
			
					when "00100" => avalon_readData(19 downto 0)<=left_ccx_reg;
					when "00101" => avalon_readData(19 downto 0)<=left_ccy_reg;
					when "00110" => avalon_readData(19 downto 0)<=left_fcx_reg;		
					when "00111" => avalon_readData(19 downto 0)<=left_fcy_reg;	
			
					when "01000" => avalon_readData(19 downto 0)<=right_ccx_reg;
					when "01001" => avalon_readData(19 downto 0)<=right_ccy_reg;
					when "01010" => avalon_readData(19 downto 0)<=right_fcx_reg;		
					when "01011" => avalon_readData(19 downto 0)<=right_fcy_reg;			
					when others =>
			
				end case;
			end if;
	
		end if;
	
	end process;
		
end arch;

