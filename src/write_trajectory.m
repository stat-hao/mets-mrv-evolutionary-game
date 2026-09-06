function write_trajectory(fileName,s)
%WRITE_TRAJECTORY Keep state order explicit in each numeric output.
T=array2table([s.t s.u], 'VariableNames',{'t','x','y','z','r'});
writetable(T,fileName);
end
