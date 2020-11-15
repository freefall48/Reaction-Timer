-- rxnfri11group3
-- countdown_tb.vhd
-- Test bench for initial countdown.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity countdown_tb is
--  Port ( );
end countdown_tb;

architecture Behavioral of countdown_tb is

constant Clk_Period : time := 10 ns;

component countdown is
    Port ( clk : in STD_LOGIC;
           reset : in std_logic;
           trigger : out std_logic;
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal clk, trigger : std_logic := '0';
signal reset : std_logic := '0';
signal an : std_logic_vector(3 downto 0);

begin

-- Generate the clock signal
clk <= not clk after Clk_Period / 2;

UUT: countdown port map (clk=>clk, reset=>reset, trigger=>trigger, an=>an);

process
begin
    wait for 100 ns;
    reset <= '0';
    wait for clk_period;
    -- Bring the countdown out of reset.
    reset <= '1';
    assert (an = "1111") report "Countdown was not reset." severity failure;
    wait for clk_period;
    assert (an = "1000") report "Not displaying 3 dots." severity failure;
    wait for clk_period;
    assert (an = "1100") report "Not displaying 2 dots." severity failure;
    wait for clk_period;
    assert (an = "1110") report "Not displaying 1 dot." severity failure;
    wait for clk_period;
    assert (an = "1111") report "Not all dots are off." severity failure;
    assert (trigger = '1') report "The trigger signal not set at countdown completion." severity failure;
    
    -- Unit correctly counted down.
    report "All tests passed!" severity note;
end process;


end Behavioral;
