library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--              ESTADOS
-- S0: A CIB não enviou pacote para o submódulo em questão
-- S1: A CIB enviou um pacote, esperando um envio do submódulo
-- S2: O SM enviou um pacote sem o ACK setado, espera o segundo pacote do SM
-- S3: O SM enviou o ACK setado
-- S4: O SM não setou o ACK após em dois pacotes

entity acknowledgement is
Generic(
		N_SM: integer := 6 -- Número variável de submódulos
			);
port(
		clk: in std_logic; 
		RST: in std_logic;
		ACK: in std_logic_vector((N_SM-1) downto 0); -- Recebe um sinal do CIB confirmando que os SM's receberam o pacote
		received: in std_logic_vector((N_SM-1) downto 0); -- Sinal do CIB atestando que recebeu alguma coisa de um SM
		sendTx: in std_logic_vector((N_SM-1) downto 0); -- Sinal do CIB atestando que enviou um sinal para um SM
		Err: out std_logic_vector((N_SM-1) downto 0) -- Aponta um erro de um SM
		);
end entity;	

-- Descreve os estados como um Array de tamanho igual ao número de SM
architecture behv of acknowledgement is
	type STATES is (S0, S1, S2, S3, S4); --Enumeration of the Types
	type STATES_array is array (0 to (N_SM-1)) of STATES;
	signal CS, NS : STATES_array; ---------------------------------------------

begin

	process(CLK, RST)
	begin
		if RST = '1' then
		for instance in 0 to (N_SM-1) loop
			CS(instance) <= S0;
		end loop;
		elsif CLK'event and CLK = '1' then
		for instance in 0 to (N_SM-1) loop
			CS(instance) <= NS(instance);
		end loop;
		end if;
	end process;

	process(sendTx, received, ACK, CS)
	
	begin
	for instance in 0 to (N_SM-1) loop
		case CS(instance) is
			when S0 => Err(instance) <= '0';
							if SendTx(instance) = '1' then 
								NS(instance) <= S1; 
							else NS(instance) <= S0; 
							end if;
							
			when S1 => Err(instance) <= '0';
							if Received(instance) = '1' and ACK(instance) = '0' then 
								NS(instance) <= S2;
							elsif Received(instance) = '1' and ACK(instance) = '1' then 
								NS(instance) <= S3; 
							else NS(instance) <= S1;
							end if;
							
			when S2 => Err(instance) <= '0';
							if Received(instance) = '1' and ACK(instance) = '1' then 
								NS(instance) <= S3; 
							elsif Received(instance) = '1' and ACK(instance) = '0' then 
								NS(instance) <= S4; 
							else NS(instance) <= S2;
							end if;
							
			when S3 => Err(instance) <= '0';
							NS(instance) <= S0;
							
			when S4 => Err(instance) <= '1';
							NS(instance) <= S0;
							
		end case;
	end loop;
	end process;
end behv;
		
	