-- rxnfri11group3
-- 16bit_clk_counter.vhd
-- 16 bit counter
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_counter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in std_logic;
           ones, tens, hundreds, thousands : out STD_LOGIC_VECTOR(3 downto 0));
end clk_counter;

architecture Behavioral of clk_counter is

constant COUNT_LIMIT : STD_LOGIC_VECTOR(15 downto 0) := X"270F"; -- The maximum value that we can display on the screen

component adder_16bit is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           Sum : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component bin2bcd is
    Port ( count : in STD_LOGIC_VECTOR (15 downto 0);
           ones, tens, hundreds, thousands : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal sum_a, sum_b, total : std_logic_vector (15 downto 0);

begin
    
    adder : adder_16bit port map (A=>sum_a, B=>sum_b, sum=>total);
    bcd:    bin2bcd port map (count=>total, ones=>ones, tens=>tens, hundreds=>hundreds, thousands=>thousands);
    
    process (clk, reset)
    begin
        if reset = '0' then
            sum_a <= (others => '0');
            sum_b <= (others => '0');
        elsif rising_edge(clk) then
            sum_a <= total;
            if total = count_limit or enable = '0' then
                sum_b <= (others => '0');
            else
                sum_b <= (0 => '1', others => '0');
            end if;
        end if;
    end process;


end Behavioral;
