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


ENTITY debayeriser is
	generic(bitsPerPixel : natural :=8;--10
			nbPixelPerLine: natural :=752;--752
			nbLines: natural :=480;
			bufferLineSize: natural:=1024);--480
			--the size is supposed to be even! even x even
	port(
	
	clk : in std_logic;
	reset : in std_logic;
	
	-- entrée
	newframe 			: in std_logic;
	newline 			: in std_logic;
	pixel_in 			: in std_logic_vector(bitsPerPixel-1 downto 0);
	pixelAvailable		: in std_logic;
	
	-- sortie
	newframe_out 		: out std_logic;
	newline_out 		: out std_logic;
	pixel_out 			: out std_logic_vector(31 downto 0);
	pixelAvailable_out	: out std_logic;
	lastPixel_out		: out std_logic
	
	
	);
end debayeriser; 

architecture arch of debayeriser is

	--type threeline_in is array (0 to 2) of std_logic_vector(bitsPerPixel*nbPixelPerLine-1 downto 0);--thre lines of 752 pixels (so 752*10 bits per line)
	--signal pixelsBuffer 		: threeline_in;
	
	--nbPixelPerLine-3
	type bufferLine is array(bufferLineSize-1 downto 0) of std_logic_vector(bitsPerPixel-1 downto 0);
	
	
	signal pixelsBuffer_0 		: bufferLine;
	signal pixelsBuffer_1 		: bufferLine;
	signal pixelsBuffer_2 		: bufferLine;
	
	type pixelArray is array(2 downto 0) of std_logic_vector(bitsPerPixel-1 downto 0);--three pixels of n bits

	
	--the three line of thre pixel, on which we work.
	signal pixelsLine_0 		: pixelArray;
	signal pixelsLine_1			: pixelArray;
	signal pixelsLine_2 		: pixelArray; 
	
	signal col_reg		: std_logic_vector(9 downto 0);--store the colonne number, [0;751]
	signal line_reg		: std_logic_vector(8 downto 0);--store the line number [0;479]
	
	type stateType is (waitBegin,twoLines_B,twoLines_G,BGB_first_B,BGB_B,BGB_G,BGB_last_G,GRG_first_G,GRG_G,GRG_R,GRG_last_R,twoLines_end_R,twoLines_end_G,twoLines_end_last_R);
	signal state : stateType;
	
	signal nbPixels_reg: std_logic_vector(18 downto 0);--number of pixels received, [0;752*480]// used to know when we have enough pixels to start
	
	signal lastLineShift: std_logic; --for the last line, we must manually shift the buffer because no pixel will comes
	
	--signal FIFOhead : 	std_logic_vector(9 downto 0);
	--signal FIFOtail :	std_logic_vector(9 downto 0);
	
	
