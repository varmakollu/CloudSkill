# Get Started with Cloud Storage - Challenge Lab


```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/main/Get%20Started%20with%20Cloud%20Storage%20Challenge%20Lab/quicklabarc111.sh

chmod +x quicklabarc111.sh

./quicklabarc111.sh

```

## Special Case Step 1 
- To create a bucket with the Nearline storage class using gsutil, you can use the following command:

```
gsutil mb -p $BUCKET -c nearline gs://$BUCKET-bucket
```
