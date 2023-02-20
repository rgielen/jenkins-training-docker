#!groovy
node {

    def dockerImage = null

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        dockerImage = docker.build("rgielen/jenkins-training:${BUILD_DATE_FORMATTED, 'yyMMdd'}-${env.BUILD_NUMBER}","--pull .")
    }

    stage('Push') {
        docker.withRegistry('', 'hub.docker.com-rgielen') {
            dockerImage.push()
            dockerImage.push("latest")
        }
    }

}
