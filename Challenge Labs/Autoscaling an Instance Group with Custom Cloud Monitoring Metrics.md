# Autoscaling an Instance Group with Custom Cloud Monitoring Metrics - GSP087

```
gcloud compute instance-templates create autoscaling-instance01 --metadata=startup-script-url=gs://YOUR_BUCKET_NAME/startup.sh,gcs-bucket=gs://YOUR_BUCKET_NAME
```
