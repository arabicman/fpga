module math (clk,a,b,math_in,result) ;
            input clk;
            input [15:0] a;
				input [15:0] b;
				input [1:0] math_in;
				output [15:0] result;
reg[15:0] result; 
				

wire[15:0] c,d;
multiply m1(clk,a,b,c); 


div  m2(clk,a,b,d);


		
always 
  begin 
    case (math_in) 
	 0: result = a + b ;
	 1: result = a - b ;
	 2: result= c;
	
	 3: result =d;
	 endcase
  end

 endmodule


module multiply (clk,a,b,c);
      
    input clk;  
    input [15:0] a, b;  
    output [15:0] c;  
  
    reg [15:0] c;  
  
    parameter s0 = 0, s1 = 1, s2 = 2;  
    reg [2:0] count = 0;  
    reg [1:0] state = 0;  
    reg [15:0] P, T;  
    reg [15:0] b_reg;  
  
    always @(posedge clk) begin  
        case (state)  
            s0: begin  
                count <= 0;  
                P <= 0;  
                b_reg <=b;  
                T <= {{16{1'b0}}, a};  
                state <= s1;  
            end  
            s1: begin  
                if(count == 3'b111)  
                    state <= s2;  
                else begin  
                    if(b_reg[0] == 1'b1)  
                        P <= P + T;  
                    else  
                        P <= P;  
                    b_reg <= b_reg >> 1;  
                    T <= T << 1;  
                    count <= count + 1;  
                    state <= s1;  
                end  
            end  
            s2: begin  
                c <= P;  
                state <= s0;  
            end  
            default: ;  
        endcase  
    end  
  
endmodule 

module div (clk,a,b,d);
           input clk;
           input       [15:0]        a;//
           input       [15:0]        b;//
           output [15:0] d;
			  reg  [15:0]   d;//
//           output reg  [15:0]        y_yushu//


reg [15:0] tempa;
reg [15:0] tempb;
reg [31:0] temp_a;
reg [31:0] temp_b;

integer i;

always@(posedge clk)
   begin
      tempa = a;
      tempb = b;
   end

always@(*)
   begin
      temp_a = {16'h0,tempa};
      temp_b = {tempb,16'h0};
      for(i = 0; i < 16; i = i+1)         
         begin:shift_left
//            temp_a = temp_a << 1 ;
            temp_a = {temp_a[28:0],1'b0}  ;
            if(temp_a[31:16] >= temp_b[31:16] )
               temp_a = temp_a - temp_b + 1;
            else
               temp_a = temp_a;
         end
       d = temp_a[15:0];
       //y_yushu = temp_a[15:8];
   end


endmodule
