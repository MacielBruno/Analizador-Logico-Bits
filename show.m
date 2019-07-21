function pckt_text = show(pckt,user_par)
%pck is the packet
%user_par is a string containing the parameters of the function from
%the xls file
%user_par_str=split(convertCharsToStrings(user_par),',');
%user_parc = cellstr(user_par_str);
 user_parc_array = split(string(user_par),',');
 user_parc = cellstr(user_parc_array);
% check for bin parameter
if numel(user_parc)==3
    if strcmp(user_parc{3},'bin')
        n2s=@dec2bin2str;
    end
else
    n2s=@num2str;
end

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

%check whether text should be shown
if numel(user_parc)>1
    condition = user_parc{2};
    for i=1:sizep
        %Since variables are generated in a struct (to avoid evalin), it is
        %necessary to change the name of variables
        condition = strrep(condition,pckt.fields{i,1},['pckt_vars.' pckt.fields{i,1}]);
    end
    showtxt=evaluate(condition);
else
    showtxt=true;
end

%Process first argument
if strcmpi(user_parc{1},'all')
    for k=1:sizep
        pckt_text{k,1} = [pckt.fields{k,1} ' = ' n2s(pckt_vars.(pckt.fields{k,1}))];
    end
else
    %Divide string into text and evaluatable parts
    expr=user_parc{1};
    if expr(end)~= ''''
       expr=[expr ' ']; 
    end
    exectv = true;
    char_index=1;
    part_index=1;
    %expr_parts{2,part_index} = exectv; %user_parc{1};
    expr_part_temp='';
    for k=1:(numel(expr))
        if (expr(k)=='''')||(k==numel(expr))
            if k==1
                exectv=~exectv;
                %expr_parts{2,part_index} = exectv;
            else
                expr_parts{2,part_index} = exectv;
                exectv=~exectv;
                expr_parts{1,part_index} = expr_part_temp;
                char_index=1;
                expr_part_temp='';
                part_index = part_index+1;
            end
        else
            expr_part_temp(char_index)=expr(k);
            char_index=char_index+1;
        end
    end
    %Change variable names
    for i=1:sizep
        for j=1:size(expr_parts)
            if expr_parts{2,j}
                expr_parts{1,j} = strrep(expr_parts{1,j},pckt.fields{i,1},pckt.fields{i,1});
            end
        end
    end
    %Execute evaluatable parts and substitute DT (data type)
    for j=1:(numel(expr_parts(1,:)))
        if expr_parts{2,j} && isempty(strfind(expr_parts{1,j},'DT'))
            expr_parts{3,j} = n2s(pckt_vars.(expr_parts{1,j}));
        else
            expr_parts{3,j}= strrep(expr_parts{1,j},'DT',pckt.data_type);
        end
    end
    if showtxt
        pckt_text={strcat(expr_parts{3,:})};
    else
        pckt_text={};
    end
end
end

function str = dec2bin2str(num)
str=dec2bin(round(num),1);
end

function str = bin2str(num) %num is a row vector
str = num2str(2.^[numel(num)-1:-1:0]*num');
end

function num = bin2dec(bin)
num = 2.^[numel(bin)-1:-1:0]*bin';
end

% function var_gen(str)
%     evalin('caller',str);
% end

function res = evaluate(str)
res=evalin('caller',str);
end