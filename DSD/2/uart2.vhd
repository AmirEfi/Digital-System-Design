LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY uart2 IS

	GENERIC (
		N : integer := 8
	);
	PORT(
		rst   : IN  std_logic;
		clk   : IN  std_logic;
		baud  : IN std_logic_vector(N-1 DOWNTO 0);
		io    : INOUT std_logic;
      
		-- Parallel 2 Serial
		start : IN  std_logic;
		din   : IN  std_logic_vector(N-1 DOWNTO 0);
		tx    : OUT std_logic;		

		-- Serial 2 Parallel
		rx   : IN  std_logic;			
		dout : OUT std_logic_vector(N-1 DOWNTO 0);
		done : OUT std_logic
	);
END uart2;

ARCHITECTURE test OF uart2 IS

  TYPE snd_state IS (idles, sz, sb0, sb1, sb2, sb3, sb4, sb5, sb6, sb7, sb8, sb9, sb10);
  TYPE rcv_state IS (idler, rb0, rb1, rb2, rb3, rb4, rb5, rb6, rb7, rb8, final);
  SIGNAL snd_cur, snd_nxt : snd_state;
  SIGNAL rcv_cur, rcv_nxt : rcv_state;
  SIGNAL counter : integer := 0;
  SIGNAL tmp_dout : std_logic;
  SIGNAL parity : std_logic;

BEGIN

  SEQ: PROCESS (rst, clk)
  BEGIN
    IF rst = '1' THEN
      counter <= 0;
      rcv_cur <= idler;
      snd_cur <= idles;
    ELSIF clk'EVENT AND clk = '1' THEN
      IF (counter = (to_integer(unsigned(baud)) - 1) ) THEN
	  rcv_cur <= rcv_nxt;
          snd_cur <= snd_nxt;
	  counter <= 0;
      ELSE
	  counter <= counter + 1;
      END IF; 
    END IF;
  END PROCESS SEQ;

  SND: PROCESS (snd_cur, start, din)
  BEGIN
    CASE snd_cur IS
      WHEN idles => 
        tx <= '1';
        IF start = '1' THEN 
          snd_nxt <= sz;
        ELSE
          snd_nxt <= idles;
        END IF;
      WHEN sz     =>   snd_nxt <= sb0;   tx <= '0';
      WHEN sb0    =>   snd_nxt <= sb1;   tx <= din(0);
      WHEN sb1    =>   snd_nxt <= sb2;   tx <= din(1);
      WHEN sb2    =>   snd_nxt <= sb3;   tx <= din(2);
      WHEN sb3    =>   snd_nxt <= sb4;   tx <= din(3);
      WHEN sb4    =>   snd_nxt <= sb5;   tx <= din(4);
      WHEN sb5    =>   snd_nxt <= sb6;   tx <= din(5);
      WHEN sb6    =>   snd_nxt <= sb7;   tx <= din(6);
      WHEN sb7    =>   snd_nxt <= sb8;   tx <= din(7);
      WHEN sb8    =>   snd_nxt <= sb9;   tx <= (din(0) XOR din(1) XOR din(2) XOR din(3) XOR din(4) XOR din(5) XOR din(6) XOR din(7));
      WHEN sb9    =>   snd_nxt <= sb10;  tx <= 'Z';
      WHEN OTHERS =>   IF (io = '1') THEN
			   snd_nxt <= idles;
		       ELSIF (io = '0') THEN
			   snd_nxt <= sz;
		       END IF;
    END CASE;
  END PROCESS SND;

  RCV: PROCESS (rcv_cur, rx)
  BEGIN
    done <= '0';
    CASE rcv_cur IS
      WHEN idler => 
        IF rx = '0' THEN 
          rcv_nxt <= rb0;
        END IF;
      WHEN rb0 =>     rcv_nxt <= rb1;   dout(0) <= rx; tmp_dout <= rx; 
      WHEN rb1 =>     rcv_nxt <= rb2;   dout(1) <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN rb2 =>     rcv_nxt <= rb3;   dout(2) <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN rb3 =>     rcv_nxt <= rb4;   dout(3) <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN rb4 =>     rcv_nxt <= rb5;   dout(4) <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN rb5 =>     rcv_nxt <= rb6;   dout(5) <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN rb6 =>     rcv_nxt <= rb7;   dout(6) <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN rb7 =>     rcv_nxt <= rb8;   dout(7) <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN rb8 =>     rcv_nxt <= final; parity  <= rx; tmp_dout <= tmp_dout XOR rx;
      WHEN OTHERS =>  rcv_nxt <= idler; 
					IF (parity = tmp_dout) THEN
					    io <= '1';
					    done <= '1';
					ELSE
					    io <= '0';
					END IF;
    END CASE;
  END PROCESS RCV;

END test;
	