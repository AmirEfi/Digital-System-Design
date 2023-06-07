LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY TEA_tb IS 
END TEA_tb;

ARCHITECTURE test1 OF TEA_tb IS
  COMPONENT TEA IS
    PORT(
    	clk, start: IN  std_logic;
    	key       : IN  unsigned(127 DOWNTO 0);
    	plain     : IN  unsigned(63 DOWNTO 0);
    	cipher    : OUT unsigned(63 DOWNTO 0);
    	done      : OUT std_logic
    );
  END COMPONENT;

  SIGNAL t_clk    : std_logic := '0';
  SIGNAL t_start  : std_logic := '0';
  SIGNAL t_key    : unsigned (127 DOWNTO 0);
  SIGNAL t_plain  : unsigned(63 DOWNTO 0);
  SIGNAL t_cipher : unsigned(63 DOWNTO 0);
  SIGNAL t_done   : std_logic;
  
BEGIN
  t_clk <= NOT t_clk AFTER 5 ns;
  t_start <= '1' AFTER 60 ns;
  
  PROCESS 
  BEGIN
	t_key <= x"00000001000000090000000400000006";
	WAIT FOR 30 ns;
	t_plain <= x"0000000300000005";
	WAIT FOR 30 ns;
  END PROCESS;
	UUT: TEA PORT MAP( t_clk, t_start, t_key, t_plain, t_cipher, t_done);
END test1;