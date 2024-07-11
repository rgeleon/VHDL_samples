
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity locker is
Port (	clk : in std_logic;
		reset : in std_logic;
		Boton_A : in std_logic;
		Boton_B : in std_logic;
		Led : out std_logic );
end locker;

architecture structural of locker is

	signal a,b : std_logic;

begin

	Antirebotes_A : entity work.Antirrebotes
	port map (
		clk => clk,
		reset => reset,
		boton => Boton_A,
		filtrado => a);
	Antirebotes_B : entity work.Antirrebotes
	port map (
		clk => clk,
		reset => reset,
		boton => Boton_B,
		filtrado => b);
		
	FSM_I : entity work.FSM
	port map(
		clk => clk,
		reset => reset,
		A => a,
		B => b,
		led => Led);
		 

end structural;
