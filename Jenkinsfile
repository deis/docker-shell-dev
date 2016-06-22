#!groovy

node {
 stage 'Checkout'
 checkout scm

 stage 'Docker Build and Push - Quay.io'
 def quayUsername = "deis+jenkins"
 def quayEmail = "deis+jenkins@deis.com"
 withCredentials([[$class: 'StringBinding',
                    credentialsId: '614c646f-57fc-4cdb-a70e-cbd5b0d91737',
                    variable: 'QUAY_PASSWORD']]) {

   sh """
     docker login -e="${quayEmail}" -u="${quayUsername}" -p="\${QUAY_PASSWORD}" quay.io
     make build push
   """
 }

 stage 'Docker Build and Push - DockerHub'
 def hubUsername = "deisbot"
 def hubEmail = "dummy-address@deis.com"
 withCredentials([[$class: 'StringBinding',
                    credentialsId: '0d1f268f-407d-4cd9-a3c2-0f9671df0104',
                    variable: 'DOCKER_PASSWORD']]) {

   sh """
    docker login -e="${hubEmail}" -u="${hubUsername}" -p="\${DOCKER_PASSWORD}"
    REGISTRY='' make build push
   """
 }
}
