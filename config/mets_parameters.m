function p = mets_parameters(id)
%METS_PARAMETERS Named illustrative scenarios; no empirical calibration.
% Order follows the manuscript notation, not the old positional function API.
names = {'P1','P2','P3','F3','DeltaC1','DeltaC4','V','S','F1', ...
         'DeltaC2','DeltaC3','L','K','E','D'};
switch char(id)
    case 'E1'
        v = [1 1 2 3 1 2 1 6 2 1 1 2 2 2 1];
    case 'E2'
        v = [1 1 1.5 2 1 4.5 .5 6 2 1 1 2 2 2 1];
    case 'E3'
        v = [1 1 1.5 3 1 2 2 6 2 1 2.5 2 2 2 1];
    case 'E8_case1'
        v = [1 .5 .5 1 1 4.5 .5 5 1 5.5 2 1 1 1 .5];
    case 'E8_case2'
        v = [1.5 1 .5 2 .5 3.5 .3 3 1 6 2.5 1 1 1 1];
    case 'E9'
        v = [.5 1 1 2 1 1 2.5 1.5 2 .5 .5 2 2 2 1];
    case 'E16'
        v = [.5 .5 1 1 5 3 2 2 1 3.5 1.5 1 1 1 1];
    case 'mixed_boundary'
        v = [2 1 2 1 3 2 1 2 4 6 1 1 1 2 1];
    case 'mixed_line'
        v = [1 .5 .5 1 1 4.5 .5 5 1 5 2 1 1 1 .5];
    otherwise
        error('METS:UnknownScenario','Unknown scenario: %s',char(id));
end
p = cell2struct(num2cell(v), names, 2);
end
