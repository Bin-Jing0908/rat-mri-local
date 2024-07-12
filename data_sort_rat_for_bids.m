%%data prepare for bids transformation
datapath='C:\Users\209\Desktop\dicom';
savepath='C:\Users\209\Desktop\dicom_dpabi';
list=dir(datapath);
for i=3:size(list,1)
    cd(strcat(list(i).folder,'\',list(i).name));
    num=dir('MRI*');
    fullname=list(i).name;
    newname=fullname(19:end-26);
    if size(num,1)==38
        mkdir(strcat(savepath,'\T1Raw\',newname));
        copyfile('MRI*',strcat(savepath,'\T1Raw\',newname));
    end
     if size(num,1)==7600
        mkdir(strcat(savepath,'\FunRaw\',newname));
        copyfile('MRI*',strcat(savepath,'\FunRaw\',newname));
     end
end