#!/bin/bash


varip="$1"
varmask="$2"
vargateway="$3"
varcpu="$4"
varmem="$5"
varhost="$6"
varcluster="$7"
varnet="$8"


mkdir /terraform/"$varhost"
cp /terraform/Template/*.tf /terraform/"$varhost"
cd /terraform//"$varhost"

sed -i "s/_IP/${varip}/g" build.tf
sed -i "s/_MASK/${varmask}/g" build.tf
sed -i "s/_GATEWAY/${vargateway}/g" build.tf
sed -i "s/_HOST/${varhost}/g" build.tf
sed -i "s/_NET/${varnet}/g" build.tf
sed -i "s/_CPU/${varcpu}/g" build.tf
sed -i "s/_MEM/${varmem}/g" build.tf

terraform init
terraform plan
terraform apply -auto-approve
