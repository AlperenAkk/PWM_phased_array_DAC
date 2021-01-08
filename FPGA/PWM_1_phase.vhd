
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

ENTITY PWM_1_phase is
    generic(
        num_bits : INTEGER := 12
    );
    port(
        CLK_IN  : IN STD_LOGIC;
        reset_n   : IN STD_LOGIC;
        EN     : IN STD_LOGIC;
        DUTY_CYCLE: IN STD_LOGIC_VECTOR(num_bits-1 downto 0);
        PWM_OUT: OUT STD_LOGIC
        );
END PWM_1_phase;

ARCHITECTURE RTL OF PWM_1_phase is

signal counter: UNSIGNED(num_bits-1 downto 0);

begin

count_proc: process(CLK_IN,reset_n)
begin
    if(reset_n = '0') then
        counter <= (others => '0');
    
    elsif rising_edge(CLK_IN) then
        if (EN = '1') then
            counter <= counter + 1;
        else
            counter <= counter; 
        end if;
    end if;
end process count_proc;

PWM_gen: process(CLK_IN,reset_n)
begin
    if(reset_n = '0') then
        PWM_OUT <= '0';
    
    elsif rising_edge(CLK_IN) then
        if (EN = '1') then
            if (counter < unsigned(DUTY_CYCLE)) then
                PWM_OUT <= '1';    
            else
                PWM_OUT <= '0';
            end if;
        else
            PWM_out <= '0';
        end if;
    end if;
end process PWM_gen;

END RTL;

