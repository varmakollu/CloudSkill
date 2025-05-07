#!/bin/bash
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear

echo
echo "${CYAN_TEXT}${BOLD_TEXT}=========================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}🚀         INITIATING EXECUTION         🚀${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}=========================================${RESET_FORMAT}"
echo

echo "${BLUE_TEXT}${BOLD_TEXT}🛠️  Gathering Your Google Cloud Project Details...${RESET_FORMAT}"
echo "${CYAN_TEXT}   Fetching your active Project ID.${RESET_FORMAT}"
export PROJECT_ID=$(gcloud config get project)

echo "${CYAN_TEXT}   Identifying the default Compute Zone.${RESET_FORMAT}"
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

echo "${CYAN_TEXT}   Identifying the default Compute Region.${RESET_FORMAT}"
export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

echo "${GREEN_TEXT}   Project ID set to: ${WHITE_TEXT}${BOLD_TEXT}$PROJECT_ID${RESET_FORMAT}"
echo "${GREEN_TEXT}   Default Zone set to: ${WHITE_TEXT}${BOLD_TEXT}$ZONE${RESET_FORMAT}"
echo "${GREEN_TEXT}   Default Region set to: ${WHITE_TEXT}${BOLD_TEXT}$REGION${RESET_FORMAT}"
echo

export BUCKET_NAME="scc-export-bucket-$PROJECT_ID"
echo "${BLUE_TEXT}${BOLD_TEXT}   Bucket name will be: ${WHITE_TEXT}${BOLD_TEXT}$BUCKET_NAME${RESET_FORMAT}"
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}📬 Setting up a Pub/Sub Topic for Findings...${RESET_FORMAT}"
gcloud pubsub topics create projects/$DEVSHELL_PROJECT_ID/topics/export-findings-pubsub-topic
echo "${GREEN_TEXT}${BOLD_TEXT}✅ Pub/Sub Topic created successfully!${RESET_FORMAT}"
echo

echo "${MAGENTA_TEXT}${BOLD_TEXT}📩 Creating a Subscription to the Pub/Sub Topic...${RESET_FORMAT}"
gcloud pubsub subscriptions create export-findings-pubsub-topic-sub --topic=projects/$DEVSHELL_PROJECT_ID/topics/export-findings-pubsub-topic
echo "${GREEN_TEXT}${BOLD_TEXT}✅ Pub/Sub Subscription created!${RESET_FORMAT}"
echo

echo "${BLUE_TEXT}${BOLD_TEXT}👉 MANUAL STEP REQUIRED: Please follow the link below.${RESET_FORMAT}"
echo "${BLUE_TEXT}   Open this URL in your browser to configure continuous export to Pub/Sub in Security Command Center:${RESET_FORMAT}"
echo "${WHITE_TEXT}${UNDERLINE_TEXT}https://console.cloud.google.com/security/command-center/config/continuous-exports/pubsub?project=$DEVSHELL_PROJECT_ID${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}   Name the continuous export: ${WHITE_TEXT}export-findings-pubsub${RESET_FORMAT}"
echo

function check_progress {
  while true; do
    echo
    echo -n "${YELLOW_TEXT}${BOLD_TEXT}🤔 Have you completed the manual step in the Google Cloud Console as per the video (created 'export-findings-pubsub')? (Y/N): ${RESET_FORMAT}"
    read -r user_input
    if [[ "$user_input" == "Y" || "$user_input" == "y" ]]; then
      echo
      echo "${GREEN_TEXT}${BOLD_TEXT}👍 Awesome! Continuing with the script...${RESET_FORMAT}"
      echo
      break
    elif [[ "$user_input" == "N" || "$user_input" == "n" ]]; then
      echo
      echo "${RED_TEXT}${BOLD_TEXT}❗ Please complete the manual step to create ${WHITE_TEXT}export-findings-pubsub${RED_TEXT}${BOLD_TEXT} in the SCC console and then enter 'Y' to proceed.${RESET_FORMAT}"
    else
      echo
      echo "${MAGENTA_TEXT}${BOLD_TEXT}⚠️ Invalid input. Please enter Y or N.${RESET_FORMAT}"
    fi
  done
}

echo
echo "${YELLOW_TEXT}${BOLD_TEXT}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}🚀          PAUSE: FOLLOW VIDEO INSTRUCTIONS          🚀${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET_FORMAT}"
echo
echo "${CYAN_TEXT}${BOLD_TEXT}   Ensure the Continuous Export in SCC is named: ${WHITE_TEXT}export-findings-pubsub${RESET_FORMAT}"
echo
check_progress

