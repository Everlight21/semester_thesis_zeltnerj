
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity RX_Multiplexer is
		--generic( bufferSizerLog : natural :=10);--nb element in buffer 2^bufferSizelog

        port (
				-- inputs:
            clkcamera 	: IN std_logic;
				clkcamerax4	: IN std_logic;
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
				
				Pixel_Data	: OUT std_logic_vector(7 downto 0)	
              );
				  
end entity RX_Multiplexer;


architecture arch of RX_Multiplexer is

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

	
	
	signal wen: std_logic;
	signal rden1,rden2,rden3,rden4,rden5,rden6,rden7,rden8: std_logic;	
	signal wrfull1,wrfull2,wrfull3,wrfull4,wrfull5,wrfull6,wrfull7,wrfull8: std_logic;
	signal fifoBuffer1: std_logic_vector(31 downto 0);
	signal fifoBuffer2: std_logic_vector(31 downto 0);
	signal fifoBuffer3: std_logic_vector(31 downto 0);
	signal fifoBuffer4: std_logic_vector(31 downto 0);	
	signal fifoBuffer5: std_logic_vector(31 downto 0);
	signal fifoBuffer6: std_logic_vector(31 downto 0);
	signal fifoBuffer7: std_logic_vector(31 downto 0);
	signal fifoBuffer8: std_logic_vector(31 downto 0);		
	--signal temp_data: std_logic_vector (31 downto 0);  
	signal nbinrow: std_logic_vector (11 downto 0);
	signal clear: std_logic;
	signal channel1,channel2,channel3,channel4,channel5,channel6,channel7,channel8: std_logic;	
	
	-- extra write master signals
	signal write_word_count : std_logic_vector (9 downto 0); 				-- tracks the number of words written within a burst
	signal nbElementInBuffersignal1	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo
	signal nbElementInBuffersignal2	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo	
	signal nbElementInBuffersignal3	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo
	signal nbElementInBuffersignal4	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo	
	signal nbElementInBuffersignal5	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo
	signal nbElementInBuffersignal6	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo	
	signal nbElementInBuffersignal7	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo
	signal nbElementInBuffersignal8	: std_logic_vector(9 downto 0);     -- tracks the available room in the fifo		
	signal am_dataWrite1,am_dataWrite2,am_dataWrite3,am_dataWrite4,am_dataWrite5,am_dataWrite6,am_dataWrite7,am_dataWrite8: std_logic_vector (31 downto 0);  
	
begin	

	--from slave (change the start address when slave indicates it)
	process(clkcamera,reset)
	begin
		if(reset='1')then
		
		--	current_start_address_index<='0';
		--	endframe<='1';
			
		elsif(rising_edge(clkcamera))then
		
			wen <='0';
			
				if(camInt_newData='1' and camInt_newFrame='1' and camInt_newLine='1')then
					if(wrfull1='0')then
						wen <='1';
						fifoBuffer1<="00000000"&camInt_data1(7 downto 0)&camInt_data1(7 downto 0)&camInt_data1(7 downto 0);
						fifoBuffer2<="00000000"&camInt_data2(7 downto 0)&camInt_data2(7 downto 0)&camInt_data2(7 downto 0);
						fifoBuffer3<="00000000"&camInt_data3(7 downto 0)&camInt_data3(7 downto 0)&camInt_data3(7 downto 0);
						fifoBuffer4<="00000000"&camInt_data4(7 downto 0)&camInt_data4(7 downto 0)&camInt_data4(7 downto 0);
						fifoBuffer5<="00000000"&camInt_data5(7 downto 0)&camInt_data5(7 downto 0)&camInt_data5(7 downto 0);
						fifoBuffer6<="00000000"&camInt_data6(7 downto 0)&camInt_data6(7 downto 0)&camInt_data6(7 downto 0);
						fifoBuffer7<="00000000"&camInt_data7(7 downto 0)&camInt_data7(7 downto 0)&camInt_data7(7 downto 0);
						fifoBuffer8<="00000000"&camInt_data8(7 downto 0)&camInt_data8(7 downto 0)&camInt_data8(7 downto 0);								
					end if;
				end if;				
				
