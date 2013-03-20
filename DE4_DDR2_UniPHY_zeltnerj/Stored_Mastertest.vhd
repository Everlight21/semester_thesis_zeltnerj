

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Master part of the camera. Must send to the avalon bus the data received via the controler camInt.

entity Stored_Mastertest is
		generic( bufferSizerLog : natural :=10);--nb element in buffer 2^bufferSizelog

        port (
				-- inputs:
            clk 		: IN std_logic;
				clkdvi 	: IN std_logic;
				reset		: IN std_logic;
					-- AVALON Slave				
				--as_startaddress: IN std_logic_vector(31 downto 0);
					-- Camera Interface
				--camInt_data	: OUT std_logic_vector(31 downto 0);
				camInt_datar	: OUT std_logic_vector(7 downto 0);
				camInt_datag	: OUT std_logic_vector(7 downto 0);
				camInt_datab	: OUT std_logic_vector(7 downto 0);				
				camInt_newFrame: IN std_logic;--indicates a new frame (must restart sending from to the start address)
				camInt_newLine: IN std_logic;--indicates a new line
				--camInt_lastPixel: IN std_logic;
				camInt_Pixelav: IN std_logic

				--debug
				--fifo_full	: OUT std_logic

             
              );
end entity Stored_Mastertest;


architecture arch of Stored_Mastertest is

component fifo
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		wrusedw		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
	);
end component;

	
	--FIFO--128 elements
	--type memoryFIFO is array(2**11-1 downto 0) of std_logic_vector(31 downto 0);
	
	--signal outputBuffer						: memoryFIFO;
	--signal bufferHead						: std_logic_vector(bufferSizerLog-1 downto 0);
	--signal bufferTail						: std_logic_vector(bufferSizerLog-1 downto 0);
	
	
	-- state machine states
	type read_states_T is (idle, mid_burst, finish_reads);
	--type write_states_T is (idle, running);
	signal read_state : read_states_T;
	--signal bufferHeadVar		: std_logic_vector(11-1 downto 0);
	--signal write_state : write_states_T;
	
	-- extra read master signals
	signal read_address : std_logic_vector (31 downto 0);         -- the current read address
	
	signal pending_reads : std_logic_vector (11-1 downto 0);         -- tracks the number of transactions that are waiting for readdata to be returned
	signal reads_within_block : std_logic_vector (11-1 downto 0);    -- tracks the words read within a block
	
	signal temp_data: std_logic_vector (31 downto 0);    
	signal bursts_completed : std_logic_vector (2 downto 0);  -- tracks the number of bursts completed
	signal taken: std_logic;
	signal nbElementInBuffersignal	: std_logic_vector(5 downto 0);
	signal wen: std_logic;
	signal rden: std_logic;	
	signal rdempty: std_logic;
	signal fifoBuffer: std_logic_vector(31 downto 0);
	signal clear: std_logic;
	signal counter: std_logic_vector(7 downto 0);
	
	
begin	


--	--from slave (change the start address when slave indicates it)
--	process(clk,reset)
--	begin
--		if(reset='1')then
--			
--		elsif(rising_edge(clk))then
--			
----			if(camInt_newFrame='0')then
----				read_address<=(others=>'0');
----			end if;
--
--		end if;
--	end process;

-------------------------------------------------------------------------------
-- THE READ MASTER STATE MACHINE
-------------------------------------------------------------------------------

	process (clk,reset)

		--variable nbElementInBuffer	: std_logic_vector(9 downto 0);
		--variable burstToSend		: std_logic_vector(5 downto 0);
		
		--variable bufferTailVar		: std_logic_vector(11-1 downto 0);
		--variable bufferHeadVar		: std_logic_vector(11-1 downto 0);
		--variable current_read_address		: std_logic_vector(31 downto 0);

	begin
	
		if(reset='1')then
	
		--read_state <= idle;
		--read_address := (others => '0');
		--words_read <= (others => '0');
		--bufferTailVar:=(others=>'0');
		--bufferHeadVar:=(others=>'0');
		--nbElementInBuffer:=(others=>'0');
		--current_read_address:=(others=>'0');
		--pending_reads <= (others => '0');
		counter<=(others => '0');
		
		elsif(rising_edge(clk))then
	
		wen<='0';
	

		

		if (nbElementInBuffersignal<20) then--(wrfull = '0') then --nbElementInBuffersignal<500 and 
			counter<=counter+1;
--			if(counter<256) then
--				fifoBuffer<="000000000000000000000000"&counter(7 downto 0);
--			end if;
--			if(counter<512 and counter>255) then
--				fifoBuffer<="0000000000000000"&counter(7 downto 0)&"00000000";
--			end if;		
--			if(counter<786 and counter>511) then
--				fifoBuffer<="00000000"&counter(7 downto 0)&"0000000000000000";
--			end if;	
--			if(counter>786) then
--				fifoBuffer<="00000000"&counter(7 downto 0)&counter(7 downto 0)&counter(7 downto 0);
--			end if;	
			fifoBuffer<="000000000000000000000000"&counter(7 downto 0);			
			wen<='1';
		--else
			--counter<=(others => '0');
		--	wen<='0';
		end if;
			
--		if(camInt_newFrame='1')then
--		--	counter<=(others => '0');
--		end if;			
		
	end if;
end process;

process (clkdvi,reset)

		--variable burstToSend		: std_logic_vector(5 downto 0);

	begin
	
		if(reset='1')then
	
		clear<='1';
		camInt_datar<=(others=>'0');
		camInt_datag<=(others=>'0');
		camInt_datab<=(others=>'0');

		elsif(rising_edge(clkdvi))then
	
		--taken <='0';
		clear<='0';
		rden<='0';
		
		if(camInt_Pixelav='1' and camInt_newFrame='0' and camInt_newLine='0')then--new pixel to send
			if(rdempty='0') then
				rden<='1';
				--camInt_data<=temp_data;
				camInt_datar<=temp_data(23 downto 16);
				camInt_datag<=temp_data(15 downto 8);
				camInt_datab<=temp_data(7 downto 0);
			else
				--rden<='1';
				--camInt_data<="00000000111111111111111111111111";--orange
				camInt_datar<=(others=>'0');
				camInt_datag<=(others=>'0');
				camInt_datab<=(others=>'0');
			end if;	
		end if;
		
		
--		if(camInt_newFrame='1')then
--			clear<='1';
--		end if;
		
	end if;		
		
end process;		

fifo1 : fifo
port map(
		aclr		=>clear,
		data		=>fifoBuffer,
		rdclk		=>clkdvi,
		rdreq		=>rden,
		wrclk		=>clk,
		wrreq		=>wen,
		q			=>temp_data,
		rdempty	=>rdempty,
		wrusedw	=>nbElementInBuffersignal
);	
	

end arch;