echo "${BLUE_TEXT}${BOLD_TEXT}💻 Launching a new Compute Engine Instance...${RESET_FORMAT}"
gcloud compute instances create instance-1 --zone=$ZONE \
--machine-type e2-micro \
--scopes=https://www.googleapis.com/auth/cloud-platform
echo "${GREEN_TEXT}${BOLD_TEXT}✅ Compute Instance 'instance-1' created!${RESET_FORMAT}"
echo

echo "${CYAN_TEXT}${BOLD_TEXT}📊 Creating a BigQuery Dataset for Continuous Export...${RESET_FORMAT}"
bq --location=$REGION --apilog=/dev/null mk --dataset \
$PROJECT_ID:continuous_export_dataset
echo "${GREEN_TEXT}${BOLD_TEXT}✅ BigQuery Dataset 'continuous_export_dataset' created!${RESET_FORMAT}"
echo

check_and_enable_securitycenter() {
  echo "${BLUE_TEXT}${BOLD_TEXT}🛡️  Checking Security Command Center API status...${RESET_FORMAT}"
  is_enabled=$(gcloud services list --enabled --filter="securitycenter.googleapis.com" --format="value(NAME)" 2>/dev/null)

  if [ "$is_enabled" == "securitycenter.googleapis.com" ]; then
  echo "${GREEN_TEXT}${BOLD_TEXT}👍 Security Command Center API is already active.${RESET_FORMAT}"
  else
  echo "${YELLOW_TEXT}${BOLD_TEXT}⏳ Security Command Center API is not enabled. Activating it now... (This might take a moment)${RESET_FORMAT}"
  gcloud services enable securitycenter.googleapis.com --quiet >/dev/null 2>&1

  echo "${MAGENTA_TEXT}${BOLD_TEXT}⏱️  Waiting for the Security Command Center API to be fully enabled...${RESET_FORMAT}"
  while true; do
    is_enabled=$(gcloud services list --enabled --filter="securitycenter.googleapis.com" --format="value(NAME)" 2>/dev/null)
    if [ "$is_enabled" == "securitycenter.googleapis.com" ]; then
    echo "${GREEN_TEXT}${BOLD_TEXT}✅ Security Command Center API has been successfully enabled!${RESET_FORMAT}"
    break
    fi
    echo "${RED_TEXT}   Still waiting... checking again in 5 seconds.${RESET_FORMAT}"
    sleep 5
  done
  fi
}

check_and_enable_securitycenter
echo

echo "${MAGENTA_TEXT}${BOLD_TEXT}📤 Setting up SCC BigQuery Export Configuration...${RESET_FORMAT}"
gcloud scc bqexports create scc-bq-cont-export --dataset=projects/$PROJECT_ID/datasets/continuous_export_dataset --project=$PROJECT_ID --quiet
echo "${GREEN_TEXT}${BOLD_TEXT}✅ SCC BigQuery Export configured!${RESET_FORMAT}"
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}🔑 Creating Service Accounts and Generating Keys...${RESET_FORMAT}"
for i in {0..2}; do
  echo "${CYAN_TEXT}   Creating service account sccp-test-sa-$i...${RESET_FORMAT}"
  gcloud iam service-accounts create sccp-test-sa-$i
  echo "${CYAN_TEXT}   Generating key for sccp-test-sa-$i...${RESET_FORMAT}"
  gcloud iam service-accounts keys create /tmp/sa-key-$i.json \
  --iam-account=sccp-test-sa-$i@$PROJECT_ID.iam.gserviceaccount.com
done
echo "${GREEN_TEXT}${BOLD_TEXT}✅ Service Accounts and Keys created successfully!${RESET_FORMAT}"
echo

