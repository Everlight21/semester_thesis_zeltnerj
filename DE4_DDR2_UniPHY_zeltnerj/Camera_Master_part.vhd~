
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Camera_Master_part is

        port (
				-- inputs:
            clk 			: IN std_logic;
				clkcamera	: IN std_logic;
				reset		: IN std_logic;

					-- Camera Interface
				camInt_data1	: IN std_logic_vector(7 downto 0);
				camInt_data2	: IN std_logic_vector(7 downto 0);
				camInt_data3	: IN std_logic_vector(7 downto 0);
				camInt_data4	: IN std_logic_vector(7 downto 0);
				camInt_data5	: IN std_logic_vector(7 downto 0);
				camInt_data6	: IN std_logic_vector(7 downto 0);
				camInt_data7	: IN std_logic_vector(7 downto 0);
				camInt_data8	: IN std_logic_vector(7 downto 0);							
				camInt_newData: IN std_logic;
				camInt_newFrame: IN std_logic;--indicates a new frame (must restart sending from to the start address)
				camInt_newLine: IN std_logic;--indicates a new line
				
					-- AVALON master
				am_WaitRequest	: IN std_logic;
				am_address		: OUT std_logic_vector(31 downto 0);
				--am_byteEnable: OUT std_logic_vector(3 downto 0);
				am_dataWrite	: OUT std_logic_vector(31 downto 0);
				am_write			: OUT std_logic;
				am_burstcount	: OUT std_logic_vector(7 downto 0)

              );
end entity Camera_Master_part;


architecture arch of Camera_Master_part is

component fifocamera
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdusedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrfull		: OUT STD_LOGIC 
	);
end component;

	
	-- state machine states
	type write_states_T is (idle, fifo_wait, mid_burst);--, final_burst);
	signal write_state : write_states_T;
	
	signal wen: std_logic;
	signal rden1,rden3,rden5: std_logic;	
	signal wrfull1,wrfull3,wrfull5: std_logic;
	signal fifoBuffer1: std_logic_vector(31 downto 0);
	signal fifoBuffer3: std_logic_vector(31 downto 0);
	signal fifoBuffer5: std_logic_vector(31 downto 0);

	signal nbinrow: std_logic_vector (9 downto 0);
	signal clear: std_logic;
	signal channelselect: std_logic_vector (3 downto 0);
	signal camInt_newFrameold: std_logic;	
	
	-- extra write master signals
	signal write_address : std_logic_vector (31 downto 0);    				-- the current write address
	signal write_word_count : std_logic_vector (10 downto 0); 				-- tracks the number of words written within a burst
	signal nbElementInBuffersignal1	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo
	signal nbElementInBuffersignal3	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo
	signal nbElementInBuffersignal5	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo
	signal am_dataWrite1,am_dataWrite3,am_dataWrite5: std_logic_vector (31 downto 0);  
	
begin	

	--from slave (change the start address when slave indicates it)
	process(clkcamera,reset)
	begin
		if(reset='1')then

			clear<='1';
			
		elsif(rising_edge(clkcamera))then
		
			wen <='0';
			
				if(camInt_newData='1' and camInt_newFrame='1' and camInt_newLine='1' )then
					if(wrfull1='0')then
						wen <='1';
						fifoBuffer1<="00000000"&camInt_data1(7 downto 0)&camInt_data1(7 downto 0)&camInt_data1(7 downto 0);
						fifoBuffer3<="00000000"&camInt_data3(7 downto 0)&camInt_data3(7 downto 0)&camInt_data3(7 downto 0);
						fifoBuffer5<="00000000"&camInt_data5(7 downto 0)&camInt_data5(7 downto 0)&camInt_data5(7 downto 0);						
					end if;
				end if;				
				
			camInt_newFrameold<=camInt_newFrame;

			if(camInt_newFrame='0' and camInt_newFrameold='1')then  -- 1  0
				clear<='1';
			else
				clear<='0';
			end if;		

		end if;
	end process;
	
	

	-------------------------------------------------------------------------------
