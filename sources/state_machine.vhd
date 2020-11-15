-- rxnfri11group3
-- state_machine.vhd
-- State machine for going through
-- project processes.
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_machine is
  Port ( 
        -- Signals to hardware
        DP  : out   std_logic := '1';
        BTN : in    std_logic;
        CLK : in    std_logic;
        -- Countdown signals
        COUNTDOWN_R_SET   : out   std_logic;
        COUNTDOWN_TRIGG   : in    std_logic;
        -- Mux
        ANODE_SELECT : out std_logic_vector(1 downto 0);
        CATHODE_SELECT : out std_logic_vector(1 downto 0);
        -- Counter signals
        COUNT_R_SET : out   std_logic;
        COUNT_EN    : out   std_logic;
        -- Clock divider signals
        CLK_EN  : out   std_logic;
        -- Cheat signals
        CHEAT   : out   std_logic
        );
end state_machine;

architecture Behavioral of state_machine is

-- FSM type and signals
type State_t is (RESET, COUNTDOWN, TIMING, DISPLAY, CHEATING);
signal state : State_t;

begin

    state_machine : process (clk) begin
        if rising_edge(clk) then
            -- Default assignments for output signals. States need to explictly
            -- change the assignments.
            DP <= '1';                  -- Disable the decimal points
            ANODE_SELECT <= "00";        -- Disable all digits
            COUNTDOWN_R_SET <= '0';     -- Hold the countdown in reset
            COUNT_R_SET <= '0';         -- Hold the timer in reset
            COUNT_EN <= '0';            -- Hold timer in not enabled
            CATHODE_SELECT <= "00";     -- Disable the display segments
            CLK_EN <= '0';              -- Disable the seconds clock
            CHEAT <= '0';               -- Disable the cheat signal
            
            -- States of the FSM used to control the components interactions
            case State is
                when RESET => -- Reset state
                    -- Hold everything in reset for 1 cycle and move on unconditionally
                    state <= COUNTDOWN;
                    
                when COUNTDOWN => -- Countdown state
                    COUNTDOWN_R_SET <= '1';   -- Bring the countdown out of reset
                    CLK_EN <= '1';  -- Enable the 1Hz clock
                    DP <= '0';      -- Enable the decimal points
                    ANODE_SELECT <= "01";
                    
                    if COUNTDOWN_TRIGG = '1' then     -- If the countdown sets trigger high move to the next state
                        state <= TIMING;
                    elsif btn = '1' then    -- If the button is pushed before trigger goto CHEAT state
                        state <= CHEATING;
                    end if;
 
                when TIMING => -- Timing state
                    COUNT_R_SET <= '1';   -- Bring the timer out of reset
                    COUNT_EN <= '1';   -- Enable the timer
                    ANODE_SELECT <= "10";
                    CATHODE_SELECT <= "01";
                    
                    if btn = '1' then       -- BTN pressed so stop timing
                        state <= DISPLAY;
                    end if;
                    
                when DISPLAY => -- Display the time taken to press the button
                    COUNT_R_SET <= '1'; -- Keep the timer out of reset while we process the value
                    ANODE_SELECT <= "10";
                    CATHODE_SELECT <= "01";
                    
                    if BTN = '1' then
                        state <= RESET;
                    end if;
                    
                when CHEATING => -- Detected some cheating going on here
                    CLK_EN <= '1';
                    CHEAT <= '1';
                    
                    if BTN = '1' then
                        state <= RESET;
                    end if;    
            end case;
        end if;
    end process;


end Behavioral;
