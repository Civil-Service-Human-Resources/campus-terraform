echo "Validting env vars"
: "${RESOURCE_GROUP_NAME?Please set a valid RESOURCE_GROUP_NAME}"
: "${STORAGE_ACCOUNT_NAME:?Please set a valid STORAGE_ACCOUNT_NAME}"

echo "Getting account key for storage account"
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
echo "Storing account key as ARM_ACCESS_KEY variable"
export ARM_ACCESS_KEY=$ACCOUNT_KEY
