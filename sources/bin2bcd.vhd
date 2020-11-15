-- rxnfri11group3
-- Credit to user1155120 https://stackoverflow.com/questions/39548841/16bit-to-bcd-conversion/39551228#39551228
-- Modified to fit our design
-- bin2bcd.vhd
-- Extracts digits of timer
-- 
-- Used by Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bin2bcd is
    Port ( count : in STD_LOGIC_VECTOR (15 downto 0);
           ones, tens, hundreds, thousands : out STD_LOGIC_VECTOR (3 downto 0));
end bin2bcd;

architecture Behavioral of bin2bcd is

begin

    process (count)
        variable bcd:   std_logic_vector (15 downto 0);
        variable bint:  std_logic_vector (13 downto 0);
    begin
        bcd := (others => '0');
        bint := count (13 downto 0);

        for i in 0 to 13 loop
            bcd(15 downto 1) := bcd(14 downto 0);
            bcd(0) := bint(13);
            bint(13 downto 1) := bint(12 downto 0);
            bint(0) := '0';

            if i < 13 and bcd(3 downto 0) > "0100" then
                bcd(3 downto 0) := 
                    std_logic_vector (unsigned(bcd(3 downto 0)) + 3);
            end if;
            if i < 13 and bcd(7 downto 4) > "0100" then
                bcd(7 downto 4) := 
                    std_logic_vector(unsigned(bcd(7 downto 4)) + 3);
            end if;
            if i < 13 and bcd(11 downto 8) > "0100" then
                bcd(11 downto 8) := 
                    std_logic_vector(unsigned(bcd(11 downto 8)) + 3);
            end if;
            if i < 13 and bcd(15 downto 12) > "0100" then
                bcd(11 downto 8) := 
                    std_logic_vector(unsigned(bcd(15 downto 12)) + 3);
            end if;
        end loop;
                      
        -- We need to use these digits for the timer              
        thousands <= bcd(15 downto 12);
        hundreds <= bcd(11 downto 8);
        tens <= bcd(7 downto 4);
        ones <= bcd(3 downto 0);
    end process;
    

end Behavioral;
