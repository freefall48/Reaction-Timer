-- rxnfri11group3
-- coutdown.vhd
-- Handles count down of
-- decimal points.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity countdown is
    Port ( clk : in STD_LOGIC;
           reset : in std_logic;
           trigger : out std_logic;
           an : out STD_LOGIC_VECTOR (3 downto 0));
end countdown;

architecture Behavioral of countdown is

type countdown_state is (Off, ThreeDots, TwoDots, OneDot, Complete);
signal state, next_state : countdown_state;

-- The design of the state machine means that the dots will turn off on the rising edge
-- of the clock.
begin
    state_change: process (clk, reset)
    begin
        if reset = '0' then
            state <= Off;
        elsif clk'event and clk = '1' then
            state <= next_state;
        end if;
    end process;
    
    state_logic : process (state)
    begin      
             -- FSM that drives the decimal point countdown
             -- Default assignments
            an <= (others => '1');
            trigger <= '0';
            case state is
                when Off =>
                    next_state <= ThreeDots;
                when ThreeDots =>
                    an <= "1000";
                    next_state <= TwoDots;
                when TwoDots =>
                    an <= "1100";
                    next_state <= OneDot;
                when OneDot =>
                    an <= "1110";
                    next_state <= Complete;
                when Complete =>
                    -- The countdown has completed, trigger the 
                    -- trigger signal as the last LED goes out
                    trigger <= '1'; 
            end case;
    end process;

end Behavioral;
