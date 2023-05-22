library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_compteur_de_cycle is
end tb_compteur_de_cycle;

architecture behavioral of tb_compteur_de_cycle is

	signal tb_resetn, tb_Restart      : std_logic := '0';
	signal tb_clk                     : std_logic := '0';
	signal tb_End_cnt_cycles          :  std_logic:= '0';
	
	
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	
	
	component compteur_de_cycle
		port ( 
    clk      : in std_logic:= '0';
    resetn   : in std_logic:= '0'; 
    Restart   : in std_logic:= '0'
		 );
	end component;
	
	begin
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	uut: compteur_de_cycle
        port map (
            clk => tb_clk, 
            resetn => tb_resetn,
            Restart => tb_Restart
        );
		
	--Simulation du signal d'horloge en continue
	process
    begin
		wait for hp;
		tb_clk <= not tb_clk;
	end process;


	process
	begin        
	    wait for 780 ns;
		tb_resetn <= '1';
		--tb_Restart <= '1';
		wait for 10 ns;    
		tb_resetn <= '0'; 
		wait;
	    
	end process;
	
	
end behavioral;