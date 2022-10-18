# Demo Advanced Cluster Security for Kubernetes Submariner Addon

In this demo we will deploy a simple Redis cluster on OpenShift Container Platform (OCP) using Advanced Cluster Manager (ACM).

Redis is an in-memory data structure store, used as a distributed, in-memory key–value database, cache and message broker, with optional durability.

The Redis cluster is made of two pods:

- a leader: where the data is written by your applications
- a follower: a replica syncing data from the leader

For the sake of simplicity, this demo doesn't showcase a frontend application writing data to Redis. Instead we will write data with the `redis-cli` tool, directly from the terminal of the leader pod.

We could imagine any kind of application (todo list, guestbook, etc.) in any kind of language (Python, Go, etc.) writing to the leader node.

## Single vs multi cluster

### Single Cluster (not demoed)

Without Submariner, all components of an application must reside on the same cluster.

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/single.png)

### Multi Cluster (demoed)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/multi.png)

Two clusters are present and managed by ACM.

Both clusters reside in a clusterset. The submariner addon must be installed on both nodes.

The installation takes a few minutes. Wait until all ticks are green.

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install1.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install2.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install3.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install4.png)

![](https://raw.githubusercontent.com/sebw/submariner-demo/master/screenshots/submariner-install5.png)

We deploy the leader on cluster1, using label dc=a.

We deploy the follower on cluster2, using label dc=b.

When the leader application is deployed, a `ServiceExport` (a CRD) is created.

The ServiceExport automatically triggers the creation of a ServiceImport on cluster2.

The ServiceImport will trigger the Lighthouse DNS to create the DNS record.

## Redis CLI howto

### Writing data on the leader

```bash
oc login --token=sha256~XXX --server=https://cluster1:6443
oc rsh $(oc -n demo get pod -o name|head -n1)
```

```bash
# redis-cli
# 127.0.0.1:6379> get meetup
# 127.0.0.1:6379> set meetup cool
# OK
# 127.0.0.1:6379> get meetup
# "cool"
```

### Checking replication on the follower

```bash
oc login --token=sha256~XXX --server=https://cluster2:6443
oc rsh $(oc -n demo get pod -o name|head -n1)
```

```bash
# redis-cli
# 127.0.0.1:6379> get meetup
# "cool"
```

## Troubleshooting

You can use the `nettest` container image to troubleshoot potential problems:

```bash
oc -n default run submariner-test --rm -ti --image quay.io/submariner/nettest -- /bin/bash
```

When inside the container:

```bash
curl redis-leader.demo.svc.clusterset.local:6379
```

# Container used for this demo

The leader uses the official Redis image `docker.io/redis:7.0.5`.

The follower is based on the same image and is customized. The Dockerfile can be found in the `redis-follower` folder on this repository.

# Sources

https://rcarrata.github.io/openshift/rhacm-submariner-2/

https://hackmd.io/@-NygPmSYSkulcwHiqKwsuw/submariner

https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html-single/add-ons/index#enable-service-discovery-submariner