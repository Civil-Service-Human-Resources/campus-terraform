echo "Validting env vars"
: "${RESOURCE_GROUP_NAME?Please set a valid RESOURCE_GROUP_NAME}"
: "${STORAGE_ACCOUNT_NAME:?Please set a valid STORAGE_ACCOUNT_NAME}"
: "${KEY_SUFFIX:?Please set a valid KEY_SUFFIX}"
: "${CONTAINER_NAME:?Please set a valid CONTAINER_NAME}"

echo "Getting account key for storage account"
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
echo "Storing account key as ARM_ACCESS_KEY variable"
export ARM_ACCESS_KEY=$ACCOUNT_KEY

echo "Setting up backend configs"

envs=("integration" "production" "webops")

for env in "${envs[@]}"
do
  file="environments/$env/backend.conf"
  echo "storage_account_name  = \"$STORAGE_ACCOUNT_NAME\"" > $file
  echo "resource_group_name  = \"$RESOURCE_GROUP_NAME\"" >> $file
  echo "container_name  = \"$CONTAINER_NAME\"" >> $file
  echo "key  = \"$env.$KEY_SUFFIX\"" >> $file
done

