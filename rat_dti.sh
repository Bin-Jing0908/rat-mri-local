#!/bin/bash

path=~/neurodesktop-storage/dat  

for file in $(ls $path); do
    echo $file
    cd $path/$file
    mrconvert dwi_btable.nii DTI.mif -grad grad_btable_fix.txt
    dwidenoise DTI.mif dDTI.mif
    mrdegibbs dDTI.mif gdDTI.mif
    dwifslpreproc gdDTI.mif pgdDTI.mif -rpe_none -pe_dir LR -eddy_options " --slm=linear"
    dwibiascorrect ants pgdDTI.mif bpgdDTI.mif
    dwi2tensor bpgdDTI.mif tensor.mif
    tensor2metric -fa FA.nii.gz tensor.mif
    tensor2metric -adc MD.nii.gz tensor.mif
    tensor2metric -ad AD.nii.gz tensor.mif
    tensor2metric -rd RD.nii.gz tensor.mif
done
