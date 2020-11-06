`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:32:35 11/05/2020 
// Design Name: 
// Module Name:    analog_capture 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module analog_capture(
	// System clock:
	input gCLK_50MHz,
	
	// Pre-Amplifier and Analog to Digital Converter ports:
	output reg  SPI_MOSI,	// FPGA -> AD
	output reg	AMP_CS,		// FPGA -> AMP
	output reg  SPI_SCK,		// FPGA -> AMP/ADC
	output reg	AMP_SHDN,	// FPGA -> AMP
	input			AMP_DOUT,	// FPGA <- DOUT
	output reg	AD_CONV,		// FPGA -> ADC
	input 		SPI_MISO,	// FPGA <- ADC
	
	output reg [13:0]	audio_channel
);

	// State declaration:
	localparam IDLE = 0;
	localparam SETTING_AMP = 1;
	localparam READING_ADC = 2;
	
	// Pre-Amplifier's gain value:
	localparam A_GAIN = 4'b0001;
	localparam B_GAIN = 4'b0000;
	
	// System clock for SPI:
	wire clk_10MHz;
	wire clk_50MHz;
	reg en_sck_10M;
	
	// Registers for FSM SPI:
	reg [1:0] FSM_state = 0;
	
	// Inner regs and counters:
	reg [5:0] cnt_delay = 0;
	reg [7:0] gain_values;
	
	
	// Register for samples from ADC:
	reg [33:0] audio_samples;

	always@(posedge clk_10MHz) begin
		case(FSM_state)
	
			IDLE: begin
				SPI_MOSI <= 1'bz;
				AMP_CS	<= 1'b1;
				AMP_SHDN	<= 1'b1;
				AD_CONV	<= 1'b0;
				
				en_sck_10M <= 1'b0;
			
				gain_values[7:4] <= B_GAIN;
				gain_values[3:0] <= A_GAIN;
			
				FSM_state <= SETTING_AMP;
			end
		
			SETTING_AMP: begin
				cnt_delay <= cnt_delay + 6'b1;
			
				AMP_CS 	<= 1'b0;
				AMP_SHDN <= 1'b0;
			
				if (cnt_delay >= 1 && cnt_delay <= 8) begin
					en_sck_10M <= 1'b1;
				
					SPI_MOSI 			<= gain_values[7];
					gain_values[7:1] 	<= gain_values[6:0];
				end
				else if (cnt_delay == 9) begin
					en_sck_10M 	<= 1'b0;
					SPI_MOSI 	<= 1'bz;
				end
				else if (cnt_delay == 10) begin
					cnt_delay 	<= 0;
					AMP_CS 		<= 1'b1;
					FSM_state 	<= READING_ADC;
				end
			end
			
			READING_ADC: begin
				AD_CONV 		<= 1'b1;
				cnt_delay 	<= cnt_delay + 4'b1;
				
				if (cnt_delay >= 1 && cnt_delay <= 35) begin
					AD_CONV 		<= 1'b0;
					en_sck_10M 	<= 1'b1;
					
					audio_samples[0] 		<= SPI_MISO;
					audio_samples[33:1] 	<= audio_samples[32:0];
				end
				else if (cnt_delay == 36) begin
					AD_CONV		<= 1'b1;
					en_sck_10M 	<= 1'b0;
					cnt_delay 	<= 0;
					
					audio_channel[13:0] <= audio_samples[31:17];
					
					FSM_state <= READING_ADC;
				end
			end
		
		endcase
	end
	
	always@(posedge clk_50MHz) begin
		if (en_sck_10M)
			SPI_SCK <= clk_10MHz;
		else
			SPI_SCK <= 1'b0;
	end
	 
	 // Instantiate the module
	Divider_to_10MHz instance_name (
		.CLKIN_IN(gCLK_50MHz), 
		.RST_IN(1'b0), 
		.CLKFX_OUT(clk_10MHz), 
		.CLKIN_IBUFG_OUT(clk_50MHz)
    );
			
endmodule
