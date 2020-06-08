# Showoff app
The application is written in Python with the help of Flask together with Gunicorn.
It simply does nothing but showing a hello-world-like welcome message.

# Architecture overview
![Architecture Overview](https://user-images.githubusercontent.com/19154708/84089051-48634f80-a9ee-11ea-8f82-4e5d082d5e5c.png)

# Docker image CI
A new version of docker image is being prepared on each commit to any development and master branch.
- for master branch, the image matches: ```<container_registry_login_server>/showoff:${{ github.sha }}```
- for dev branches the image matches: ```<container_registry_login_server>/showoff:${{ github.run_id }}```

# Usage
To recreate the infrastructure stack, one should initialize the Container Registry and push the image before proceeding with the remaining resources.

### Initialize resource group and container registry
```bash
cd terraform
terraform init
terraform plan -target azurerm_container_registry.acr -out basic-plan.out
terraform apply basic-plan.out
```
### Build and push the image to the registry
```bash
az acr build --registry terraformshowoff -g terraform-showoff --image showoff:v1.0.0 ../
```
### Proceed with the remaining resources
```bash
terraform plan -var app_tag="v1.0.0" -out plan.out
terraform apply plan.out
```
The whole process will take approximately 15-20 minutes due to the long Gateway Application's initialization.
