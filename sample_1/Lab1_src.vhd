

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Practica1 is 
    Port (  clk : in std_logic;
            reset : in std_logic;
            segmentos : out std_Logic_vector(6 downto 0);
            selector : out std_logic_vector(3 downto 0));
end Practica1;

architecture Behavioral of Practica1 is
        constant max_contador_int   : integer := 125000000;
        signal contador_int         : integer range 0 to max_contador_int-1;
        
        constant max_contador_int4   : integer := 4000;
        signal contador_int4         : integer range 0 to max_contador_int-1;
        signal enable4 : std_logic;
        signal contador_selector : unsigned(1 downto 0);
        
        signal enable_s : std_logic;
        signal enable_ds : std_logic;
        signal enable_m : std_logic;
        signal enable_dm : std_logic;
        
        signal contador_s : unsigned(3 downto 0);
        signal contador_ds : unsigned(3 downto 0);
        signal contador_m : unsigned(3 downto 0);
        signal contador_dm : unsigned(3 downto 0);
        
        signal segundos : std_logic_vector(3 downto 0);
        signal minutos : std_logic_vector(3 downto 0);
        signal dec_segundos : std_logic_vector(3 downto 0);
        signal dec_minutos : std_logic_vector(3 downto 0);
        
        signal bcd_in : std_logic_vector(3 downto 0);
begin
    --Divisor de frecuencias.
     process(clk,reset)
             begin
                if (reset = '1') then
                    contador_int <= 0;
                elsif (clk'event and clk = '1') then
                    if (contador_int < max_contador_int) then
                        contador_int <= contador_int + 1;
                    else
                        contador_int <= 0;
                    end if;
                end if;
            end process;
        
        enable_s <= '1' when (contador_int = max_contador_int-1) else '0';

--Contador de segundos.
    process(clk,reset)
    begin
        if(reset='1')then
            contador_s <= (others => '0');
        elsif (clk'event and clk = '1') then
            if(enable_s = '1') then
                if(contador_s  = 9) then
                    contador_s <= (others => '0') ;
                else
                    contador_s <= contador_s + 1;
                end if;
            end if;
        end if;
    end process;
enable_ds <= '1' when contador_s=9 and enable_s='1' else '0';
                
--Contador de decenas de segundos.
process(clk,reset)
    begin
        if(reset='1')then
            contador_ds <= "0000";
        elsif (clk'event and clk = '1') then
            if(enable_ds = '1') then
                if(contador_ds  = 5) then
                    contador_ds <= "0000";
                else
                    contador_ds <= contador_ds + 1;
                end if;
            end if;
        end if;
    end process;
enable_m <= '1' when contador_ds=5 and enable_ds='1' else '0';

--Contador de minutos.
process(clk,reset)
    begin
        if(reset='1')then
            contador_m <= "0000";
        elsif (clk'event and clk = '1') then
            if(enable_m = '1') then
                if(contador_m  = 9) then
                    contador_m <= "0000";
                else
                    contador_m <= contador_m + 1;
                end if;
            end if;
        end if;
    end process;
enable_dm <= '1' when contador_m=9 and enable_m='1' else '0';
--Contador de decenas de minutos.
process(clk,reset)
    begin
        if(reset='1')then
            contador_dm <= "0000";
        elsif (clk'event and clk = '1') then
            if(enable_dm = '1') then
                if(contador_dm  = 5) then
                    contador_dm <= "0000";
                else
                    contador_dm <= contador_dm + 1;
                end if;
            end if;
        end if;
    end process;

segundos <= std_logic_vector(contador_s);
dec_segundos <= std_logic_vector(contador_ds);
minutos <= std_logic_vector(contador_m);
dec_minutos <= std_logic_vector(contador_dm);

--Divisor de frecuencia 4khz.
process(clk,reset)
             begin
                if (reset = '1') then
                    contador_int4 <= 0;
                elsif (clk'event and clk = '1') then
                    if (contador_int4 < max_contador_int4) then
                        contador_int4 <= contador_int4 + 1;
                    else
                        contador_int4 <= 0;
                    end if;
                end if;
            end process;
        
        enable4 <= '1' when (contador_int4 = max_contador_int4-1) else '0';
        
--Contador de 4 ciclos.
      process(clk,reset)
    begin
        if(reset='1')then
            contador_selector <= (others => '0');
        elsif (clk'event and clk = '1') then
            if(enable4 = '1') then
                if(contador_selector  = 3) then
                    contador_selector <= (others => '0') ;
                else
                    contador_selector <= contador_selector + 1;
                end if;
            end if;
        end if;
    end process;

--Multiplexor
with contador_selector select
    bcd_in <=  segundos when "00",
               dec_segundos when "01",
               minutos when "10",
               dec_minutos when "11",
               "-" when others;
--Decodificador bcd.
    with bcd_in select
        segmentos <=    "0000001" when "0000", -- 0
                        "1001111" when "0001", -- 1
                        "0010010" when "0010", -- 2
                        "0000110" when "0011", -- 3
                        "1001100" when "0100", -- 4
                        "0100100" when "0101", -- 5
                        "0100000" when "0110", -- 6
                        "0001111" when "0111", -- 7
                        "0000000" when "1000", -- 8
                        "0000100" when "1001", -- 9
                        "-------" when others;
                        
--Selector

with contador_selector select
    selector <=     "0001" when "00",
                    "0010" when "01",
                    "0100" when "10",
                    "1000" when "11",
                    "----" when others;

end Behavioral;
