# Managing infrastructure as code with Terraform, Cloud Build, and GitOps

This is the repo for the [Managing infrastructure as code with Terraform, Cloud Build, and GitOps](https://cloud.google.com/solutions/managing-infrastructure-as-code) tutorial. This tutorial explains how to manage infrastructure as code with Terraform and Cloud Build using the popular GitOps methodology.

## Quick Start

1. Build this image and add it to your gcr repo

```
$ git clone git@github.com:GoogleCloudPlatform/cloud-builders-community
$ cd cloud-builders-community/ansible
$ gcloud builds submit .
```

## Cloud Logging Filter for Managed Instance Group VMs

Note:
You must have granted the "Logs Configuration Writer" IAM role (roles/logging.configWriter) to the credentials used with terraform.

[Zugriffssteuerung mit IAM](https://cloud.google.com/logging/docs/access-control)

```
resource.type="gce_instance"
protoPayload.methodName="v1.compute.instances.insert"
protoPayload.response.status="RUNNING"

resource.type="gce_instance"
protoPayload.methodName="v1.compute.instances.delete"
protoPayload.response.status="RUNNING"
```

## Configuring your **dev** environment

Just for demostration, this step will:
 1. Configure an apache2 http server on network '**dev**' and subnet '**dev**-subnet-01'
 2. Open port 80 on firewall for this http server 

```bash
cd ../environments/dev
terraform init
terraform plan
terraform apply
terraform destroy
```

## Promoting your environment to **production**

Once you have tested your app (in this example an apache2 http server), you can promote your configuration to prodution. This step will:
 1. Configure an apache2 http server on network '**prod**' and subnet '**prod**-subnet-01'
 2. Open port 80 on firewall for this http server 

```bash
cd ../prod
terraform init
terraform plan
terraform apply
terraform destroy
```

## HAProxy dynamic configuration
[Programmatic HAProxy Configuration Using the Data Plane API](https://www.haproxy.com/blog/programmatic-haproxy-configuration-using-the-data-plane-api/)
[Run the HAProxy Kubernetes Ingress Controller Outside of Your Kubernetes Cluster](https://www.haproxy.com/blog/run-the-haproxy-kubernetes-ingress-controller-outside-of-your-kubernetes-cluster/)

## Get Kubernetes Config

```bash
( ssh <your_master_hostname> 'sudo cat /etc/rancher/k3s/k3s.yaml' ) | sed 's/127.0.0.1/<your_master_hostname>/' > ~/.kube/config
```
