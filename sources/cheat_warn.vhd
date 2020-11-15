-- rxnfri11group3
-- cheat_warn.vhd
-- Allows blinking of 
-- Leds if caught cheating.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cheat_warn is
    Port ( cheat : in STD_LOGIC;
           clk : STD_LOGIC;
           red1, red2 : out STD_LOGIC);
end cheat_warn;

architecture DFlow of cheat_warn is

begin
    -- Alternate the blinking of the two red LEDs
    red1 <= clk and cheat;
    red2 <= (not clk) and cheat;

end DFlow;
