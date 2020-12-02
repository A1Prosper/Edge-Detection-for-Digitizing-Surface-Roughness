function k=DEM_surf_1()
a1 = 200; %height of frame (width of cropping rect)
a2 = 930; %width of frame (length of cropping rect)
a3 = 934; %number of frames
a4 = 5; %index of frame width
a5 = 1/a4;
c1 = 10; %1st column of cropping rect
c2 = 240; %1st row of cropping rect
b=zeros(a1,a2,a3);
for x=1:a3        %This block goes through all the frames, converts to gray scale and detects the edges
    if x<10
        jpgFileName = strcat('image','_', '00',num2str(x), '.jpg');
    elseif x<100
        jpgFileName = strcat('image','_', '0',num2str(x), '.jpg');
    else
        jpgFileName = strcat('image','_',num2str(x), '.jpg'); 
    end
    r=imread(jpgFileName);
    crop_ = imcrop(r,[c1 c2 a2-1 a1-1]); %crops the image to outline only the are around the laser line
    e=rgb2gray(crop_);
    f=edge(e,'Canny',[0.2,0.4]); %detects the edges of the laser line on each of the frames 
    b(:,:,x)=f;     %compiles all the frames into a 3D matrix
    %figure
    %imshow(f)
end
[q,r,s]=size(b);    %This block goes through each column from bottom up and picks the z position of the lower edge
k=zeros(a2/a4,a3);
for h=1:s %indexes the frames 
    for g=1:a4:r %indexes thru the length of each photo frame a4 points at a time 
        for i=q:-1:1 %indexes thru the columns of each frame
            if b(i,g,h)==1  %lower edge of laser line                          
                k(round(g*-a5+((a2/a4)+a5)),h)=i; %2D matrix of edge elevation
                break      %jumps to the next column after locating the first edge
            end     
        end 
    end
end
[l,m]=size(k);      % The following block fill areas where edges were not detected (blanks)
for n=1:l
    for o=1:m
        if n==1 || n==2 || n==3
            if k(n,o)==0
                k(n,o)=k(n+1,o);            
            end
        else
            if k(n,o)==0
                k(n,o)=k(n-1,o);
            end
        end
    end
end 
for p=1:m
    k(:,p)=smooth(k(:,p));  %smoothens the final matrix column-wise
end
for q=1:l
    k(q,:)=transpose(smooth(k(q,:))); %smoothens the final matrix row-wise
end
%k = transpose(transpose(k));
end