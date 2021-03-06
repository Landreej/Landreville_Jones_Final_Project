// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus II License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Generated by Quartus II 64-Bit Version 15.0 (Build Build 145 04/22/2015)
// Created on Wed Dec 02 17:05:58 2015

ps2_keyboard ps2_keyboard_inst
(
	.clk(clk_sig) ,	// input  clk_sig
	.ps2_clk(ps2_clk_sig) ,	// input  ps2_clk_sig
	.ps2_data(ps2_data_sig) ,	// input  ps2_data_sig
	.ps2_code_new(ps2_code_new_sig) ,	// output  ps2_code_new_sig
	.ps2_code(ps2_code_sig) 	// output [7:0] ps2_code_sig
);

defparam ps2_keyboard_inst.clk_freq = 50000000;
defparam ps2_keyboard_inst.debounce_counter_size = 8;
