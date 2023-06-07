LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY uart2_tb IS 
	GENERIC (
		N : integer := 8
	);
END uart2_tb;
ARCHITECTURE test1 OF uart2_tb IS
  COMPONENT uart2 IS
	
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
        rx    : IN  std_logic;			
        dout  : OUT std_logic_vector(N-1 DOWNTO 0);
        done  : OUT std_logic
    );
  END COMPONENT;
  SIGNAL t_rst    : std_logic;
  SIGNAL t_clk    : std_logic := '0';
  SIGNAL t_start  : std_logic;
  SIGNAL t_din	  : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL t_tx     : std_logic;			
  SIGNAL t_rx     : std_logic;			
  SIGNAL t_dout	  : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL t_done   : std_logic;
  SIGNAL t_baud   : std_logic_vector (N-1 DOWNTO 0);	
  SIGNAL t_io     : std_logic;		
BEGIN
  t_clk <= NOT t_clk AFTER 5 ns;
  t_baud <= b"00000011";
  t_rst <= '1', '0' AFTER 30 ns;
  
  PROCESS 
  BEGIN
  t_start <= '0';
  t_din <= X"C3";
  t_rx <= '1';
  WAIT FOR 40 ns;
  t_start <= '1';
  WAIT FOR 50 ns;
  t_start <= '0';
  WAIT FOR 100 ns;
  t_rx <= '0';
  WAIT FOR 30 ns;
  t_rx <= '1';
  WAIT;
  END PROCESS;

  UART : uart2 PORT MAP(t_rst, t_clk, t_baud, t_io, t_start, t_din, t_tx, t_rx, t_dout, t_done);
END test1;
	
ARCHITECTURE test2 OF uart2_tb IS
  COMPONENT uart2 IS
	
    PORT(
        rst   : IN  std_logic;
        clk   : IN  std_logic;
	baud  : IN  std_logic_vector(N-1 DOWNTO 0);
	io    : INOUT std_logic;
        
        -- Parallel 2 Serial
	start : IN std_logic;
        din   : IN  std_logic_vector(N-1 DOWNTO 0);
        tx    : OUT std_logic;			

        -- Serial 2 Parallel
        rx    : IN  std_logic;			
        dout  : OUT std_logic_vector(N-1 DOWNTO 0);
        done  : OUT std_logic
    );
  END COMPONENT;
  SIGNAL t_rst    : std_logic;
  SIGNAL t_clk    : std_logic := '0';
  SIGNAL t_start0 : std_logic;
  SIGNAL t_din0	  : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL x01      : std_logic;			
  SIGNAL x10      : std_logic;			
  SIGNAL t_dout0  : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL t_done0  : std_logic;			
  SIGNAL t_start1 : std_logic;
  SIGNAL t_din1	  : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL t_dout1  : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL t_done1  : std_logic;
  SIGNAL t_baud1  : std_logic_vector (N-1 DOWNTO 0);
  SIGNAL t_io0    : std_logic;
  SIGNAL t_io1    : std_logic;				
BEGIN
  t_clk <= NOT t_clk AFTER 5 ns;
  t_baud1 <= b"00000011";
  t_rst <= '1', '0' AFTER 30 ns;  
  PROCESS 
  BEGIN
  t_start0 <= '0';
  t_start1 <= '0';
  t_din0 <= X"C3";
  WAIT FOR 40 ns;
  t_start0 <= '1';
  WAIT FOR 50 ns;
  t_start0 <= '0';
  WAIT;
  END PROCESS;
  U1 : uart2 PORT MAP(t_rst, t_clk, t_baud1, t_io0, t_start0, t_din0, x01, x10, t_dout0, t_done0);
  U2 : uart2 PORT MAP(t_rst, t_clk, t_baud1, t_io1, t_start1, t_din1, x10, x01, t_dout1, t_done1);
END test2;
