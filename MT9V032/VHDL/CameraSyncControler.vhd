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

ENTITY CameraSyncControler is
	generic( pixelBits : natural :=10);
	
	port(
	clk				: in std_logic;
	reset			: in std_logic;
	fifo_data_in	: in std_logic_vector(pixelBits+1 downto 0);--input bayer pixel+FV+LV
	fifo_empty		: in std_logic;
	fifo_full		: in std_logic;
	fifo_nbElem		: in std_logic_vector(3 downto 0);
		
	--to fifo
	fifo_read		: out std_logic;
	
	--
	dataAvailable	: out std_logic;
	pixel			: out std_logic_vector(pixelBits-1 downto 0);--output pixel Bayer
	FV				: out std_logic;
	LV				: out std_logic
	);
end CameraSyncControler; 

architecture arch of CameraSyncControler is 
	
	type stateType is (waitData,waitReadData,readData);
	
	signal state : stateType;
	signal elemToRead: std_logic_vector(3 downto 0);
	signal fifoBeenFull: std_logic;
begin
	
	process(clk,reset)
	begin
	
		if(reset='1')then
			state<=waitData;
			fifoBeenFull<='0';
			pixel<=(others=>'0');
			
		elsif(rising_edge(clk))then
	
			fifo_read<='0';
			dataAvailable<='0';
			
			if(fifo_full='1')then
				fifoBeenFull<='1';
			end if;
			
			case state is 
				when waitData=>
					if(fifo_nbElem/=0)then--if the fifo is not empty, read a value
						fifo_read<='1';
						state<=waitReadData;
						elemToRead<=fifo_nbElem;
					end if;
					
				when waitReadData =>
					state<=readData;
					if(elemToRead/=1)then--if there is more than one element to read, mantain the read to 1
						fifo_read<='1';
					end if;
					
				when readData=>
					if(fifoBeenFull='1')then
						pixel<=(others=>'0');
					else
						pixel<=fifo_data_in(pixelBits-1 downto 0);
					end if;
					
					FV<=fifo_data_in(pixelBits);
					LV<=fifo_data_in(pixelBits+1);
					dataAvailable<='1';
					
					if(elemToRead=1)then--if we have read all we have to read
						state<=waitData;
						fifo_read<='0';
					elsif(elemToRead=2)then--already set the read fifo to 1 during 2 cycles, must set to 0
						elemToRead<=elemToRead-1;
						fifo_read<='0';
						state<=readData;
					else
						elemToRead<=elemToRead-1;
						fifo_read<='1';
						state<=readData;
					end if;
			end case;
		end if;
	
	end process;

end arch; 