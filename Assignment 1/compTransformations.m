function [ transformations ] = compTransformations(path, step_size, print_step)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

addpath ./SupplementalCode/

if nargin < 1
    path = './Data/data/';
end

if nargin < 2
    step_size = 1;
end

if nargin < 3
   print_step = true; 
end


file = fullfile(path, '*.pcd');
d = dir(file);


file_names = [];
for k = 1:numel(d)
  filename = fullfile(path,d(k).name);
  if ~contains(filename, 'normal')
     file_names = [file_names; filename];
  end
end

transformations = cell(length(file_names), 4);

for file_no = 1:step_size:length(file_names)-1
    if print_step
        disp("Step")
        disp(file_no)
    end
    
    frame1_filename = file_names(file_no,   :);
    frame2_filename = file_names(file_no+1, :);
    
    frame1 = readPcd(frame1_filename);
    frame1 = frame1(:, 1:3).';
    
    frame2 = readPcd(frame2_filename);
    frame2 = frame2(:, 1:3).';

    [ R, t ] = merge(frame1, frame2);
    transformations{file_no, 1} = num2cell(R);
    transformations{file_no, 2} = num2cell(t);
    transformations{file_no, 3} = num2cell(file_no);
    transformations{file_no, 4} = num2cell(file_no+1);
end

save('Output/transformations.mat', 'transformations');

end

