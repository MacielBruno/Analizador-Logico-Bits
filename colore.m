function cor = colore(pckt,user_par)
%pck is the packet
%user_par is a string containing the parameters of the function from
%the xls file
% user_parc=strsplit(user_par,',');

%user_par_str = split(convertCharsToStrings(user_par),',');
user_par_str = split(string(user_par),',');
user_parc = cellstr(user_par_str);
% check for conditional parameter
if numel(user_parc)>1
    %generate variables dynamically in function workspace
    sizep=size(pckt.fields,1);
    if sizep>20
        sizep=20;
    end
    
    for i=1:sizep
        %var_gen([pckt.fields{i,1} '=' num2str(bin2dec(pckt.fields{i,2}))])
        %using evalin is bad
        pckt_vars.(pckt.fields{i,1})=bin2dec(pckt.fields{i,2});
    end
    
    %check whether color should be changed
    condition = user_parc{2};
    for i=1:sizep
        %Since variables are generated in a struct (to avoid evalin), it is
        %necessary to change the name of variables
        condition = strrep(condition,pckt.fields{i,1},['pckt_vars.' pckt.fields{i,1}]);
    end
    if evaluate(condition)
        if strcmpi(user_parc{1},'dc')
            cor = pckt.def_color;
        else
            cor = evaluate(user_parc{1});
        end
    else
        cor = [];
    end
else
    if strcmpi(user_parc{1},'dc')
        cor = pckt.def_color;
    else
        cor = evaluate(user_parc{1});
    end
end
end

function res = evaluate(str)
res=evalin('caller',str);
end

function num = bin2dec(bin)
num = 2.^[numel(bin)-1:-1:0]*bin';
end