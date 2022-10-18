# Demo Advanced Cluster Security for Kubernetes Submariner Addon

In this demo we deploy a simple Redis cluster on OpenShift Container Platform (OCP) using Advanced Cluster Manager (ACM).

The Redis cluster is made of two pods:

- a leader: where the data is written by your applications
- a follower: a replica syncing data from the leader

For the sake of simplicity, this demo doesn't showcase a frontend application writing data to Redis.

We can imagine any kind of application (todo list, guestbook, etc.) in any kind of language (Python, Go, etc.) writing to the leader node.

So instead of an app, we are going to write directly to the leader using the `redis-cli` utility and check on the follower if data have been replicated.

## Scenario 1 - single cluster deployment

TODO insert image

## Scenario 2 - multi cluster deployment

TODO insert image

## Redis demo



## If you don't want to deploy things using ACM

```bash
# Clone repo
git clone https://github.com/sebw/submariner-demo.git
cd single-cluster

# Create project
oc apply -f 00-project.yaml

# Deploy leader
oc apply -f 01-redis-leader-deployment.yaml

# Create leader service
oc apply -f 02-redis-leader-service.yaml

# Deploy follower
oc apply -f 03-redis-follower-deployment.yaml

# From now, go in the terminal of the leader pod
# redis-cli
# 127.0.0.1:6379> get meetup
# 127.0.0.1:6379> set meetup cool
# OK
# 127.0.0.1:6379> get meetup
# "cool"

# Now go to the terminal of the follower pod and verify data have been replicated
# redis-cli
# 127.0.0.1:6379> get meetup
# "cool"
```

Success!