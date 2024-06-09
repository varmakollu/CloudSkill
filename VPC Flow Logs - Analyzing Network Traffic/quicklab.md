# VPC Flow Logs - Analyzing Network Traffic


### Set ZONE
```
export ZONE=
```

```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/main/VPC%20Flow%20Logs%20-%20Analyzing%20Network%20Traffic/quick212.sh
sudo chmod +x quick212.sh
./quick212.sh
```

```
CP_IP=$(gcloud compute instances describe web-server --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

export MY_SERVER=$CP_IP

for ((i=1;i<=50;i++)); do curl $MY_SERVER; done
```

## Congratulations, you're all done with the lab 😄