BEGIN


	--process to acquire and shift the buffer
	process(clk,reset)
		--variable FIFOtailTMP :	std_logic_vector(9 downto 0);
		variable FIFOhead : 	integer range 0 to bufferLineSize-1;
		variable FIFOtail :		integer range 0 to bufferLineSize-1;
		
		--variable nbPixels_var: std_logic_vector(18 downto 0);
	begin
	
		if(reset='1')then

			--nbPixels_var:=(others=>'0');
			nbPixels_reg<=(others=>'0');
			
			FIFOhead:=0;--restart the fifo pointer
			FIFOtail:=0;--tail= head +1
			
			--nbPixels_reg<=nbPixels_var;
		elsif(rising_edge(clk))then
	
			if(newFrame='1')then
				--nbPixels_var:=(others=>'0');
				nbPixels_reg<=(others=>'0');
			end if;
			
			--a new pixel is available, store it and shift all the buffer (also shift the buffer is ask by state machine)
			if(pixelAvailable='1' or lastLineShift='1')then
			
				--there is nbPixelPerLine pixels, but the buffer is nbPixelPerLine-2 pixels 
				--(3 pixels are not stored in buffer and we add one pixel in buffer to be free)
				--increment tail
				FIFOtail:=FIFOtail+1;
				if(FIFOtail=nbPixelPerLine-2)then
					FIFOtail:=0;
				end if;
				
				--get the last pixel input in the fifo and send it to the 3x3 matrix (line 2)
				pixelsBuffer_2(FIFOhead)<=pixel_in;--input pixel
				pixelsBuffer_1(FIFOhead)<=pixelsLine_2(0);--from last of line 2 to first of line 1
				pixelsBuffer_0(FIFOhead)<=pixelsLine_1(0);--from last of line 1 to first of line 0
								
			
				--shift the 3x3 matrix
				pixelsLine_2(1 downto 0)<=pixelsLine_2(2 downto 1);--shit the three pixels vector
				pixelsLine_1(1 downto 0)<=pixelsLine_1(2 downto 1);--shit the three pixels vector
				pixelsLine_0(1 downto 0)<=pixelsLine_0(2 downto 1);--shit the three pixels vector
				
				--increment head
				FIFOhead:=FIFOhead+1;
				if(FIFOhead=nbPixelPerLine-2)then
					FIFOhead:=0;
				end if;
			
			end if;

			if(pixelAvailable='1')then--count the number of pixel of the current image received
				--nbPixels_var:=nbPixels_var+1;
				nbPixels_reg<=nbPixels_reg+1;
			end if;	
			
				
			pixelsLine_2(2)<=pixelsBuffer_2(FIFOtail);--from last of buffer to first of 3 pixel matrix
			pixelsLine_1(2)<=pixelsBuffer_1(FIFOtail);--from last of buffer to first of 3 pixel matrix
			pixelsLine_0(2)<=pixelsBuffer_0(FIFOtail);--from last of buffer to first of 3 pixel matrix
			
			
			--nbPixels_reg<=nbPixels_var;
		end if;
		
		
		
	
	end process;

	--the state machine
	--the pixel we want to compute the value is always the pixel (1)(1)
	--
	--	...	2	1	0
	--
	--	...	A	B	C	-- 2
	--	...	D	_	F	-- 1
	--	... G	H	I	-- 0 
	process(clk,reset)
		variable red 	: std_logic_vector(2+bitsPerPixel-1 downto 0);--larger than pixels to avoid overflow in the addition
		variable green 	: std_logic_vector(2+bitsPerPixel-1 downto 0);
		variable blue 	: std_logic_vector(2+bitsPerPixel-1 downto 0);
		
	begin
	
		if(reset='1')then
			state<=waitBegin;
			lastPixel_out<='0';
		elsif(rising_edge(clk))then
	
			pixelAvailable_out<='0';
			newline_out<='0';
			newframe_out<='0';
			lastLineShift<='0';
			lastPixel_out<='0';
			
			case state is

				when waitBegin =>
				
					line_reg<=(others=>'0');
					col_reg<=(others=>'0');

					if(nbPixels_reg=(nbPixelPerLine*2-2) and pixelAvailable='1')then--if we have received enough of the two lines to begin to compute the image
						state<=twoLines_B;
						
						newframe_out<='1';
						newline_out<='1';
					end if;
					
				when twoLines_B =>--if we have two lines, we can compute the border pixels. here we are on a blue pixel					
					
					
					--	2	1	0
					--
					--	R	G	x	--2
					--	G	B	x	--1	
					--	x	x	x	--0
					blue:="00" & pixelsLine_1(1);

					green:=	( ("00" 	& pixelsLine_1(2))
							+ ("00" 	& pixelsLine_2(1)));
							
					green(bitsPerPixel-1 downto 0):=green(bitsPerPixel downto 1);-- div by 2
							
					red:="00" & pixelsLine_2(2);
					
--					red:=(others=>'0');
--					green:=(others=>'0');
--					blue:=(others=>'1');
								
					if(pixelAvailable='1')then
						col_reg<=col_reg+1;
						state<=twoLines_G;				
						pixelAvailable_out<='1';
					end if;
					
				when twoLines_G =>--if we have two lines, we can compute the border pixels. here we are on a blue pixel					
					
					
					if(col_reg/=nbPixelPerLine-2)then--if it is not the last pixel of the line
				
						--
						--	2	1	0
						--
						-- 	G	R	x	--2
						--	B	G	x	--1
						--	x	x	x	--0

						blue:=	"00" & pixelsLine_1(2);
						green:=	"00" 	& pixelsLine_1(1);		
						red:=	"00" & pixelsLine_2(1);			
					else--for the last pixel of the line,...					
						--
						--	2	1	0
						--
						-- 	x	R	G	--2
						--	x	G	B	--1
						--	x	x	x	--0

						blue:=	"00" & pixelsLine_1(0);
						green:=	"00" 	& pixelsLine_1(1);		
						red:=	"00" & pixelsLine_2(1);				
					end if;
				
					
