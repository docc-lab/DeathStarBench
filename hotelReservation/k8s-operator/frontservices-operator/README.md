# Summary: Building and Deploying a Kubernetes Operator

## Prerequisites
1. Install Go (version 1.23.0)

    ```bash
    wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz

    export PATH=$PATH:/usr/local/go/bin
    ```

2. Install Operator SDK 1.28

    ```bash
    export ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac)
    export OS=$(uname | awk '{print tolower($0)}')

    export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.36.1
    curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH}

    chmod +x operator-sdk_${OS}_${ARCH} && sudo mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk
    ```

3. Install controller runtime v0.14.1 and controller-gen v0.16.0

    ```bash
    go install sigs.k8s.io/controller-tools/cmd/controller-gen@v0.16.0
    go install sigs.k8s.io/controller-runtime@latest

    export PATH=$PATH:$(go env GOPATH)/bin
    ```

## Step 1: Create the Operator Project

Inside your operator go project dir, in our case fetch & checkout to operator branch of lab forked DSB.

```bash
cd /local/DeathStarBench/hotelReservation/k8s-operator/frontservices-operator/src

# following are what I already did, you can try with an empty dir
go mod init
operator-sdk init --domain mycompany.com
operator-sdk create api --group mygroup --version v1 --kind MyResource --resource --controller
```

## Step 2: Implement the Operator Logic

1. Define your Custom Resource (CR) in `api/v1/myresource_types.go`
2. Implement reconciliation logic in `controllers/myresource_controller.go`

## Step 3: Update Dependencies

```bash
go mod tidy
go mod vendor
```

## Step 4: Generate Code and Manifests

```bash
make generate
make manifests
```

## (Optional) Step 5: Build the Operator Image

```bash
make docker-build IMG=<your-registry>/myoperator:v0.1.0
```

## (Optional) Step 6: Push the Operator Image

```bash
make docker-push IMG=<your-registry>/myoperator:v0.1.0
```

## Step 7: Deploy the Operator

In our case, I already prepared the deployment.yaml for operator under .../k8s-operator/frontservices-operator/deployment. So go ahead to apply it with kubectl

Btw, we need to (a) create a namespace for the operator pod, (b) update the docker image name inside, (c) apply those rbac and crd yamls.

```bash
cd /local/DeathStarBench/hotelReservation/k8s-operator/frontservices-operator
vim deployment/frontendservice-operator-system

kubectl create namespace frontendservice-operator-system

kubectl apply -f crd/frontend.crd.yaml
kubectl apply -f rbac/frontendservice-operator-rolebinding.yaml
kubectl apply -f rbac/frontendservice-operator-role.yaml 
kubectl apply -f rbac/frontendservice-operator-serviceaccount.yaml

kubectl apply -f frontendservice-operator-deployment.yaml 

# alterantively, using Makefile generated from operator sdk, it requires a specific path of deployment.yaml though
make deploy IMG=<your-registry>/myoperator:v0.1.0
```

## Step 8: Verify the Deployment

```bash
kubectl get deployment -n myoperator-system #
kubectl get pods -n myoperator-system
```

## Step 9: Create a Custom Resource

Create a YAML file for your CR and apply it:

```bash
kubectl apply -f /local/DeathStarBench/hotelReservation/kubernetes/my-frontendCR.frontend.yaml
```

## Step 10: Verify the Custom Resource

```bash
kubectl get FrontendService
```

## Optional: Check Operator Logs & Uninstall the Operator

```bash
kubectl logs -f frontendservice-operator-f858b748b-kslhx -n frontendservice-operator-system

make undeploy
```