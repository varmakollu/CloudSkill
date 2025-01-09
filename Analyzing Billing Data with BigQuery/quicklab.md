# Analyzing Billing Data with BigQuery || GSP621


### Run the following Commands in CloudShell

```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/refs/heads/main/Analyzing%20Billing%20Data%20with%20BigQuery/gsp621.sh

sudo chmod +x gsp621.sh

./gsp621.sh
```

* Go to **BigQuery** from [here](https://console.cloud.google.com/bigquery?)

```
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item FROM `billing_dataset.enterprise_billing` GROUP BY 1
```
```
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item, Count(*) as NUM FROM `billing_dataset.enterprise_billing` GROUP BY CONCAT(service.description, ' : ',sku.description)
```

### Congratulations 🎉 for completing the Lab !
