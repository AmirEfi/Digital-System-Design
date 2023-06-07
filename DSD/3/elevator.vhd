LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY elevator IS 
    GENERIC (
	N : integer := 4
    );
    PORT(
        clk             : IN std_logic;
        rst             : IN std_logic;
        come            : IN std_logic_vector(N-1 DOWNTO 0);
        cf              : IN std_logic_vector(N-1 DOWNTO 0);
        switch          : IN std_logic_vector(N-1 DOWNTO 0);
        motor_up        : OUT std_logic;
        motor_down      : OUT std_logic;
        elevator_state  : OUT std_logic;
        current_floor   : OUT std_logic_vector(N-1 DOWNTO 0)
    );
END elevator;
ARCHITECTURE elv_tst OF elevator IS  
    TYPE state IS (F1, F2, F3, F4, DOWNWard, UPWard);
    SIGNAL current_state, next_state : state;

BEGIN  

    PROCESS (come, cf, switch)
    BEGIN 
        CASE current_state IS 
            WHEN F1 =>
                IF (come = "0010" OR come = "0100" OR come = "1000" OR cf = "0010" OR cf = "0100" OR cf = "1000") THEN
                    next_state <= UPWard;
                ELSE
                    next_state <= F1;
                END IF;
            WHEN F2 =>
                IF (come = "0100" OR come = "1000" OR cf = "0100" OR cf = "1000") THEN
                    next_state <= UPWard;
                ELSIF (come = "0001" OR cf = "0001") THEN
                    next_state <= DOWNWard;
                ELSE
                    next_state <= F2;
                END IF;
            WHEN F3 =>
                IF (come = "1000" OR cf = "1000") THEN
                    next_state <= UPWard;
                ELSIF (come = "0010" OR come = "0001" OR cf = "0010" OR cf = "0001") THEN
                    next_state <= DOWNWard;
                ELSE
                    next_state <= F3;
                END IF;
            WHEN F4 =>
                IF (come = "0001" OR come = "0010" OR come = "0100" OR cf = "0001" OR cf = "0010" OR cf = "0100") THEN
                    next_state <= DOWNWard;
                ELSE
                    next_state <= F4;
                END IF;
            WHEN UPWard =>
                IF (switch = "0010" AND (come = "0010" OR cf = "0010")) THEN
                    next_state <= F2;
                ELSIF (switch = "0100" AND (come = "0100" OR cf = "0100")) THEN
                    next_state <= F3;
                ELSIF (switch = "1000" AND (come = "1000" OR cf = "1000")) THEN
                    next_state <= F4;
                ELSE
                    next_state <= UPWard;
                END IF;
            WHEN DOWNWard =>
                IF (switch = "0001" AND (come = "0001" OR cf = "0001")) THEN
                    next_state <= F1;
                ELSIF (switch = "0010" AND (come = "0010" OR cf = "0010")) THEN
                    next_state <= F2;
                ELSIF (switch = "0100" AND (come = "0100" OR cf = "0100")) THEN
                    next_state <= F3;
                ELSE
                    next_state <= DOWNWard;
                END IF;
        END CASE;
    END PROCESS;

    PROCESS (come, cf, switch, clk)
    BEGIN 
        CASE current_state IS 
            WHEN F1 =>
                motor_up<='0';
		motor_down<='0';
		elevator_state<='0';
	     	current_floor<="0001";
            WHEN F2 =>
                motor_up<='0';
		motor_down<='0';
		elevator_state<='0';
	     	current_floor<="0010";
            
            WHEN F3 =>
                motor_up<='0';
		motor_down<='0';
		elevator_state<='0';
	     	current_floor<="0100";
               
            WHEN F4 =>
                motor_up<='0';
		motor_down<='0';
		elevator_state<='0';
	     	current_floor<="1000";
                
            WHEN UPWard =>
                IF (switch = "0010") THEN
                    motor_up<='1';
		    motor_down<='0';
		    elevator_state<='1';
	     	    current_floor<="0010";
                ELSIF (switch = "0100") THEN
                    motor_up<='1';
		    motor_down<='0';
		    elevator_state<='1';
	     	    current_floor<="0100";
                ELSIF (switch = "1000") THEN
                    motor_up<='1';
		    motor_down<='0';
		    elevator_state<='1';
	     	    current_floor<="1000";
                ELSE
                    motor_up<='1';
		    motor_down<='0';
		    elevator_state<='1';
	     	    current_floor<="1111";
                END IF;
            WHEN DOWNWard =>
                IF (switch = "0001") THEN
		    motor_up<='0';
		    motor_down<='1';
		    elevator_state<='1';
	     	    current_floor<="0001";
                    
                ELSIF (switch = "0010") THEN
	       	    motor_up<='0';
		    motor_down<='1';
		    elevator_state<='1';
	     	    current_floor<="0010";
                    
                ELSIF (switch = "0100") THEN
 		    motor_up<='0';
		    motor_down<='1';
		    elevator_state<='1';
	     	    current_floor<="0100";
                    
                ELSE
		    motor_up<='0';
		    motor_down<='1';
		    elevator_state<='1';
	     	    current_floor<="1111";
                END IF;
        END CASE;
    END PROCESS;

    PROCESS (clk,rst)
    BEGIN
	IF (rst= '1' ) THEN
	 current_state <= F1;
	ELSIF (clk = '1' AND clk'EVENT) THEN
                current_state <= next_state;
            
        END IF;
    END PROCESS;

    
END elv_tst;