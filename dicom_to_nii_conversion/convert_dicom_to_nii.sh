#!/usr/bin/env bash

# run in terminal of your own laptop 

##############
## Settings ##
##############

# comment these out if causing errors
set -o nounset
set -o errexit
set -o pipefail

#shopt -s globstar nullglob

###########
## Logic ##
###########

# define the folder where dcm2niix function is saved
dcm2niix_fld="/Users/bowmore1/Documents/Zhennong/sort_AUH_code/dcm2niix_11-Apr-2019/"


# define the folder where the patients are saved
# an asterisk '*' can be used if you want all patients in one folder
readonly PATIENTS=(/Volumes/mcveighlab_01/Zhennong_VR_Data/Abnormal/CVC1909251456/ )
#readonly PATIENTS=(/Volumes/mcveighlab_01/Zhennong_VR_Data/Abnormal/*/ )

# define dicom image folder
img_fld="img-dcm"

for p in ${PATIENTS[*]};
do
	
  # check whether this patient has dicom image folder
  if [ -d ${p}${img_fld} ];
  then
	echo ${p}

  output=${p}img-nii # different directory from dicom image folder
  mkdir -p ${output}

  # check whether already converted
  if [ -d ${output} ] && [ "$(ls -A  ${output})" ];then
    echo "already done"
    continue
  fi

  # find all the subfolders (each subfolder represent one time frame during the heartbeat)
  IMGS=(${p}${img_fld}/*/)
  
  for i in $(seq 0 $(( ${#IMGS[*]} - 1 )));
      do

      echo ${IMGS[${i}]}
      # assert whether there are dicom files in this subfolder
      if [ "$(ls -A ${IMGS[${i}]})" ]; then # if dcm2niix doesn't successfully convert, try to remove -i y

        # main conversion function
        ${dcm2niix_fld}dcm2niix -i y -m y -b n -o ${output}/ -f "${i}" -9 -z y "${IMGS[${i}]}"
      
      else
        echo "${IMGS[${i}]} is emtpy; Skipping"
        continue
      fi
      
    done

  else
    echo "${p} missing dicom image folder"
    continue
    
  fi
done
