module key_scan (reset,CLOCK_50,row,col,key_value,LCD_EN,key_down,x,mark);
				input CLOCK_50;  
				input reset;
				input x;
				input [2:0] row;
				input [2:0] mark;
            output[3:0] key_value;
				output [3:0] col;
				output LCD_EN;
				output key_down;
			
reg[3:0] key_value;			
reg[3:0] col;			
reg [14:0] count;
reg [2:0] state;  //

reg key_flag;   //
reg key_flag_dly;   //
reg key_flag_dly1;   //
reg key_flag_dly2;   //
reg key_flag_dly3;   //
reg key_flag_dly4;   //
reg key_flag_dly5;   //
reg key_flag_dly6;   //

reg CLOCK_1khz;  
reg [3:0] col_reg;  //
reg [2:0] row_reg;  //
reg [2:0] ex_reg;

always @(posedge CLOCK_50 or negedge reset) 
    if(!reset) 
		 begin 
			CLOCK_1khz<=0; 
			count<=0; 
		 end
    else 
		begin
			if(count>=25000) 
            begin
            CLOCK_1khz<=~CLOCK_1khz;
            count<=0;
            end
			else count<=count+1;
      end
		

 
always @(posedge CLOCK_1khz or negedge reset )
    
	 if(!reset) begin ex_reg<=3'b000;col<=4'b0000;state<=0;end
     else if(x==0) begin
	  		ex_reg[2:0]<=mark[2:0];
			col_reg<=4'b0000;
			row_reg<=3'b000;
			key_flag<=1'b1;
			state<=0;
			end
	  else  begin 
				case (state)
				0: 
				  begin
				   ex_reg[1:0]<=3'b000;
					col[3:0]<=4'b0000;
					key_flag<=1'b0;
					if(row[2:0]!=3'b111) 
						begin 
							state<=1; col[3:0]<=4'b1110;ex_reg[1:0]<=3'b000;
						end  	
					else state<=0;
					end 
			
				1:  	 
				 begin	  
					if(row[2:0]!=3'b111)
						begin 
							state<=5;
						end   		 
					else  begin state<=2; col[3:0]<=4'b1101;ex_reg[1:0]<=3'b000;end  	 
				  end 
  
			  2:	 
				 begin    	 
				  if(row[2:0]!=3'b111) 
					  begin 
						state<=5;
					  end   	  
				  else  
					  begin 
						  state<=3; 
						  col[3:0]<=4'b1011;ex_reg[1:0]<=3'b000;
					  end  	 
				 end
	 
			 3:	 
				 begin    
	 
				 if(row[2:0]!=3'b111) 
					 begin 
						state<=5;
					 end   
				 else  begin state<=4;col[3:0]<=4'b0111;ex_reg[1:0]<=3'b000;end  
				  end
	 
			 4:
	 			begin    
	 
				 if(row[2:0]!=3'b111)
					 begin 
						state<=5;
					 end  
	 
				 else  state<=0;ex_reg[1:0]<=3'b000;	 
				 end
			 5:	 
				 begin  
	 
				  if(row[2:0]!=3'b111)  
					 begin
						col_reg<=col;  
						row_reg<=row;
				      ex_reg<=3'b000;		
						state<=5; 
						key_flag<=1'b1;  
					  end             
					else
						begin 
							state<=0;
						end
				end    
			endcase 
     end 
	  
always @(posedge  CLOCK_1khz  )
    begin
      key_flag_dly <= key_flag;
		key_flag_dly1 <= key_flag_dly;
		key_flag_dly2 <= key_flag_dly1;
		key_flag_dly3 <= key_flag_dly2;
		key_flag_dly4 <= key_flag_dly3;
	 end	 
 assign LCD_EN = !key_flag & key_flag_dly4 ; 

always @(posedge  CLOCK_50  )
    begin
      key_flag_dly6 <= key_flag;
	 end	 
assign key_down = !key_flag & key_flag_dly6 ;
 
always @(CLOCK_1khz or col_reg or row_reg or ex_reg)
	begin
		if(key_flag==1'b1) 
			  begin
				 case ({col_reg,row_reg,ex_reg})
				  10'b1110_110_000:key_value<=0;  //1
				  10'b1110_101_000:key_value<=1;  //2
				  10'b1110_011_000:key_value<=2;  //3 
//				  8'b1110_0111:key_value<=3;
				  10'b1101_110_000:key_value<=4;  //4
				  10'b1101_101_000:key_value<=5;  //5
				  10'b1101_011_000:key_value<=6;  //6
//				  8'b1101_0111:key_value<=7; 
				  10'b1011_110_000:key_value<=8;   //7
				  10'b1011_101_000:key_value<=9;   //8
 				  10'b1011_011_000:key_value<=10;   //9 
//				  8'b1011_0111:key_value<=11;
				  10'b0111_110_000:key_value<=12;   //*
				  10'b0111_101_000:key_value<=13;  //0
				  10'b0111_011_000:key_value<=14;  //=
				  
				  10'b0000_000_001:key_value<=3; //+
				  10'b0000_000_010:key_value<=7; //-
				  10'b0000_000_100:key_value<=11; //x
				  10'b0000_000_011:key_value<=15; ///
				  
//				  8'b0111_0111:key_value<=15;     
				 endcase 
		  end   
	end  

	


endmodule
