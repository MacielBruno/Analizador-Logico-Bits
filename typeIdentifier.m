function [color,text] = typeIdentifier(matrizDePacotes,fileType,strt_cfg)
%     load('strt_cfg_file.mat');
%     color = {};
color = cell(1,size(matrizDePacotes,1));
%     text = {};
text = cell(size(matrizDePacotes,1),3);
defaultColor = 	[1,1,0]; % Yellow

holderCell = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Iremos descobrir a origem do pacote, i.e., se � um SM2Arm,
% Arm2CC,CC2Arm, Arm2SM
for i = 1:size(strt_cfg.strt_cfg,2)
    if strt_cfg.strt_cfg(i).pckt_name == fileType
        index_in_strt_cfg = i;
        break;
    end
end

for line = 1:size(matrizDePacotes,1)
    colorCheck = 0;
    pacote = matrizDePacotes(line,:);
    pacote = pacote(2:end);
    
    % Agora que j� temos a origem do pacote, vamos descobrir a que tipo de
    % pacote ele pertence, fazendo a opera��o descrita pelo Gean.
    
    % Pegando o nosso pacote vamos fazer
    % pacotes & strt_cfg(index_in_strt_cfg).pckts(i).test_bits ==
    % strt_cfg(index_in_strt_cfg).pckts(i).mask, at� achar o i que
    % satisfaz esta igualdade
    test = 0;
    for i = 1:size(strt_cfg.strt_cfg(index_in_strt_cfg).pckts,2)
        if (pacote & strt_cfg.strt_cfg(index_in_strt_cfg).pckts(i).test_bits) == strt_cfg.strt_cfg(index_in_strt_cfg).pckts(i).mask
            packetTypeIndex = i; % Encontrou o tipo de pacote
            test = 1;
            break;
        end
    end
    if test == 0
        pacote
        error('Previous package has not been defined in the configuration file')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Pega as informa��es dos fields
    pckt = struct;
    for i = 1:size(strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).fields,2)
        pckt.fields{i,1} = strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).fields(i).name;
        pckt.fields{i,2} = b2d(pacote(strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).fields(i).logic_index));
    end
    pckt.def_color = strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).color;
    
    % Pega os par�metros de cada fun��o que ser�o passados para a
    % fun��o show() e colore()
    %         for i = 1:size((strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).function),2)
    %             pckt.user_parc{i} = strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).function(i).param;
    %         end
    pckt.data_type = strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).data_type;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% PART 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Chamar as fun��es show(pckt(k),pckt(k).user_parc) e colore(pck, pckt.user_parc)
    counter = 1;
    for i = 1:size(strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).function,2)
        func = strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).function(i).handl;
        user_parc = strt_cfg.strt_cfg(index_in_strt_cfg).pckts(packetTypeIndex).function(i).param;
        holderCell = func(pckt,user_parc);
        if isequal(func,@show)
            text{line,counter} = holderCell;
            counter = counter + 1;
        elseif isequal(func,@colore)
            if isequal(holderCell,[]) == 0
                color{line} = holderCell;
                colorCheck = 1;
            elseif colorCheck == 0
                color{line} = defaultColor;
            elseif isequal(holderCell,[]) == 1
                continue;
            end
        end
    end
end
end


