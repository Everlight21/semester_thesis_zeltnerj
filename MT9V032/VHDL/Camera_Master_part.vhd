----------------------------------------------------------
--
--	Iván Muñoz - IN - LAP - EPFL
--
--	17.05.08
--
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Master part of the camera. Must send to the avalon bus the data received via the controler camInt.

entity Camera_Master_part is
		generic( bufferSizerLog : natural :=10);--nb element in buffer 2^bufferSizelog

        port (
				-- inputs:
                clk 			: IN std_logic;
				reset		: IN std_logic;
					-- AVALON master
				am_WaitRequest: IN std_logic;
					-- AVALON Slave				
				as_startAddress1: IN std_logic_vector(31 downto 0);
				as_startAddress2: IN std_logic_vector(31 downto 0);
				as_addressChanged: IN std_logic;
				as_begin		: IN std_logic;
				as_24bits		: IN std_logic; --if must store 24 bits (3 colors), not 32 bits
					-- Camera Interface
				camInt_data	: IN std_logic_vector(31 downto 0);
				camInt_newData: IN std_logic;
				camInt_newFrame: IN std_logic;--indicates a new frame (must restart sending from to the start address)
				camInt_lastPixel: IN std_logic;
				-- outputs:
					-- AVALON master
				am_address	: OUT std_logic_vector(31 downto 0);
				am_byteEnable: OUT std_logic_vector(3 downto 0);
				am_dataWrite	: OUT std_logic_vector(31 downto 0);
				am_write		: OUT std_logic;
				am_burstcount: OUT std_logic_vector(31 downto 0);
					-- slave part
				as_transfert_frame_finished: OUT std_logic;
				as_lastBufferUsed	: OUT std_logic_vector(31 downto 0);
				--debug
				fifo_full	: OUT std_logic

             
              );
end entity Camera_Master_part;


architecture arch of Camera_Master_part is

	signal start_address1		: std_logic_vector(31 downto 0);
	signal start_address2		: std_logic_vector(31 downto 0);
	--signal current_start_address: std_logic_vector(31 downto 0);
	signal current_start_address_index: std_logic;
	--signal current_address,next_address	: std_logic_vector(31 downto 0);
	
	--FIFO--128 elements
	type memoryFIFO is array(2**bufferSizerLog downto 0) of std_logic_vector(31 downto 0);
	
	signal outputBuffer						: memoryFIFO;
	--signal bufferHead						: std_logic_vector(bufferSizerLog-1 downto 0);
	--signal bufferTail						: std_logic_vector(bufferSizerLog-1 downto 0);
	
	signal outputBufferIsLastPixel			: std_logic_vector(2**bufferSizerLog-1 downto 0);--inidicate if the pixel in array outputBuffer is the last pixel of the frame
	--state machine to write the avalon bus
	type StateType is (waitData,setBurst,sendBurst);
	signal state 				: StateType;
	
	signal transfertFinished	: std_logic;
	
	signal currentStartAddress: std_logic_vector(31 downto 0);
	
	signal to24Bits_reg	: std_logic;
begin	

	--from slave (change the start address when slave indicates it)
	process(clk)
	begin
		if(reset='1')then
			current_start_address_index<='0';
		elsif(rising_edge(clk))then
			
			as_transfert_frame_finished<='0';
			
			if(as_begin='1')then
				current_start_address_index<='0';
				to24Bits_reg<=as_24bits;
			end if;
			
			if(as_addressChanged='1')then
				start_address1<=as_startAddress1;
				start_address2<=as_startAddress2;
				--current_start_address<=as_startAddress2;--set to 2, when new frame cames, will set to 1 (begin with 1)
				
			elsif(transfertFinished='1')then--if the frame is finished, we must change were the image must be stored
		
