# Lab 4 - Load Balancing and CloudWatch Alarms

## Deployment
1. Copy lab credentials to `~/.aws/credentials`
2. Import lab key and update permissions as well
3. Set tf-state bucket name in `backend.tf` file
4. Navigate to `$PROJECT_ROOT/locals.tf` and:
   * Set media-bucket name if necessary
     * Default: `media-bucket-991617069`
5. Finally run:
```bash
terraform init
terraform apply -auto-approve
```

## Connecting to Bastion and a WebVM
Assuming you have the key with proper permissions in your machine:
```shell
# IN LOCAL TTY 
export KEY_PATH=path/to/key
export BASTION_IP=xxx.xxx.xxx.xxx

# COPY WHOLE COMMAND STRING COPYING THE PEM AND SETTING PERMISSION
# Copies pem to user home folder
cat $KEY_PATH | pbcopy && echo "echo \"$(pbpaste)\" > ~/key.pem && sudo chmod 400 ~/key.pem" | pbcopy

# Connect to bastion
ssh -i $KEY_PATH ec2-user@$BASTION_IP
```
```shell
# INSIDE BASTION
export WEB_PRIVATE_IP=xxx.xxx.xxx.xxx

# Paste from clipboard and enter to copy key
pbpaste <enter>
ssh -i key.pem ec2-user@$WEB_PRIVATE_IP
```
