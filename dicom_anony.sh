#!/bin/bash

path=/media/bjing/NEW/healthy_data/rest/1/
target=/media/bjing/NEW/healthy_data/rest_anony/1


for file in $(ls $path); do
    echo $file
    #cd $path/$file
    for sub in $(ls $path/$file); do
    echo $sub
    mkdir -p $target/$file/$sub
    dicom-anonymizer $path/$file/$sub $target/$file/$sub
    done
    
done
