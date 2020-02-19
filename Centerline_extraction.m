%% Add the folder used for centerline extraction
addpath('phi-max-skeleton3d-matlab-c534cab')
addpath('example vessel')
%% Load your vessel image
cd 'example vessel/'
files=dir('*.dcm');
info = dicominfo(files(1,1).name);
for l=1:numel(files)
    img=dicomread(files(l,1).name);
   Image(:,:,l) = img;
end
pixel_size= info.PixelSpacing(1);
Image = double(Image);
cd '/Users/zhennongchen/Documents/GitHub/Senior_Project_code'
%% Additional step: elongate the vessel (only use when centerline extraction algorithm failed at the end of vessel)
% add additional slices at the end of the vessel to improve the result of
% centerline extraction
elongated_slice_number=3;
Image=double(Image);
Image_2=[];
for i=1:(size(Image,3)+elongated_slice_number)
    if i<1+elongated_slice_number
        Image_2(:,:,i)=Image(:,:,1);
    else
        Image_2(:,:,i)=Image(:,:,i-elongated_slice_number);
    end
end
Image=Image_2;clear Image_2
%% centerline extraction
% set a suitable threshold which need to be determined by yourself after
% trials
Image_binary=Image>250;
% centerline extraction
skel = Skeleton3D(Image_binary);

% view the centerline output    
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
% you should output the image same as centerline_example.png
%% Get the coordiantes for all center points
[x,y,z]=ind2sub(size(skel),find(skel==1));