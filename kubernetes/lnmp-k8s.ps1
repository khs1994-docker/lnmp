<#
.SYNOPSIS
  lnmp k8s CLI
.DESCRIPTION
  lnmp k8s CLI
.EXAMPLE
  PS C:\> lnmp-k8s create development

.EXAMPLE
  PS C:\> lnmp-k8s create development --dry-run

.INPUTS

.OUTPUTS

.NOTES

#>
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

$k8s_current_context=kubectl config current-context

"==> Kubernetes context is [ $k8s_current_context ]"
""

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

  create             Deploy lnmp on k8s {ENVIRONMENT: development (default) | testing | staging | production} {OPTIONS}
  delete             Stop lnmp on k8s, keep data resource(pv and pvc) {ENVIRONMENT: development (default) | testing | staging | production}
  cleanup            Stop lnmp on k8s, and remove all resource(pv and pvc) {ENVIRONMENT: development (default) | testing | staging | production}

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

Function _delete_lnmp($NAMESPACE="lnmp"){
  kubectl -n $NAMESPACE delete deployment -l app=lnmp
  kubectl -n $NAMESPACE delete service -l app=lnmp
  kubectl -n $NAMESPACE delete secret -l app=lnmp
  kubectl -n $NAMESPACE delete configmap -l app=lnmp
  kubectl -n $NAMESPACE delete cronjob -l app=lnmp
}

Function _create_pvc($NAMESPACE="lnmp"){
  kubectl -n $NAMESPACE apply -f deployment/pvc/lnmp-pvc.yaml
}

Function _create_hostpath($ENVIRONMENT="development"){
  $items="mysql-data","nginx-data","redis-data","log","registry-data"
  foreach($item in $items){
    mkdir -Force /Users/$env:username/.docker/Volumes/lnmp-$item-$ENVIRONMENT
  }
}