function wait_for_findings() {
  echo "${BLUE_TEXT}${BOLD_TEXT}🕵️  Monitoring BigQuery for new findings...${RESET_FORMAT}"
  while true; do
  result=$(bq query --apilog=/dev/null --use_legacy_sql=false --format=pretty \
    "SELECT finding_id, event_time, finding.category FROM continuous_export_dataset.findings")

  if echo "$result" | grep -qE '^[|] [a-f0-9]{32} '; then
    echo "${GREEN_TEXT}${BOLD_TEXT}🎉 Findings detected in BigQuery!${RESET_FORMAT}"
    echo "${WHITE_TEXT}$result${RESET_FORMAT}"
    break
  else
    echo "${YELLOW_TEXT}${BOLD_TEXT}⏳ No findings yet. Will check again in 2 minutes...${RESET_FORMAT}"
    for i in $(seq 120 -1 1); do
      printf "\r${YELLOW_TEXT}${BOLD_TEXT}   %3d seconds remaining...${RESET_FORMAT}" "$i"
      sleep 1
    done
    printf "\r${YELLOW_TEXT}${BOLD_TEXT}   Checking for findings now...                     ${RESET_FORMAT}\n" 
  fi
  done
}

wait_for_findings
echo

echo "${BLUE_TEXT}${BOLD_TEXT}📦 Creating a Google Cloud Storage Bucket...${RESET_FORMAT}"
echo "${BLUE_TEXT}   Bucket name: ${WHITE_TEXT}$BUCKET_NAME${BLUE_TEXT} in region ${WHITE_TEXT}$REGION${BLUE_TEXT}.${RESET_FORMAT}"
gsutil mb -l $REGION gs://$BUCKET_NAME/
echo "${GREEN_TEXT}${BOLD_TEXT}✅ Storage Bucket '$BUCKET_NAME' created!${RESET_FORMAT}"
echo

echo "${MAGENTA_TEXT}${BOLD_TEXT}🛡️  Enforcing Public Access Prevention on the Bucket...${RESET_FORMAT}"
echo "${MAGENTA_TEXT}   Securing bucket '${WHITE_TEXT}$BUCKET_NAME${MAGENTA_TEXT}' to prevent public access.${RESET_FORMAT}"
gsutil pap set enforced gs://$BUCKET_NAME
echo "${GREEN_TEXT}${BOLD_TEXT}✅ Public Access Prevention enforced on '$BUCKET_NAME'!${RESET_FORMAT}"
echo

echo "${CYAN_TEXT}${BOLD_TEXT}⏳ Pausing for 15 seconds to allow configurations to settle...${RESET_FORMAT}"
sleep 15
echo

echo "${CYAN_TEXT}${BOLD_TEXT}📄 Exporting Current Findings to a JSONL file...${RESET_FORMAT}"
echo "${CYAN_TEXT}   Listing findings from 'projects/$PROJECT_ID' and saving to 'findings.jsonl'.${RESET_FORMAT}"
gcloud scc findings list "projects/$PROJECT_ID" \
  --format=json \
  | jq -c '.[]' \
  > findings.jsonl
echo "${GREEN_TEXT}${BOLD_TEXT}✅ Findings exported to 'findings.jsonl'!${RESET_FORMAT}"
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}⏳ Pausing for another 15 seconds...${RESET_FORMAT}"
sleep 15
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}☁️  Uploading 'findings.jsonl' to the Storage Bucket...${RESET_FORMAT}"
echo "${YELLOW_TEXT}   Copying 'findings.jsonl' to 'gs://$BUCKET_NAME/'.${RESET_FORMAT}"
gsutil cp findings.jsonl gs://$BUCKET_NAME/
echo "${GREEN_TEXT}${BOLD_TEXT}✅ 'findings.jsonl' uploaded to '$BUCKET_NAME'!${RESET_FORMAT}"
echo

echo
echo "${YELLOW_TEXT}${BOLD_TEXT}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}🚀          PAUSE: FOLLOW VIDEO INSTRUCTIONS          🚀${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET_FORMAT}"
echo

echo "${GREEN_TEXT}${BOLD_TEXT}🔗 OPEN BIGQUERY CONSOLE FOR NEXT STEPS:${RESET_FORMAT}"
echo "${WHITE_TEXT}${UNDERLINE_TEXT}https://console.cloud.google.com/bigquery?project=$DEVSHELL_PROJECT_ID${RESET_FORMAT}"
echo
echo "${YELLOW_TEXT}${BOLD_TEXT}   In BigQuery, you will be working with a table. The suggested name is: ${WHITE_TEXT}old_findings${RESET_FORMAT}"
echo

echo
echo "${MAGENTA_TEXT}${BOLD_TEXT}💖 Enjoyed this script and the video? Consider subscribing to TutorialBoy! 👇${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}https://www.youtube.com/@tutorialboy24${RESET_FORMAT}"
echo
