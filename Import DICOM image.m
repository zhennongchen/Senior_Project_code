clear all;
close all;
%% Step 1: cd to the folder where all the dicom images are saved
% replace with your own folder
cd '/Users/zhennongchen/Documents/Zhennong_Senior project/Patient_000'
%% Step 2: find all the dicom files in this folder
files=dir('*.dcm'); 
info = dicominfo(files(1,1).name); % also get the info saved with dicom files
%pixel_size=info.PixelSpacing(1); % the size of one pixel in millimeter

% Combine all 2D images into one big 3D matrix, Image. 
% Image(x,y,z) = I can be interpreted as the pixel(x,y,z) in the image has
% brightness as I.

for l=1:numel(files)
    img=dicomread(files(l,1).name);
    %img = info.RescaleSlope.*img + info.RescaleIntercept;
    Image(:,:,l) = img; 
end
Image = double(Image);
%% Step 3: cd back to the folder where all your MATLAB codes are saved
% replace with your own folder
cd '/Users/zhennongchen/Documents/GitHub/Senior_Project_code'
%% Step 4: Visualize CT images in matlab
slice_number = 20 % choose which slice you want to visualize
figure(1)
imagesc(Image(:,:,slice_number)) 
% only visualize a certain ROI in this slice
figure(2)
imagesc(Image(100:200,200:300,slice_number)) 
% view slice series
figure(3)
montage(permute(Image(:,:,20:30),[1 2 4 3]),[min(Image(:)) max(Image(:))]);
% as you may find by yourself already, in the displayed image, the vertical
% axis is x-axis and the horizontal is y-axis.
%% Step 5: only visualize pixels in a certain brightness range
slice = Image(:,:,20);