--				if (FVLVDS='0')then
--					nbpixelswr<=(others=>'0');	
--				end if;			

		end if;
	end process;
	
	

	-------------------------------------------------------------------------------
-- THE WRITE MASTER STATE MACHINE
-------------------------------------------------------------------------------
	
	process(clkcamerax4,reset)

		
	begin

		
		if(reset='1')then
			
			clear<='1';		
			
		elsif(rising_edge(clkcamerax4))then
	
			clear<='0';
			rden1		<= '0';
--			rden5		<= '0';
--			rden9		<= '0';
--			rden13	<= '0';
			
		
				--if (nbElementInBuffersignal1 >= 256 ) then
				if(camInt_newData='1' and camInt_newFrame='1' and camInt_newLine='1')then
				
						if(nbinrow < 512) then
							rden1		<= '1';
							nbinrow<=nbinrow+1;
							Pixel_Data<=am_dataWrite1(7 downto 0);
--						elsif(nbinrow > 511 and nbinrow < 1024) then
--							rden5		<= '1';
--							nbinrow<=nbinrow+1;
--							Pixel_Data<=am_dataWrite2(7 downto 0);
--						elsif(nbinrow > 1023 and nbinrow < 1536) then
--							rden9		<= '1';
--							nbinrow<=nbinrow+1;
--							Pixel_Data<=am_dataWrite3(7 downto 0);
--						elsif(nbinrow > 1535 and nbinrow < 2048) then
--							rden13		<= '1';
--							nbinrow<=nbinrow+1;
--							Pixel_Data<=am_dataWrite4(7 downto 0);							
--						elsif(nbinrow > 1535) then
--							nbinrow<=(others => '0');
--						else
							--nbinrow<=nbinrow+1;
						end if;
				
				end if;
				
			
		end if;
	
	end process;

	


	--rden1		<= '1' when (write_state = mid_burst or write_state = final_burst) and am_WaitRequest = '0' and channel1 = '0' else '0';
	--rden5		<= '1' when (write_state = mid_burst or write_state = final_burst) and am_WaitRequest = '0' and (channel1 = '1' or nbinrow<4) else '0';
	
	--rden1		<= '1' when (write_state = mid_burst or write_state = final_burst) and am_WaitRequest = '0' and channel1 = '1' else '0';
	--rden2		<= '1' when (write_state = mid_burst or write_state = final_burst) and am_WaitRequest = '0' and channel2 = '1' else '0';
	--rden3		<= '1' when (write_state = mid_burst or write_state = final_burst) and am_WaitRequest = '0' and channel3 = '1' else '0';
	--rden4		<= '1' when (write_state = mid_burst or write_state = final_burst) and am_WaitRequest = '0' and channel4 = '1' else '0';
	--rden5		<= '1' when (write_state = mid_burst or write_state = final_burst) and am_WaitRequest = '0' and channel5 = '1' else '0';		
	
fifo1 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer1,
		rdclk		=>clkcamerax4,
		rdreq		=>rden1,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite1,
		wrfull	=>wrfull1,
		rdusedw	=>nbElementInBuffersignal1
);	
fifo2 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer2,
		rdclk		=>clkcamerax4,
		rdreq		=>rden2,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite2,
		wrfull	=>wrfull2,
		rdusedw	=>nbElementInBuffersignal2
);	
fifo3 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer3,
		rdclk		=>clkcamerax4,
		rdreq		=>rden3,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite3,
		wrfull	=>wrfull3,
		rdusedw	=>nbElementInBuffersignal3
);	
fifo4 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer4,
		rdclk		=>clkcamerax4,
		rdreq		=>rden4,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite4,
		wrfull	=>wrfull4,
		rdusedw	=>nbElementInBuffersignal4
);	
fifo5 : fifocamera
port map(
		aclr		=>clear,
		data		=>fifoBuffer5,
		rdclk		=>clkcamerax4,
		rdreq		=>rden5,
		wrclk		=>clkcamera,
		wrreq		=>wen,
		q			=>am_dataWrite5,
		wrfull	=>wrfull5,
		rdusedw	=>nbElementInBuffersignal5
);	

	

end arch;

