library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity usertop is

	port(

		CLOCK_50: in STD_LOGIC;
		CLK_500Hz: in STD_LOGIC;
		RKEY: in STD_LOGIC_VECTOR(3 downto 0);
		KEY: in STD_LOGIC_VECTOR(3 downto 0);
		RSW: in STD_LOGIC_VECTOR(17 downto 0);
		SW    : in STD_LOGIC_VECTOR(17 downto 0);
		LEDR : out STD_LOGIC_VECTOR(17 downto 0);
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7: out std_logic_vector(6 downto 0)
	 );
end usertop;

architecture Structural of usertop is

  -- 3 bits signals
	signal inA, inC, inE: std_logic_vector(2 downto 0);
  signal inA0, inA1, inC0, inC1: std_logic_vector(2 downto 0);
  -- 2 bits signals
  signal inB, inD, inF: std_logic_vector(1 downto 0);
  -- 1 bit signal
  signal inG: std_logic;
  -- singal rerouting inner signals
	signal aux0, aux1, aux2, aux3, aux4: std_logic_vector(2 downto 0);
  signal aux5: std_logic;
  signal outResult: std_logic_vector(5 downto 0);
  -- signal for hexadecimal display
  signal hexDisplay: std_logic_vector(3 downto 0);

  component full_adder is
    port(
      A: in std_logic;
      B: in std_logic;
      Cin: in std_logic;
      S: out std_logic;
      Cout: out std_logic
    );
  end component;

  component adder_223_1111 is
    port(
      in_0, in_1: in std_logic_vector(2 downto 0);
      in_2: std_logic;
      out_0: out std_logic_vector(3 downto 0)
    );
  end component;

	component decod7seg is
		port(
			c : in  std_logic_vector(3 downto 0);
			f : out std_logic_vector(6 downto 0)
		);
	end component;

  begin

		inA <= SW(15 downto 13);
		inB <= SW(12 downto 11);
		inC <= SW(10 downto 8);
		inD <= SW(7 downto 6);
    inE <= SW(5 downto 3);
    inF <= SW(2 downto 1);
    inG <= SW(0);

    inA0(0) <= inB(0) and inA(0);
    inA0(1) <= inB(0) and inA(1);
    inA0(2) <= inB(0) and inA(2);
    inA1(0) <= inB(1) and inA(0);
    inA1(1) <= inB(1) and inA(1);
    inA1(2) <= inB(1) and inA(2);
    inC0(0) <= inD(0) and inC(0);
    inC0(1) <= inD(0) and inC(1);
    inC0(2) <= inD(0) and inC(2);
    inC1(0) <= inD(1) and inC(0);
    inC1(1) <= inD(1) and inC(1);
    inC1(2) <= inD(1) and inC(2);

		U0: full_adder port map(  inA0(0),
                              inC0(0),
                              inG,
                              outResult(0), aux0(1)
		);
    U1: full_adder port map(  inA1(0),
                              inA0(1),
                              inC0(1),
                              aux0(0), aux1(1)
    );
    U2: full_adder port map(  inA1(1),
                              inA0(2),
                              inC0(2),
                              aux1(0),aux2(1)
    );
    U3: full_adder port map(  inA1(2),
                              inC1(2),
                              inE(2),
                              aux2(0),aux3(2)
    );
    U4: full_adder port map(  inC1(0),
                              inE(0),
                              inF(0),
                              aux0(2),aux5
    );
    U5: full_adder port map(  inC1(1),
                              inE(1),
                              inF(1),
                              aux1(2),aux2(2)
    );
    -- level 2
    U6: full_adder port map(aux0(0), aux0(1), aux0(2),
                              outResult(1),aux4(0)
    );
    U7: full_adder port map(aux1(0), aux1(1), aux1(2),
                              aux3(0),aux4(1)
    );
    U8: full_adder port map(aux2(0), aux2(1), aux2(2),
                              aux3(1),aux4(2)
    );
    -- level 3
    U9: adder_223_1111 port map(aux3, aux4, aux5,
                              outResult(5 downto 2)
    );
    --send to hexa display
		U10: decod7seg port map(	c => outResult(3 downto 0),
														f => HEX0
		);

    hexDisplay <= "00" & outResult(5 downto 4);

		U11: decod7seg port map(	c => hexDisplay,
														f => HEX1
		);

    LEDR <= "000000000000" & outResult;
end Structural;
