#!/bin/bash

# Color codes for better readability
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

# Function for logging with timestamps
log() {
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to retry commands with exponential backoff
retry_command() {
  local cmd=$1
  local description=$2
  local retries=0
  local wait_time=$RETRY_WAIT_INITIAL
  local result=0

  while [ $retries -lt $MAX_RETRIES ]; do
    log "${YELLOW_TEXT}Attempting: $description (Attempt $((retries+1))/${MAX_RETRIES})${RESET_FORMAT}"
    
    # Execute the command
    eval "$cmd"
    result=$?
    
    if [ $result -eq 0 ]; then
      log "${GREEN_TEXT}Success: $description${RESET_FORMAT}"
      return 0
    else
      retries=$((retries+1))
      if [ $retries -lt $MAX_RETRIES ]; then
        log "${YELLOW_TEXT}Failed. Retrying in $wait_time seconds...${RESET_FORMAT}"
        sleep $wait_time
        wait_time=$((wait_time*2)) # Exponential backoff
      else
        log "${RED_TEXT}Failed after $MAX_RETRIES attempts: $description${RESET_FORMAT}"
        return 1
      fi
    fi
  done
  
  return 1
}

# Check if gcloud is installed
if ! command -v gcloud &>/dev/null; then
  log "${RED_TEXT}Error: gcloud CLI is not installed. Please install it before running this script.${RESET_FORMAT}"

fi

# Set variables
FUNCTION_NAME="gcfunction"
# MAX_RETRIES=5
# RETRY_WAIT_INITIAL=3
TEST_DATA='{"message":"Hello World!"}'
# Ask for region with default value
# echo -n "${CYAN_TEXT}Enter REGION: ${RESET_FORMAT}"
# read user_region
# REGION=${user_region:-us-central1}
# echo "${GREEN_TEXT}Using region: $REGION${RESET_FORMAT}"

# Task 3: Test the function
log "${BLUE_TEXT}${BOLD_TEXT}Task 3: Testing the function${RESET_FORMAT}"
# Ask user for function URL
echo -n "${CYAN_TEXT}Enter Function URL: ${RESET_FORMAT}"
read user_function_url
FUNCTION_URL=${user_function_url}

if [ -z "$FUNCTION_URL" ]; then
  log "${RED_TEXT}Failed to get function URL. Cannot test the function.${RESET_FORMAT}"
else
  log "Function URL: $FUNCTION_URL"
  
  # Test the function using curl
  retry_command "curl -X POST $FUNCTION_URL -H 'Content-Type: application/json' -d '$TEST_DATA'" "Testing function with HTTP request"
  
  if [ $? -eq 0 ]; then
    log "${GREEN_TEXT}Function test completed successfully${RESET_FORMAT}"
  else
    log "${RED_TEXT}Function test failed after multiple attempts${RESET_FORMAT}"
  fi
fi

# Task 4: View logs
log "${BLUE_TEXT}${BOLD_TEXT}Task 4: Retrieving function logs${RESET_FORMAT}"
retry_command "gcloud logging read 'resource.type=cloud_function AND resource.labels.function_name=$FUNCTION_NAME' --limit=10" "Retrieving function logs"

# Clean up
log "Cleaning up temporary files..."
rm -rf $TEMP_DIR

echo
echo "${GREEN_TEXT}${BOLD_TEXT}╔════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}              Lab Completed Successfully!               ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}╚════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo
echo -e "${RED_TEXT}${BOLD_TEXT}Subscribe our Channel:${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@tutorialboy24${RESET_FORMAT}"
echo
