# Ingesting FHIR Data with the Healthcare API


### NOTE: Go to Task 1 and Export the variables

```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/main/Ingesting%20FHIR%20Data%20with%20the%20Healthcare%20API/quicklab.sh
sudo chmod +x quicklab.sh
./quicklab.sh

```
### After above command get executed follow the video instructions

```
gcloud healthcare fhir-stores export bq de_id \
--dataset=$DATASET_ID \
--location=$LOCATION \
--bq-dataset=bq://$PROJECT_ID.de_id \
--schema-type=analytics
```

```
SELECT
  id AS patient_id,
  name[safe_offset(0)].given AS given_name,
  name[safe_offset(0)].family AS family,
  birthDate AS birth_date
FROM dataset1.Patient LIMIT 10
```

## Congratulations, you're all done with the lab 😄
