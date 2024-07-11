
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity antirrebotes is
 Port (	clk : in std_logic;
		reset : in std_logic;
		boton : in std_logic;
		filtrado : out std_logic );
end antirrebotes;

architecture Behavioral of antirrebotes is

	signal Q1,Q2,Q3,flanco,E,T : std_logic;
	type STATE is(S_NADA,S_BOTON);
	signal S_STATE : STATE;
	constant cont_max : integer := 125*10**3;
	signal cont : integer range 0 to cont_max-1;

begin

--Sincronizador y Detector de flanco

	process(clk,reset)
	begin
		if(reset = '1') then
			Q1 <= '0';
			Q2 <= '0';
			Q3 <= '0';
		elsif(clk'event and clk = '1') then
			if(boton = '1') then
				Q1 <= '1';
			else Q1 <= '0';
			end if;
			if(Q1 = '1') then
				Q2 <= '1';
			else Q2 <= '0';
			end if;
			if(Q2 = '1') then
				Q3 <= '1';
			else Q3 <= '0';
			end if;
		end if;
	end process;

	flanco <= '1' when(Q2 = '1' and Q3 = '0') else '0';

--Máquina de estados

	process(clk,reset)
	begin
		if(reset = '1') then
			S_STATE <= S_NADA;
		elsif(clk'event and clk = '1') then
			if(flanco = '1' and T = '0') then
				S_STATE <= S_BOTON;
			elsif(T = '1') then
				S_STATE <= S_NADA;
			end if;
		end if;
	end process;

	E <= '1' when(S_STATE = S_BOTON) else '0';
	filtrado <= '1' when(Q2 = '1' and T = '1') else '0';

--Temporizador

	process(clk,reset)
	begin
		if(reset = '1') then
			cont <= 0;
		elsif(clk'event and clk = '1') then
			if(E = '1') then
				if(cont < cont_max) then
					cont <= cont + 1;
				else cont <= 0;
				end if;
			end if;
		end if;
		end process;

	T <= '1' when(cont = cont_max-1) else '0';

end Behavioral;
