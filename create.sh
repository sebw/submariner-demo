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
#
# Then go to follower pod and "get meetup"