Function _create_pv($NAMESPACE="lnmp",$ENVIRONMENT="development"){
  # _create_hostpath $ENVIRONMENT

  Get-Content deployment/pv/lnmp-volume.windows.temp.yaml `
      | %{Write-Output `
            $_.Replace("/Users/username","/Users/$env:username") `
          } `
      | %{Write-Output `
            $_.Replace("development",$ENVIRONMENT) `
         } `
      | kubectl apply -f -
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

$command,$others=$args

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
    "==> Latest Stable Version is: $KUBECTL_VERSION
    "
  }

  "create" {
    if( $k8s_current_context -ne "docker-desktop"){
      Write-Warning "==> You can use this script on WSL2:

PS:> $ wsl -- ./lnmp-k8s $args
"

      exit
    }

    if( $k8s_current_context -ne "docker-desktop"){
      Write-Warning "
==> This Script ONLY Support [ K8S on Docker Desktop ] On Winodws

==> Check Kubernetes context [ docker-desktop ] ...

$(kubectl config get-contexts docker-desktop 2>&1 )

==> you can use kubernetes context [ docker-desktop ] by EXEC:

$ kubectl config use-context docker-desktop

"

      exit
    }

    $ENVIRONMENT="development"
    $NAMESPACE="lnmp"

    if ($others){
      $ENVIRONMENT=$others.split(' ')[0]
      $_,$options=$others
    }

    if($ENVIRONMENT -ne "development"){
      $NAMESPACE="lnmp", $ENVIRONMENT -join '-'
    }

    "==> NAMESPACE is $NAMESPACE"
    "==> OPTIONS is $options"

    kubectl create namespace $NAMESPACE $options

    if($NAMESPACE -ne "lnmp"){
      $items="mysql","redis","php","nginx"

      _create_pv $NAMESPACE $ENVIRONMENT $options
      # dont create pvc

      foreach($item in $items){
        (get-content deployment/$item/overlays/$ENVIRONMENT/kustomization.yaml) `
        -replace "# - hostpath.patch.yaml","- hostpath.patch.yaml" `
        | Set-Content deployment/$item/overlays/$ENVIRONMENT/kustomization.yaml
      }

      foreach($item in $items){
        kubectl -n $NAMESPACE apply -k deployment/$item/overlays/$ENVIRONMENT/ $options
      }

      # kubectl -n $NAMESPACE apply -k deployment/nginx/overlays/windows/ $options

      return
    }

    _create_pv $NAMESPACE $ENVIRONMENT $options
    _create_pvc $NAMESPACE $options

    $CONFIG_ROOT="deployment/php/overlays/${ENVIRONMENT}/config"
    kubectl -n $NAMESPACE create configmap lnmp-php-conf-0.0.1 `
      --from-file=php.ini=${CONFIG_ROOT}/ini/php.${ENVIRONMENT}.ini `
      --from-file=zz-docker.conf=${CONFIG_ROOT}/zz-docker.${ENVIRONMENT}.conf `
      --from-file=composer.config.json=${CONFIG_ROOT}/composer/config.${ENVIRONMENT}.json `
      --from-file=docker.ini=${CONFIG_ROOT}/conf.d/docker.${ENVIRONMENT}.ini $options
    kubectl -n $NAMESPACE label configmap lnmp-php-conf-0.0.1 app=lnmp version=0.0.1 $options

    $CONFIG_ROOT="deployment/mysql/overlays/${ENVIRONMENT}/config"
    kubectl -n $NAMESPACE create configmap lnmp-mysql-cnf-0.0.1 `
       --from-file=docker.cnf=${CONFIG_ROOT}/docker.${ENVIRONMENT}.cnf $options
    kubectl -n $NAMESPACE label configmap lnmp-mysql-cnf-0.0.1 app=lnmp version=0.0.1 $options

    $CONFIG_ROOT="deployment/nginx/overlays/${ENVIRONMENT}/config"
    kubectl -n $NAMESPACE create configmap lnmp-nginx-conf-0.0.1 `
       --from-file=nginx.conf=${CONFIG_ROOT}/nginx.${ENVIRONMENT}.conf $options
    kubectl -n $NAMESPACE label configmap lnmp-nginx-conf-0.0.1 app=lnmp version=0.0.1 $options

    kubectl -n $NAMESPACE create configmap lnmp-nginx-conf.d-0.0.1 `
    --from-file=deployment/configMap/nginx-conf-d $options
    kubectl -n $NAMESPACE label configmap lnmp-nginx-conf.d-0.0.1 app=lnmp version=0.0.1 $options

    # kubectl -n $NAMESPACE create secret generic lnmp-mysql-password `
    #  --from-literal=password=mytest $options

    kubectl -n $NAMESPACE create -f deployment/lnmp-configMap.${ENVIRONMENT}.yaml $options

    kubectl -n $NAMESPACE create -f deployment/lnmp-secret.${ENVIRONMENT}.yaml $options

    kubectl -n $NAMESPACE create -f deployment/mysql/base/lnmp-mysql.yaml $options

    kubectl -n $NAMESPACE create -f deployment/redis/base/lnmp-redis.yaml $options

    kubectl -n $NAMESPACE create -f deployment/php/base/lnmp-php7.yaml $options

    kubectl -n $NAMESPACE create -f deployment/nginx/base/lnmp-nginx.yaml $options

    kubectl -n $NAMESPACE create -f deployment/nginx/base/lnmp-nginx.service.yaml $options

  }

  "delete" {
    $ENVIRONMENT="development"
    $NAMESPACE="lnmp"

    if ($others){
      $ENVIRONMENT=$others.split(' ')[0]
      $_,$options=$others
    }

    if($ENVIRONMENT -ne "development"){
      $NAMESPACE="lnmp", $ENVIRONMENT -join '-'
    }

    "==> NAMESPACE is $NAMESPACE"

    _delete_lnmp $NAMESPACE
  }

  "cleanup" {
    $ENVIRONMENT="development"
    $NAMESPACE="lnmp"

    if ($others){
      $ENVIRONMENT=$others.split(' ')[0]
      $_,$options=$others
    }

    if($ENVIRONMENT -ne "development"){
      $NAMESPACE="lnmp", $ENVIRONMENT -join '-'
    }

    "==> NAMESPACE is $NAMESPACE"
    _delete_lnmp $NAMESPACE

    kubectl -n $NAMESPACE delete pvc -l app=lnmp

    if($ENVIRONMENT -eq 'development'){
      kubectl delete pv -l app=lnmp
    }else{
      "==> SKIP delete PV"
    }

    kubectl -n $NAMESPACE delete ingress -l app=lnmp
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
