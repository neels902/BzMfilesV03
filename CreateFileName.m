function fileName = CreateFileName(I_DestStg, I_DirName, I_COREstring)
% used inside OutfileBz
% it creates a directory and ident
% simply adds 1 to the total number of files with the CORstring -
% regardless of the file numbers e.g. 'Bfield_TXT_034523' or
% 'Bfield_TXT_crap' does not matter

%% inputs 
DestStg = I_DestStg ; % I_FileLoc % directory destination of where to place files eg. '~/'
DirName = I_DirName; % name of folder to create eg. 'Bz4CastFiles'
COREstring = I_COREstring; % core string structure of the file names eg. 'Bfield_TXT';
filetype = '.txt';

%% check folder exists or make it 
HomeDirTest = [DestStg, DirName];
if exist(HomeDirTest,'dir') ~= 7
    mkdir(HomeDirTest)
end

%% check the last value of filenumer in sequence
FilepathCore = [HomeDirTest, '/',COREstring];
HomeFilTest = [FilepathCore, '_001', filetype];
NN = length(COREstring)+1; % add 1 for the '_' in the number section
PP = length(filetype);

% fullfile(FilepathCore); % check help file for this cool syntax

if exist (HomeFilTest,'file') ~= 2
    fileName = HomeFilTest;
else
    % listing = dir(name);
    dirName = FilepathCore;
    fileDetails = dir( [dirName,'*',filetype] );
    files = {fileDetails.name}';  % -- print check of all files
    
    ll = length(files);             % NEW METHODOLGY JUST ADD 1 to total number in folder
    LL = ll+1;
    str = sprintf('%03u',LL);
    newStr = ['_', str];
    fileName = [FilepathCore, newStr, filetype];   
    
%     FilStg = char(files); % convert cell to char array of all file names
%     % FilStg = cell2struct(files,'temp',);
%     NumStrArr =  FilStg(:,NN+1: end-PP-1);
%     % NumStrArr =  FilStg(:,NN+1:NN+3 );
 
end


% while a <0 do
% end
    
end
