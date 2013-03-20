

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


ENTITY LVDSSyncControler is
	
	port(
	clk			: in std_logic;
	reset			: in std_logic;
	LVDSRX		: in std_logic_vector(49 downto 0);
	rxclk			: in std_logic;
	button1		: in std_logic;

    button2		: in std_logic;	
	button3		: in std_logic;
	---	
	align1	: out std_logic;
	align2	: out std_logic;	
	align3	: out std_logic;	
	align4	: out std_logic;		
	dataAvailable	: out std_logic;
	led1	: out std_logic;	
	led2	: out std_logic;	
	pixel1			: out std_logic_vector(9 downto 0);
	pixel5			: out std_logic_vector(9 downto 0);
	pixel9			: out std_logic_vector(9 downto 0);
	pixel13			: out std_logic_vector(9 downto 0);	
	FV				: out std_logic;
	LV				: out std_logic
	);
end LVDSSyncControler; 

architecture arch of LVDSSyncControler is 

	--signal binningcorrect : std_logic_vector(2 downto 0);
	signal count 	: std_logic_vector(16 downto 0);	
	--signal pixelCounter: integer range 0 to 90240;--360960;--752*480	
	
	
begin
	
	process(clk,reset)
	
	begin
	
		if(reset='1')then
		
		pixel1<=(others=>'0');	
		pixel5<=(others=>'0');	
		pixel9<=(others=>'0');			
		pixel13<=(others=>'0');			
		FV<='0';
		LV<='0';
		align1<='0';
		align2<='0';	
		align3<='0';		
		count<=(others=>'0');
		dataAvailable<='0';	
		
		
		elsif(rising_edge(clk))then
		
			dataAvailable<='0';
			
			--alignment control
			if(LVDSRX(1) = '0' and LVDSRX(0) = '1') then --reverse order!			
				align1<='0';
				if(count<64000) then
				count<=count+1;
				end if;
			elsif (count<63000) then
				align1<='1';
			end if;
			
			if(button1='1' )then
				align2<='1';
			else
				align2<='0';
			end if;
			
			if(button2='1' )then
				align3<='1';
			else
				align3<='0';
			end if;
			
			if(button3='1' )then
				align4<='1';
			else
				align4<='0';
			end if;
					
			FV					<=  LVDSRX(7);	
			LV					<=  LVDSRX(8);	
			dataAvailable	<=  LVDSRX(9);	
			led1				<=  LVDSRX(1);	
			led2				<=  LVDSRX(0);	
			
			pixel1(9)<=  LVDSRX(10);
			pixel1(8)<=  LVDSRX(11);
			pixel1(7)<=  LVDSRX(12);
			pixel1(6)<=  LVDSRX(13);
			pixel1(5)<=  LVDSRX(14);
			pixel1(4)<=  LVDSRX(15);
			pixel1(3)<=  LVDSRX(16);
			pixel1(2)<=  LVDSRX(17);					
			pixel1(1)<=  LVDSRX(18);	
			pixel1(0)<=  LVDSRX(19);	
			
			pixel5(9)<=  LVDSRX(20);
			pixel5(8)<=  LVDSRX(21);
			pixel5(7)<=  LVDSRX(22);
			pixel5(6)<=  LVDSRX(23);
			pixel5(5)<=  LVDSRX(24);
			pixel5(4)<=  LVDSRX(25);
			pixel5(3)<=  LVDSRX(26);
			pixel5(2)<=  LVDSRX(27);					
			pixel5(1)<=  LVDSRX(28);	
			pixel5(0)<=  LVDSRX(29);

			pixel9(9)<=  LVDSRX(30);
			pixel9(8)<=  LVDSRX(31);
			pixel9(7)<=  LVDSRX(32);
			pixel9(6)<=  LVDSRX(33);
			pixel9(5)<=  LVDSRX(34);
			pixel9(4)<=  LVDSRX(35);
			pixel9(3)<=  LVDSRX(36);
			pixel9(2)<=  LVDSRX(37);					
			pixel9(1)<=  LVDSRX(38);	
			pixel9(0)<=  LVDSRX(39);	
			
			pixel13(9)<=  LVDSRX(40);
			pixel13(8)<=  LVDSRX(41);
			pixel13(7)<=  LVDSRX(42);
			pixel13(6)<=  LVDSRX(43);
			pixel13(5)<=  LVDSRX(44);
			pixel13(4)<=  LVDSRX(45);
			pixel13(3)<=  LVDSRX(46);
			pixel13(2)<=  LVDSRX(47);					
			pixel13(1)<=  LVDSRX(48);	
			pixel13(0)<=  LVDSRX(49);				
								
		end if;
	
	end process;


end arch; 
