#!/usr/bin/env bash

set -x

echo "Set app"
mkdir -p ../app/laravel/public
cp deployment/app/index.php ../app/laravel/public/

echo "Up nfs server"
./lnmp-k8s nfs
sleep 30
docker ps -a
./lnmp-k8s nfs logs
sudo mkdir -p /tmp2
# install nfs dep
sudo apt install -y nfs-common
sudo mount -t nfs4 -v ${SERVER_IP}:/lnmp/log /tmp2
sudo umount /tmp2

echo "set LNMP_NFS_SERVER_HOST .env"
sed -i "s#192.168.199.100#${SERVER_IP}#g" .env

./lnmp-k8s create
echo "${SERVER_IP} laravel2.t.khs1994.com" | sudo tee -a /etc/hosts
ping -c 1 laravel2.t.khs1994.com
sleep 120
kubectl get -n lnmp all
curl -k https://laravel2.t.khs1994.com
./lnmp-k8s delete
./lnmp-k8s cleanup
./lnmp-k8s nfs down
echo "Test noNFS volume"
cp -rf ../app ~/app-development
./lnmp-k8s create development --no-nfs
sleep 50
kubectl get -n lnmp all
curl -k https://laravel2.t.khs1994.com
test -z "${LNMP_K8S_LOCAL_INSTALL_OPTIONS}" && (kubectl apply -f deployment/runtimeClass/runtimeClass.yaml && kubectl apply -f deployment/runtimeClass/pod.yaml) || true
test "${LNMP_K8S_LOCAL_INSTALL_OPTIONS}" = "--crio" && (kubectl apply -f deployment/runtimeClass/runtimeClass.yaml && kubectl apply -f deployment/runtimeClass/pod.yaml) || true
test "${LNMP_K8S_LOCAL_INSTALL_OPTIONS}" = "--docker" && docker run -it --rm --runtime=runsc alpine uname -a || true
test "${LNMP_K8S_LOCAL_INSTALL_OPTIONS}" = "--docker" && docker run -it --rm alpine uname -a || true
sleep 10
kubectl get all
kubectl get pod
POD_NAME=`kubectl get pod | awk '{print $1}' | tail -1` || true
kubectl exec ${POD_NAME} -- uname -a || true
