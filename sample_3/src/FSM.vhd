
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
 Port (
		clk: in std_logic;
		reset : in std_logic;
		A : in std_logic;
		B : in std_logic;
		led : out std_logic);
end FSM;

architecture Behavioral of FSM is

	type STATE is (S_RESET,S_A,S_B,S_AA,S_BB,S_AB,S_AAB,S_ABB,S_AABB);
	signal S_STATE : STATE;


begin

	process(clk,reset)
	begin

	if(reset = '1') then
		S_STATE <= S_RESET;
	elsif(clk'event and clk = '1') then
		case S_STATE is
			when S_RESET =>
				if(A = '1') then
					S_STATE <= S_A;
				elsif(B = '1') then
					S_STATE <= S_B;
				end if;
			when S_A =>
				if(A = '1') then
					S_STATE <= S_AA;
				elsif(B = '1') then
					S_STATE <= S_AB;
				end if;
			when S_B =>
				if(A = '1') then
					S_STATE <= S_AB;
				elsif(B = '1') then
					S_STATE <= S_BB;
				end if;
			when S_AA =>
				if(A = '1') then
					S_STATE <= S_AA;
				elsif(B = '1') then
					S_STATE <= S_AAB;
				end if;
			when S_BB =>
				if(A = '1') then
					S_STATE <= S_ABB;
				elsif(B = '1') then
					S_STATE <= S_BB;
				end if;
			when S_AB =>
				if(A = '1') then
					S_STATE <= S_AAB;
				elsif(B = '1') then
					S_STATE <= S_ABB;
				end if;
			when S_AAB =>
				if(A = '1') then
					S_STATE <= S_AAB;
				elsif(B = '1') then
					S_STATE <= S_AABB;
				end if;
			when S_ABB =>
				if(A = '1') then
					S_STATE <= S_AABB;
				elsif(B = '1') then
					S_STATE <= S_ABB;
				end if;
			when S_AABB =>
		end case;
	end if;
	end process;

	led <= '1' when(S_STATE = S_AABB) else '0';

end Behavioral;
