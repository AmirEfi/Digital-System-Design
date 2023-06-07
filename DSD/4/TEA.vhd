LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY TEA IS
  PORT (
    clk, start: IN  std_logic;
    key       : IN  unsigned(127 DOWNTO 0);
    plain     : IN  unsigned(63 DOWNTO 0);
    cipher    : OUT unsigned(63 DOWNTO 0);
    done      : OUT std_logic
    );
END TEA;

ARCHITECTURE tea1 OF TEA IS
  SIGNAL counter : integer               := 0;
  SIGNAL delta   : unsigned(31 DOWNTO 0) := x"9E3779B9";
  SIGNAL v0      : unsigned(31 DOWNTO 0) := x"00000000";
  SIGNAL v1      : unsigned(31 DOWNTO 0) := x"00000000";
  SIGNAL k0      : unsigned(31 DOWNTO 0) := x"00000000";
  SIGNAL k1      : unsigned(31 DOWNTO 0) := x"00000000";
  SIGNAL k2      : unsigned(31 DOWNTO 0) := x"00000000";
  SIGNAL k3      : unsigned(31 DOWNTO 0) := x"00000000";
  SIGNAL sum     : unsigned(31 DOWNTO 0) := x"00000000";
  
BEGIN
    PROCESS(clk, start)
	VARIABLE tmp1    : unsigned(31 DOWNTO 0);
	VARIABLE tmp2    : unsigned(31 DOWNTO 0);
	VARIABLE tmp3_v0 : unsigned(31 DOWNTO 0);
	VARIABLE tmp_sum : unsigned(31 DOWNTO 0);
    BEGIN
      IF (counter = 0 AND start = '0') THEN
	v1 <= plain(31 DOWNTO 0);
	v0 <= plain(63 DOWNTO 32);
	k0 <= key(127 DOWNTO 96);
	k1 <= key(95 DOWNTO 64);
	k2 <= key(63 DOWNTO 32);
	k3 <= key(31 DOWNTO 0);
	done <= '0';
	cipher <= x"0000000000000000";
      ELSIF(counter < 32 AND start = '1' AND clk = '1') THEN
	tmp_sum := sum + delta;
	sum <= tmp_sum;
	tmp1 := ((SHIFT_LEFT(v1,4)) + k0) XOR (v1 + tmp_sum) XOR ((SHIFT_RIGHT(v1,5)) + k1);
	tmp3_v0 := v0 + tmp1;
	v0 <= tmp3_v0;
	tmp2 := ((SHIFT_LEFT(tmp3_v0,4)) + k2) XOR (tmp3_v0 + tmp_sum) XOR ((SHIFT_RIGHT(tmp3_v0,5)) + k3);
	v1 <= v1 + tmp2;
        counter <= counter + 1;
      ELSIF (counter = 32) THEN
	done <= '1'; 
      	cipher <= v0 & v1;
      END IF;
    END PROCESS;
END tea1;