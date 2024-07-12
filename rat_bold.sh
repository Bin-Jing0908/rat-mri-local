# provide path to templates and masks. 
template=/home/jovyan/neurodesktop-storage/SIGMA/SIGMA_Rat_Anatomical_Imaging/InVivo/SIGMA_InVivo_Brain_Template.nii
mask=/home/jovyan/neurodesktop-storage/SIGMA/SIGMA_Rat_Anatomical_Imaging/InVivo/SIGMA_InVivo_Brain_Mask.nii
wm=/home/jovyan/neurodesktop-storage/SIGMA/SIGMA_Rat_Anatomical_Imaging/InVivo/SIGMA_InVivo_WM_mask.nii
csf=/home/jovyan/neurodesktop-storage/SIGMA/SIGMA_Rat_Anatomical_Imaging/InVivo/Reslice_SIGMA_InVivo_CSF_mask.nii
atlas=/home/jovyan/neurodesktop-storage/SIGMA/SIGMA_Rat_Brain_Atlases/SIGMA_Anatomical_Atlas/InVivo_Atlas/SIGMA_InVivo_Anatomical_Brain_Atlas.nii
#roi=/template/roi/
TR=2.0
bids_folder=//home/jovyan/Desktop/BIDS/export/
preprocess_folder=/home/jovyan/Desktop/BIDS/preprocess/
confound_folder=/home/jovyan/Desktop/BIDS/preprocess_confound/
cd ${bids_folder}
ls . | while read line
do
mkdir -p ${preprocess_folder}${line}
mkdir -p ${confound_folder}${line}
rabies -p MultiProc preprocess ${bids_folder}${line} ${preprocess_folder}${line} \
--anat_template ${template} \
--brain_mask ${mask} \
--WM_mask ${wm} \
--CSF_mask ${csf} \
--vascular_mask ${csf} \
--labels ${atlas} \
--TR ${TR}s \
--fast_commonspace \
--commonspace_resampling 0.3x0.3x0.3 \
--anat_inho_cor_method N4_reg \
--bold_inho_cor_method N4_reg \
--anat_autobox \
--coreg_script Rigid 
#### Confound regression list
#1. aroma + 0.01 - 0.1 Hz bandpass filter (aromas)
denoise_list=("aromas")
#("aromas" "aromal" "GSRs" "WMCSFs" "aromasr")
denoise_parameters=("--lowpass 0.1 --run_aroma --aroma_dim 10" "--lowpass 0.20 --run_aroma --aroma_dim 10" "--lowpass 0.1 --conf_list global_signal mot_6" "--lowpass 0.1 --conf_list WM_signal CSF_signal mot_6" "--lowpass 0.1 --run_aroma --aroma_dim 10 --apply_scrubbing")
for denoise in ${denoise_list[*]}; do
id=$(echo ${denoise_list[@]/$denoise//} | cut -d/ -f1 | wc -w | tr -d ' ')
echo $id
param=${denoise_parameters[$id]}
rabies -p MultiProc confound_correction ${preprocess_folder}${line} ${confound_folder}${line} \
--read_datasink \
--TR ${TR} \
--highpass 0.01 \
--smoothing_filter 0.5 ${param}
done
done
