function ES = ES_frame(vendor)

switch vendor
    case {'GE Vingmed Ultrasound','TomTec','Epsilon'}
        ES = 17;
        
    case {'TOSHIBA_MEC_US','TOSHIBA MEC US A4C_simu'}
        ES = 19;
        
    case 'ESAOTE'
        ES = 17;
        
    case 'SAMSUNG MEDISON CO'
        ES = 20;
        
    case 'Siemens'
        ES = 18;
        
    case 'Philips Medical Systems'
        ES = 16;
        
    case 'Hitachi Aloka Medical,Ltd'
        ES = 22;
        
    otherwise
        error('vendor not defined')
        
end

end