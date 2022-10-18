# Demo Advanced Cluster Security for Kubernetes Submariner Addon

In this demo we deploy a simple Redis cluster on OpenShift Container Platform (OCP) using Advanced Cluster Manager (ACM).

The Redis cluster is made of two pods:

- a leader: where the data is written by your applications
- a follower: a replica syncing data from the leader

For the sake of simplicity, this demo doesn't showcase a frontend application writing data to Redis, nor does it support persistent storage.

We can imagine any kind of application (todo list, guestbook, etc.) in any kind of language (Python, Go, etc.) writing to the leader node.

So instead of an app, we are going to write directly to the leader using the `redis-cli` utility and check on the follower if data have been replicated.

## Scenario 1 - single cluster deployment

TODO insert image

## Scenario 2 - multi cluster deployment

TODO insert image

### Preparing the environment

Two clusters are present and managed by ACM.

Create a clusterset and put both OCP clusters in it.

Then install the submariner add-on on each.

The installation will take a few minutes until all ticks are green.

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install1.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install2.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install3.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install4.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install5.png)


## If you don't want to deploy things using ACM

### Clone repo

```bash
git clone https://github.com/sebw/submariner-demo.git
cd single-cluster/
```

### Log into your OCP

```bash
# Login
oc login --token=sha256~XYZ --server=https://your-ocp:6443
```
### Create project

Edit `00-project.yaml`

```yaml
apiVersion: project.openshift.io/v1
description: "Demo Submariner"
displayName: submariner-demo
kind: ProjectRequest
metadata:
  name: submariner-demo
```

```bash
oc apply -f 00-project.yaml
```
### Deploy leader

```bash
oc apply -f 01-redis-leader-deployment.yaml
```
### Create leader service

```bash
oc apply -f 02-redis-leader-service.yaml
```
### Deploy follower

```bash
oc apply -f 03-redis-follower-deployment.yaml
```
### From now, go in the terminal of the leader pod

```bash
# redis-cli
# 127.0.0.1:6379> get meetup
# 127.0.0.1:6379> set meetup cool
# OK
# 127.0.0.1:6379> get meetup
# "cool"
```

### Check replication on follower pod

```bash
# redis-cli
# 127.0.0.1:6379> get meetup
# "cool"
```

Repeat the steps for the multi-cluster scenario by applying the correct configuration files to the correct clusters.

Success!

# Sources

https://rcarrata.github.io/openshift/rhacm-submariner-2/
https://hackmd.io/@-NygPmSYSkulcwHiqKwsuw/submariner
https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html-single/add-ons/index#enable-service-discovery-submariner