--				if(current_start_address=start_address1)then
--					as_lastBufferUsed<=start_address2;
--					current_start_address<=start_address2;
--				else
--					as_lastBufferUsed<=start_address1;
--					current_start_address<=start_address1;
--				end if;
				if(current_start_address_index='0')then
					current_start_address_index<='1';
					as_lastBufferUsed<=currentStartAddress;
				else
					current_start_address_index<='0';
					as_lastBufferUsed<=currentStartAddress;
				end if;
				
				as_transfert_frame_finished<='1';--indicata to slave that transfert is finished
			end if;
		end if;
	end process;
	
	--to the Avalon bus
	--state machine
	

	
	--synchronous part
	process(clk,reset)
		--variable temporaryBufferHead: std_logic_vector(bufferSizerLog-1 downto 0);
		variable nbElementInBuffer	: std_logic_vector(bufferSizerLog-1 downto 0);
		variable burstToSend		: std_logic_vector(5 downto 0);
		
		variable bufferTailVar		: std_logic_vector(bufferSizerLog-1 downto 0);
		variable bufferHeadVar		: std_logic_vector(bufferSizerLog-1 downto 0);
		
		variable current_address	: std_logic_vector(31 downto 0);
		
	begin

		
		if(reset='1')then
			
			state<=waitData;
			bufferTailVar:=(others=>'0');
			bufferHeadVar:=(others=>'0');
			nbElementInBuffer:=(others=>'0');
			fifo_full<='0';

			currentStartAddress<=(others=>'0');
			
		elsif(rising_edge(clk))then
	
			--default values
			--as_transfert_frame_finished<='0';
			transfertFinished<='0';

			
			if(camInt_newFrame='1')then--indicate new frame, must restart from the begining of the image
--				if(current_start_address=start_address1)then
--					current_address:=start_address2;
--				else
--					current_address:=start_address1;
--				end if;

				if(current_start_address_index='0')then
					current_address:=start_address1;
					currentStartAddress<=start_address1;
				else
					current_address:=start_address2;
					currentStartAddress<=start_address2;
				end if;
				

			end if;
			
			if(camInt_newData='1')then--new data to send
				outputBuffer(conv_integer(bufferTailVar))<=camInt_data;
				outputBufferIsLastPixel(conv_integer(bufferTailVar))<=camInt_lastPixel;
				

				
				--bufferTail<=bufferTail+1;
				bufferTailVar:=bufferTailVar+1;
				nbElementInBuffer:=nbElementInBuffer+1;
				
				if(nbElementInBuffer=std_logic_vector(conv_unsigned((2**bufferSizerLog)-1,bufferSizerLog)))then--to know if the fifo is full
					fifo_full<='1';
				end if;
				
			end if;
			

			case state is
			
					when waitData=>
							am_write<='0';
							
							if(nbElementInBuffer>=32)then--if we have enough data to send a burst, go to burst state
								state<=setBurst;
							else
								state<=waitData;
							end if;
					
					when setBurst => 	
								
								burstToSend:="100000";--32
								
								--busrtNb:=nbElementInBuffer;
								--am_burstcount(4 downto 0)<=burstSent;--indicate the size of the burst we want to perform (8)
								am_write<='1';--want to write
								
								state<=sendBurst;--send burst data
																
					when sendBurst =>
								
								am_write<='1';--indicates we want to write
								
								if(am_WaitRequest='1')then--if must wait the destination, stay in this state
									state<=sendBurst;
								else
									--one less to send
									burstToSend:=burstToSend-1;
									nbElementInBuffer:=nbElementInBuffer-1;
									
									if(to24Bits_reg='1')then--must increment the address only by 3
										current_address:=current_address+3;
									else
										current_address:=current_address+4;
									end if;
									
									transfertFinished<=outputBufferIsLastPixel(conv_integer(bufferHeadVar));--indicate if the pixel is the last of the frame
									
									if(burstToSend=0)then--if the burst is finished
										am_write<='0';--indicates we want to write
										
										if(nbElementInBuffer<32)then--if there is not enough data to do a burst
											state<=waitData;
										else--else prepare to send next burst
											state<=setBurst;
										end if;
									else--if the burst is not finished, continue with the next data
										state<=	sendBurst;												
									end if;
									
									bufferHeadVar:=bufferHeadVar+1;--point to next data to send
								end if;
								
					
			end case;			
			

			--output the data
			am_address<=current_address;	
			am_dataWrite<=outputBuffer(conv_integer(bufferHeadVar));--output the head
			am_burstcount(5 downto 0)<=burstToSend;
			

			if(to24Bits_reg='1')then--if 8 bits=> must store 24 bits only
				am_byteEnable<="0111";
			else--must store all the 32 bits
				am_byteEnable<="1111";
			end if;
			
		end if;
	
	end process;

	

end arch;

