#!/bin/sh

if [ $# -lt 2 ]
  then
    echo "Not enough arguments. Usage: ./build.sh region tenancy_hash ocir_user"
    echo "Example: ./build.sh ca-montreal-1 abscdasda k8s_service_user"
    exit 1

else
export REGION=$1.ocir.io
export TENANCY_HASH=$2
export OCIR_USER=$TENANCY_HASH/$3

 echo "Enter OCIR Token"
  read -r OCIR_PASSWORD   

  echo "--- login into OCIR ---"
  echo ${OCIR_PASSWORD} | docker login -u ${OCIR_USER} --password-stdin ${REGION}  

  if [ $? -eq 1 ]
   then  
    echo "--- incorrect credentials. Try again"
    exit 1
  else

    echo "--- pruning images ---"
        docker system prune -f -a

    echo "--- building images ---"
        docker-compose build

    echo "--- tag image stres-app:latest ---"
        docker tag stress-app:latest ${REGION}/${TENANCY_HASH}/stress-app:latest

        echo "--- push image stress-app:latest ---"
        docker push ${REGION}/${TENANCY_HASH}/stress-app:latest
    fi
fi