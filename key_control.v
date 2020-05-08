module key_controll (clk,key_in,EN,a,b,math);
                  input clk;

		  input [3:0]key_in;
		  input EN;
		  output[15:0]a; 
		  output [15:0] b;
		  output[1:0]math;
                  


//reg	[5:0]	state;
 reg[15:0]a;
reg[15:0]b;
reg[1:0] math; 
reg ab_flag;
reg[15:0]temp_a,temp_b;
reg [1:0]math_temp;
always@( posedge clk )
begin 
    if(EN) 
     begin
	   case (key_in)
		0 : begin //1
	         if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0001};
				else temp_b <= {temp_b[11:0],4'b0001};
			 end
			
		1 : begin //2
	        if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0010};
				else temp_b <= {temp_b[11:0],4'b0010};
			 end			
				
		2 : begin //3
	         if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0011};
				else temp_b <= {temp_b[11:0],4'b0011};
			 end

		4 : begin //4
	        if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0100};
				else temp_b <= {temp_b[11:0],4'b0100};
			 end

		5 : begin //5
	         if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0101};
				else temp_b <= {temp_b[11:0],4'b0101};
			 end

		6 : begin//6 
	        if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0110};
				else temp_b <= {temp_b[11:0],4'b0110};
			 end


		8 : begin //7
	         if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0111};
				else temp_b <= {temp_b[11:0],4'b0111};
			 end

		9 : begin //8
	        if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b1000};
				else temp_b <= {temp_b[11:0],4'b1000};
			 end

		10 : begin //9
	         if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b1001};
				else temp_b <= {temp_b[11:0],4'b1001};
			 end



		12 : begin //*
	        if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0000};
				else temp_b <= {temp_b[11:0],4'b0000};
			 end

		13 : begin //0
	         if(!ab_flag)
				  temp_a <= {temp_a[11:0],4'b0000};
				else temp_b <= {temp_b[11:0],4'b0000};
			 end


			  
		3 : begin //Multiply
		      ab_flag <= 1;
	         math_temp <= 0 ;
			 end
		7 : begin //D
           	 ab_flag <= 1;	
	          math_temp <= 1;
		 end			 
		11 : begin //D
           	 ab_flag <= 1;	
	          math_temp <= 2;
		 end			 

		15 : begin //D
           	 ab_flag <= 1;	
	          math_temp <= 3;
		 end
		 
		14 : begin //#
		      a <= temp_a; 
				b <= temp_b;
	         temp_b <= 16'h0000;
			   temp_a <= 16'h0000;	
	         ab_flag <= 0 ;
				math <= math_temp ;
			  end
		 
		default 	;
      endcase
	 end 
end

endmodule 		 	 
