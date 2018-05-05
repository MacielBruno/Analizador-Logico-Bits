library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--use IEEE.FLOAT_PKG.all;


--              ESTADOS
-- S0: A CIB não enviou pacote para o submódulo em questão
-- S1: A CIB enviou um pacote, esperando um envio do submódulo
-- S2: O SM enviou um pacote sem o ACK setado, espera o segundo pacote do SM
-- S3: O SM enviou o ACK setado
-- S4: O SM não setou o ACK após em dois pacotes

--              Função
--		Queremos verificar o correto funcionamento dos submódulos,
--para isso iremos verificar se eles enviam pacotes com
--informações para o Comando Interno de Braço(CIB), ou seja, estipulamos
--um intervalo de tempo máximo (maximumDelay) que o SM pode ficar sem enviar uma mensagem
--ao CIB. Para isso vamos utilizar o a frequência de clock do CIB, sabendo que esta é
-- igual a 48MHz, o período de um ciclo é de aproximadamente 21ns


-------------------- Suporemos que o clock deste FPGA é 200 MHz ------------------

entity ACKPROTEC is
Generic (N_SM: integer := 6); -- Número variável de submódulos
port(
		clk: in std_logic; 
		RST: in std_logic;
		ACK: in std_logic_vector((N_SM-1) downto 0); -- Recebe um sinal do CIB confirmando que os SM's receberam o pacote
		received: in std_logic_vector((N_SM-1) downto 0); -- Sinal do CIB atestando que recebeu alguma coisa de um SM
		sendTx: in std_logic_vector((N_SM-1) downto 0); -- Sinal do CIB atestando que enviou um sinal para um SM
		protectionReadySM: in std_logic_vector((N_SM-1) downto 0); -- Mostra os SM que estão prontos para serem averiguados pelo sistema de proteção
		Err: out std_logic_vector((N_SM-1) downto 0); -- Aponta um erro de um SM
		ErrDelay: out std_logic_vector((N_SM-1) downto 0) -- Aponta uma falta de comunicação de um SM
		);
constant clockFrequency : integer := 48000000; -- 2DC6C00 = 48MHz (frequência de clock do CIB)
constant clockPeriod : real := real(real(clockFrequency)**(-1)); -- Período do clock(em ns)
constant maximumDelay : real := 100.0e-9; -- O delay máximo vai ser de períodos de clock(em ns)
constant relation :  integer := integer(maximumDelay/clockPeriod);
end entity;	

-- Descreve os estados como um Array de tamanho igual ao número de SM
architecture behv of ACKPROTEC is
	type STATES is (S0, S1, S2, S3, S4); --Enumeration of the Types
	subtype counter is integer range 0 to integer(maximumDelay/clockPeriod); -- Cria um tipo que conta o número de ciclos, até a quantidade
	-- de ciclos máxima
	type counter_array is array(0 to (N_SM-1)) of counter; -- Cria um counter para cada submódulo
	type STATES_array is array (0 to (N_SM-1)) of STATES;
	signal CS, NS : STATES_array; ---------------------------------------------
	signal contador : counter_array; -- Cria um conjunto de sinais para contar de 0 até a contagem máxima de ciclos

begin
	process(CLK, RST)
	begin
		for instance in 0 to (N_SM - 1) loop
		if CLK'event and CLK = '1'  then
			ErrDelay(instance) <= '0';
			if(protectionReadySM(instance) = '1') then -- Se a proteção estiver habilitada para o submódulo:
				if received(instance) = '1' then
					contador(instance) <= 0;
				elsif (contador(instance)) = integer(maximumDelay/clockPeriod) then -- Se o contador de ciclos chegar ao número máximo
					ErrDelay(instance) <= '1'; -- gera um erro
					contador(instance) <= 0;
				else
					contador(instance)  <= contador(instance)  + 1; -- Caso contrário soma 1 ao contador de ciclos
				end if;
			end if;
			end if;
		end loop;
	end process;
	
	
	
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
		
	