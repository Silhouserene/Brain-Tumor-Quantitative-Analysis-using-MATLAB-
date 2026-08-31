clc;
clear all;
close all;

%% 1. LOAD ALL DICOM IMAGES

folder = 'YOUR_DICOM_FOLDER_PATH';

files = dir(fullfile(folder, '*.dcm'));

num_images = length(files);

fprintf('Number of DICOM images found: %d\n', num_images);


%% 2. CREATE FOLDERS FOR FINAL IMAGES AND DICOM INFO

output_folder = fullfile(folder, 'Processed_Images');
info_folder = fullfile(folder, 'DICOM_Info');

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

if ~exist(info_folder, 'dir')
    mkdir(info_folder);
end


%% 3. PROCESS ALL IMAGES

for k = 1:num_images

    %% Load DICOM

    filename = fullfile(folder, files(k).name);

    img = dicomread(filename);

    info = dicominfo(filename);


    %% Grayscale

    if size(img,3) == 3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end


    %% Normalization

    Normimg = mat2gray(gray_img);


    %% Resize

    img_re = imresize(Normimg, 2, 'bicubic');


    %% Filtering

    img_denoised = medfilt2(img_re, [3 3]);


    %% Contrast Enhancement

    img_enhanced = adapthisteq(img_denoised);


    %% Save FINAL processed image

    imwrite(img_enhanced, ...
        fullfile(output_folder, ...
        sprintf('Processed_Slice_%03d.png', k)));


    %% Save DICOM information

    info_filename = fullfile(info_folder, ...
        sprintf('DICOM_Info_Slice_%03d.txt', k));

    diary(info_filename);

    disp(info);

    diary off;


    fprintf('Processed Slice %d/%d\n', k, num_images);

end


fprintf('\nAll images and DICOM information saved successfully.\n');