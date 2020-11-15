-- rxnfri11group3
-- reaction_timer.vhd
-- Top level file for the reaction timer
-- 
-- Matt Johnson, Reto Schori, Max Young
-- 20 May 2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reaction_timer is
  Port (
        CLK100MHZ: in STD_LOGIC;
        AN : out STD_LOGIC_VECTOR(7 downto 0);
        DP : out STD_LOGIC;
        BTNC : in std_logic;
        LED16_R : out std_logic;
        LED17_R : out std_logic;
        CA ,CB, CC, CD, CE, CF, CG : out std_logic
        );
end reaction_timer;

architecture Structual of reaction_timer is
-- Clock divider
component clock_divider is
	generic(
		INPUT_FREQUENCY  : integer;
		OUTPUT_FREQUENCY : integer
	);
	port(
		in_clock  : in std_logic;
		enable    : in std_logic;
		out_clock : out std_logic
	);
end component;
-- Countdown module
component countdown is
    Port ( CLK : in STD_LOGIC;
           reset : in std_logic;
           trigger : out std_logic;
           AN : out STD_LOGIC_VECTOR (3 downto 0));
end component;
-- Edge detector for button pushes
component edge_detect is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           btn_edge : out STD_LOGIC);
end component;
-- Flash the RED leds to display cheating
component cheat_warn is
    Port ( cheat : in STD_LOGIC;
           clk : STD_LOGIC;
           red1, red2 : out STD_LOGIC);
end component;
-- Counter
component clk_counter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in std_logic;
           ones, tens, hundreds, thousands : out STD_LOGIC_VECTOR(3 downto 0));
end component;
-- Wrapper for the display of numbers
component Display_Wrapper is
  port (CLK     : in STD_LOGIC; -- This should be your 'display' clock, the clock that is used to switch between anodes
        Message : in STD_LOGIC_VECTOR (15 downto 0);
        CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC; -- Segment cathodes
        AN 		: out STD_LOGIC_VECTOR ( 3 downto 0));
end component;
-- State machine
component state_machine is
  Port ( 
        -- Signals to hardware
        DP  : out   std_logic := '1';
        CLK : in    std_logic;
        -- Debounced and edge detected button
        BTN : in    std_logic;
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
end component;
-- Mux
component mux4to1 is
    Port ( s_line : in STD_LOGIC_VECTOR (1 downto 0);
           a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           c : in STD_LOGIC_VECTOR (7 downto 0);
           d : in STD_LOGIC_VECTOR (7 downto 0);
           o_line : out STD_LOGIC_VECTOR (7 downto 0));
end component;

-- Clock Signals
signal clk_ms : std_logic;          -- Milliseconds clock divider
signal clk_s : std_logic;           -- Seconds clock divider
signal clk_s_enable : std_logic;    -- Seconds clock enabled, enable high

-- Countdown signals
signal countdown_anode : std_logic_vector(3 downto 0);  -- Display anodes when countdown module active
signal countdown_reset : std_logic;                     -- Countdown reset, reset low
signal countdown_trigger : std_logic;                   -- When the countdown has elasped goes high

-- Counter signals
signal timer_reset : std_logic;                                             -- Timer reset, reset low
signal ones, tens, hundreds, thousands : std_logic_vector (3 downto 0);     -- The value for each column to be displayed
signal timer_enable : std_logic;                                            -- Timer should be counting, enable high

-- Display wrapper signals
signal DISPLAY_C        : std_logic_vector(1 to 7);
signal DISPLAY_ANODE    : std_logic_vector(3 downto 0);

-- Button signals
signal BTNC_EDGE : std_logic;   -- Debounced and edge detected BTNC push

-- Cheating signals
signal CHEAT  : std_logic;  -- High when BTNC is pressed before the countdown elapses

-- Mux signals
signal ANODE_SELECT : std_logic_vector(1 downto 0);
signal CATHODE_SELECT : std_logic_vector(1 downto 0);
signal float : std_logic; -- The cathode only uses 7 of the 8 bits so the final bit needs a 
                          -- signal to assign to.

begin
    -- Clock that runs at a frequency of 1000 HZ.
    clk_div_1000hz: clock_divider   generic map (INPUT_FREQUENCY=> 100000000, OUTPUT_FREQUENCY=> 1000)
                            port map (in_clock=>CLK100MHZ, out_clock=>clk_ms, enable=>'1');
                            
    -- Clock that runs at a frequency of 1 HZ.
    clk_div_1hz: clock_divider   generic map (INPUT_FREQUENCY=> 100000000, OUTPUT_FREQUENCY=> 1)
                            port map (in_clock=>CLK100MHZ, out_clock=>clk_s, enable=>clk_s_enable);
    
    -- Prompt the user when to push the button
    countdown_seq: countdown port map (clk=>clk_s, reset=>countdown_reset, trigger=>countdown_trigger, an=>countdown_anode);
    
    -- Debounce and detect the rising edge of button pushes
    btnc_event : edge_detect port map (clk=>clk_ms, btn=>BTNC, btn_edge=>btnc_edge);
    
    -- Flash the red leds when cheating is detected
    warning : cheat_warn port map (clk=>clk_s, cheat=>cheat, red1=>LED16_R, red2=>LED17_R); 
    
    -- Count the ms taken for the user to push the button
    counter : clk_counter port map (clk=>clk_ms, reset=>timer_reset, enable=>timer_enable, ones=>ones, tens=>tens, 
                                    hundreds=>hundreds, thousands=>thousands);
    
    -- Display wrapper
    display: Display_Wrapper port map (clk=>clk_ms, message(15 downto 12)=> thousands, message(11 downto 8)=>hundreds,
                                       message(7 downto 4)=>tens, message(3 downto 0)=>ones, CA=>DISPLAY_C(1), CB=>DISPLAY_C(2),
                                       CC=>DISPLAY_C(3),CD=>DISPLAY_C(4),CE=>DISPLAY_C(5),CF=>DISPLAY_C(6),CG=>DISPLAY_C(7), AN=>DISPLAY_ANODE);
                                       
    anode_mux : mux4to1 port map (s_line=>ANODE_SELECT, b(3 downto 0)=>countdown_anode, b(7 downto 4)=>x"F",
                                    c(3 downto 0)=>display_anode, c(7 downto 4)=>x"F", a=>x"FF", d=>x"00", o_line=>AN);
                                    
    cathode_mux : mux4to1 port map(s_line=>cathode_select, a=>x"FF", b(6 downto 0)=>display_c, b(7)=>'1', c=>x"00", d=>x"00", o_line(7)=>float,
                                    o_line(6)=>CA,o_line(5)=>CB,o_line(4)=>CC,o_line(3)=>CD,o_line(2)=>CE,o_line(1)=>CF,o_line(0)=>CG);
        
    
    -- Connections to the state machine that controls the state of the program
    fsm : state_machine port map (dp=>DP,btn=>btnc_edge, clk=>clk_ms, COUNTDOWN_R_SET=>countdown_reset, COUNTDOWN_TRIGG=>countdown_trigger,
                                    COUNT_R_SET=>timer_reset, COUNT_EN=>timer_enable, clk_en=>clk_s_enable, cheat=>cheat, 
                                    ANODE_SELECT=>anode_select, CATHODE_SELECT=>cathode_select);

end Structual;
