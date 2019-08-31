% Wavelet image compression - RGB images
clear all;
close all; 
% Reading an image file
% im = input('Enter a image');
filedir='iris_dataset\CASIA';
num=0;
for i =1:108
    if(i==2 ||  i==6)
        continue;
    end
    if(i<10)
        currentdir=[filedir,'\00',num2str(i),'\'];
    elseif(i<100)
        currentdir=[filedir,'\0',num2str(i),'\'] ;
    else
        currentdir=[filedir,'\',num2str(i),'\'] ;
    end
    for j=1:2
        images=dir([currentdir,num2str(j),'\*.bmp']);
        nfiles = length(images);
        for k=1:nfiles
            currentfilename=[currentdir,num2str(j),'\',images(k).name];
            X=imread(currentfilename);
            num=num+1;
            % inputting the decomposition level and name of the wavelet
            % n=input('Enter the decomposition level');
            % wname = input('Enter the name of the wavelet');
            n=2;
            wname='haar';
            x = double(X);
            NbColors = 255;
            map = gray(NbColors);
            x = uint8(x);
            
            % A wavelet decomposition of the image
            [c,s] = wavedec2(x,n,wname);
            % wdcbm2 for selecting level dependent thresholds  
            alpha = 1.5; m = 2.7*prod(s(1,:));
            [thr,nkeep] = wdcbm2(c,s,alpha,m);
            % Compression
            [xd,cxd,sxd,perf0,perfl2] = wdencmp('lvd',c,s,wname,n,thr,'h');
            disp('Compression Ratio');
            disp(perf0);
            % Decompression
            R = waverec2(c,s,wname);
            rc = uint8(R);
            imwrite(rc,[currentdir,num2str(j),'\com_',images(k).name]);
        end
    end
end
