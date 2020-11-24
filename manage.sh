#!/usr/bin/env bash
set -x

start ()
{
    mkdir tmp
    multipass launch --name k3s --cpus 4 --mem 4g --disk 20g
    multipass exec k3s -- bash -c "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -"
    K3S_IP=$(multipass info k3s | grep IPv4 | awk '{print $2}')
    multipass exec k3s sudo cat /etc/rancher/k3s/k3s.yaml | sed "s/127.0.0.1/${K3S_IP}/" > tmp/k3s.yaml
    export KUBECONFIG=${PWD}/tmp/k3s.yaml

    multipass mount ${PWD} k3s:/home/ubuntu/challange

    for i in `ls -d acceleration-*/ | sed 's#/##g'`; do
        cat Dockerfile.tmpl | sed "s/##APP_NAME##/$i/g" > Dockerfile.$i
        docker build -t $i  -f ./Dockerfile.$i .
        docker save --output $i.tar $i:latest
        multipass exec k3s sudo k3s ctr images import /home/ubuntu/challange/$i.tar
    done

    helm upgrade acceleration ./chart/acceleration -i -f ./chart/acceleration/values.yaml
}

stop ()
{
    multipass umount k3s
    multipass stop k3s
    multipass delete k3s
    rm *.tar Dockerfile.acceleration-* tmp
}

case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
*)
    echo "Howto run app: $0 (start|stop)"
esac
