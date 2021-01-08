library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



ENTITY PWM_2_phase_tb is
END PWM_2_phase_tb;

ARCHITECTURE RTL OF PWM_2_phase_tb is

constant c_CLOCK_PERIOD : time := 100  ns;

signal CLK_IN   : STD_LOGIC := '0';
signal reset_n  : STD_LOGIC := '0';
signal EN       : STD_LOGIC := '0';
signal DUTY_CYCLE : STD_LOGIC_VECTOR(11 downto 0) := x"400";
signal PWM_OUT_0  : STD_LOGIC := '0';
signal PWM_OUT_1  : STD_LOGIC := '0';

COMPONENT PWM_2_phase 
    generic(
        num_bits : INTEGER := 12
    );
    port(
        CLK_IN  : IN STD_LOGIC;
        reset_n   : IN STD_LOGIC;
        EN     : IN STD_LOGIC;
        DUTY_CYCLE: IN STD_LOGIC_VECTOR(num_bits-1 downto 0);
        PWM_OUT_0: OUT STD_LOGIC;
        PWM_OUT_1: OUT STD_LOGIC
        );
END COMPONENT PWM_2_phase;

BEGIN

DUT: PWM_2_phase
    generic map(num_bits => 12)
    port map(
        CLK_IN      => CLK_IN,
        reset_n     => reset_n,
        EN          => EN,
        DUTY_CYCLE  => DUTY_CYCLE,
        PWM_OUT_0   => PWM_OUT_0,
        PWM_OUT_1   => PWM_OUT_1
    );


p_CLK_GEN : process is
    begin
        wait for c_CLOCK_PERIOD/2;
        CLK_IN <= not CLK_IN;
end process p_CLK_GEN; 

process                               -- main testing
begin
    wait for 10*c_CLOCK_PERIOD;
    reset_n <= '1';
    wait for 2 sec;
end process;

process                               -- main testing
begin
    EN <= '0';
    wait for 30*c_CLOCK_PERIOD;
    EN <= '1';
    wait for 100 ms;
end process;

END RTL;