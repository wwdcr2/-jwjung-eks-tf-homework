# Install kubectl & eksctl 
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x $HOME/kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin

# IAM User
aws configure set default.region ap-northeast-2
aws configure set aws_access_key_id [ACCESS_KEY_ID]
aws configure set aws_secret_access_key [SECRET_ACCESS_KEY]

#Nginx Ingress & Sample Nginx Page
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/aws/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/wwdcr2/-jwjung-eks-tf-homework/master/file/ingress.yml
kubectl apply -f https://raw.githubusercontent.com/wwdcr2/-jwjung-eks-tf-homework/master/file/nginx.yml