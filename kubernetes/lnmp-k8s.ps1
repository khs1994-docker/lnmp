cd $PSScriptRoot

################################################################################

$MINIKUBE_VERSION="1.3.1"
$KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release"
$KUBECTL_URL="https://mirror.azure.cn/kubernetes/kubectl"

################################################################################

if (!(Test-Path .env.ps1 )){
  cp .env.example.ps1 .env.ps1
}

if (!(Test-Path .env )){
  cp .env.example .env
}

if (!(Test-Path coreos/.env )){
  cp coreos/.env.example coreos/.env
}

if (!(Test-Path wsl2/.env )){
  cp wsl2/.env.example wsl2/.env
}

if (!(Test-Path wsl2/.env.ps1 )){
  cp wsl2/.env.example.ps1 wsl2/.env.ps1
}

if (!(Test-Path systemd/.env )){
  cp systemd/.env.example systemd/.env
}

. "$PSScriptRoot/.env.example.ps1"

if (Test-Path .env.ps1 ){
  . "$PSScriptRoot/.env.ps1"
}

$current_context=kubectl config current-context

if (!($current_context -eq "docker-desktop")){
   Write-Warning "This Script Support Docker Desktop Only"
   exit
}

Function print_info($message){
  write-host "==> $message"
}

Function print_help_info(){
  echo "

Usage: lnmp-k8s.ps1 COMMAND

Commands:
  kubectl-install    Install kubectl
  kubectl-info       Get kubectl latest version info

  minikube-install   Install minikube
  minikube-up        Start minikube

  create             Deploy lnmp on k8s [--ingress]
  delete             Stop lnmp on k8s, keep data resource(pv and pvc)
  cleanup            Stop lnmp on k8s, and remove all resource(pv and pvc)

  registry           Up Registry

  create-pv          Create PV and PVC

  helm-development   Install Helm LNMP In Development
  helm-testing       Install Helm LNMP In Testing
  helm-staging       Install Helm LNMP In Staging
  helm-production    Install Helm LNMP In Production
"
}

if (!(Test-Path systemd/.env)){
  Copy-Item systemd/.env.example systemd/.env
}

if ($args.length -eq 0){
  print_help_info
  exit
}

Function get_kubectl_version(){
  $url="https://storage.googleapis.com/kubernetes-release/release/stable.txt"
  $url="https://mirror.azure.cn/kubernetes/kubectl/stable.txt"
  return $KUBECTL_VERSION=$(curl.exe -fsSL $url)
}

Function _delete_lnmp(){
  kubectl -n lnmp delete deployment -l app=lnmp
  kubectl -n lnmp delete service -l app=lnmp
  kubectl -n lnmp delete secret -l app=lnmp
  kubectl -n lnmp delete configmap -l app=lnmp
  kubectl -n lnmp delete cronjob -l app=lnmp
}

Function _create_pv(){
  Get-Content deployment/pv/lnmp-volume.windows.temp.yaml `
      | %{Write-Output $_.Replace("/Users/username","/Users/$env:username")} `
      | kubectl create -f -

  kubectl -n lnmp create -f deployment/pvc/lnmp-pvc.yaml
}

Function _registry_up(){
  kubectl -n lnmp create configmap lnmp-registry-conf-0.0.1 --from-file=config.yml=helm/registry/config/config.development.yml
  kubectl -n lnmp label configmap lnmp-registry-conf-0.0.1 app=lnmp version=0.0.1

  kubectl -n lnmp create secret generic lnmp-registry-tls-0.0.1 --from-file=tls.crt=helm/registry/config/ssl/public.crt `
      --from-file=tls.key=helm/registry/config/ssl/private.key `
  kubectl -n lnmp label secret lnmp-registry-tls-0.0.1 app=lnmp version=0.0.1

  kubectl -n lnmp create -f addons/registry.yaml
}

Function _helm_lnmp($environment, $debug=0){
  cd helm

  if ($debug){
    $opts="--debug","--dry-run"
  }

  Foreach ($item in $helm_services)
  {
  helm install ./$item `
      --name lnmp-$item-$environment `
      --namespace lnmp-$environment `
      --set APP_ENV=$environment `
      --set platform=windows `
      --set username=$env:username `
      $( Foreach ($opt in $opts){ echo $opt} )
  }

  cd $PSScriptRoot
}