--					red:=(others=>'0');
--					green:=(others=>'1');
--					blue:=(others=>'0');
					
					if(pixelAvailable='1')then
						if(col_reg=(nbPixelPerLine-1))then--end of the line, go to compute the first pixel of a 3 line
							state<=GRG_first_G;	-- the first line we can use is of type GRG and the middle pixel is G
							line_reg<=line_reg+1;
							col_reg<=(others=>'0');
						else
							col_reg<=col_reg+1;
							state<=twoLines_B;
						end if;
						pixelAvailable_out<='1';
					end if;
					
				when GRG_first_G =>--process the first pixel of a 3 lines data
						
					--
					--	2	1	0
					--
					-- 	G	B	x	--2
					--	R	G	x	--1
					--	x	x	x	--0

					blue:=	"00" & pixelsLine_2(1);
					green:=	"00" 	& pixelsLine_1(1);		
					red:=	"00" & pixelsLine_1(2);
						
--					red:=(others=>'1');
--					green:=(others=>'1');
--					blue:=(others=>'0');			
					
					if(pixelAvailable='1')then--first pixel of line treated, lets compute the following "normal" pixels
						col_reg<=col_reg+1;
						state<=GRG_R;
						pixelAvailable_out<='1';
						newline_out<='1';
					end if;
												
				when GRG_R =>--line of type GRG, we are on a R pixel
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	B		G		B		//line 2
				-- 	G		R		G		//line 1
				--	B		G		B		//line 0			
	
					red:="00" & pixelsLine_1(1);
					--we have (a+b+c+d)/4 
					green:=	( ("00" 	& pixelsLine_2	(1))
							+ ("00" 	& pixelsLine_0	(1))
							+ ("00" 	& pixelsLine_1	(2))
							+ ("00" 	& pixelsLine_1	(0)));
							
					green(bitsPerPixel-1 downto 0):=green(bitsPerPixel+1 downto 2);-- div by 4
							
					blue:=	(	("00" 	&	pixelsLine_2	(2))
							+ 	("00" 	&	pixelsLine_2	(0))
							+ 	("00" 	&	pixelsLine_0	(2))
							+ 	("00" 	&	pixelsLine_0	(0)));
							
					blue(bitsPerPixel-1 downto 0):=blue(bitsPerPixel+1 downto 2);--div by 4
					
--					red:=(others=>'1');
--					green:=(others=>'0');
--					blue:=(others=>'0');
												
					if(pixelAvailable='1')then
						col_reg<=col_reg+1;
						state<=GRG_G;
						pixelAvailable_out<='1';
					else
						state<=GRG_R;
					end if;
					
				when GRG_G =>--line of type GRG, we are on a G pixel
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	G		B		G
				-- 	R		G		R
				--	G		B		G
								
					green:="00" & pixelsLine_1(1);
					
					red:=	( ("00" 	& pixelsLine_1	(2))
							+ ("00" 	& pixelsLine_1	(0)));	
					red(bitsPerPixel-1 downto 0):=red(bitsPerPixel downto 1);--div by 2
							
					blue:=	(	("00" 	&	pixelsLine_2	(1))
							+ 	("00" 	&	pixelsLine_0	(1)));	
					blue(bitsPerPixel-1 downto 0):=blue(bitsPerPixel downto 1);--div by 2
					
--					red:=(others=>'1');
--					green:=(others=>'0');
--					blue:=(others=>'0');			

					if(pixelAvailable='1')then--if there is a new value, the buffer has been shifted and we can tread the data
						
						if(col_reg=(nbPixelPerLine-2))then--last pixel of line will follow
							state<=GRG_last_R;	
						else
							state<=GRG_R;
						end if;
						col_reg<=col_reg+1;
						pixelAvailable_out<='1';
					else
						state<=GRG_G;
					end if;
			
				when GRG_last_R =>--line of type GRG, we are on the last pixel of the line, it is of type R
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	x		x		x		//line 2
				-- 	x		R		G		//line 1
				--	x		G		B		//line 0			
			
					red:="00" & pixelsLine_1(1);
					green:=	( ("00" 	& pixelsLine_1	(0))
							+ ("00" 	& pixelsLine_0	(1)));			
					green(bitsPerPixel-1 downto 0):=green(bitsPerPixel downto 1);-- div by 1	
					blue:=	("00" 	&	pixelsLine_0	(0));
					
					--colorRed
