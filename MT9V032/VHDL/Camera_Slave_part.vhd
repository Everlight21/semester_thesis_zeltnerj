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

-- Serial input, parallel output (8 bits)
--
--
entity Camera_Slave_part is 
        port (
				-- inputs:
                 clk 			: IN std_logic;
				reset		: IN std_logic;


					-- Avalon bus
				avalon_chipselect: IN std_logic;
				avalon_address	: IN std_logic_vector(2 downto 0);--6 registers used
				avalon_read		: IN std_logic;
				avalon_writeData	: IN std_logic_vector(31 downto 0);
				avalon_write		: IN std_logic;
				
					-- Camera interface and master part
				camInt_frame_finished: IN std_logic;
				camInt_nbPixels	: IN std_logic_vector(31 downto 0);
				
				am_transfert_frame_finished: IN std_logic;
				am_bufferUsed	: IN std_logic_vector(31 downto 0);
				
					-- outputs:
					-- AVALON Slave				
				am_startAddress1	: OUT std_logic_vector(31 downto 0);
				am_startAddress2	: OUT std_logic_vector(31 downto 0);
				am_addressChanged	: OUT std_logic;
				am_begin			: OUT std_logic;
				am_24bits			: OUT std_logic;--24 or 32 by pixel
					-- camera Interface
				camInt_start		: OUT std_logic;
				camInt_mode		: OUT std_logic;
				camInt_stop		: OUT std_logic;
				camInt_BGR		: OUT std_logic;--if 0, RGB, if 1 BGR
				camInt_8bits		: OUT std_logic;--if 0, 10 bits data, if 1 8 bits
				
					--Avalon bus
				avalon_readData 	: OUT std_logic_vector(31 downto 0);
				avalon_irq			: OUT std_logic;
				
					--Color correction
				WB_newValue			: OUT std_logic;
				WB_factor1	: OUT std_logic_vector(9 downto 0);
				WB_factor2	: OUT std_logic_vector(9 downto 0);
				WB_factor3	: OUT std_logic_vector(9 downto 0);
				
					--PixelSelector
				pixelSelector_color		: OUT std_logic;
				
					--MT9V032 device
				cam_Exposure		: OUT std_logic;
				cam_Feedback		: in std_logic;
					
					--Input control
				IC_inputControlMode:  OUT std_logic_vector(1 downto 0)

             
              );
end entity Camera_Slave_part;


architecture arch of Camera_Slave_part is

	--registers accessible via avalon									10  		|	9-8						7			6				5					4			3			2					1							0
	signal status_reg		: std_logic_vector(31 downto 0);--0=> 	...	feedBack	| InputControlMode	|	24bits	|	BGR/RGB_n	| 	8/10bits_n		|	irq_en	|	running	|	frame_finished	|	mode (video/snapthot_n)	|	color/bw
	signal control_reg		: std_logic_vector(31 downto 0);--1=>	...	feedBack    | InputControlMode	|	24bits	|	BGR/RGB_n	| 	8/10bits_n	 	|	irq		|	start	|	stop			|	mode (video/snapthot_n)	|	color/bw
	signal startAddress1_reg: std_logic_vector(31 downto 0);--2=> address of the first byte for the first buffer
	signal startAddress2_reg: std_logic_vector(31 downto 0);--3=> address of the first byte for the second buffer
	signal lastValidBuffer_reg: std_logic_vector(31 downto 0);--4=> address of the las valid frame captured
	signal nbPixels_reg		: std_logic_vector(31 downto 0);--5=> nbPixels of the last aquisition
	signal colorCorrection_reg: std_logic_vector(31 downto 0);--6=>format XX|factor3|factor2|factor1
	signal mustSetExposure	: std_logic;--set by the start of a snapshot,
	
	signal internalIRQ		: std_logic;
	---------------------------------
	
