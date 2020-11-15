-- rxnfri11group3
-- edge_detect.vhd
-- Only output high when rising
-- edge of button is detected.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detect is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           btn_edge : out STD_LOGIC);
end edge_detect;

architecture Behavioral of edge_detect is

signal btn_shift : std_logic_vector (1 downto 0);
signal btn_debounced : std_logic;

begin
    -- Use a shift register to keep track of the state of the button and only
    -- output high when a rising edge is detected.
    process (clk)
        begin
            if rising_edge(clk) then
                btn_shift <= btn_shift(0) & btn_debounced;
                if btn_shift = "01" then
                    btn_edge <= '1';
                else
                    btn_edge <= '0';
                end if;
            end if;
    end process;
    -- Debounce the input button signal
    btn_debounced <= btn after 50 ns;


end Behavioral;


