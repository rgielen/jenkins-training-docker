#!groovy
node {

    def dockerImage = null

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        dockerImage = docker.build("rgielen/jenkins-training:${currentBuild.startTimeInMillis}-${env.BUILD_NUMBER}")
    }

    stage('Push') {
        docker.withRegistry('', 'hub.docker.com-rgielen') {
            dockerImage.push()
            dockerImage.push("latest")
        }
    }

}
