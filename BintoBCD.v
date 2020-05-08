module Bin_to_BCD (bin,BCD);
                input [15:0]bin;
					 output [15:0]BCD;
wire [3:0]a,b,c,d;
assign a = bin /1000 ;
assign b = (bin - a*1000)/100;
assign c = (bin - a *1000 - b*100)/10;
assign d = bin % 10 ;
assign BCD = {a,b,c,d};
endmodule
