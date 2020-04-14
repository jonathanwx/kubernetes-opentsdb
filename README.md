# kubernetes-opentsdb
opentsdb for kubernetes

kubernetes环境下的opentsdb 

[docker hub地址](https://hub.docker.com/r/jonathanwx/kubernetes-opentsdb)

`opentsdb.yaml`
``` yaml 
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: opentsdb
spec:
  serviceName: opentsdb
  selector:
    matchLabels:
      app: opentsdb
  template:
    metadata:
      labels:
        app: opentsdb
    spec:
      containers:
      - name: opentsdb
        imagePullPolicy: IfNotPresent
        image: jonathanwx/kubernetes-opentsdb:2.4.0
        ports:
          - containerPort: 4242
        env:
        - name: ZK_SERVERS
          value: "zookeeper-0.zookeeper:2181,zookeeper-1.zookeeper:2181,zookeeper-2.zookeeper:2181"
---
apiVersion: v1
kind: Service
metadata:
  name: opentsdb
  labels:
    app: opentsdb
spec:
  ports:
  - port: 4242
  clusterIP: None
  selector:
    app: opentsdb

```

部署方式`kubectl apply -f opentsdb`