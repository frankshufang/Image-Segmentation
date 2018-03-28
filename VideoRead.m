obj = VideoReader('D:\CMU\2017 Fall\Research\ImageSegmentation\highcurvedonly.mp4');%输入视频位置
WriterObj=VideoWriter('CanalSegmentation3.avi');
numFrames = obj.CurrentTime;% 帧的总数
open(WriterObj);
figure(1)
for k = 261 : 5 : 401
    frame = read(obj,k);%读取第几帧
%     frame(1:50,:,:)=[];
%     frame(end-49:end,:,:)=[];
%     frame(:,1:30,:)=[];
%     frame(:,end-29:end,:)=[];
    imshow(frame);%显示帧
    hold on
%     frame=uint8(floor(double(frame)/16)*16+8);
%     imshow(frame);
%     [bw,mask] = segmentImage(frame);
    [I, mask] = MarkerControlled_Watershed(frame);
    for i = 1 : 3
        I1(:, :, i) = I;
    end
    Imask = imadd(I1, mask);
    imwrite(Imask, strcat('D:\CMU\2017 Fall\Research\ImageSegmentation\frame', num2str(k), '.jpg'), 'jpg');% 保存帧
    writeVideo(WriterObj, Imask);
end
close(WriterObj);