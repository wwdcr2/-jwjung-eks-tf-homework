curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin

aws configure set default.region ap-northeast-2
#sa-jwjung

aws eks --region ap-northeast-2 update-kubeconfig --name eks-tf-demo-cluster

aws eks describe-cluster --name eks-tf-demo-cluster --query "cluster.identity.oidc.issuer" --output text
#-> https://oidc.eks.ap-northeast-2.amazonaws.com/id/8945252C3C307D85E66A09CF51E6CD7E

aws iam list-open-id-connect-providers | grep 8945252C3C307D85E66A09CF51E6CD7E

eksctl utils associate-iam-oidc-provider --cluster eks-tf-demo-cluster --approve

aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

eksctl create iamserviceaccount \
  --cluster eks-tf-demo-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::713225129300:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

mkdir -p /root/environment/manifests/alb-controller && cd /root/environment/manifests/alb-controller

kubectl apply --validate=false -f https://raw.githubusercontent.com/wwdcr2/-jwjung-eks-tf-homework/master/file/cert-manager.yaml
kubectl apply -f https://raw.githubusercontent.com/wwdcr2/-jwjung-eks-tf-homework/master/file/v2_2_1_full.yaml
kubectl apply -f https://raw.githubusercontent.com/wwdcr2/-jwjung-eks-tf-homework/master/file/2048.yaml
