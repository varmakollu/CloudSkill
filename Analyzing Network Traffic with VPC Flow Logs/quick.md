# Analyzing Network Traffic with VPC Flow Logs

```
export ZONE=
```
```
curl -LO raw.githubusercontent.com/varmakollu/CloudSkill/refs/heads/main/Analyzing%20Network%20Traffic%20with%20VPC%20Flow%20Logs/quick.sh

sudo chmod +x quick.sh

./quick.sh
```
---

* For the Sink name, type **bq_vpcflows**

```
export MY_SERVER=$(gcloud compute instances describe web-server --zone "$ZONE" --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

for ((i=1;i<=50;i++)); do curl $MY_SERVER; done
```
---

* Add the following to the **BigQuery Editor** and **REPLACE_YOUR_TABLE_ID** with *TABLE_ID* while retaining the accents (**`**) on both sides:

```
#standardSQL
SELECT
jsonPayload.src_vpc.vpc_name,
SUM(CAST(jsonPayload.bytes_sent AS INT64)) AS bytes,
jsonPayload.src_vpc.subnetwork_name,
jsonPayload.connection.src_ip,
jsonPayload.connection.src_port,
jsonPayload.connection.dest_ip,
jsonPayload.connection.dest_port,
jsonPayload.connection.protocol
FROM
`REPLACE_YOUR_TABLE_ID`
GROUP BY
jsonPayload.src_vpc.vpc_name,
jsonPayload.src_vpc.subnetwork_name,
jsonPayload.connection.src_ip,
jsonPayload.connection.src_port,
jsonPayload.connection.dest_ip,
jsonPayload.connection.dest_port,
jsonPayload.connection.protocol
ORDER BY
bytes DESC
LIMIT
15
```
```
#standardSQL
SELECT
jsonPayload.connection.src_ip,
jsonPayload.connection.dest_ip,
SUM(CAST(jsonPayload.bytes_sent AS INT64)) AS bytes,
jsonPayload.connection.dest_port,
jsonPayload.connection.protocol
FROM
`REPLACE_YOUR_TABLE_ID`
WHERE jsonPayload.reporter = 'DEST'
GROUP BY
jsonPayload.connection.src_ip,
jsonPayload.connection.dest_ip,
jsonPayload.connection.dest_port,
jsonPayload.connection.protocol
ORDER BY
bytes DESC
LIMIT
15
```

### Congratulations 🎉 for completing the Lab !
