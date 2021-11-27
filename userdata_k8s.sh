curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin

export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
aws configure set default.region ${AWS_REGION}


aws eks describe-cluster --name eks-tf-demo-cluster --query "cluster.identity.oidc.issuer" --output text
#-> https://oidc.eks.ap-northeast-2.amazonaws.com/id/325A525D9BB4E7BC9C876F6FBE5F185B

aws iam list-open-id-connect-providers | grep 325A525D9BB4E7BC9C876F6FBE5F185B

eksctl utils associate-iam-oidc-provider --cluster eks-tf-demo-cluster --approve #안되면 로컬에서?

aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

eksctl create iamserviceaccount \
  --cluster eks-tf-demo-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::693705052816:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

aws eks describe-cluster --name eks-tf-demo-cluster --query "cluster.identity.oidc.issuer" --output text

mkdir -p /root/environment/manifests/alb-controller && cd /root/environment/manifests/alb-controller

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.1/cert-manager.yaml
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/v2_2_1_full.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/examples/2048/2048_full.yaml
