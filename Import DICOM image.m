clear all;
close all;
%% Step 1: cd to the folder where all the dicom images are saved
% replace with your own folder
%cd '/Users/zhennongchen/Documents/Zhennong_Senior project/Patient_000'
cd '/Users/zhennongchen/Documents/CorCTA w-c  3.0  B20f  0% - 9'
%% Step 2: find all the dicom files in this folder
files=dir('*.dcm'); 
info = dicominfo(files(1,1).name); % also get the info saved with dicom files
pixel_size=info.PixelSpacing(1); % the size of one pixel in millimeter

% Combine all 2D images into one big 3D matrix, Image. 
% Image(x,y,z) = I can be interpreted as the pixel(x,y,z) in the image has
% brightness as I.

for l=1:numel(files)
    img=dicomread(files(l,1).name);
    img = info.RescaleSlope.*img + info.RescaleIntercept;
    Image(:,:,l) = img; 
end
Image = double(Image);

%% Step 3: cd back to the folder where all your MATLAB codes are saved
% replace with your own folder
cd '/Users/zhennongchen/Documents/GitHub/Senior_Project_code'
%% Step 4: Visualize CT images in matlab
slice_number = 26 % choose which slice you want to visualize
figure(1)
imagesc(Image(:,:,slice_number)) 
% also can be displayed as greyscale image
window_level = -500
window_width = 2000
G = Turn_data_into_greyscale(Image(:,:,slice_number),window_level,window_width);
figure(2)
imshow(G)
%% Step 5: choose the region of interest for the calcium
calcium_point = [292,205,26];
ROI = Image(calcium_point(1)-15:calcium_point(1)+15,calcium_point(2)-15:calcium_point(2)+15,calcium_point(3)-5:calcium_point(3)+5);
%% step 6: set a threshold to find the centerline
Image_binary = ROI > 600; % set a reasonable threshold
skel = Skeleton3D(Image_binary); % centerline extract algorithm
% display the result
figure();
col=[.7 .7 .8];
hiso = patch(isosurface(Image_binary,0),'FaceColor',col,'EdgeColor','none');
hiso2 = patch(isocaps(Image_binary,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(Image_binary,hiso);
alpha(0.5);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;
w=size(skel,1);
l=size(skel,2);
h=size(skel,3);
[x,y,z]=ind2sub([w,l,h],find(skel(:)));
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','k','Color','k');            
set(gcf,'Color','white');
view(140,80)
%% step 7: extract all centerline point coordinate
% extract the coordinate of all center points
[x,y,z]=ind2sub(size(skel),find(skel==1));