-- THE WRITE MASTER STATE MACHINE
-------------------------------------------------------------------------------
	
	process(clk,reset)

		
	begin

		
		if(reset='1')then
			
			write_state <= idle;
			channelselect<="1001";		
			write_address<=(others => '0');
			
		elsif(rising_edge(clk))then

	
		case write_state is
			
			-- IDLE
			-- Just sit and wait for the go flag
			-- When the go flag is set start by moving to the fifo wait state and 
			-- set the address and word counter.
			when idle =>
				--if write_state = idle and csr_go_flag = '1' then
					write_state <= fifo_wait;
				--	read_address <= csr_rd_addr;
					write_word_count <= (others => '0');
					
					
					--bursts_completed <= (others => '0');
				--end if;
				
				
			-- FIFO_WAIT
			-- wait until the fifo has enough words for a standard burst size.
			-- If the read state machine is idle then it means that there will
			-- be no more words written in to the fifo, in this case the transaction
			-- is complete if the fifo is empty so go to the idle state.
			-- Otherwise go to final_burst state to empty the fifo.
			-- Set the burstcount value upon changing state
			when fifo_wait =>
				if (nbElementInBuffersignal1 >= 32 and nbElementInBuffersignal3 >= 32 and nbElementInBuffersignal5 >=32) then--and nbElementInBuffersignal2 >= 256 and nbElementInBuffersignal3 >= 256 and nbElementInBuffersignal4 >= 256) then
					write_state <= mid_burst;
					am_burstcount <= "00100000";
				--elsif read_state = idle then
				--	if fifo_words = 0 then
					--	write_state <= idle;
				--	else
				--		write_state <= final_burst;
				--		avm_write_master_burstcount <= fifo_words;
				--	end if;
				end if;
				
			-- MID_BURST
			-- Burst transaction in progress
			-- If waitrequest is active do nothing otherwise
			-- count words written in this burst.
			-- If burst complete then increment address and reset word count
			-- Stay in mid_burst if there is enough data in fifo or jump to fifo_wait state.
			-- The write data is updated if not in waitrequest by control of the fifo read signal
			-- in the combinatorial section below.
			when mid_burst =>
				
				if (am_WaitRequest /= '1') then
				
					if (write_word_count = 31) then  -- if burst complete --31
					
						write_word_count <= (others => '0');
						
						
						if(nbinrow = 15) then --16 packets total
							channelselect<="0100";	
							write_address <= write_address + 128;
							nbinrow<=nbinrow+1;
						elsif(nbinrow = 31) then
							channelselect<="0001";
							write_address <= write_address + 128;
							nbinrow<=nbinrow+1;				
						elsif(nbinrow = 47) then
							channelselect<="1001";
							write_address <= write_address + 1664;  -- 1664 = 1920*4-32*4*47
							nbinrow<=(others => '0');
						else
							write_address <= write_address + 128;
							nbinrow<=nbinrow+1;
						end if;


						write_state <= idle;
						
					else
						write_word_count <= write_word_count + 1;
					end if;
				end if;


			-- FINAL_BURST
			-- Read master is complete so just empty fifo.
			-- Burst count value will be set upon entry to this state.
			-- Just wait for fifo to empty and jump to idle state.
--			when final_burst =>
--				--am_write<='1';
--				if am_WaitRequest /= '1' then
--					if nbElementInBuffersignal1 = 1 then  -- fifo_words will be 1 if this is the last
--						write_state <= idle;
--					end if;
--				end if;
				
			when others =>
				write_state <= idle;
		
		end case;
		
		if(clear='1')then
			write_address <=(others => '0');
			nbinrow<=(others => '0');
		end if;
			
		end if;
	
	end process;

	-- the write signal is active if in the mid burst of final burst states
	--am_write <= '1' when write_state = mid_burst or write_state = final_burst else '0';
	am_write <= '1' when write_state = mid_burst else '0';
	-- the fifo_read signal takes data from the fifo and updates it's output with the next word should be 1 when writing and not in waitrequest
	rden1		<= '1' when write_state = mid_burst and am_WaitRequest = '0' and channelselect = "0001"  else '0';
	rden3		<= '1' when write_state = mid_burst and am_WaitRequest = '0' and channelselect = "0100"  else '0';	
	rden5		<= '1' when write_state = mid_burst and am_WaitRequest = '0' and channelselect = "1001"  else '0';	
	
	--output the data
	am_address<=write_address;
	
	with channelselect select
		am_dataWrite	<= am_dataWrite1 when "0001",
								am_dataWrite3 when "0100",
								am_dataWrite5 when "1001",								
								(others => '0') when others;
								
	
fifo1 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer1,
		rdclk		=>clk,
		rdreq		=>rden1,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite1,
		wrfull	=>wrfull1,
		rdusedw	=>nbElementInBuffersignal1
);	
--fifo2 : fifocamera
--port map(
--		aclr		=>clear,
--		data		=>fifoBuffer2,
--		rdclk		=>clk,
--		rdreq		=>rden2,
--		wrclk		=>clkcamera,
--		wrreq		=>wen,
--		q			=>am_dataWrite2,
--		wrfull	=>wrfull2,
--		rdusedw	=>nbElementInBuffersignal2
--);	
fifo3 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer3,
		rdclk		=>clk,
		rdreq		=>rden3,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite3,
		wrfull	=>wrfull3,
		rdusedw	=>nbElementInBuffersignal3
);	
--fifo4 : fifocamera
--port map(
--		aclr		=>clear,
--		data		=>fifoBuffer4,
--		rdclk		=>clk,
--		rdreq		=>rden4,
--		wrclk		=>clkcamera,
--		wrreq		=>wen,
--		q			=>am_dataWrite4,
--		wrfull	=>wrfull4,
--		rdusedw	=>nbElementInBuffersignal4
--);	
fifo5 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer5,
		rdclk		=>clk,
		rdreq		=>rden5,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite5,
		wrfull	=>wrfull5,
		rdusedw	=>nbElementInBuffersignal5
);	
--fifo6 : fifocamera
--port map(
--		aclr		=>clear,
--		data		=>fifoBuffer6,
--		rdclk		=>clk,
--		rdreq		=>rden6,
--		wrclk		=>clkcamera,
--		wrreq		=>wen,
--		q			=>am_dataWrite6,
--		wrfull	=>wrfull6,
--		rdusedw	=>nbElementInBuffersignal6
--);	
--fifo7 : fifocamera
--port map(
--		aclr		=>clear,
--		data		=>fifoBuffer7,
--		rdclk		=>clk,
--		rdreq		=>rden7,
--		wrclk		=>clkcamera,
--		wrreq		=>wen,
--		q			=>am_dataWrite7,
--		wrfull	=>wrfull7,
--		rdusedw	=>nbElementInBuffersignal7
--);	

	

end arch;