begin		

	--write process
	process(clk,reset)
		variable exposureTimeCounter: std_logic_vector(2 downto 0);--the counter to know how many clock cylcles we must set to 1 the exposure signal
		variable nbStart:std_logic_vector(2 downto 0);
		variable nbSnapshot: std_logic_vector(2 downto 0);
	begin
	
		if(reset='1')then
			status_reg<=(others=>'0');
			control_reg<=(others=>'0');
			startAddress1_reg<=(others=>'0');
			startAddress2_reg<=(others=>'0');
			lastValidBuffer_reg<=(others=>'0');
			nbPixels_reg<=(others=>'0');
			mustSetExposure<='0';
			exposureTimeCounter:=(others=>'0');
			nbStart:=(others=>'0');
			nbSnapshot:=(others=>'0');
			internalIRQ<='0';
		elsif(rising_edge(clk))then
		
			--default values
			camInt_start<='0';
			camInt_stop<='0';
			am_addressChanged<='0';
			am_begin<='0';
			camInt_8bits<='0';
			camInt_BGR<='0';
			cam_Exposure<='0';
			WB_newValue<='0';
			
			status_reg(10)<=cam_Feedback;--feedback of the camera. LED_ON or 3.3VDD depending on the version (parallel/serial)
		
			--want to write something
			if(avalon_chipselect='1' and avalon_write='1')then
				
				case avalon_address is
					when "000" =>--cannot write status_reg (read only), only ack irq
							--if(avalon_writeData(4)='1')then
								internalIRQ<='0';--irq ack
							--end if;
					when "001" =>--control reg
							if(avalon_writeData(3)='1')then--start='1'
								control_reg(3)<='1';--start
								control_reg(2)<='0';--not stop
								status_reg(2)<='0';--frame not finished
								control_reg(1)<=avalon_writeData(1);--write the mode
								status_reg(1)<=avalon_writeData(1);
								control_reg(0)<=avalon_writeData(0);--color or black and white (select if must debayerise the data (and do all the stuff for the color) or not.
								status_reg(0)<=avalon_writeData(0);--0 means that we use the color version, 1 the black and white.
								
								camInt_start<='1';
								camInt_mode<=avalon_writeData(1);
								
								mustSetExposure<=not avalon_writeData(1);--if mode is 0, mustSetExposre is set to 1
								
								status_reg(3)<='1';--running
								
								
								
								--the mode of aquisition
								control_reg(5)<=avalon_writeData(5);-- if 0 => 10 bits, if 1 => 8 bits
								control_reg(6)<=avalon_writeData(6);-- if 0 => RBG, if 1 => BGR
								status_reg(5)<=avalon_writeData(5);
								status_reg(6)<=avalon_writeData(6);--BGR\RGB_n
								
								--am_addressChanged<='1';--indicate the new value for 8 bits (will affect the address if implemented)
								am_begin<='1';
								camInt_8bits<=avalon_writeData(5);
								camInt_BGR<=avalon_writeData(6);
								
								--debut: count the number of starts
								nbStart:=nbStart+1;
								
								--mode for the input, if the camera is the parallel or serial one, and whitch mode for the serial one
								control_reg(9 downto 8)<=avalon_writeData(9 downto 8);
								status_reg(9 downto 8)<=avalon_writeData(9 downto 8);
								
								--24bits or 32 bits am_24bits
								control_reg(7)<=avalon_writeData(7);
								status_reg(7)<=avalon_writeData(7);
								
							elsif(avalon_writeData(2)='1')then--stop
								control_reg(3)<='0';--not start
								control_reg(2)<='1';--stop
								
								camInt_stop<='1';		--stopped						
								status_reg(3)<='0';--not running
							end if;
							
							control_reg(4)<=avalon_writeData(4);-- change the irq value
							status_reg(4)<=avalon_writeData(4);-- change the irq value
					when "010" => --change the start address 1
							startAddress1_reg<=avalon_writeData;
							
							--indicate address has changed (start is used to modify the start address)
							am_addressChanged<='1';
							am_startAddress1<=avalon_writeData;
							am_startAddress2<=startAddress2_reg;
							
							
					when "011" => --change the start address 2
							startAddress2_reg<=avalon_writeData;
							
							--indicate address has changed (start is used to modify the start address)
							am_addressChanged<='1';
							am_startAddress1<=startAddress1_reg;
							am_startAddress2<=avalon_writeData;
							
					when "110" => --change the color correction value
							colorCorrection_reg<=avalon_writeData;--store the value
							
							WB_newValue<='1';--indicates that the correction value has changed
							WB_factor1<=avalon_writeData(9 downto 0);--
							WB_factor2<=avalon_writeData(19 downto 10);--
							WB_factor3<=avalon_writeData(29 downto 20);--
					when others=>
					
				end case;
				
			end if;
			
			
			--image finished
			if(camInt_frame_finished='1')then--the camera controler indicates that all the pixels have been sent to the master part
				
				nbPixels_reg<=camInt_nbPixels;

				--if frame finished and the mode is snapshot, the system is not running anymore
				if(status_reg(1)='0')then--mode snaphsot
				
					status_reg(3)<='0';--not running anymore
				
				end if;
				
			end if;
			
			
			if(am_transfert_frame_finished='1')then--the master part indicates that all the pixels of the frame have been sent. The use can get the image.
				status_reg(2)<='1';--indicate finished
				--status_reg(4)<=control_reg(4);--if irq enable, set bit 4 to 1, 0 otherwise
				internalIRQ<=status_reg(4);
				lastValidBuffer_reg<=am_bufferUsed;--update the last buffer used
				

			end if;
			
			
			--manage the exposure
			if(mustSetExposure='1')then
		
				exposureTimeCounter:=exposureTimeCounter+1;
				cam_Exposure<='1';
				
				if(exposureTimeCounter="111")then
					mustSetExposure<='0';
					exposureTimeCounter:=(others=>'0');
					nbSnapshot:=nbSnapshot+1;
				end if;
		
			end if;
			
		end if;
	
		
	end process;
	
	avalon_irq<=internalIRQ;
	--avalon_irq<=status_reg(4);--irq
	pixelSelector_color<=status_reg(0);
	IC_inputControlMode<=status_reg(9 downto 8);
	am_24bits<=status_reg(7);
	
	--read process
	process(clk)
	begin
	
		if(rising_edge(clk))then
	
			--want to read
			if(avalon_chipselect='1' and avalon_read='1')then
	
				case avalon_address is
					when "000" => avalon_readData<=status_reg;
					when "001" => avalon_readData<=control_reg;
					when "010" => avalon_readData<=startAddress1_reg;
					when "011" => avalon_readData<=startAddress2_reg;
					when "100" => avalon_readData<=lastValidBuffer_reg;
					when "101" => avalon_readData<=nbPixels_reg;
					when "110" => avalon_readData<=colorCorrection_reg;		
									
					when others =>
			
				end case;
			end if;
	
		end if;
	
	end process;
	
end arch;

