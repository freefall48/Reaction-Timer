-- rxnfri11group3
-- testbenches_Quad_4_bit_counter_tb.vhd
-- Test bench for 4 bit counter.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Quad_4_bit_counter_TB is
--  Port ( );
end Quad_4_bit_counter_TB;

architecture Behavioral of Quad_4_bit_counter_tb is

   component clk_counter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in std_logic;
           ones : out STD_LOGIC_VECTOR(3 downto 0);
           tens : out STD_LOGIC_VECTOR(3 downto 0);
           hundreds : out STD_LOGIC_VECTOR(3 downto 0);
           thousands : out STD_LOGIC_VECTOR(3 downto 0));
    end component;


   signal EN : STD_LOGIC := '0';
   signal R_SET : STD_LOGIC := '0';
   signal stage_1_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal stage_2_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal stage_3_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal stage_4_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal clk_in_ctr : STD_LOGIC := '0';
   signal overflow : STD_LOGIC := '0';
   -- signal ClockPeriod : TIME := 50 ns;

   constant ClockPeriod : Time := 1000 ns;

begin

   UUT: clk_counter
      port map( enable => EN, reset => R_SET, ones => stage_1_q_out, tens => stage_2_q_out, 
                  hundreds => stage_3_q_out, thousands => stage_4_q_out, 
                     clk => clk_in_ctr); 

   clk_process : process
   begin
      clk_in_ctr <= '0';
      wait for ClockPeriod / 2;
      clk_in_ctr <= '1';
      wait for ClockPeriod / 2;
   end process clk_process;

   io_process : process
   begin
     wait for 100 ns;
     R_SET <= '0';
     wait for ClockPeriod;
     EN <= '1';
     R_SET <= '1';
     
     -- Check 9 to 10 transition:
     wait for (ClockPeriod * 9);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"0") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "count 9 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"1") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "count 10 failed." severity failure;
     
     -- Check 99 to 100 transition:
     wait for (ClockPeriod * 89);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"9") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "count 99 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"0") and (stage_3_q_out = X"1") and (stage_4_q_out = X"0") report "count 100 failed." severity failure;
     
     -- Check 999 to 1000 transition:
     wait for (ClockPeriod * 899);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"9") and (stage_3_q_out = X"9") and (stage_4_q_out = X"0") report "count 999 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"0") and (stage_3_q_out = X"0") and (stage_4_q_out = X"1") report "count 1000 failed." severity failure;
     
     -- Our timer does not roll back around to 0000, once the maximum of 9999 is reached
     -- then the counter simply stops counting. Originally values of 9999 would of been 
     -- discarded and not used within calculations.
     -- Pushing BTNC twice simply resets the statemachine
     wait for (ClockPeriod * 8999);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"9") and (stage_3_q_out = X"9") and (stage_4_q_out = X"9") report "count 9999 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"9") and (stage_3_q_out = X"9") and (stage_4_q_out = X"9") report "count 9999 not held." severity failure;  
     
     report "Testbench completed successfully!" severity note;
  end process io_process;

end Behavioral;
