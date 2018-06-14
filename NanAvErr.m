function [average,standard_error]=NanAvErr(data,col,QuietZeroNoisyOne)

% Average and standard error on data containing NaNs - 15/01/07
%
%
% DESCRIPTION: NanAvErr works out the average and standard error for 
% data in the specified column of a 2D matrix; ignoring any NaNs present in
% that column. Thpse NaNs are treated as if they don't exist - they don't
% contribute to the sum of data values, or to the number of data values,
% when working out the average and the standard error.
%
%The formula for the standard error used is:
%   s = Ei=1:n([x(i)-average_x]) /[sqrt(n)*sqrt(n-1)]
%
% NB zeros are assumed to be real data - this code will need to be altered if, 
% when the instrument isn't working, zeros are returned in the data.  
%
%
% COORDINATE SYSTEM: N/A 
%
%
% DATA: N/A, but would commonly be used on a timeseries
%
%
% ARGUMENTS:
%
% I data            2D matrix, [x,y] with the data series of interest in
%                   the x direction, ie as a column. The canonical example would be a
%                   timeseries of data, eg of |B| [Note transposing!]:
%                   data=[0 1 2 3; 50 10 NaN 20; 20 6 NaN 18]'
%
%                    [t   |B|   B_z]
%               data =
%                     0   50    20
%                     1   10    6
%                     2   NaN   NaN
%                     3   20    18
                    
% 
% I col             Column of data for which the average and standard error
%                   are required, ignoring any NaNs in that column. EG for
%                   the example above 2 would give the error and std dev on
%                   |B|; 3 on B_z
%
% O average         The average of the data in column col, ignoring any
%                   NaNs present - explicitly, they don't contribute to the numerator
%                   (sum of non-NaN data values: 80 for |B| in example) or denominator 
%                   (number of non-NaN data values: 3 for |B|) when working out the average; 
%                   so it would be 26.67 for |B| in above example
%
% O standard_error  The standard error of the data in column col, ignoring
%                   any NaNs present; 12.02 for |B| in above example
%
% [average,standard_error]=NanAvErr(data,col]-- works
% NOTE: Prerequisite for the script: shocking 

% Space and Atmospheric Physics Group
% The Blackett Laboratory - Imperial College London

if ~exist('QuietZeroNoisyOne','var')||isempty(QuietZeroNoisyOne)
    QuietZeroNoisyOne=1;
end

sum_realdata=0;
sum_realelem=0;
sum_sqdiff=0;
average=0;
standard_error=0;

%Check the data's oriented correctly - warns if it's not in the format
%specified above. Will print erroneously if there are fewer rows than columns for a good reason, 
%say only a brief time's being considered.
if QuietZeroNoisyOne~=0
    if size(data,2)>=size(data,1)
        disp(char('','Note your data has more columns than rows - this function provides',...
                  'an average and standard error for the data in a particular column ',...
                  'of your data; are you sure your data''s oriented correctly?','',...
                  'Check, as otherwise the answer this function provides won''t', 'be the one you expect!',''));
    end
end

%Working out the average
for i=1:size(data,1) %Looks at all the rows of 'data'
        if isnan(data(i,col))~=1 %If the element in column 'col', in the ith row of 'data' isn't a NaN then that 
                                 %element contributes to the sum, and the overall count of elements is incremented. 
                                 %NB can't use data(i,col)==NaN as the condition; NaNs are never equal in Matlab.
            sum_realdata=sum_realdata+data(i,col);
            sum_realelem=sum_realelem+1;
        elseif isnan(data(i,col))==1 %being explicit that nothing happens if a NaN is found - the sum is unchanged
            sum_realdata=sum_realdata;
            sum_realelem=sum_realelem;
        end  
end

if sum_realelem~=0
    average=sum_realdata/sum_realelem;
elseif sum_realelem==0
    if QuietZeroNoisyOne~=0
        disp(char('','DaoMei! All your data''s NaNs',''))
    end
end

%Working out the standard deviation
for i=1:size(data,1)
        if isnan(data(i,col))~=1
            sum_sqdiff=sum_sqdiff+((data(i,col)-average)^2);
        elseif isnan(data(i,col))==1
            sum_sqdiff=sum_sqdiff;
        end
end

standard_error=sqrt(sum_sqdiff)/(sqrt(sum_realelem)*sqrt(sum_realelem-1));

return