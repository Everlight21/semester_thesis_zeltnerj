

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Stored_Master is

        port (
				-- inputs:
            clk 		: IN std_logic;
				clkdvi 	: IN std_logic;
				reset		: IN std_logic;
				
				-- DVI Interface
				DVI_data	: OUT std_logic_vector(31 downto 0);
				DVI_newFrame: IN std_logic;
				DVI_newLine: IN std_logic;
				DVI_Pixelav: IN std_logic;
				
				-- AVALON master
				am_WaitRequest: IN std_logic;
				am_address	: OUT std_logic_vector(31 downto 0);
				am_readdata	: IN std_logic_vector(31 downto 0);
				am_read		: OUT std_logic;
				am_readdatavalid		: IN std_logic;				
				am_burstcount: OUT std_logic_vector(7 downto 0)
             
              );
end entity Stored_Master;


architecture arch of Stored_Master is

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
		wrusedw		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
end component;

	
	-- state machine states
	type read_states_T is (idle,fifo_wait, mid_burst, finish_reads);
	signal read_state : read_states_T;
	
	-- extra read master signals
	signal read_address : std_logic_vector (31 downto 0);     -- the current read address
	--signal bursts_completed : std_logic_vector (2 downto 0);  -- tracks the number of bursts completed
	--signal room_in_fifo : std_logic_vector (6 downto 0);      -- tracks the available room in the fifo
	signal pending_reads : std_logic_vector (10 downto 0);     -- tracks the number of transactions that are waiting for readdata to be returned

	
	signal temp_data: std_logic_vector (31 downto 0);    
	signal nbElementInBuffersignal	: std_logic_vector(11 downto 0);
	signal wen: std_logic;
	signal rden: std_logic;	
	signal rdempty: std_logic;
	signal fifoBuffer: std_logic_vector(31 downto 0);
	signal clear: std_logic;
	
	
	
begin	

-------------------------------------------------------------------------------
-- THE READ MASTER STATE MACHINE
-------------------------------------------------------------------------------

	process (clk,reset)


	begin
	
		if(reset='1')then
	
		read_state <= idle;
		read_address <= (others => '0');
		--bursts_completed <= (others => '0');
		pending_reads <= (others => '0');
		clear<='1';
		
	elsif (rising_edge (clk)) then
	
		if(DVI_newFrame='0')then
			read_address <= (others => '0');
		end if;
		
		if (am_readdatavalid = '1') then
			pending_reads <= pending_reads - 1;
		end if;
			
		clear<='0';
		
		case read_state is
			
			-- IDLE
			-- When idle just sit and wait for the go flag.
			-- Only start if the write state machine is idle as it may be
			-- finishing a previous data transfer.
			-- Start the machine by moving to the fifo_wait state and initialising address and counters.
			when idle =>
			
					read_state <= fifo_wait;
					--bursts_completed <=(others => '0');	
					pending_reads <= (others => '0');
			
			-- FIFO WAIT
			-- When in this state wait for the fifo to have sufficient space for another block of 32 words
			-- If so, start a block of reads by moving to the reading state.
			when fifo_wait =>
				-- check that fifo has enough space for 32 words
				if (nbElementInBuffersignal<3768) then
					read_state <= mid_burst;
					-- add 32 to the pending reads counter but be mindful that a word may be returned at the same time
					if (am_readdatavalid = '0') then
						pending_reads <= pending_reads + 128;
					else
						pending_reads <= pending_reads + 127;
					end if;					
					
				end if;
				
			-- MID BURST
			-- Count bursts
			-- If all bursts complete go to finish_reads state.
			-- Otherwise stay in this state if there is room in fifo or return to fifo_wait if not.
			-- As each burst is completed increment address, bursts completed counter and pending reads counter.
			-- Be midful to do nothing if waitrequest is active
			when mid_burst =>
				-- if waitrequest is active do nothing, otherwise...
				if (am_WaitRequest /= '1') then
				
					--if bursts_completed = 7 then  -- 8 in total (7 previous plus this one)
						read_state <= finish_reads;
						-- no need to check for pending reads complete as we've just requested another 32 words
			
					--else
						--bursts_completed <= bursts_completed + 1;
						read_address <= read_address + 512;  -- 128 = 32 * 4 (burst length * word size (in bytes)
						
--						if (nbElementInBuffersignal<500) then
--							read_state <= mid_burst;
--							-- add 32 to the pending reads counter but be mindful that a word may be returned at the same time
--							if avm_read_master_readdatavalid = '0' then
--								pending_reads <= pending_reads + 32;
--							else
--								pending_reads <= pending_reads + 31;
--							end if;
--						else
--							read_state <= fifo_wait;
--						end if;
						
					--end if;

				end if;


			-- FINISH READS
			-- All the read address phases are complete but there may readdata pending.
			-- Just sit and wait until there is no readdata pending and then move to idle state.
			-- Note that the pending_reads counter is decremented in the default section above.
			when finish_reads =>
				if (am_readdatavalid = '1') then
					if (pending_reads = 1) then  -- 1 indicates that this is the final readdata
						read_state <= idle;
					end if;
				end if;
		
		end case;

	end if;
	end process;

-- read combinatorial signals
	-- read when in mid_burst state only
	am_read <= '1' when read_state = mid_burst else '0';
	
	-- simply write data into the fifo as it comes in
	-- no need for any checks as the read transaction would not be started
	-- if there was insufficient room
	wen <= am_readdatavalid;
	
	-- read master always uses the same burst size
	am_burstcount <= "10000000"; -- 128 decimal
	
	-- this maps the internal address directly to the external port
	am_address <= read_address;
	

process (clkdvi,reset)


	begin
	
		if(reset='1')then
	
		DVI_data<=(others=>'0');

		elsif(rising_edge(clkdvi))then
	
		rden<='0';
		
		if(DVI_Pixelav='1' and DVI_newFrame='1' and DVI_newLine='1')then
			if(rdempty='0') then
				rden<='1';
				DVI_data<=temp_data;
			else
				DVI_data<="00000000111111111111111111111111";--orange
			end if;	
		end if;
		
	end if;		
		
end process;		
	



fifo1 : fifo
port map(
		aclr		=>clear,
		data		=>am_readdata,
		rdclk		=>clkdvi,
		rdreq		=>rden,
		wrclk		=>clk,
		wrreq		=>wen,
		q			=>temp_data,
		rdempty	=>rdempty,
		wrusedw	=>nbElementInBuffersignal
);	
	

end arch;


