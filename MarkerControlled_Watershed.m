function [I, Lrgb] = MarkerControlled_Watershed(HandImage)  
%��Ƿ����Ƶķ�ˮ���㷨  
%��̳̺�����ͬ��������û�ж���Ĳ����ע�ͣ�ֱ��ʵ��  
%չʾ�Ľ��ͼ���ٸ�����  
  
close all;  
  
%%  
%����һ����ȡ��ɫͼ��ת��Ϊ�Ҷ�ͼ  
% HandImage = imread('frame152.jpg');  
I = rgb2gray(HandImage);  
  
%���ԭͼ�У�Ŀ�������ǽϰ��ģ���������෴���������ȡ��  
% Fan=ones(size(I,1),size(I,2))*255;  
% Fan=uint8(Fan);  
% Fan=Fan-I;  
% I=Fan;  
figure()
imshow(I), title('Original Image')  
%%  
%******************������������ؽ��Ŀ��ղ���************************************  
  
se = strel('disk',20);%diskָ������һ��Բ�εĽṹ�壬�ڶ�������ָ���ṹ��İ뾶  

%�����������л����ؽ��Ŀ�������ʹ��imerode��imreconstruct����ʵ��  
Ie = imerode(I, se);%�ȸ�ʴ��erosion��  
Iobr = imreconstruct(Ie, I);%���ؽ�  
  
Iobrd = imdilate(Iobr, se);%�ڻ����ؽ��Ŀ������Ľ�������ϣ����и�ʴ  
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));%�ؽ������ͼ��Ϊ��ʴ��ͼ��ȡ����ģ��Ϊ��ʴǰԭͼȡ����  
Iobrcbr = imcomplement(Iobrcbr);%�ؽ������ȡ�����õ�ʵ�ʻ����ؽ��ıղ����Ľ����  
figure  
imshow(Iobrcbr)%, title('�����ؽ��Ŀ�+�ղ��� (Iobrcbr)')  
  
  
%%  
%******************�����������ǰ������************************************  
%����Iobrcbr�����򼫴�ֵ���õ��õ�ǰ����ǡ�  
%�õ���ǰ�����ͼfgm�Ƕ�ֵͼ����ɫ��Ӧǰ������  
fgm = imregionalmax(Iobrcbr);  
  
%Ϊ�˷�����ͽ������ǰ�����ͼ���ӵ�ԭʼͼ����  
I2 = I;  
I2(fgm) = 255;%��fgm�е�ǰ����������ֵΪ1����ǵ�ԭͼ�ϣ��ð�ɫ��  
  
%ע�⵽һЩ�󲿷��غϻ���Ӱ�ڵ�������û�б���ǳ���������ζ����Щ�������տ��ܲ��ᱻ��ȷ�ķָ������  
%���ң���Щ������ǰ�������ȷ�ĵ���������ı�Ե������ζ����Ӧ���������ǰ߿�ı�Ե����������һ�㡣  
%�����ͨ���ȱղ������ٸ�ʴ������㡣  
se2 = strel(ones(5,5));  
fgm2 = imclose(fgm, se2);  
fgm3 = imerode(fgm2, se2);  
  
%��������ᵼ��������һЩ��Ⱥ�Ĺ����㣬��Щ����Ҫ���Ƴ��ġ�  
%�����ͨ��bwareaopen������㣬�������Ƴ���Щ�������ص��������ָ��ֵ������  
fgm4 = bwareaopen(fgm3, 2000);
I3 = I;  
I3(fgm4) = 255;  
  
%%  
%*********************���Ĳ������㱳�����**********************************  
%��������Ƴ��ı�Ǳ����㷨��ǰ������ǣ�ͼ����������������壬��԰��������Ǳ�����  
%����������������裬��ǽ�����ܲ�������  
  
%��������Ҫ��Ǳ�������ȥ�������ͼ��Iobrcbr�У����������ڱ���������������Ƚ���һ����ֵ������  
bw = imbinarize(Iobrcbr);  
% bw=im2bw(Iobrcbr,graythresh(Iobrcbr));%��ʹ����һ�д��뱨���ˣ��ʻ���һ�ֶ�ֵ������  
  
%�������������Ǻڵ��ˣ�����������������ǲ�ϣ���������̫�ӽ�������Ҫ�ָ������ı߽硣  
  
D = bwdist(bw);  
%D = bwdist(BW)�����ֵͼ��BW��ŷ����þ��󡣶�BW��ÿһ�����أ�����任ָ�����غ������BW�������صľ��롣  
%bwdistĬ��ʹ��ŷ����þ��빫ʽ��BW����������ά����D��BW��ͬ���Ĵ�С��  
  
%����bw��Ŀ�������ǰ�ɫ��1.����D�ж�Ӧ��Ŀ�����崦����0�����Ž��뱳��Խ���Ӧ����ֵԽ��  
%��ʱ���÷�������ʹ�÷�ˮ���㷨�ļ��裨��ֳ���Ŀ��������ֵ�ϵͣ�  
%���ǵõ��ı�������� �����뱳�����һ��Ȧ���ܹ���סĿ������  
DL = watershed(D);  
bgm = DL == 0;%��ˮ��任���L�У�ͬһ������ͬһ���ֱ�ʾ�������ֽ���ͬһ��0��ʶ  
  
%%  
%******************���岽������ָ�����޸ĺ󣩵ķ�ˮ��任*****************  
% ����imimposemin���Ա������޸�һ��ͼƬ��ʹ����ֻ��ָ����λ�ô�ȡ�þֲ���Сֵ  
% ���������ʹ��imimposemin���޸��ݶȷ�ֵͼ��ʹ�þֲ���Сֵֻ������ǰ����Ǻͱ�����Ǵ���  
% �ӽ������imimposemin�Ὣָ��������Ϊ-Inf���Ӷ���Ϊ��Сֵ  
% ��ͼ�����൱��ƽ������һ������ͬ��ֵ������  
  
  
%ʹ��Sobel��Ե������ӣ�imfilter��������һЩ�򵥵����������������ݶȷ�ֵ��  
%�ݶ�ֵ����������ı�Ե���ߣ��������������ڲ��͡�  
hy = fspecial('sobel');%��ȡsobel����ģ�壬���������ݶ�  
hx = hy';%����ģ��  
Iy = imfilter(double(I), hy, 'replicate');%���������ݶ�
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);%�����ݶȷ�ֵ  
  
gradmag2 = imimposemin(gradmag, bgm | fgm4);
  
%Finally we are ready to compute the watershed-based segmentation.  
L = watershed(gradmag2);
% maxL = 1 : max(max(L));
% frequency = histc(L, maxL);
% frequency = sum(frequency,2);
% [~, maxF] = max(frequency);
% [row, col] = find(L==maxF);
% L(row, col) = 0;
  
%%  
%******************�����������ӻ����************************************  
I4 = I;  
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;  
figure()   
imshow(I4)  
% title('��ԭͼ�ϻ���ǰ����������ǣ��Լ��ָ�߽�')  
  
  
Lrgb = label2rgb(L, 'jet', 'w', 'noshuffle');  
figure() 
imshow(Lrgb)  
% % title('Colored watershed label matrix (Lrgb)')  
%   
% figure(1)  
% imshow(I)  
% hold on  
% himage = imshow(Lrgb);  
% himage.AlphaData = 0.3;  
% title('Lrgb superimposed transparently on original image')  
  
  
end