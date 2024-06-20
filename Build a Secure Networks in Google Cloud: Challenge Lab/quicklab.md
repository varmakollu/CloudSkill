# Build a Secure Google Cloud Network: Challenge Lab


### Tap here to open [Online Notepad](https://www.rapidtables.com/tools/notepad.html#)


### Export the below variables:

```
export IAP_NETWORK_TAG=

export INTERNAL_NETWORK_TAG=

export HTTP_NETWORK_TAG=

export ZONE=
```

```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/main/Build%20a%20Secure%20Networks%20in%20Google%20Cloud%3A%20Challenge%20Lab/quick322.sh
sudo chmod +x quick322.sh
./quick322.sh
```

```
gcloud compute ssh bastion --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet --command="gcloud compute ssh juice-shop --zone=$ZONE --internal-ip --quiet"
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
