#!/bin/bash

# Create managed instance group
gcloud compute instance-groups managed create dev-instance-group \
    --template=dev-instance-template \
    --size=1 \
    --region=$REGION

# Configure Autoscaling
gcloud compute instance-groups managed set-autoscaling dev-instance-group \
    --region=$REGION \
    --min-num-replicas=1 \
    --max-num-replicas=3 \
    --target-cpu-utilization=0.6 \
    --mode=on

# Validation

gcloud compute instance-groups managed describe dev-instance-group --region=$REGION

# Check autoscaling policies:

gcloud compute instance-groups managed describe-autohealing dev-instance-group --region=$REGION
