function [config] = ReadConfig(fname)
    fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    config = jsondecode(str);
end

