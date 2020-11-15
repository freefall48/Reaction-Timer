-- rxnfri11group3
-- Display_Wrapper.vhd
-- Top-level file for use with the testbench in 
-- Display_tb.vhd.
-- 
-- Aurthor: C.P. Moore
-- Used by: Matt Johnson, Reto Schori, Max Young
-- 28 April 2020

library IEEE;
use IEEE.std_logic_1164.all;

entity Display_Wrapper is
  port (CLK     : in STD_LOGIC; -- This should be your 'display' clock, the clock that is used to switch between anodes
        Message : in STD_LOGIC_VECTOR (15 downto 0);
        CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC; -- Segment cathodes
        AN 		: out STD_LOGIC_VECTOR ( 3 downto 0));
end entity;

-- Do not change anything above this line.
-- Edit the architecture below to match your project files.

architecture structural of Display_Wrapper is
    -- Convert the bcd 4-bit vector into a 7 segement vector
    component BCD_to_7SEG is
		   Port ( bcd_in: in std_logic_vector (3 downto 0);	  -- Input BCD vector
    			leds_out: out	std_logic_vector (1 to 7));   -- Output 7-Seg vector 
    end component;
    
    component multiplex_display is
    Port ( 
        clk : in std_logic;
        an : out std_logic_vector (3 downto 0);
        ones, tens, hundreds, thousands : in std_logic_vector (1 to 7);
        c : out std_logic_vector (1 to 7)
        );
    end component;
    
    signal ones, tens, hundreds, thousands : std_logic_vector (1 to 7);
  
  begin
    -- Convert the BCD value for each digit into a 7 segment display vector
    ones_bcd: BCD_to_7SEG port map (bcd_in=>Message(3 downto 0), leds_out=>ones);
    tens_bcd: BCD_to_7SEG port map (bcd_in=>Message(7 downto 4), leds_out=>tens);
    hund_bcd: BCD_to_7SEG port map (bcd_in=>Message(11 downto 8), leds_out=> hundreds);
    thou_bcd: BCD_to_7SEG port map (bcd_in=>Message(15 downto 12), leds_out=>thousands);
    
    multiplex : multiplex_display port map (clk=>clk, an=>an, 
                                            c(1)=>CA, c(2)=>CB, c(3)=>CC, c(4)=>CD, c(5)=>CE, c(6)=>CF, c(7)=>CG, 
                                            ones=>ones, tens=>tens, hundreds=>hundreds, thousands=>thousands);
end structural;  