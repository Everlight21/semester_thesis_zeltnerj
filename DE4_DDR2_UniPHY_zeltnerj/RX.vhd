

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;


ENTITY RX is
	
	port(
	clk					: in std_logic;
	clklvds				: in std_logic;	
	reset					: in std_logic;
	camdata1				: in std_logic_vector(9 downto 0);
	camdata2			: in std_logic_vector(9 downto 0);	
	LVDVI					: in std_logic;
	FVDVI					: in std_logic;	
	dataAvailableDVI 	: in std_logic;
	dataAvailableLVDS : in std_logic;	
	FVLVDS 				: in std_logic;	
	LVLVDS 				: in std_logic;		
	pixelr				: out std_logic_vector(7 downto 0);
	pixelg				: out std_logic_vector(7 downto 0);
	pixelb				: out std_logic_vector(7 downto 0)	
		);
end RX; 

architecture arch of RX is 

component storage
  port(
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wrclock		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

	signal count 	: std_logic_vector(16 downto 0);	
	signal oldvalue 	: std_logic_vector(9 downto 0);
	type pixelArray is array(2500 downto 0) of std_logic_vector(9 downto 0);
	signal linebuffer 		: pixelArray;
	signal nbpixels1: std_logic_vector(15 downto 0);	
	signal nbpixels2: std_logic_vector(15 downto 0);		
	signal nbinrow: integer range 0 to 2500;--number of pixels received	
	signal nbpixelswr: std_logic_vector(15 downto 0);	
	signal wen : std_logic;
	signal pixeldata1 : std_logic_vector(7 downto 0);
	signal pixeldata2 : std_logic_vector(7 downto 0);	

	
	
	
begin
	
	process(clk,reset)
	
		--	variable index2 :		integer range 0 to 2047;
	
	begin
	
		if(reset='1')then
		
	--	pixel1<=(others=>'0');
	--nbinrow	<=(others=>'0');
		--count<=(others=>'0');	
		
		
		elsif(rising_edge(clk))then
			
			if(dataAvailableDVI='1')then
			
				if(nbinrow<128)then
					if(nbpixels1<"1111111111111110")then
						nbpixels1<=nbpixels1+1;
						nbinrow<=nbinrow+1;
						pixelr <= pixeldata1;
						pixelg <= pixeldata1;
						pixelb <= pixeldata1;
					end if;		
				elsif(nbinrow>127 and nbinrow<256)then
						nbpixels2<=nbpixels2+1;
						nbinrow<=nbinrow+1;
						pixelr <= pixeldata2;
						pixelg <= pixeldata2;
						pixelb <= pixeldata2;
				else
					pixelr <= (others=>'0');
					pixelg <= (others=>'0');
					pixelb <= (others=>'0');		
				end if;
				
--				if(dataAvailableLVDS='1')then
					--pixel1<=linebuffer(nbpixels);
--				else
--					pixel1<="0000000000";
--				end if;
						
			end if;		
		
			if(LVDVI='1')then	
				nbinrow<=0;
			end if;
			
			if(FVDVI='1')then	
				nbpixels1<=(others=>'0');	
				nbpixels2<=(others=>'0');					
			end if;
			
		end if;
	
	end process;
	
		process(clklvds,reset)
		
		--variable index :		integer range 0 to 2047;
	
	begin
	
		if(reset='1')then
		

		count<=(others=>'0');	
		oldvalue<=(others=>'0');	
		
		
		elsif(rising_edge(clklvds))then
		
			wen <='0';
			
			
			if(dataAvailableLVDS='1' and FVLVDS='1' and LVLVDS='1')then
			
				if(nbpixelswr<"1111111111111110")then
					nbpixelswr<=nbpixelswr+1;--count the number of pixel of the current image received
					wen <='1';
					--linebuffer(nbpixelswr)<=camdata;
				end if;
			end if;				
			
			if (FVLVDS='0')then
				nbpixelswr<=(others=>'0');	
			end if;	
			
		end if;
	
	end process;
	
store1 : storage
port map(
		data		=>camdata1(9 downto 2),
		rdaddress		=>nbpixels1,
		rdclock		=>clk,
		wraddress		=>nbpixelswr,
		wrclock		=>clklvds,
		wren		=>wen,
		q		=>pixeldata1
);	
store2 : storage
port map(
		data		=>camdata2(9 downto 2),
		rdaddress		=>nbpixels2,
		rdclock		=>clk,
		wraddress		=>nbpixelswr,
		wrclock		=>clklvds,
		wren		=>wen,
		q		=>pixeldata2
);			

end arch; 