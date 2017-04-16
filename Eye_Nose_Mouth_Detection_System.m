clear all;
close all;

k=imread('1.png'); %image to be read. For the viva I used 5 png photos for demonstarte the system.
I=k(:,:,1);

%% Here "vision.CascadeObjectDetector(") is located in the package called "vision". This one can detect objects using the "Viola-Jones algorithm".

% Bellow code is to detect the face of the loaded image
faceDetect = vision.CascadeObjectDetector();
bbox=step(faceDetect,I);
face=imcrop(I,bbox); 
centerx=size(face,1)/2+bbox(1);
centery=size(face,2)/2+bbox(2);

% Bellow code is to detect the eyes of the loaded image
eyeDetect = vision.CascadeObjectDetector('RightEye');
eyebox=step(eyeDetect,face);
n=size(eyebox,1);
e=[];
for it=1:n
    for j=1:n
        if (j > it)
          if ((abs(eyebox(j,2)-eyebox(it,2))<68)&& (abs(eyebox(j,1)-eyebox(it,1))>40))
            e(1,:)=eyebox(it,:);
            e(2,:)=eyebox(j,:);
            d=1;break;
          end
        end
    end
    if(d == 1)
        break;
    end
end
eyebox(1,:)=e(1,:);
eyebox(2,:)=e(2,:);
c=eyebox(1,3)/2;
d=eyebox(1,4)/2;
eyeCenter1x=eyebox(1,1)+c+bbox(1);
eyeCenter1y=eyebox(1,2)+d+bbox(2);
e=eyebox(2,3)/2;
f=eyebox(2,4)/2;
eyeCenter2x=eyebox(2,1)+e+bbox(1);
eyeCenter2y=eyebox(2,2)+f+bbox(2);

% Bellow code is to detect the nose of the loaded image
ndetect=vision.CascadeObjectDetector('Nose','MergeThreshold',16);
nosebox=step(ndetect,face);
noseCenterx=nosebox(1,1)+(nosebox(1,3)/2)+bbox(1);
noseCentery=nosebox(1,2)+(nosebox(1,4)/2);
m=[1,noseCentery,size(face,1),((size(face,2))-noseCentery)];
mouth=imcrop(face,m);

% Bellow code is to detect the mouth of the loaded image
mdetect=vision.CascadeObjectDetector('Mouth','MergeThreshold' ,20);
mouthbox=step(mdetect,mouth);
for it=1:size(mouthbox,1)
    if(mouthbox(it,2)>20)
        mouthbox(1,:)=mouthbox(it,:);
        break;
    end
end
mouthbox(1,2)=mouthbox(1,2)+noseCentery;
noseCentery=noseCentery+bbox(2);

mouthCenterx=mouthbox(1,1)+(mouthbox(1,3)/2)+bbox(1);
mouthCentery=mouthbox(1,2)+(mouthbox(1,4)/2)+bbox(2);
shape=[centerx centery;eyeCenter1x eyeCenter1y;eyeCenter2x eyeCenter2y;noseCenterx noseCentery;mouthCenterx mouthCentery];

%%

%To get the bound boxes for the detected points of the image
 eyebox(1,1:2)=eyebox(1,1:2)+bbox(1,1:2);
 eyebox(2,1:2)=eyebox(2,1:2)+bbox(1,1:2);
 nosebox(1,1:2)=nosebox(1,1:2)+bbox(1,1:2);
 mouthbox(1,1:2)=mouthbox(1,1:2)+bbox(1,1:2);
 all_points=[eyebox(1,:);eyebox(2,:);nosebox(1,:);mouthbox(1,:)];
 dpoints=size(all_points,1);
 label=cell(dpoints,1);
 
 
 i=1;
 for i = 1: dpoints
 label{i}=[num2str(i)];
 i=i+1;
 end
 
 videoout=insertObjectAnnotation(I,'rectangle',all_points,label,'TextBoxOpacity',0.2,'Fontsize',9);
 imshow(videoout);hold on;plot(shape(:,1),shape(:,2),'.','MarkerSize',10);