--					red:=(others=>'0');
--					green:=(others=>'0');
--					blue:=(others=>'0');
					
					if(pixelAvailable='1')then
						
						state<=BGB_first_B;
						pixelAvailable_out<='1';
						line_reg<=line_reg+1;
						col_reg<=(others=>'0');
						
						if(line_reg=nbLines-3)then--if the next line is the last but one, must begin to shift manually
							lastLineShift<='1';--indicate to shift the buffer
						end if;
					else
						state<=GRG_last_R;
					end if;				
				
				
				when BGB_first_B =>--line of type BGB, we are on a B pixel, it is the first pixel of the line
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	R		G		x	--2
				-- 	G		B		x	--1
				--	x		x		x	--0
					
				
					blue:="00" & pixelsLine_1(1);
					green:=	( ("00" 	& pixelsLine_2	(1))
							+ ("00" 	& pixelsLine_1	(2)));
							
					green(bitsPerPixel-1 downto 0):=green(bitsPerPixel downto 1);-- div by 2
							
					red:=	("00" 	&	pixelsLine_2	(2));
					
					--colorBlue
--					red:=(others=>'0');
--					green:=(others=>'1');
--					blue:=(others=>'1');
					
					if(line_reg=nbLines-2)then
						state<=BGB_G;
						newLine_out<='1';
						pixelAvailable_out<='1';
						lastLineShift<='1';--indicate to shift the buffer
						col_reg<=col_reg+1;
						blue(9 downto 0):=col_reg(9 downto 0);----------------<<
					elsif(pixelAvailable='1')then
						state<=BGB_G;		
						newLine_out<='1';
						pixelAvailable_out<='1';
						col_reg<=col_reg+1;
					else
						state<=BGB_first_B;
					end if;
										
				when BGB_G =>--line of type BGB, we are on a G pixel
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	G		R		G
				-- 	B		G		B
				--	G		R		G	

					
					green:="00" & pixelsLine_1(1);
					
					--we have (a+b+c+d)/4 
					blue:=	( ("00" 	& pixelsLine_1	(2))
							+ ("00" 	& pixelsLine_1	(0)));
							
					blue(bitsPerPixel-1 downto 0):=blue(bitsPerPixel downto 1);--div by 2
							
					red:=	(	("00" 	&	pixelsLine_2	(1))
							+ 	("00" 	&	pixelsLine_0	(1)));
							
					red(bitsPerPixel-1 downto 0):=red(bitsPerPixel downto 1);--div by 2
					
--					red:=(others=>'1');
--					green:=(others=>'0');
--					blue:=(others=>'1');
							
					--if it is the end of the frame, must shift ourself, no data will come to shift the buffer
					if(line_reg=nbLines-2)then
						state<=BGB_B;
						pixelAvailable_out<='1';
						lastLineShift<='1';--indicate to shift the buffer
						col_reg<=col_reg+1;
						--blue(9 downto 0):=col_reg(9 downto 0);----------------<<
					elsif(pixelAvailable='1')then
						state<=BGB_B;
						pixelAvailable_out<='1';
						col_reg<=col_reg+1;
					else
						state<=BGB_G;
					end if;
				
				when BGB_B =>--line of type BGB, we are on a B pixel
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	R		G		R
				-- 	G		B		G
				--	R		G		R
					
					if(col_reg<nbPixelPerLine-1)then
						blue:="00" & pixelsLine_1(1);
						--we have (a+b+c+d)/4 
						green:=	( ("00" 	& pixelsLine_2	(1))
								+ ("00" 	& pixelsLine_0	(1))
								+ ("00" 	& pixelsLine_1	(2))
								+ ("00" 	& pixelsLine_1	(0)));
								
						green(bitsPerPixel-1 downto 0):=green(bitsPerPixel+1 downto 2);-- div by 4
								
						red:=	(	("00" 	&	pixelsLine_2	(2))
								+ 	("00" 	&	pixelsLine_2	(0))
								+ 	("00" 	&	pixelsLine_0	(2))
								+ 	("00" 	&	pixelsLine_0	(0)));
								
						red(bitsPerPixel-1 downto 0):=red(bitsPerPixel+1 downto 2);--div by 4
								
					end if;
					
--					red:=(others=>'0');
--					green:=(others=>'0');
--					blue:=(others=>'1');
					
					if(line_reg=nbLines-2)then--the last line but one
						if(col_reg=(nbPixelPerLine-2))then--will compute the last pixel of the line
							state<=BGB_last_G;
						else
							state<=BGB_G;
						end if;
						col_reg<=col_reg+1;
						pixelAvailable_out<='1';
						lastLineShift<='1';--indicate to shift the buffer
						--blue(9 downto 0):=col_reg(9 downto 0);----------------<<
					elsif(pixelAvailable='1')then
						if(col_reg=(nbPixelPerLine-2))then--will compute the last pixel of the line
							state<=BGB_last_G;
						else
							state<=BGB_G;
						end if;
						col_reg<=col_reg+1;
						pixelAvailable_out<='1';
					else
						state<=BGB_B;
					end if;
					
				when BGB_last_G =>--line of type BGB, we are on a G pixel
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	x		x		x	--2
				-- 	x		G		B	--1
				--	x		R		G	--0

					
					green:="00" & pixelsLine_1(1);
					blue:=	("00" 	& 	pixelsLine_1	(0));	
					red:=	("00" 	&	pixelsLine_0	(1));
					
					--colorGreen
