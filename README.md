# IKS Demo

First run terraform apply to push the policies into Intersight.  Modify the cluster action from Unassign, to Deploy, and rerun to deploy the IKS environment.

## YELB

Download the kubeconfig file of the cluster from the "Operate \ Kubernetes" view:

```bash
export KUBECONFIG=/path/to/<cluster>-kubeconfig.yml
```

and install yelb:

```bash
kubectl create ns yelb
kubectl apply -f https://raw.githubusercontent.com/lamw/vmware-k8s-app-demo/master/yelb.yaml

kubectl -n yelb get pods
```

Grab the external IP for the front end:

```bash
kubectl -n yelb describe pod yelb-ui | grep ^Node\:
```

### Browsing YELB

Point your browser to the external IP above on port 30001.

### Generate Traffic

If you want some voting traffic:

```python
#!/usr/bin/env python3

import requests
import random

votes = ['ihop','chipotle','outback']

while True:
	requests.get("http://10.0.44.13:30001/api/%s" % (random.choice(votes)))
```


## SMM

In Intersight, navigate to "Operate \ Kubernetes", click the cluster that was deployed.  Then click "Operate \ Add-ons", and then click "smm".  You will need to run:

```bash
smm login
```

from the command line to generate a login token.