#!/bin/bash

# Bright Foreground Colors
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

# Displaying start message
echo
echo "${CYAN_TEXT}${BOLD_TEXT}╔════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}                  Starting the process...                   ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}╚════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo

echo
echo "${GREEN_TEXT}${BOLD_TEXT} ========================== Set the Region ========================== ${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT} Enter REGION: ${RESET_FORMAT}"
read -r REGION

export REGION=$REGION

echo
echo "${GREEN_TEXT}${BOLD_TEXT} ========================== Enabling Services ========================== ${RESET_FORMAT}"
echo

gcloud services enable dataplex.googleapis.com

gcloud services enable datacatalog.googleapis.com

echo
echo "${GREEN_TEXT}${BOLD_TEXT} ========================== Creating Lake ========================== ${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT} Creating the 'orders-lake' in region: ${REGION} ... ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT} =================================================================== ${RESET_FORMAT}"
echo

gcloud dataplex lakes create orders-lake \
  --location=$REGION \
  --display-name="Orders Lake"

echo
echo "${GREEN_TEXT}${BOLD_TEXT} ========================== Creating Zone ========================== ${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT} Creating 'customer-curated-zone' within 'orders-lake' ... ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT} =================================================================== ${RESET_FORMAT}"
echo

gcloud dataplex zones create customer-curated-zone \
    --location=$REGION \
    --lake=orders-lake \
    --display-name="Customer Curated Zone" \
    --resource-location-type=SINGLE_REGION \
    --type=CURATED \
    --discovery-enabled \
    --discovery-schedule="0 * * * *"

echo
echo "${GREEN_TEXT}${BOLD_TEXT} ========================== Creating Asset ========================== ${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT} Creating 'customer-details-dataset' asset ... ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT} =================================================================== ${RESET_FORMAT}"
echo

gcloud dataplex assets create customer-details-dataset \
--location=$REGION \
--lake=orders-lake \
--zone=customer-curated-zone \
--display-name="Customer Details Dataset" \
--resource-type=BIGQUERY_DATASET \
--resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customers \
--discovery-enabled

echo
echo "${GREEN_TEXT}${BOLD_TEXT} ========================== Creating Tag Template ========================== ${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT} Creating 'protected_data_template' tag template in region: ${REGION} ... ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT} ============================================================================= ${RESET_FORMAT}"
echo

gcloud data-catalog tag-templates create protected_data_template --location=$REGION --field=id=protected_data_flag,display-name="Protected Data Flag",type='enum(YES|NO)' --display-name="Protected Data Template"

echo "${BLUE_TEXT}${BOLD_TEXT}Click here: ${RESET_FORMAT}""${WHITE_TEXT}${BOLD_TEXT}https://console.cloud.google.com/dataplex/search?project=$DEVSHELL_PROJECT_ID&qSystems=DATAPLEX${RESET_FORMAT}"

echo
# echo "${GREEN_TEXT}${BOLD_TEXT}╔════════════════════════════════════════════════════════╗${RESET_FORMAT}"
# echo "${GREEN_TEXT}${BOLD_TEXT}              Lab Completed Successfully!               ${RESET_FORMAT}"
# echo "${GREEN_TEXT}${BOLD_TEXT}╚════════════════════════════════════════════════════════╝${RESET_FORMAT}"
# echo
echo -e "${RED_TEXT}${BOLD_TEXT}Subscribe our Channel:${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@tutorialboy24${RESET_FORMAT}"
echo
