% Wavelet image compression - RGB images
clear all;
close all; 
% Reading an image file
% im = input('Enter a image');
filedir='F:\Mycompleted task\Matlab_image project\image compression\iris_dataset\CASIA';
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
            Orig_I1 = double(imread(currentfilename));
            Orig_I=imresize(Orig_I1,[512 512]);
            rate = 1;

            OrigSize = size(Orig_I, 1);
            max_bits = floor(rate * OrigSize^2);
            OutSize = OrigSize;
            image_spiht = zeros(size(Orig_I));
            [nRow, nColumn] = size(Orig_I);
            n = size(Orig_I,1);
            n_log = log2(n); 
            level = n_log;
            % wavelet decomposition level can be defined by users manually.

            type = 'bior4.4';
            [Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);

            [I_W, S] = func_DWT(Orig_I, level, Lo_D, Hi_D);
            img_enc = func_SPIHT_Enc(I_W, max_bits, nRow*nColumn, level);   

            img_dec = func_SPIHT_Dec(img_enc);

            img_spiht = func_InvDWT(img_dec, S, Lo_R, Hi_R, level);
            f='compress';
            mkdir(f);
            imwrite(img_spiht, gray(256), [f,'\com_',images(k).name], 'bmp');
            
            Q = 255;
            MSE = sum(sum((img_spiht-Orig_I).^2))/nRow / nColumn;
            fprintf('The psnr performance is %.2f dB\n', 10*log10(Q*Q/MSE));
            
        end
    end
end





