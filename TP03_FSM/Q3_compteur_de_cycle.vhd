library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity compteur_de_cycle is

port(
    clk      : in std_logic:= '0';
    resetn   : in std_logic:= '0'; 
    Restart   : in std_logic:= '0'
    
  );
end entity compteur_de_cycle;


architecture behavioral of compteur_de_cycle is

  signal LED_State      : std_logic := '0';
  signal End_Counter_int  : std_logic := '0';
  signal End_cnt_cycles   : std_logic := '0';
  signal Clk_cnt          : unsigned(27 downto 0):= (others => '0');
  constant Max_Cycles     : positive := 4;

 -- Définition des signaux pour le compteur
 component counter_unit
    generic (
      --Time_value : positive := 200000000
     Time_value : positive := 6
    );
    port(
		clk, resetn, Restart	: in std_logic:= '0'; 
        End_Counter             : out std_logic:= '0'
    );
    end component;
    

	begin

	-- Instanciation du compteur
	
   COUNTER : counter_unit
    port map(
      clk         => clk,
      resetn      => resetn,
      Restart => Restart,
      End_Counter => End_Counter_int
    );

		--Partie sequentielle
		process(clk,resetn)
		begin
			if(resetn = '1') then 
			  Clk_cnt <= (others => '0'); -- réninitialisation des registres
			  LED_State <= '0';
			 
			elsif(rising_edge(clk)) then
              if(Restart = '1') then 
			  Clk_cnt <= (others => '0'); -- réninitialisation des registres

			   elsif(End_Counter_int ='1') then
			     LED_State  <= not LED_State ;-- Changement d'état de la LED
			     if(End_cnt_cycles ='0') then 
			         Clk_cnt <= Clk_cnt + 1;
			    elsif(End_cnt_cycles ='1') then
			         Clk_cnt <= (others => '0');
			    else 
			         Clk_cnt <= Clk_cnt;
			   end if; 
			end if;
			end if;
		end process;
		
		--Partie combinatoire
        End_cnt_cycles <= '1' when (Clk_cnt = TO_UNSIGNED(Max_Cycles,28) -1) else '0';

end behavioral;