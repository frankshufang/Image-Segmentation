obj = VideoReader('D:\CMU\2017 Fall\Research\ImageSegmentation\highcurvedonly.mp4');%������Ƶλ��
WriterObj=VideoWriter('CanalSegmentation3.avi');
numFrames = obj.CurrentTime;% ֡������
open(WriterObj);
figure(1)
for k = 261 : 5 : 401
    frame = read(obj,k);%��ȡ�ڼ�֡
%     frame(1:50,:,:)=[];
%     frame(end-49:end,:,:)=[];
%     frame(:,1:30,:)=[];
%     frame(:,end-29:end,:)=[];
    imshow(frame);%��ʾ֡
    hold on
%     frame=uint8(floor(double(frame)/16)*16+8);
%     imshow(frame);
%     [bw,mask] = segmentImage(frame);
    [I, mask] = MarkerControlled_Watershed(frame);
    for i = 1 : 3
        I1(:, :, i) = I;
    end
    Imask = imadd(I1, mask);
    imwrite(Imask, strcat('D:\CMU\2017 Fall\Research\ImageSegmentation\frame', num2str(k), '.jpg'), 'jpg');% ����֡
    writeVideo(WriterObj, Imask);
end
close(WriterObj);