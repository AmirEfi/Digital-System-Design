LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FA IS  -- Full Adder
	PORT (
		a , b : IN STD_LOGIC;
		cin : IN STD_LOGIC;
		cout : OUT STD_LOGIC;
		sum : OUT STD_LOGIC
	);
END FA;

ARCHITECTURE FA_tst OF FA IS

BEGIN
	sum <= a XOR b XOR cin;
	cout <= (a AND b) OR (a AND cin) OR (b AND cin);

END FA_tst;

-- End of Full Adder

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY HA IS -- Half Adder
	PORT (
		a , b : IN STD_LOGIC;
		cout : OUT STD_LOGIC;
		sum : OUT STD_LOGIC	
	);
END HA;

ARCHITECTURE HA_tst OF HA IS

BEGIN
	sum <= a XOR b;
	cout <= a AND b;

END HA_tst;

-- END of Half Adder
		

-- Multiplier 8-bit
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mul8 IS
	PORT (
		a , b : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END mul8;

ARCHITECTURE mul8_tst OF mul8 IS 
	
	COMPONENT FA IS 
		PORT (
			a , b : IN STD_LOGIC;
			cin : IN STD_LOGIC;
			cout : OUT STD_LOGIC;
			sum : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT HA IS
		PORT (
			a , b : IN STD_LOGIC;
			cout : OUT STD_LOGIC;
			sum : OUT STD_LOGIC
		);
	END COMPONENT;

	TYPE row IS ARRAY (7 DOWNTO 0, 7 DOWNTO 0) OF STD_LOGIC;
	SIGNAL tmp_sum : row := ( (OTHERS => (OTHERS => '0') ) );
	SIGNAL tmp_out : row := ( (OTHERS => (OTHERS => '0') ) );
	SIGNAL couts : row := ( (OTHERS => (OTHERS => '0') ) );

BEGIN
	tmp_sum(0,0) <= a(0) AND b(0);
	tmp_sum(1,0) <= a(1) AND b(0);
	tmp_sum(2,0) <= a(2) AND b(0);
	tmp_sum(3,0) <= a(3) AND b(0);
	tmp_sum(4,0) <= a(4) AND b(0);
	tmp_sum(5,0) <= a(5) AND b(0);
	tmp_sum(6,0) <= a(6) AND b(0);
	tmp_sum(7,0) <= a(7) AND b(0);
	
	L1: FOR i IN 0 TO 7 GENERATE

		IF1: IF i = 0 GENERATE
			output(0) <= tmp_sum(i,0);
		END GENERATE IF1;

		IF2: IF i /= 0 GENERATE
			HAs: HA PORT MAP (a => tmp_sum(i,0), b => tmp_out(i-1,1), cout => couts(i,0), sum => output(i) );
		END GENERATE IF2;

	     L2: FOR j IN 1 TO 7 GENERATE
		tmp_sum(i,j) <= a(i) AND b(j);

		IF3: IF i /= 0 GENERATE

			IF4: IF j = 7 GENERATE
				FA1: FA PORT MAP (a => tmp_sum(i,j), b => couts(i-1,j), cin => couts(i,j-1), cout => couts(i,j), sum => tmp_out(i,j) );
			END GENERATE IF4;

			IF5: IF j /= 7 GENERATE
				FA2: FA PORT MAP (a => tmp_sum(i,j), b => tmp_out(i-1,j+1), cin => couts(i,j-1), cout => couts(i,j), sum => tmp_out(i,j) );
			END GENERATE IF5;

		END GENERATE IF3;

		IF6: IF i = 0 GENERATE
			FA3: FA PORT MAP (a => tmp_sum(i,j), b => '0', cin => couts(i,j-1), cout => couts(i,j), sum => tmp_out(i,j) );
		END GENERATE IF6;
		
			
			
	     END GENERATE L2;


	END GENERATE L1;
	
	output(15) <= couts(7,7);

	L3: FOR i IN 14 DOWNTO 8 GENERATE
		output(i) <= tmp_out(7,i-7);
	END GENERATE L3;

END mul8_tst;