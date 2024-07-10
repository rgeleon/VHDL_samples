library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity rider_tb is
end rider_tb;

architecture Behavioral of rider_tb is

--Declaración del DUT (design under test)
    component riderContdesp is 
            port (
                clk     :   in std_logic;
                reset   :   in std_logic;
                start   :   in std_logic;
                leds    :   out std_logic_vector(7 downto 0) 
                );
    end component;
    
--Declaración de señales necesarias para el testeo.              
    signal clk_tb  :   std_logic;
    constant clk_period : time := 8 ns;
    
    signal start_tb : std_logic;
    signal reset_tb : std_logic;
    
    signal leds_tb : std_logic_vector(7 downto 0);
    
begin
--Instanciación del circuito bajo análisis. CUT = Circuit Under Test  

CUT: riderContdesp port map(
        clk => clk_tb,
        start => start_tb,
        reset => reset_tb,
        leds => leds_tb);

-- Generación del reloj
clk_proc: process
    begin
        clk_tb <= '1';
        wait for clk_period/2;
        clk_tb <= '0';
        wait for clk_period/2;
    end process;
    
--Proceso general del test.
test: process
        begin
--            reset_tb <= '1'; --Estado de reset inicial.
--            start_tb <= '0';
--            wait for 1000ms;
--            reset_tb <= '0'; --Estado inicial.
--            start_tb <= '0';
--            wait for 1000ms;
--            reset_tb <= '0'; --Aprieto start.
--            start_tb <= '1';
--            wait for 1000ms;
--            reset_tb <= '0'; --Suelto start.
--            start_tb <= '0';
--            wait for 1000ms;
--            reset_tb <= '0'; --Aprieto start otra vez por error.
--            start_tb <= '1';
--            wait for 1000ms; 
--            reset_tb <= '0'; --Suelto start.
--            start_tb <= '0';
--            wait for 10000ms;
--            reset_tb <= '1'; --Aprieto reset.
--            start_tb <= '0';
--            wait for 1000ms; 
--            reset_tb <= '0'; --Suelto reset.
--            start_tb <= '0';
--            wait for 1000ms;
--            reset_tb <= '1'; --Nuevo apriete de reset accidental.
--            start_tb <= '0';
--            wait for 1000ms;
--            reset_tb <= '1'; --Aprieto start y reset a la vez.
--            start_tb <= '1';
--            wait for 1000ms;
--            reset_tb <= '0'; --Los suelto.
--            start_tb <= '0';
--            wait for 1000ms;
            -- reset_tb <= '0';
            --start_tb <= '0';
            --wait for 1000ms;
            --Se podrían poner más vainas copiando lo de arriba.
            reset_tb <= '1';
            start_tb <= '0';
            wait for 10000*clk_period;
            reset_tb <= '0';
            start_tb <= '0';
            wait for 10*clk_period;
            reset_tb <= '0';
            start_tb <= '1';
            wait for 10*clk_period;
            reset_tb <= '0';
            start_tb <= '0';
            wait;
end process;
end Behavioral;
