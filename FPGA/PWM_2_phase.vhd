
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

ENTITY PWM_2_phase is
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
END PWM_2_phase;

ARCHITECTURE RTL OF PWM_2_phase is
CONSTANT trig_count_1		: integer := 2**(num_bits-1);

signal counter_0: UNSIGNED(num_bits-1 downto 0);
signal counter_1: UNSIGNED(num_bits-1 downto 0);

signal state : integer range 0 to 1;
begin

count_proc: process(CLK_IN,reset_n)
begin
    if(reset_n = '0') then
        counter_0 <= (others => '0');
        
    elsif rising_edge(CLK_IN) then
        if (EN = '1') then
            counter_0 <= counter_0 + 1;
        else
            counter_0 <= counter_0; 
        end if;
    end if;
end process count_proc;

count_start: process(CLK_IN,reset_n)
BEGIN
    if(reset_n = '0') then
        state <= 0;
        counter_1 <= (others => '0');
    elsif rising_edge(CLK_IN) then
        case state is
            when 0 =>
                if counter_0 < trig_count_1 then
                    counter_1 <= (others => '0');
                    state <= 0;
                else
                    state <= 1;
                end if;

            when 1 => 
                if (EN = '1') then
                    counter_1 <= counter_1 + 1;
                else
                    counter_1 <= counter_1; 
                end if;
        end case;
    end if; 
end process count_start;

PWM_gen: process(CLK_IN,reset_n)
begin
    if(reset_n = '0') then
        PWM_OUT_0 <= '0';
        PWM_OUT_1 <= '0';
    
    elsif rising_edge(CLK_IN) then
        if (EN = '1') then
            if (counter_0 < unsigned(DUTY_CYCLE)) then
                PWM_OUT_0 <= '1';    
            else
                PWM_OUT_0 <= '0';
            end if;

            if (counter_1 < unsigned(DUTY_CYCLE)) and state = 1 then
                PWM_OUT_1 <= '1';
            else
                PWM_OUT_1 <= '0';
            end if;
        else
            PWM_OUT_0 <= '0';
            PWM_OUT_1 <= '0';
        end if;
    end if;
end process PWM_gen;

END RTL;

