--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:01:28 11/05/2020
-- Design Name:   
-- Module Name:   D:/Program/xilinx/ise14.4/14.4/ISE_DS/Projects/Vega_vad/tb_spi.vhd
-- Project Name:  Vega_vad
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: analog_capture
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_spi IS
END tb_spi;
 
ARCHITECTURE behavior OF tb_spi IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT analog_capture
    PORT(
         gCLK_50MHz : IN  std_logic;
         SPI_MOSI : OUT  std_logic;
         AMP_CS : OUT  std_logic;
         SPI_SCK : OUT  std_logic;
         AMP_SHDN : OUT  std_logic;
         AMP_DOUT : IN  std_logic;
         AD_CONV : OUT  std_logic;
         SPI_MISO : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal gCLK_50MHz : std_logic := '0';
   signal AMP_DOUT : std_logic := '0';
   signal SPI_MISO : std_logic := '0';

 	--Outputs
   signal SPI_MOSI : std_logic;
   signal AMP_CS : std_logic;
   signal SPI_SCK : std_logic;
   signal AMP_SHDN : std_logic;
   signal AD_CONV : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant gCLK_50MHz_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: analog_capture PORT MAP (
          gCLK_50MHz => gCLK_50MHz,
          SPI_MOSI => SPI_MOSI,
          AMP_CS => AMP_CS,
          SPI_SCK => SPI_SCK,
          AMP_SHDN => AMP_SHDN,
          AMP_DOUT => AMP_DOUT,
          AD_CONV => AD_CONV,
          SPI_MISO => SPI_MISO
        );

   -- Clock process definitions
   gCLK_50MHz_process :process
   begin
		gCLK_50MHz <= '0';
		wait for gCLK_50MHz_period/2;
		gCLK_50MHz <= '1';
		wait for gCLK_50MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for gCLK_50MHz_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
