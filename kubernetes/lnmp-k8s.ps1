cd $PSScriptRoot

################################################################################

$MINIKUBE_VERSION="0.28.1"
$KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release"

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

. "$PSScriptRoot/.env.example.ps1"

if (Test-Path .env.ps1 ){
  . "$PSScriptRoot/.env.ps1"
}

$current_context=kubectl config current-context

if (!($current_context -eq "docker-for-desktop")){
   Write-Warning "This Script Support Docker for Desktop Only"
   exit
}

Function print_help_info(){
  echo "

Usage: lnmp-k8s.ps1 COMMAND

Commands:
  kubectl-install    Install kubectl
  kubectl-getinfo    Get kubectl latest version info

  minikube-install   Install minikube
  minikube           Start minikube

  create             Deploy lnmp on k8s
  delete             Stop lnmp on k8s, keep data resource(pv and pvc)
  cleanup            Stop lnmp on k8s, and remove all resource(pv and pvc)

  registry           Up Registry

  create-pv          Create PV and PVC

  dashboard          How to open Dashboard

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
  return $KUBECTL_VERSION=$(wsl curl https://storage.googleapis.com/kubernetes-release/release/stable.txt)
}

Function _delete(){
  kubectl -n lnmp delete deployment -l app=lnmp
  kubectl -n lnmp delete service -l app=lnmp
  kubectl -n lnmp delete secret -l app=lnmp
  kubectl -n lnmp delete configmap -l app=lnmp
  kubectl -n lnmp delete cronjob -l app=lnmp
}

Function _create_pv(){
  Get-Content deployment/lnmp-volume.windows.example.yaml `
      | %{Write-Output $_.Replace("/Users/username","/Users/$env:username")} `
      | kubectl create -f -

  kubectl -n lnmp create -f deployment/lnmp-pvc.yaml
}

Function _registry(){
  kubectl -n lnmp create configmap lnmp-registry-conf-0.0.1 --from-file=config.yml=helm/registry/config/config.development.yml
  kubectl -n lnmp label configmap lnmp-registry-conf-0.0.1 app=lnmp version=0.0.1

  kubectl -n lnmp create secret generic lnmp-registry-tls-0.0.1 --from-file=tls.crt=helm/registry/config/ssl/public.crt `
      --from-file=tls.key=helm/registry/config/ssl/private.key `
  kubectl -n lnmp label secret lnmp-registry-tls-0.0.1 app=lnmp version=0.0.1

  kubectl -n lnmp create -f addons/registry.yaml
}

Function _helm($environment, $debug=0){
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
      --tls $( Foreach ($opt in $opts){ echo $opt} )
  }

  cd $PSScriptRoot
}

switch ($args[0])
{
  "kubectl-install" {
    $KUBECTL_VERSION=get_kubectl_version
    wsl curl -L ${KUBECTL_URL}/${KUBECTL_VERSION}/bin/windows/amd64/kubectl.exe -o kubectl-Windows-x86_64.exe

    echo "
Move kubectl-Windows-x86_64.exe to your PATH, then rename it kubectl
    "
  }

  "kubectl-getinfo" {
    $KUBECTL_VERSION=get_kubectl_version
    echo "Latest Stable Version is: $KUBECTL_VERSION
    "
  }

  "create" {
    kubectl create namespace lnmp
    _create_pv

    kubectl -n lnmp create -f deployment/lnmp-configMap.yaml

    kubectl -n lnmp create configmap lnmp-nginx-conf-d-0.0.1 --from-file=deployment/configMap/nginx-conf-d
    kubectl -n lnmp label configmap lnmp-nginx-conf-d-0.0.1 app=lnmp version=0.0.1

    kubectl -n lnmp create configmap lnmp-php-conf-0.0.1 `
             --from-file=php.ini=helm/nginx-php/config/php/ini/php.development.ini `
                     --from-file=helm/nginx-php/config/php/docker-xdebug.ini `
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

    kubectl -n lnmp create -f deployment/lnmp-mysql.yaml

    kubectl -n lnmp create -f deployment/lnmp-redis.yaml

    kubectl -n lnmp create -f deployment/lnmp-php7.yaml

    kubectl -n lnmp create -f deployment/lnmp-nginx.service.yaml

    kubectl -n lnmp create -f deployment/lnmp-nginx.yaml
  }

  "delete" {
    _delete
  }

  "cleanup" {
    _delete

    kubectl -n lnmp delete pvc -l app=lnmp
    kubectl -n lnmp delete pv -l app=lnmp
    kubectl -n lnmp delete ingress -l app=lnmp
  }

  "registry" {
    _create_pv
    _registry
  }

  "create-pv" {
    _create_pv
  }

  "minikube" {
    minikube.exe start `
      --hyperv-virtual-switch="minikube" `
      -v 10 `
      --registry-mirror=https://registry.docker-cn.com `
      --vm-driver="hyperv" `
      --memory=4096
  }

  "minikube-install" {
    wsl curl -L `
      http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-windows-amd64.exe `
      -o minikube.exe
  }

  "dashboard" {
    echo "
$ kubectl proxy

open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

"
  }

  "helm-development" {
    _helm development $args[1]
  }

  "helm-testing" {
    _helm testing $args[1]
  }

  "helm-staging" {
    _helm staging $args[1]
  }

  "helm-production" {
    _helm production $args[1]
  }

  Default {
    Write-Warning "Command not found"
  }

}
