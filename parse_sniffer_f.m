%function struct_cfg = parse_sniffer_f(file_name) 

%test variables
file_name='pckts_structs';

clear strt_cfg

%aux functions
letter2number = @(c)1+lower(c)-'a';

[status,sheets]=xlsfinfo(file_name);
if length(sheets)<1
    error('file contains no sheets')
else
    disp(['file ''' file_name ''' contains ' num2str(length(sheets)) ' packet types'])
    disp(sheets')
end

xl = actxserver('excel.application'); %open activex server
wb = xl.Workbooks.Open([pwd '\' file_name]); %open specified xlsx file

for i=1:length(sheets)
    strt_cfg(i).pckt_name = sheets{i};
    %get raw data
    [num,txt,mixed] = xlsread(file_name,strt_cfg(i).pckt_name); 
    strt_cfg(i).table_txt=txt;
    strt_cfg(i).table_mixed=mixed;
    mixed_temp=mixed;
    mixed_temp(~cellfun(@isnumeric,mixed_temp))={NaN};
    strt_cfg(i).table_num=cell2mat(mixed_temp);
    
    %Extract packet numbers
    start_text=txt{1,2};
    start=[str2num(start_text(isstrprop(start_text,'digit')))...
        letter2number(start_text(isstrprop(start_text,'alpha')))];
    endi=start + [strt_cfg(i).table_num(2,2)-1 strt_cfg(i).table_num(3,2)-1];
    strt_cfg(i).pckts_raw.num=strt_cfg(i).table_num(start(1):endi(1),start(2):endi(2));
    
    %Extract packet text
    strt_cfg(i).pckts_raw.text=strt_cfg(i).table_txt(start(1):endi(1),start(2):endi(2));
    %grouped cells has only the first element no empty. This
    %this lines fills the rest of the elements by knowing that they correspond to
    %NaN cells in the numeric array
    txt_size=size(strt_cfg(i).pckts_raw.text);
    for n=1:txt_size(1)
        for k=2:txt_size(2)
            if strcmp(strt_cfg(i).pckts_raw.text{n,k},'') &&...
                    isnan(strt_cfg(i).pckts_raw.num(n,k))&&...
                    ~strcmp(strt_cfg(i).pckts_raw.text{n,k-1},'')
                strt_cfg(i).pckts_raw.text{n,k}=strt_cfg(i).pckts_raw.text{n,k-1};
            end
        end
    end
    
    %Extract packet data type
    strt_cfg(i).pckts_raw.datatype_text = strt_cfg(i).table_txt(start(1):endi(1),endi(2)+1);
    for n=1:txt_size(1)
        strt_cfg(i).pckts(n).data_type=strt_cfg(i).pckts_raw.datatype_text(n,:);
    end

    %Extract function text
    strt_cfg(i).pckts_raw.func_text=strt_cfg(i).table_txt(start(1):endi(1),endi(2)+2:end);
    for n=1:txt_size(1)
        u=strt_cfg(i).pckts_raw.func_text(n,:);
        u=u(~cellfun(@isempty, u));
        for p=1:numel(u)
            str_func=u{p};
            if ~isempty(strfind(str_func,'show'))
                strt_cfg(i).pckts(n).function(p).handl=@show;
                strt_cfg(i).pckts(n).function(p).param=str_func((strfind(str_func, '(')+1):(strfind(str_func, ')')-1));
            elseif ~isempty(strfind(str_func,'colore'))
                strt_cfg(i).pckts(n).function(p).handl=@colore;
                strt_cfg(i).pckts(n).function(p).param=str_func((strfind(str_func, '(')+1):(strfind(str_func, ')')-1));
            else
                disp('Function not recognized')
            end
        end
    end
    
    %Extract default color - cell colors
    ind_c=endi(2)+1;
    if floor(ind_c/26) < 1
        colname = char(65 + ind_c -1);
    elseif (0 < floor(ind_c/26))&& (floor(ind_c/26) < 26)    %alles bis Spalte ZZ abgedeckt
        colname = char(65 + floor(ind_c/26)-1);
        colname(2) = char(65 + ind_c -26*floor(ind_c/26) -1);
    end
    for n=start(1):endi(1)
        wbSheet1 = wb.Sheets.Item(strt_cfg(i).pckt_name); %specify sheet
        dat_range = [colname num2str(n)]; % Read any cell
        rngObj = wbSheet1.Range(dat_range); %set that as active cell(s)
        rngObj.Interior.Color;
        cellColor = rngObj.Interior.Color;
        strt_cfg(i).pckts(n-start(1)+1).color = fliplr(floor(mod(cellColor ./ [65536, 256, 1], 256)));
    end
        
       
  
    % Calculate packet masks and tested bits
    %if (pckt & tested_bits) xnor mask 
    num_temp=strt_cfg(i).pckts_raw.num;
    num_temp(isnan(num_temp))=0;
    %This mask is used in a xnor test
    for n=1:txt_size(1)
        strt_cfg(i).pckts(n).mask=num_temp(n,:);
    end
    num_temp=strt_cfg(i).pckts_raw.num;
    num_temp(~isnan(num_temp))=1;
    num_temp(isnan(num_temp))=0;
    %But only bits that identify the packet type are tested
    for n=1:txt_size(1)
        strt_cfg(i).pckts(n).test_bits=num_temp(n,:);
    end
    
    %Calculate field masks and names
    for n=1:txt_size(1)
        %removes '' and 'X'
        field_names=unique(strt_cfg(i).pckts_raw.text(n,:));    
        notxt_ind=ismember(field_names,{'' 'X'});
        field_names(notxt_ind)=[];
        %Calculate field indexes
        for k=1:numel(field_names)
            strt_cfg(i).pckts(n).fields(k).name=field_names{k};
            strt_cfg(i).pckts(n).fields(k).logic_index=ismember(strt_cfg(i).pckts_raw.text(n,:),field_names{k});
        end
    end
    
end

wb.Close;
xl.Quit;
xl.delete;

disp(['Finished parsing file ''' file_name ''''])

clearvars  cellColor colname dat_range endi field_names file_name i ind_c...
k letter2number mixed mixed_temp n notxt_ind num num_temp p rngObj sheets...
start start_text status str_func txt txt_size u wb wbSheet1 xl ans
%end

