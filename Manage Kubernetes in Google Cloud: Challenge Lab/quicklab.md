# Manage Kubernetes in Google Cloud: Challenge Lab

### Go to Logging > log base metric
### Metric type: <img src="https://github.com/Techcps/GSP-Short-Trick/assets/104138529/4df212f5-1e73-4bea-b706-3653d058e87e" width="25" height="25" /> Counter

### Log Metric Name:
```
pod-image-errors
```

### In the built filter box , add the following query:
```
resource.type="k8s_pod"
severity=WARNING
```

### Tap here to open the [Online Notepad](https://www.rapidtables.com/tools/notepad.html#)

### EXPORT to all the below variablbe:

```
export CLUSTER_NAME=

export ZONE=

export NAMESPACE=

export INTERVAL=

export REPO_NAME=

export SERVICE_NAME=
```

```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/main/Manage%20Kubernetes%20in%20Google%20Cloud%3A%20Challenge%20Lab/quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh
```

## Congratulations, you're all done with the lab 😄
