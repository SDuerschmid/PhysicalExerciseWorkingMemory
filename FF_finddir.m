function [dirName,fileName] = FF_finddir(curdir,subject)
%FP_LOADINFO Summary of this function goes here
%   Detailed explanation goes here
num = 1;
filename = struct;
dirname = struct;

if isstr(curdir)==1 
    list    = dir(curdir);
    l = length(list);
    for listi = 1:l
        if strfind(list(listi).name,subject)>0
            filename(num).name = list(listi).name;
            dirname(num).name = cat(2,curdir,'/',filename(num).name);
            num = num+1;
        end
    end
else
    [m,n] = size(curdir);
    for numi = 1:n
        list    = dir(curdir(numi).name);
        l = length(list);                
        for listi = 1:l
            if strfind(list(listi).name,subject)>0
                filename(num).name = list(listi).name;
                dirname(num).name = cat(2,curdir(numi).name,'/',filename(num).name);
                num = num+1;
            end
        end
    end
end

[m,n] = size(dirname);

if n == 1
    dirName = dirname.name;
    fileName = filename.name;
else
    dirName = dirname;
    fileName = filename;
end

end

