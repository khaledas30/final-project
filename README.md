# Final Project 
## Requirements
Deploy a nodejs application on GKE using CI/CD Jenkins Pipeline :
1- create a private gke cluster and connecting the cluster by subnet private 
2- After creating the cluster deploy and configure Jenkins on it 
3- The final steps is deploy the backend application on GKE using the Jenkins pipeline

## Tools
> - Terraform
> - Google Kubernetes Engine (GKE)
> - Jenkins
> - Kubernets
> - Docker
> - Gcloud

## Creating Infrastructure Using Terraform
### Network
- VPC that project will be assigned to
- Two subnets attached to two different ips [(managment subnet) for Vm and (restrecited subnet -for gke]
- NAT Gateway and Router
- Firewall to allow SSH Connection

### service account
- Service accounts that are attached to VM and GKE cluster.
> - service account [vm:container.admin]
> - service account [jke:(storage.admin) and (iam.workloadIdentityUser)]

### VM  Contains 
- vm private instance (without external ip)
### GKE  Contains  :
- Setting up gke in private subnet
- Container Node Pool

### 2. Navigate to the Terraform Code

#### 3. Initialize Terraform
```
terraform init
```

#### 4. Check Plan
```
terraform plan
```
## download cli and kubctl inside the vm instance 
```bash
sudo apt-get install  -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud -y
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
kubectl version --client
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```

## image 
- Create Dockerfile to install gcloud inside it 
> - docker build -t <name> .
- Then push this image to dockerhub and using this image at deploy the jenkins container 
![](./Screenshots/dockerhub.png)

## Apply Deployments To GKE

- after creating jke cluster connect the jke into vm instance.from the GCP console then VM instances and click the SSH to private-vm to configure to to work with GKE cluster  
> - [gcloud container clusters get-credentials project-cluster --zone us-central1-a --project abde-367812] 


## Apply the jenkins in the JKe 

- create file yaml using this image created above , install docker and kubernets inside jenkins container 
```bash
kubectl create -f namespace.yml
kubectl create -f Deployment.yml
kubectl create -f service.yml
kubectl get all
```

![](./Screenshots/deploy.png)
- Copy load-balancer IP followed by Port
- git the credential of jenkins by using command 
> - kubectl logs [podname] -n [namespace]


![](./Screenshots/jenkins.png)

## create nodejs app
> - create docker file to build image in this app and use it in the pipline 
> - create deployment file and new namespace to this app 
> - The repository of this app :
- https://github.com/khaledas30/final-app

## Apply and setup jenkins 

### Create two credentials 
> - creadential for dockerhub that pull image inside pipeline 
> - creadential for service accpunt (vm instance) that give to it [roles/container.admin] 
![Alt text](Screenshot from 2023-02-16 21-27-32.png)

### Create Jenkinsfile

Created a Jenkinsfile with continuous integration (CI) and continuous deployment (CD) stages

#### CI stage:
 
- Building the image with a version number equals to the Jenkins build number. 
- Passing the Dockerhub credentials in order to login.
- Pushing the new image to Dockerhub.

#### CD stage:

- Passing the service account credentials to connect to the cluster.
- Replacing the "tag" in the deployment file with the new BUILD_NUMBER (version).
- Deploying the app with kubectl.

## The results 

> - the pod that contain jenkins and the pod that contain the app created in the GKE cluster 

![Alt text](Screenshot from 2023-02-16 22-01-10.png)

![Alt text](Screenshot from 2023-02-16 22-02-52.png)

### The application 

![Alt text](Screenshot from 2023-02-16 22-06-39.png)
