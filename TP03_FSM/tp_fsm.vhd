library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tp_fsm is

port(
    clk      : in std_logic:= '0';
    resetn   : in std_logic:= '0'; 
    Restart   : in std_logic:= '0'; 
    OUT_R, OUT_B, OUT_V : out std_logic:= '0'
  );
end entity tp_fsm;


architecture behavioral of tp_fsm is

 -- Définition des états possibles de la machine à états
  type state is (idle, rouge, bleu, vert);
  signal current_state : state;
  signal next_state    : state;

  signal LED_State      : std_logic := '0';
  signal End_Counter_int  : std_logic := '0';
  signal End_cnt_cycles   : std_logic := '0';
  signal Clk_cnt          : unsigned(27 downto 0):= (others => '0');
  constant Max_Cycles     : positive := 4;

 -- Définition des signaux pour le compteur

 component counter_unit
    generic (
     Time_value : positive := 200000000
     --Time_value : positive := 6
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
			  current_state <= idle;
			 
			elsif(rising_edge(clk)) then
              if(Restart = '1') then 
			  Clk_cnt <= (others => '0'); -- réninitialisation des registres
			  elsif(End_Counter_int ='1') then
			  LED_State  <= not LED_State ; -- Changement d'état de la LED
			      if (End_cnt_cycles = '0') then 
			      Clk_cnt <= Clk_cnt + 1;
		          elsif(End_cnt_cycles ='1') then
		          Clk_cnt <= (others => '0'); -- réinitialisation des registres 
			      end if; 
			     end if;
			     current_state <= next_state;
			end if;
		end process;
		
		--Partie combinatoire
        End_cnt_cycles <= '1' when (Clk_cnt = TO_UNSIGNED(Max_Cycles,28) -1) else '0';
        

		-- FSM
		process(current_state, End_cnt_cycles, End_Counter_int, Restart) 
		begin
             case current_state is
             --------------------------------------
              when idle =>
                --signaux pilotes par la fsm
                      OUT_R <=LED_State;
                      OUT_B <=LED_State;
                      OUT_V <=LED_State;
                      
                 if (End_cnt_cycles = '1' and End_Counter_int ='1') then 
                 --if (End_cnt_cycles = '1' and End_Counter_int ='1') then 
                     next_state <= Rouge; --prochain etat
                  else
                     next_state <= idle;  -- Si la condition pour changer d'état n'est pas remplie, on reste dans l'état actuel
                 end if;
             -----------------------------------
              when Rouge =>
                --signaux pilotes par la fsm
                    OUT_R <=LED_State;
                    OUT_B <='0';
                    OUT_V <='0';   
                 
                 if (End_cnt_cycles = '1' and End_Counter_int ='1') then 
                 next_state <= Bleu;
                 elsif(Restart = '1')then 
                 next_state <= idle; 
                 else
                     next_state <= Rouge;  
                 end if;
             ------------------------------------
              when Bleu=>
                --signaux pilotes par la fsm
                   OUT_R <='0';
                   OUT_B <=LED_State;
                   OUT_V <='0'; 
                      
                 if (End_cnt_cycles = '1' and End_Counter_int ='1') then 
                     next_state <= Vert;
                     
                 elsif(Restart = '1')then 
                 next_state <= idle; 
                 else
                     next_state <= Bleu ;  
                 end if;
              ----------------------------------   
               when Vert=>
                --signaux pilotes par la fsm
                   OUT_R <='0';
                   OUT_B <='0';
                   OUT_V <=LED_State;  
                        
                 if (End_cnt_cycles = '1' and End_Counter_int ='1') then 
                     next_state <= Rouge;
                     
                 elsif(Restart = '1')then 
                 next_state <= idle; 
                 else
                     next_state <= Vert ;  
                 end if;                   
               -------------------------------
              end case;
		end process;
		

end behavioral;