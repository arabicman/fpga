
module BCD_to_Bin (data_in,data_out);
           input [15:0]data_in;
			  output [15:0]data_out;		  


assign data_out = data_in[15:12]*1000 + data_in[11:8]*100 + data_in[7:4]*10 + data_in[3:0];
endmodule
