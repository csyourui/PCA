clear
clc
mkdir('compare');
for test=2:2
mkdir('photo');
mkdir('result');
lamda=0.001;

file_name = sprintf('%d%s',test,'.avi');        
obj = VideoReader(file_name);    
 
numFrames = obj.NumberOfFrames;    
for k = 1: numFrames
    frame = read(obj,k);          
    gray_frame = rgb2gray(frame);
    imshow(frame);               
    imwrite(gray_frame,strcat('./photo/',num2str(k),'.jpg'),'jpg');
end


DIR='./photo/';     
file=dir(strcat(DIR,'*.jpg'));             
filenum=size(file,1);                      

fname = strcat(DIR, num2str(1), '.jpg');   
frame = imread(fname);                     
rows = size(frame(:),1);                   
XX = zeros(rows, filenum);                

for k = 1: filenum
    fname = strcat(DIR, num2str(k), '.jpg');
    frame = imread(fname);
    x = frame(:);
    XX(:, k) = x;
    
end

A = im2double(XX);
siz = size(frame);
D = size(A);
lamda = 1/sqrt(D(1,1));



[B,Q,iter]= inexact_alm_rpca(A,0.007);


DIR= sprintf('%s%d%s','./result/',test,'/');
mkdir(DIR);
for i = 1:D(1,2)
    k = 1;
    frame = uint8(zeros(siz(1,1),3*siz(1,2)));
    for y = 1: siz(1,2)
        for x = 1: siz(1,1)
            frame(x,y)=A(k,i);
            k=k+1;
        end
    end
    k = 1;
    for y = siz(1,2)+1: 2*siz(1,2)
        for x = 1: siz(1,1)
            frame(x,y)=B(k,i);
            k=k+1;
        end
    end
    k = 1;
    for y = 2*siz(1,2)+1: 3*siz(1,2)
        for x = 1: siz(1,1)
            frame(x,y)=abs(Q(k,i));
            k=k+1;
        end
    end
    imwrite(frame,strcat(DIR,num2str(i),'.jpg'));
end




%DIR=['./result/',test,'/'];  
file=dir(strcat(DIR,'*.jpg'));                
filenum=size(file,1); 
Counter = sprintf('%s%d%s','./compare/',test,'.avi')
obj_gray = VideoWriter(Counter);   
writerFrames = filenum;                     


open(obj_gray);
for k = 1: writerFrames
    fname = strcat(DIR, num2str(k), '.jpg');
    frame = imread(fname);
    writeVideo(obj_gray, frame);
end
close(obj_gray);


rmdir('photo','s');

end
% video=VideoReader('./对比/11.avi');     
% vidFrames = read(video);                   
% numFrames = get(video, 'numberOfFrames');
% 
% 
% for k = 1 : numFrames
%          mov(k).cdata = vidFrames(:,:,:,k);
%          mov(k).colormap = [];
% end
% hf=figure;                             
% 
% set(hf, 'position', [480 120 video.Width video.Height])
% 
% movie(hf, mov, 1, video.FrameRate);

  