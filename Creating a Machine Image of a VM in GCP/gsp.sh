gcloud compute machine-images create $Machine_Image_Name \
    --source-instance=$VM_Name \
    --source-instance-zone=$GCP_Zone
