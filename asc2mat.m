%% Conver .asc or .txt format into .mat format
function data = asc2mat( ascfile,format)
filename=[ascfile format];
[fileID, msg] = fopen(filename,'r');
if fileID>0
    if format=='.txt'
        X=textscan(fileID, '%s %s %s %s %s %s','headerlines', 0);
        fclose(fileID);
        %     xx=X{1};
        X6=str2double(X{6});
        data=[X6];
    else
        X=textscan(fileID, '%s %s %s','headerlines', 0);
        fclose(fileID);
        %     xx=X{1};
        X1=str2double(X{1});
        X2=str2double(X{2});
        X3=str2double(X{3});
        data=[X1, X2, X3];
        %     matfile=[ascfile '.mat'];
        %     save( matfile, 'data');
    end
else
    data=[];
    disp(msg);
end

%
