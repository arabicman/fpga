module	LCD_Controller (iCLK,iRST_N,key_in,W_en,result,LCD_DATA,LCD_RW,LCD_EN,LCD_RS);
//	Host Side
input			iCLK,iRST_N,W_en;
input [3:0]key_in;
input [15:0]result;   
//	LCD Side
output	[7:0]	LCD_DATA;
output			LCD_RW,LCD_EN,LCD_RS;
//	Internal Wires/Registers
reg	[5:0]	Init_Count,wirte_Count;
reg	[8:0]	Init_DATA,Wirte_DATA,Key_DATA;

reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg			mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg			mLCD_RS;

reg [1:0] wirte_state ;
wire		mLCD_Done;

parameter	LCD_INTIAL	=	0;
parameter	LCD_LINE1	=	5;
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	Init_SIZE	=	LCD_LINE2+9;
parameter   Wirte_SIZE = 7 ;

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		Init_Count	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
	  case ( wirte_state )
	0: begin 
		if(Init_Count<Init_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	Init_DATA[7:0];
					mLCD_RS		<=	Init_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					Init_Count	<=	Init_Count+1;
					mLCD_ST	<=	0;
				end
			endcase
		end
		else wirte_state <= 1;
		end 
		
	1: begin 
	   if (W_en == 1)
		  	begin
			if( key_in == 14 )
		     wirte_state <= 2;
			else    
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	Key_DATA[7:0];
					mLCD_RS		<=	Key_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	0;
					end
				end
			endcase
		end
	 end
	
	2: begin 
		if(wirte_Count<Wirte_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	Wirte_DATA[7:0];
					mLCD_RS		<=	Wirte_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					wirte_Count	<=	wirte_Count+1;
					mLCD_ST	<=	0;
				end
			endcase
		end
		else begin wirte_state <= 1; wirte_Count <=0;end
		end 
	
	  endcase
	end
end

always
begin
	case(key_in)
	0 : Key_DATA	<=	9'h131; //1
	1 : Key_DATA	<=	9'h132; //2
	2 : Key_DATA	<=	9'h133; //3
	3 : Key_DATA	<=	9'h12b; //+
	4 : Key_DATA	<=	9'h134; //4
	5 : Key_DATA	<=	9'h135; //5
	6 : Key_DATA	<=	9'h136; //6
	7 : Key_DATA	<=	9'h12d; //-
	8 : Key_DATA	<=	9'h137; //7
	9 : Key_DATA	<=	9'h138; //8
	10 : Key_DATA	<=	9'h139; //9
	11 : Key_DATA	<=	9'h12a; //x
	12 : Key_DATA	<=	9'h001; //clear
	13 : Key_DATA	<=	9'h130; //0
	14 : Key_DATA	<=	9'h13d; //=
	15 : Key_DATA	<=	9'h12f; ///
	
	default:		Key_DATA	<=	9'h120;
	endcase
end
	
	
always
begin
	case(Init_Count)
	//	Initial
	LCD_INTIAL+0:	Init_DATA	<=	9'h038;
	LCD_INTIAL+1:	Init_DATA	<=	9'h00E;
	LCD_INTIAL+2:	Init_DATA	<=	9'h001; 
	LCD_INTIAL+3:	Init_DATA	<=	9'h006;
	LCD_INTIAL+4:	Init_DATA	<=	9'h080;
	//	Line 1
	LCD_LINE1+0:	Init_DATA	<=	9'h120;	
	LCD_LINE1+1:	Init_DATA	<=	9'h120;	
	LCD_LINE1+2:	Init_DATA	<=	9'h120;	
	LCD_LINE1+3:	Init_DATA	<=	9'h143;//C
	LCD_LINE1+4:	Init_DATA	<=	9'h161;//a
	LCD_LINE1+5:	Init_DATA	<=	9'h16C;//l
	LCD_LINE1+6:	Init_DATA	<=	9'h163;//c
	LCD_LINE1+7:	Init_DATA	<=	9'h175;//u
	LCD_LINE1+8:	Init_DATA	<=	9'h16C;//l
	LCD_LINE1+9:	Init_DATA	<=	9'h161;//a
	LCD_LINE1+10:	Init_DATA	<=	9'h174;//t
	LCD_LINE1+11:	Init_DATA	<=	9'h16f;//o
	LCD_LINE1+12:	Init_DATA	<=	9'h172;//r
	LCD_LINE1+13:	Init_DATA	<=	9'h120;
	LCD_LINE1+14:	Init_DATA	<=	9'h120;
	LCD_LINE1+15:	Init_DATA	<=	9'h120;
	//	Change Line
	LCD_CH_LINE:	Init_DATA	<=	9'h0C0;
	//	Line 2
	LCD_LINE2+0:	Init_DATA	<=	9'h120;	
	LCD_LINE2+1:	Init_DATA	<=	9'h120;	
	LCD_LINE2+2:	Init_DATA	<=	9'h120;
//	LCD_LINE2+3:	Init_DATA	<=	9'h162;//b
//	LCD_LINE2+4:	Init_DATA	<=	9'h179;//y
//	LCD_LINE2+5:	Init_DATA	<=	9'h120;
//	LCD_LINE2+6:	Init_DATA	<=	9'h168;//h
//	LCD_LINE2+7:	Init_DATA	<=	9'h161;//a
//	LCD_LINE2+8:	Init_DATA	<=	9'h16f;//o
	LCD_LINE2+3:	Init_DATA	<=	9'h120;

	default:		Init_DATA	<=	9'h120;
	endcase
end

always
begin
  if ( result [15:12] !=0 )
    begin 
    case(wirte_Count)
      0:  Wirte_DATA	<=	9'h0CC;
	   1:  Wirte_DATA	<=	9'h0CC;
	   2:  Wirte_DATA	<=	9'h0CC;	
		3:  Wirte_DATA	<=	9'h130 + result [15:12]; 
		4:  Wirte_DATA	<=	9'h130 + result [11:8]; 
		5:  Wirte_DATA	<=	9'h130 + result [7:4]; 
		6:  Wirte_DATA	<=	9'h130 + result [3:0]; 
	 endcase 
	 end
  else if ( result [11:8] != 0 )
    begin 
    case(wirte_Count)
      0:  Wirte_DATA	<=	9'h0CD; 
	   1:  Wirte_DATA	<=	9'h0CD;
	   2:  Wirte_DATA	<=	9'h0CD;	
		3:  Wirte_DATA	<=	9'h130 + result [11:8]; 
		4:  Wirte_DATA	<=	9'h130 + result [7:4]; 
		5:  Wirte_DATA	<=	9'h130 + result [3:0];
	   6:  ;	
	 endcase 
	 end
	else if ( result [7:4] != 0 )
    begin 
    case(wirte_Count)
      0:  Wirte_DATA	<=	9'h0CE;
      1:  Wirte_DATA	<=	9'h0CE; 
      2:  Wirte_DATA	<=	9'h0CE;		
		3:  Wirte_DATA	<=	9'h130 + result [7:4]; 
		4:  Wirte_DATA	<=	9'h130 + result [3:0];
	   5:  ;
	   6:  ;	
	 endcase 
	 end 
	else 
    begin 
    case(wirte_Count)
      0:  Wirte_DATA	<=	9'h0CF;
      1:  Wirte_DATA	<=	9'h0CF;		
		2:  Wirte_DATA	<=	9'h130 + result [3:0];
	   3:  ;
	   4:  ;
	   5:  ;	
	 endcase 
	 end
end 
LCD_Core 		u0	(	//	Host Side
							.iDATA(mLCD_DATA),
							.iRS(mLCD_RS),
							.iStart(mLCD_Start),
							.oDone(mLCD_Done),
							.iCLK(iCLK),
							.iRST_N(iRST_N),
							//	LCD Interface
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS)	);




endmodule
