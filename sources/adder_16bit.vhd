-- rxnfri11group3
-- adder_16bit.vhd
-- 16 bit adder.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity adder_16bit is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           Sum : out STD_LOGIC_VECTOR (15 downto 0));
end adder_16bit;

architecture DFlow of adder_16bit is

signal raw_sum : std_logic_vector (16 downto 0);

begin

    raw_sum <= ('0' & A) + b;
    sum <= raw_sum(15 downto 0);

end DFlow;
