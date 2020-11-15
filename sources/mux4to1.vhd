-- rxnfri11group3
-- mux4to1.vhd
-- Multiplexer
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4to1 is
    Port ( s_line : in STD_LOGIC_VECTOR (1 downto 0);
           a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           c : in STD_LOGIC_VECTOR (7 downto 0);
           d : in STD_LOGIC_VECTOR (7 downto 0);
           o_line : out STD_LOGIC_VECTOR (7 downto 0));
end mux4to1;

architecture DFlow of mux4to1 is

begin

with s_line select 
    o_line <=   a when "00",
                b when "01",
                c when "10",
                d when "11";

end DFlow;
