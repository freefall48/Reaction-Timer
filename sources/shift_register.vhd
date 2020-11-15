-- rxnfri11group3
-- shift_register.vhd
-- SHift register
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC; -- Reset active low
           LOAD : in STD_LOGIC;
           D : in STD_LOGIC;
           P : in STD_LOGIC_VECTOR (7 downto 0);
           Q : out STD_LOGIC_VECTOR (7 downto 0));
end shift_register;

architecture Behavioral of shift_register is

signal register_buf : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

    process (CLK, RESET, LOAD)
    begin
        if (RESET = '0') then -- Async reset
            register_buf <= "00000000";
        elsif (LOAD = '1') then -- Async load
            register_buf <= P;
        elsif (CLK'event and CLK = '1') then
            register_buf <= D & register_buf(7 downto 1);
        end if;
    end process;
    
    Q <= register_buf;
 
end Behavioral;
