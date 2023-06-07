LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY elevator_tb IS 
	GENERIC (
		N : integer := 4
	);
END elevator_tb;

ARCHITECTURE test1 OF elevator_tb IS
  COMPONENT elevator IS
	
    PORT(
        clk       : IN  std_logic;
        rst       : IN  std_logic;
	come      : IN std_logic_vector(N-1 DOWNTO 0);
        cf        : IN std_logic_vector(N-1 DOWNTO 0);
	switch    : IN std_logic_vector(N-1 DOWNTO 0);

	motor_up        : OUT std_logic;
        motor_down      : OUT std_logic;
        elevator_state  : OUT std_logic;
        current_floor   : OUT std_logic_vector(N-1 downto 0)
    );
  END COMPONENT;

  SIGNAL t_clk    : std_logic := '0';
  SIGNAL t_rst    : std_logic;
  SIGNAL t_come   : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL t_cf	  : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL t_switch : std_logic_vector(N-1 DOWNTO 0);	
		
  SIGNAL t_motor_up       : std_logic;			
  SIGNAL t_motor_down	  : std_logic;
  SIGNAL t_elevator_state : std_logic;
  SIGNAL t_current_floor  : std_logic_vector(N-1 DOWNTO 0);	
	
BEGIN
  t_clk <= NOT t_clk AFTER 5 ns;
  t_rst <= '1', '0' AFTER 30 ns;
  
  PROCESS 
  BEGIN
  t_switch <= "0001";
  WAIT FOR 40 ns;
  t_cf <= "0100";
  WAIT FOR 40 ns;
  t_come <= "0100";
  WAIT FOR 40 ns;
  t_switch <= "0010";
  WAIT FOR 40 ns;
  t_switch <= "0100";
  WAIT FOR 40 ns;
  END PROCESS;

  UUT : elevator PORT MAP(t_clk, t_rst, t_come, t_cf, t_switch, t_motor_up, t_motor_down, t_elevator_state, t_current_floor);
END test1;
	
