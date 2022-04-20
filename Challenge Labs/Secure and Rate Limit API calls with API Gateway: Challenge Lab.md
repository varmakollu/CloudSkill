# Secure and Rate Limit API calls with API Gateway: Challenge Lab GSP350


## Task 1. Create the Hello Service API using API Gateway :-

### Deploy Backend Service

```
gcloud run deploy hello-service --image us-docker.pkg.dev/cloudrun/container/hello:latest --platform managed --region us-central1 --max-instances 3 --min-instances 1 --memory 512Mi --ingress all --allow-unauthenticated
```

```
export PROJECT_ID=$(gcloud config get-value project)
export ADDRESS=$(gcloud run services list --platform managed --format json | jq -r .[].status.address.url)
ADDRESS=${ADDRESS:8}
```
```
sed -i "s/ADDRESS/${ADDRESS}/g" openapi2-run.yaml
```
```
gcloud api-gateway api-configs create hello-config \
    --api=hello-service-api \
    --openapi-spec=openapi2-run.yaml \
    --project=$PROJECT_ID
```
### Deploying an API Gateway

```
gcloud api-gateway gateways create hello-service-gw \
    --api=hello-service-api \
    --api-config=hello-config \
    --location=us-central1 \
    --project=$PROJECT_ID
```
```
gcloud api-gateway gateways describe hello-service-gw \
    --location=us-central1 \
    --project=$PROJECT_ID
export defaultHostname=$(gcloud api-gateway gateways describe hello-service-gw \
    --location=us-central1 \
    --project=$PROJECT_ID \
    --format=json | jq -r .defaultHostname)
```

## Task 2. Secure the Hello Service API with an API Key :-

```
export APIKEY=INSERT_COPIED_CLIENT_ID
```
```
export PROJECT_ID=$(gcloud config get-value project)
export ADDRESS=$(gcloud run services list --platform managed --format json | jq -r .[].status.address.url)
ADDRESS=${ADDRESS:8}
```
```
sed -i "s/ADDRESS/${ADDRESS}/g" openapi2-secure.yaml
sed -i "s/APIKEY/${APIKEY}/g" openapi2-secure.yaml
```
```
gcloud api-gateway api-configs create hello-config-secure \
    --api=hello-service-api \
    --openapi-spec=openapi2-secure.yaml \
    --project=$PROJECT_ID
```
```
gcloud api-gateway gateways update hello-service-gw \
    --api=hello-service-api \
    --api-config=hello-config-secure \
    --location=us-central1 \
    --project=$PROJECT_ID
```
```
curl -k https://${defaultHostname}/hello
```

## Task 3. Rate Limit the Hello Service API :-

```
export PROJECT_ID=$(gcloud config get-value project)
export defaultHostname=$(gcloud api-gateway gateways describe hello-service-gw --location=us-central1 --project=$PROJECT_ID --format=json | jq -r .defaultHostname)
export ADDRESS=$(gcloud run services list --platform managed --format json | jq -r .[].status.address.url)
ADDRESS=${ADDRESS:8}
```
```
sed -i "s/ADDRESS/${ADDRESS}/g" openapi2-quota.yaml
```
```
gcloud api-gateway api-configs create hello-config-quota \
    --api=hello-service-api \
    --openapi-spec=openapi2-quota.yaml \
    --project=$PROJECT_ID
```
```
gcloud api-gateway gateways update hello-service-gw \
    --api=hello-service-api \
    --api-config=hello-config-quota \
    --location=us-central1 \
    --project=$PROJECT_ID
```
```
for n in {1..10}; do curl -s -o /dev/null -w "%{http_code}\n" -k https://${defaultHostname}/hello; done
```
