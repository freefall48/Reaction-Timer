-- rxnfri11group3
-- multiplex_display.vhd
-- Allows timer to be displayed
-- onto the 7-seg display.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplex_display is
  Port ( 
    clk : in std_logic;
    an : out std_logic_vector (3 downto 0);
    ones, tens, hundreds, thousands : in std_logic_vector (1 to 7);
    c : out std_logic_vector (1 to 7)
  );
end multiplex_display;

architecture Behavioral of multiplex_display is

-- Used to multiplex through the digits on the display
component shift_register is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC; -- Reset active low
           LOAD : in STD_LOGIC;
           D : in STD_LOGIC;
           P : in STD_LOGIC_VECTOR (7 downto 0);
           Q : out STD_LOGIC_VECTOR (7 downto 0));
end component;

-- Constants
constant bcd_seg_zero : std_logic_vector (1 to 7) := "0000001"; -- 0 in 7 segs

signal multiplexer_in : std_logic;
signal multiplexer_out : std_logic_vector (7 downto 0);

begin
    -- Shift register used to multiplex across the 8 segment display
    multiplexer : shift_register port map (clk=>clk, reset=>'1', load=>'0', d=>multiplexer_in, P=>(others => '0'), Q=>multiplexer_out);
    
    process (multiplexer_out)
    begin
        -- Default assignments for the shift register input
        multiplexer_in <= '0';
        an <= (others => '1');
        c <= (others => '1');
        
        -- Multiplexes through the 8 segments of the display by following a 1 through a shift register.
        -- If all digits are zero above the current digit (excl. ones) and the current digit is zero
        -- then do not display it.
        case multiplexer_out is
            when "00000000" => -- Put a 1 in the MSB of the shifty
                multiplexer_in <= '1';
            when "00000001" => -- Display the ones digit
                c <= ones;
                an <= "1110";
            when "00000010" => -- Display the tens digit
                c <= tens;
                -- Check if the digits to the right and this digit are zero, then do not display this digit
                if tens = bcd_seg_zero AND hundreds = bcd_seg_zero AND thousands = bcd_seg_zero then
                    AN <= "1111";
                else
                    AN <= "1101";
                end if;
            when "00000100" => -- Display the hundreds digit.
               c <= hundreds;
                -- Check if the digits to the right and this digit are zero, then do not display this digit
                if hundreds = bcd_seg_zero AND thousands = bcd_seg_zero then
                    AN <= "1111";
                else
                    AN <= "1011";
                end if;
            when "00001000" => -- Display the thousands digit
                c <= thousands;
                -- Check if the digits to the right and this digit are zero, then do not display this digit
                if thousands = bcd_seg_zero then
                    AN <= "1111";
                else
                    AN <= "0111";
                end if;
            when others => -- Unused now. Used to display text next to the counter.
        end case;
    end process;


end Behavioral;
