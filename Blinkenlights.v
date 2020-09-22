module Blinkenlights(
					data_in,
					reset,
					run,
					row_clk,
					frame_clk,
					row,
					column,
					rowcount
					);
					
	output reg [1:0] 	data_in;
	input 			reset, run, row_clk;
	output reg     frame_clk;
	output reg [7:0] 	column;
	output reg [7:0] 	row;
	
	reg [2:0] 		framecount=0;
	output reg [2:0] 		rowcount=0;

					
	parameter limit=4;	// used as the clock divider
	reg [25:0] count = 0;
	
	always@(posedge row_clk)begin
		count = count + 1; 
		if(count == 1) begin
				count <= 0;
				frame_clk <= ~frame_clk;
		end
	end

	always @(posedge row_clk)
			begin

			if(rowcount == 4'b1000)
				begin
				rowcount = 4'b0000;
				end
			else
				begin
				rowcount = rowcount + 1;
			end
	end	

	
	always @(posedge row_clk)
			begin
				case(data_in)
				
				2'b00:
				begin
					case(rowcount)																//Signed decimal for row and column
						4'b0000:begin row=8'b10000001; column=8'b00000000; end 	//row =-127,	column=126
						4'b0001:begin row=8'b10000001; column=8'b11000011; end	//row =-127,	column=126		
						4'b0010:begin row=8'b11100111; column=8'b11000011; end	//row =-25,		column=24
						4'b0011:begin row=8'b11100111; column=8'b11111111; end	//row =-25,		column=24
						4'b0100:begin row=8'b11100111; column=8'b11111111; end	//row =-25,		column=24
						4'b0101:begin row=8'b11100111; column=8'b11000011; end	//row =-25,		column=24
						4'b0110:begin row=8'b10000001; column=8'b11000011; end	//row =-127,	column=126
						4'b0111:begin row=8'b10000001; column=8'b00000000; end	//row =-127,	column=126
					endcase
				end
				
				2'b01:
				begin
					case(rowcount)
						4'b0000:begin row=8'b11100111; column=8'b00011000; end 	//row =-25,		column=24
						4'b0001:begin row=8'b11100111; column=8'b00011000; end	//row =-25,		column=24
						4'b0010:begin row=8'b11100111; column=8'b00011000; end	//row =-25,		column=24
						4'b0011:begin row=8'b00000000; column=8'b11111111; end	//row = 0,		column=-1
						4'b0100:begin row=8'b00000000; column=8'b11111111; end	//row = 0,		column=-1
						4'b0101:begin row=8'b11100111; column=8'b00011000; end	//row =-25,		column=24
						4'b0110:begin row=8'b11100111; column=8'b00011000; end	//row =-25,		column=24
						4'b0111:begin row=8'b11100111; column=8'b00011000; end	//row =-25,		column=24
					endcase
				end
				
				2'b10:
				begin
					case(rowcount)
						4'b0000:begin row=8'b10000001; column=8'b00000000; end 	//row =-127,	column=126
						4'b0001:begin row=8'b10111111; column=8'b10011111; end	//row =-65,		column=64
						4'b0010:begin row=8'b10111111; column=8'b10010001; end	//row =-65,		column=64
						4'b0011:begin row=8'b10000001; column=8'b10010001; end	//row =-127,	column=126
						4'b0100:begin row=8'b00000010; column=8'b10010001; end	//row = 2,		column=-3
						4'b0101:begin row=8'b00000010; column=8'b10010001; end	//row = 2,		column=-3
						4'b0110:begin row=8'b00000010; column=8'b11110001; end	//row = 2,		column=-3
						4'b0111:begin row=8'b10000001; column=8'b00000000; end	//row =-127,	column=126
					endcase
				end
				
				2'b11:
				begin
					case(rowcount)
						4'b0000:begin row=8'b11000011; column=8'b00000000; end 	//row =-61,		column=60
						4'b0001:begin row=8'b11000011; column=8'b00000000; end	//row =-61,		column=60
						4'b0010:begin row=8'b11011011; column=8'b11111111; end	//row =-37,		column=36
						4'b0011:begin row=8'b11011011; column=8'b11000011; end	//row =-37,		column=36
						4'b0100:begin row=8'b11011011; column=8'b11000011; end	//row =-37,		column=36
						4'b0101:begin row=8'b11011011; column=8'b11111111; end	//row =-37,		column=36
						4'b0110:begin row=8'b11000011; column=8'b00000000; end	//row =-61,		column=60
						4'b0111:begin row=8'b11000011; column=8'b00000000; end	//row =-61,		column=60
					endcase
				end
				
			endcase
		end
	
		
		
	always @(posedge frame_clk)
	begin
	if(framecount == 3'b011 || reset==0)
		begin
			framecount = 3'b000;
			end
			else if(run==1)
			begin
			framecount = framecount + 3'b001;
			end
			else if(run==0)
			begin
			framecount = framecount;
			end
		end


	
	always@(negedge frame_clk)begin
		 
		if(reset == 1 && run ==1)
			data_in = data_in + 2'b01;
		else if(reset == 1 && run ==0)
			data_in = data_in;
		else if(reset == 0)
			data_in=2'b00;
					
	end
	
endmodule