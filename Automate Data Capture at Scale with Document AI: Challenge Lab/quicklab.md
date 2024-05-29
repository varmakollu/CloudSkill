# Automate Data Capture at Scale with Document AI: Challenge Lab

```
export REGION=
```
```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/main/Automate%20Data%20Capture%20at%20Scale%20with%20Document%20AI%3A%20Challenge%20Lab/gsp367.sh
sudo chmod +x gsp367.sh
./gsp367.sh
```

```
export PROJECT_ID=$(gcloud config get-value core/project)

gsutil cp ~/document-ai-challenge/invoices/* gs://$PROJECT_ID-input-invoices/
```

## Congratulations, you're all done with the lab 😄
