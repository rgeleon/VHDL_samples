
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rider is
 Port (
        clk     :   in std_logic;
        reset   :   in std_logic;
        start   :   in std_logic;
        leds    :   out std_logic_vector(7 downto 0));
end rider;

architecture Behavioral of rider is
--Declaración variables set del start.
    signal set_start    :   std_logic;
--Declaración de señales para divisor de frecuencia.
    constant max_contador_int   : integer := 8929;	-- Aproximación para la simulación. 
													-- Valor exacto es 8.928.571
    signal contador_int         : integer range 0 to max_contador_int-1;
    signal enable_cuenta : std_logic;
--Declaración salida y sentido del registro de desplazamiento.
    signal ledsin     :   std_logic_vector(7 downto 0);
    signal sentido    :   std_logic;


begin
--Set del start.
    process(reset,clk)
        begin
        if (reset ='1') then
            set_start<='0';
        elsif(clk'event and clk = '1') then
                if(start = '1') then
                    set_start <= '1';
                end if;
            end if;
            
        end process;
--Divisor de frecuencia.
    process(clk,reset) 
    begin  
    if(reset = '1') then
        contador_int <= 0;
    elsif (clk'event and clk = '1') then
 
            if (contador_int < max_contador_int) then
                contador_int <= contador_int + 1;
            else
                contador_int <= 0;
            end if;
    end if;
    end process;
        
enable_cuenta <= '1' when (contador_int = max_contador_int-1) else '0';

--Contador de desplazamiento.
process(clk,reset)
    begin
    if(reset = '1') then
        ledsin <= "10000000";
        sentido <= '1'; 
    elsif(clk'event and clk = '1') then
        if(enable_cuenta = '1') then
            if(ledsin = "01000000")then
                sentido <= '1';
            elsif(ledsin = "00000010")then
                sentido <= '0';
            end if;
            
            if(sentido = '0') then
                ledsin(7 downto 0) <= ledsin(6 downto 0)&'0';
            elsif(sentido = '1') then
                ledsin(7 downto 0) <= '0'&ledsin(7 downto 1);
            end if;
        end if;
    end if;
end process;

leds <= ledsin;  

end Behavioral;
