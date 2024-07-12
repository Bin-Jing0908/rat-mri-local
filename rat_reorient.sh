root_dir='/home/jovyan/Desktop/BIDS/data/'
module load fsl
module load afni
cd $root_dir
output_dir='/home/jovyan/Desktop/BIDS/export/'
mkdir -p $output_dir
ls . | while read line
do
echo $line
output_sub_dir=$output_dir$line
mkdir -p $output_sub_dir'/anat'
mkdir -p $output_sub_dir'/func'
anat_name=$line'_T1w.nii'
func_name=$line'_task-rest_bold.nii'
cd $root_dir$line'/anat'
fslmaths $anat_name tmp.nii.gz
fslorient -deleteorient tmp.nii.gz
fslswapdim tmp.nii.gz x z y tmp2.nii.gz
3dresample -input tmp2.nii.gz -prefix $output_sub_dir'/anat/'$anat_name
rm tmp.nii.gz
rm tmp2.nii.gz
cd $root_dir$line'/func'
fslmaths $func_name tmp.nii.gz
fslorient -deleteorient tmp.nii.gz
fslswapdim tmp.nii.gz x z y tmp2.nii.gz
3dresample -input tmp2.nii.gz -prefix $output_sub_dir'/func/'$func_name
rm tmp.nii.gz
rm tmp2.nii.gz
echo $line >> $output_sub_dir/'info'
cd ..
done
cd ../export
tree
