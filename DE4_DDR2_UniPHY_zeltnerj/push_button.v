
`include "vpg_source/vpg.h"


module push_button(

CLKIN,
RESET_N,
BUTTON,
MODE,
MODE_CHANGED

);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input		          		CLKIN;

//////////// RESET_N //////////
input		          		RESET_N;

//////////// BUTTON x 4, EXT_IO and CPU_RESET_n //////////
input		     		BUTTON;

output		 [3:0]		MODE;
output		 MODE_CHANGED;


//---------------------------------------------------//
//				Mode Change Button Monitor 			 //
//---------------------------------------------------//
wire			mode_button;
reg			pre_mode_button;
//reg		[15:0]	debounce_cnt;
reg		[3:0]	vpg_mode;
reg				vpg_mode_change;


	assign mode_button = ~BUTTON;
	always@(posedge CLKIN or negedge RESET_N)
		begin
			if (!RESET_N)
				begin
					vpg_mode <= `FHD_1920x1080p60;//`VGA_640x480p60;
//					debounce_cnt <= 1;
					vpg_mode_change <= 1'b1;
				end
			else if (vpg_mode_change)
				vpg_mode_change <= 1'b0;
//			else if (debounce_cnt)
//				debounce_cnt <= debounce_cnt + 1'b1;
			else if (mode_button && !pre_mode_button)
				begin
//					debounce_cnt <= 1;
					vpg_mode_change <= 1'b1;
					if (vpg_mode == `VESA_1600x1200p60)
						vpg_mode <= `VGA_640x480p60;
					else
						vpg_mode <= vpg_mode + 1'b1;
				end
		end

	always@(posedge CLKIN)
		begin
			pre_mode_button <= mode_button;
		end
		
assign MODE=vpg_mode;	
assign MODE_CHANGED=vpg_mode_change;
		
endmodule