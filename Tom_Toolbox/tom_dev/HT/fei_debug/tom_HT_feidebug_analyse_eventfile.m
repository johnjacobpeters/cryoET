function tom_HT_feidebug_analyse_eventfile(filename)


fid=fopen(filename);


zz=1;
for i=1:1000000
    line=fgetl(fid);
    if (line==-1)
        break;
    else
         try
            file{zz,1}=line(1:20);
            file{zz,2}=line(21:end);
            zz=zz+1;
         catch
            
         end;
    end;
    disp(i);
end;

fclose(fid);



new.message=cell(size(file,1),500);
new.date=cell(size(file,1),200);
new.counter=zeros(size(file,1),1);

new.message{1}=file{1,2};
new.date{1}=file{1,1};
new.counter(1)=1;
entry_flag=1; 
new_entries_cc=1;

for i=2:size(file,1)
    for ii=1:new_entries_cc
        if (strcmp(file{i,2},new.message{ii})==1 ) 
            new.counter(ii)=new.counter(ii)+1;
            entry_flag=0;
            break;
        end;
    end;
    if (entry_flag==1)
        new.message{ii+1}=file{i,2};
        new.date{ii+1}=file{i,1};
        new.counter(ii+1)=1;
        new_entries_cc=new_entries_cc+1;
    end;
    entry_flag=1;   
    disp(i);
end;


disp('hallo');