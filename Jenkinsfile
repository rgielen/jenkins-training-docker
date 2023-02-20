#!groovy
node {

    def dockerImage = null

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        env.VN = VersionNumber([
            versionNumberString :'${BUILD_YEAR, XX}${BUILD_MONTH, XX}${BUILD_DAY, XX}-${BUILD_NUMBER}'
        ])
        dockerImage = docker.build("rgielen/jenkins-training:${env.VN}","--pull .")
    }

    stage('Push') {
        docker.withRegistry('', 'hub.docker.com-rgielen') {
            dockerImage.push()
            dockerImage.push("latest")
        }
    }

}