--					red:=(others=>'0');
--					green:=(others=>'0');
--					blue:=(others=>'0');
					
					if(line_reg=nbLines-2)then--last normal line, will treat the last line of the image
						state<=twoLines_end_G;
						pixelAvailable_out<='1';
						lastLineShift<='1';--indicate to shift the buffer
						line_reg<=line_reg+1;
						col_reg<=(others=>'0');
						--blue(9 downto 0):=col_reg(9 downto 0);----------------<<
					elsif(pixelAvailable='1')then			
						state<=GRG_first_G;	--continue with normals lines
						pixelAvailable_out<='1';
						line_reg<=line_reg+1;
						col_reg<=(others=>'0');
					else
						state<=BGB_last_G;
					end if;
					
				--
				--
				--
				--for the following states, there is no more pixels that comes in from the camera, we must shift manually!!!!
				--
				--
				--
				when twoLines_end_G =>--line of type GRG, we are on a G pixel
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	x		x		x	--2
				-- 	R		G		x	--1
				--	G		B		x	--0
					
					--if the first pixel of the line
					if(col_reg=0)then
						newLine_out<='1';
					end if;
					
					lastLineShift<='1';--ask the buffer to be shifted
					
					green:="00" & pixelsLine_1(1);
					blue:=	("00" 	& 	pixelsLine_0	(1));	
					red:=	("00" 	&	pixelsLine_1	(2));
					
--					red:=(others=>'0');
--					green:=(others=>'1');
--					blue:=(others=>'0');
			
					if(col_reg=(nbPixelPerLine-2))then--will compute the last pixel of the frame
						state<=twoLines_end_last_R;
						col_reg<=col_reg+1;
					else
						state<=twoLines_end_R;
						col_reg<=col_reg+1;
					end if;
					
					pixelAvailable_out<='1';
		
					
				when twoLines_end_R =>--line of type GRG, we are on a R pixel
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	x		x		x	--2
				-- 	G		R		x	--1
				--	B		G		x	--0
					
					lastLineShift<='1';--ask the buffer to be shifted
					
					green:= ( ("00" 	& pixelsLine_1	(2))
							+ ("00" 	& pixelsLine_0	(1)));
					green(bitsPerPixel-1 downto 0):=green(bitsPerPixel downto 1);-- div by 2		
					blue:=	("00" 	& 	pixelsLine_0	(2));	
					red:=	("00" 	&	pixelsLine_1	(1));
		
--					red:=(others=>'1');
--					green:=(others=>'0');
--					blue:=(others=>'0');
					
					state<=twoLines_end_G;
					pixelAvailable_out<='1';
					col_reg<=col_reg+1;
			
				
				when twoLines_end_last_R =>--line of type GRG, we are on a R pixel, it is the last of the image
				-- 	29-20	19-10	9-0		//if 10 bits
				--	23-16	15-8	7-0		//if 8 bits
				--
				--	x		x		x	--2
				-- 	X		R		G	--1
				--	X		G		B	--0
				
					lastLineShift<='1';--ask the buffer to be shifted

					
					green:= ( ("00" 	& pixelsLine_1	(0))
							+ ("00" 	& pixelsLine_0	(1)));
					green(bitsPerPixel-1 downto 0):=green(bitsPerPixel downto 1);-- div by 2	
					blue:=	("00" 	& 	pixelsLine_0	(0));	
					red:=	("00" 	&	pixelsLine_1	(1));
					
--					red:=(others=>'1');
--					green:=(others=>'0');
--					blue:=(others=>'0');
					
					state<=waitBegin;
					pixelAvailable_out<='1';
					col_reg<=(others=>'0');
					lastPixel_out<='1';--indicates that this is the last pixel
				
			end case;

		pixel_out(bitsPerPixel-1 downto 0)					<=	red(bitsPerPixel-1 downto 0);--R
		pixel_out(2*bitsPerPixel-1 downto bitsPerPixel)		<=	green(bitsPerPixel-1 downto 0);--G
		pixel_out(3*bitsPerPixel-1 downto 2*bitsPerPixel)	<= 	blue(bitsPerPixel-1 downto 0);--B

		end if;
	
	end process;

END arch; 