switch ($args[0])
{
  "kubectl-install" {
    $KUBECTL_VERSION=get_kubectl_version
    $url="${KUBECTL_URL}/${KUBECTL_VERSION}/bin/windows/amd64/kubectl.exe"
    if(Test-Path C:\bin\kubectl.exe){
      print_info "kubectl already install"
      return
    }
    curl.exe -fsSL $url -o C:\bin\kubectl.exe
  }

  "kubectl-info" {
    $KUBECTL_VERSION=get_kubectl_version
    echo "Latest Stable Version is: $KUBECTL_VERSION
    "
  }

  "create" {
    kubectl create namespace lnmp
    _create_pv

    kubectl -n lnmp create -f deployment/lnmp-configMap.yaml

    kubectl -n lnmp create configmap lnmp-nginx-conf-d-0.0.1 `
      --from-file=deployment/configMap/nginx-conf-d

    kubectl -n lnmp label configmap lnmp-nginx-conf-d-0.0.1 app=lnmp version=0.0.1

    kubectl -n lnmp create configmap lnmp-php-conf-0.0.1 `
      --from-file=php.ini=helm/nginx-php/config/php/ini/php.development.ini `
      --from-file=zz-docker.conf=helm/nginx-php/config/php/zz-docker.development.conf `
      --from-file=composer.config.json=helm/nginx-php/config/php/composer/config.development.json `
      --from-file=docker.ini=helm/nginx-php/config/php/conf.d/docker.development.ini

    kubectl -n lnmp label configmap lnmp-php-conf-0.0.1 app=lnmp version=0.0.1

    kubectl -n lnmp create configmap lnmp-mysql-cnf-0.0.1 `
       --from-file=docker.cnf=helm/mysql/config/docker.development.cnf

    kubectl -n lnmp label configmap lnmp-mysql-cnf-0.0.1 app=lnmp version=0.0.1

    kubectl -n lnmp create configmap lnmp-nginx-conf-0.0.1 `
       --from-file=nginx.conf=helm/nginx-php/config/nginx/nginx.development.conf

    kubectl -n lnmp label configmap lnmp-nginx-conf-0.0.1 app=lnmp version=0.0.1

    # kubectl -n lnmp create secret generic lnmp-mysql-password --from-literal=password=mytest

    kubectl -n lnmp create -f deployment/lnmp-secret.yaml

    kubectl -n lnmp create -f deployment/mysql/lnmp-mysql.yaml

    kubectl -n lnmp create -f deployment/redis/lnmp-redis.yaml

    kubectl -n lnmp create -f deployment/php/lnmp-php7.yaml

    kubectl -n lnmp create -f deployment/nginx/lnmp-nginx.yaml

    kubectl -n lnmp create -f deployment/nginx/lnmp-nginx.service.yaml

  }

  "delete" {
    _delete_lnmp
  }

  "cleanup" {
    _delete_lnmp

    kubectl -n lnmp delete pvc -l app=lnmp
    kubectl -n lnmp delete pv -l app=lnmp
    kubectl -n lnmp delete ingress -l app=lnmp
  }

  "registry" {
    _create_pv
    _registry_up
  }

  "create-pv" {
    _create_pv
  }

  "minikube-up" {
    minikube.exe start `
      --hyperv-virtual-switch="minikube" `
      -v 10 `
      --registry-mirror=https://dockerhub.azk8s.cn `
      --vm-driver="hyperv" `
      --memory=4096
  }

  "minikube-install" {
    curl.exe -fsSL `
      http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-windows-amd64.exe `
      -o $HOME/minikube.exe
  }

  "helm-development" {
    _helm_lnmp development $args[1]
  }

  "helm-testing" {
    _helm_lnmp testing $args[1]
  }

  "helm-staging" {
    _helm_lnmp staging $args[1]
  }

  "helm-production" {
    _helm_lnmp production $args[1]
  }

  Default {
    Write-Warning "Command not found"
  }

}
