// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.


// Generated by Quartus Prime Version 18.1 (Build Build 625 09/12/2018)
// Created on Fri Nov 15 20:35:34 2019

LCD_Core LCD_Core_inst
(
	.address(address_sig) ,	// input  address_sig
	.chipselect(chipselect_sig) ,	// input  chipselect_sig
	.read(read_sig) ,	// input  read_sig
	.write(write_sig) ,	// input  write_sig
	.writedata(writedata_sig) ,	// input [7:0] writedata_sig
	.readdata(readdata_sig) ,	// output [7:0] readdata_sig
	.waitrequest(waitrequest_sig) ,	// output  waitrequest_sig
	.clk(clk_sig) ,	// input  clk_sig
	.LCD_DATA(LCD_DATA_sig) ,	// inout [7:0] LCD_DATA_sig
	.LCD_ON(LCD_ON_sig) ,	// output  LCD_ON_sig
	.LCD_BLON(LCD_BLON_sig) ,	// output  LCD_BLON_sig
	.LCD_EN(LCD_EN_sig) ,	// output  LCD_EN_sig
	.LCD_RS(LCD_RS_sig) ,	// output  LCD_RS_sig
	.LCD_RW(LCD_RW_sig) ,	// output  LCD_RW_sig
	.reset(reset_sig) 	// input  reset_sig
);

