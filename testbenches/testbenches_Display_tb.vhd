-- rxnfri11group3
-- Display_tb.vhd
-- Testbench to test functionality of display components in 
-- ENEL373 Reaction Timer project.
--  Fixed the AN comparisons as the anode is active low NOT active high.
--
--  Allowed up to 8 clock cycles as this module use to need 8 to cycle across
--  the WHOLE 8 digits when displaying text next to the counter.
--
-- Fixed the C comparisons as the cathods are active low NOT active high.
--
-- Modified by Matthew Johnson 08 May 2020
-- Aurthor: C.P. Moore
-- 28 April 2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- needed for arithmetic

entity Display_tb is
end entity;

architecture behavioral of Display_tb is
component Display_Wrapper is
  port (CLK     : in STD_LOGIC;
        Message : in STD_LOGIC_VECTOR (15 downto 0);
        CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC;
                                 -- Segment cathodes
        AN 	    : out STD_LOGIC_VECTOR ( 3 downto 0));
end component;
  
-- Inputs:
signal CLK_sim : STD_LOGIC := '0';
signal Message_sim : STD_LOGIC_VECTOR (15 downto 0);
 
-- Outputs:
signal C_sim : STD_LOGIC_VECTOR (1 to 7); -- note big-endian vector to match CA..CG arrangement of cathodes. 
signal AN_sim : STD_LOGIC_VECTOR (3 downto 0);

constant CLK_period : time := 10 ns;
  
begin
  -- Unit under test:
  UUT: Display_Wrapper port map (CLK => CLK_sim, Message => Message_sim, CA => C_sim(1), CB => C_sim(2), CC => C_sim(3), CD => C_sim(4), CE => C_sim(5), CF => C_sim(6), CG => C_sim(7), AN => AN_sim);
    

    CLK_sim <= not(CLK_sim) after CLK_period /2;
    
  stimulus_process: process is
  
  variable ctr : integer range 0 to 9 := 0; -- loop counter
  
  begin
    wait for 100 ns;
    Message_sim <= X"4321";
    wait for 8 * CLK_period;
    
    -- Check that AN0 is selected:
    ctr := 0;
    while (AN_sim /= "1110") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 9) report "AN(0) is never selected." severity failure;
    end loop;
    
    -- Check that 1 is displayed on cahtodes:
    assert (C_sim = "1001111") report "1 not displayed correctly." severity failure;

    -- Check that AN1 is selected:
    ctr := 0;
    while (AN_sim /= "1101") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 9) report "AN(1) is never selected." severity failure;
    end loop; 
    
    -- Check that 2 is displayed on cathodes:
    assert (C_sim = "0010010") report "2 not displayed correctly." severity failure ;

    -- Check that AN2 is selected:
    ctr := 0;
    while (AN_sim /= "1011") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 9) report "AN(2) is never selected." severity failure;
    end loop; 
    
    -- Check that 3 is displayed on cathodes:
    assert (C_sim = "0000110") report "3 not displayed correctly." severity failure ;
       
    -- Check that AN3 is selected:
    ctr := 0;
    while (AN_sim /= "0111") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 9) report "AN(3) is never selected." severity failure;
    end loop; 
    
    -- Check that 4 is displayed on cathodes:
    assert (C_sim = "1001100") report "4 not displayed correctly." severity failure;

    Message_sim <= X"8765";
    -- Wait for AN0 to be selected:
    ctr := 0;
    while (AN_sim /= "1110") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 5 is displayed on cathodes:
    assert (C_sim = "0100100") report "5 not displayed correctly." severity failure;

    -- Wait for AN1 to be selected:
    ctr := 0;
    while (AN_sim /= "1101") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 6 is displayed on cathodes:
    assert (C_sim = "0100000") report "6 not displayed correctly." severity failure;

    -- Wait for AN2 to be selected:
    ctr := 0;
    while (AN_sim /= "1011") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 7 is displayed on cathodes:
    assert (C_sim = "0001111") report "7 not displayed correctly." severity failure;

    -- Wait for AN3 to be selected:
    ctr := 0;
    while (AN_sim /= "0111") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 8 is displayed on cathodes:
    assert (C_sim = "0000000") report "8 not displayed correctly." severity failure; 

    Message_sim <= X"9090";
    -- Wait for AN0 to be selected:
    ctr := 0;
    while (AN_sim /= "1110") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 0 is displayed on cathodes:
    assert (C_sim = "0000001") report "0 not displayed correctly." severity failure; 

    -- Wait for AN1 to be selected:
    ctr := 0;
    while (AN_sim /= "1101") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 9 is displayed on cathodes:
    assert (C_sim = "0000100") report "9 not displayed correctly." severity failure; 
    
    
    report "Completed all tests correcly!" severity note;
    end process;
end architecture;
    