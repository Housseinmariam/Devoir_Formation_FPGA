library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity counter_unit is
    generic (
        --vous pouvez ajouter des parameres generics ici
        constant Time_value : positive :=50
    );
    port ( 
		clk, resetn, Restart	: in std_logic:= '0'; 
        End_Counter   : out std_logic:= '0'
     );
end counter_unit;

architecture behavioral of counter_unit is
	--Declaration des signaux internes
    signal Clk_counter : unsigned(27 downto 0):= (others => '0');
	signal End_Counter_tmp :  std_logic:= '0';
	begin
	
		--Partie sequentielle
		process(clk,resetn)
		begin
			if(resetn = '1') then 
			  Clk_counter <= (others => '0'); -- réinitialisation des registres      
			elsif(rising_edge(clk)) then
			  Clk_counter <= Clk_counter + 1; 
			  if (Restart= '1') then
			  Clk_counter <= (others => '0'); -- réinitialisation des registres
			  elsif(End_Counter_tmp = '1') then
                  Clk_counter <= (others => '0'); -- réinitialisation des registres
                end if;   
			end if; 
		end process;
	
		--Partie combinatoire
        End_Counter_tmp <= '1' when (Clk_counter = TO_UNSIGNED(Time_value,28)-1) else '0';
        End_Counter <=  End_Counter_tmp;
	     
end behavioral;