module calculator(RST, CLOCK_50,ROW,Column,LCD_DATA,LCD_BLON,LCD_EN,LCD_ON,LCD_RS,LCD_RW,x,mark);
 input  RST;
 input  CLOCK_50;
 input x;
 input[2:0] mark;
 input [2:0] ROW;
 output [3:0] Column;
output [7:0] LCD_DATA;
output LCD_BLON;
output LCD_EN;
output LCD_ON;
output LCD_RS;
output LCD_RW;


wire [7:0] LCD_D_1;
wire       LCD_RW_1;
wire       LCD_EN_1;
wire       LCD_RS_1;
wire		  DLY_RST;
//=============================================================================
// Structural coding
//=============================================================================
// initial //
//
assign LCD_DATA = LCD_D_1;
assign LCD_RW   = LCD_RW_1;
assign LCD_EN   = LCD_EN_1;
assign LCD_RS   = LCD_RS_1; 
assign LCD_ON   = 1'b1;
assign LCD_BLON = 1'b0; //not supported;

wire [3:0]key_BCD;
wire key_pressed,LCDen;
wire [15:0]data_a;
wire [15:0]data_b;

wire [15:0]data_a_bin;
wire [15:0]data_b_bin;

wire [1:0] math_choice;

wire [15:0]data_result;
wire [15:0]data_BCD;
key_scan key   (  .CLOCK_50(CLOCK_50),
                  .reset(RST),
						.row(ROW),
						.col(Column),
						.key_value(key_BCD),
						.key_down(key_pressed),
						.LCD_EN(LCDen),
						.x(x),
						.mark(mark)
);		

LCD_Controller	u5	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(DLY_RST),
							.W_en(LCDen),
							.key_in(key_BCD),
							.result(data_BCD),
							//	LCD Side
							.LCD_DATA(LCD_D_1),
							.LCD_RW(LCD_RW_1),
							.LCD_EN(LCD_EN_1),
							.LCD_RS(LCD_RS_1)	);
						
//	Reset Delay Timer
Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);
						
key_controll U1 ( .clk(CLOCK_50),
                  .key_in(key_BCD),
						.EN(key_pressed),
						.a(data_a),
						.b(data_b),
					   .math(math_choice)						
);					 

BCD_to_Bin U2 (  .data_in(data_a),
                 .data_out(data_a_bin)
 );
 
BCD_to_Bin U3 (  .data_in(data_b),
                 .data_out(data_b_bin)
 );
 
 math  U4(  .clk(CLOCK_50),
            .a(data_a_bin),
            .b(data_b_bin),
				.math_in(math_choice),
				.result(data_result)			
	     );
		  
Bin_to_BCD U5 (  .bin(data_result),
                 .BCD(data_BCD)


            );		
		
endmodule
