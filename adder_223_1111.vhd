library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity adder_223_1111 is
	port(
    in_0, in_1: in std_logic_vector(2 downto 0);
    in_2: std_logic;
    out_0: out std_logic_vector(3 downto 0)
	 );
end adder_223_1111;

architecture Structural of adder_223_1111 is

  signal aux1, aux2: std_logic;

  component full_adder is
    port(
      A: in std_logic;
      B: in std_logic;
      Cin: in std_logic;
      S: out std_logic;
      Cout: out std_logic
    );
  end component;

  begin
    -- level 1
    U0: full_adder port map(A => in_0(0) ,B => in_1(0) , Cin => in_2 , S => out_0(0) , Cout => aux1 );
    -- level 2
    U1: full_adder port map(A => in_0(1) ,B => in_1(1) , Cin => aux1 , S => out_0(1) , Cout => aux2 );
    -- level 3
    U2: full_adder port map(A => in_0(2) ,B => in_1(2) , Cin => aux2 , S => out_0(2) , Cout => out_0(3));

end Structural;
