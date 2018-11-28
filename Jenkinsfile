pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/acorreiaveras/jenkins-automation.git'
      }
    }
    stage('Docker build') {
      steps {
        script {
          docker.build('smartcheck-registry')
        }

      }
    }
    stage('Docker push') {
      steps {
        script {
          docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
            docker.image('smartcheck-registry').push('jenkins-test1') }
          }

        }
      }
      stage('Get API token') {
        steps {
          sh '''curl --header \'Content-Type: application/json\' -d \'{"user": {"userID": "administrator","password": "trendmicro"}}\' -X POST https://a1979b014e35111e8a3800691bd3efc3-1497322518.us-west-1.elb.amazonaws.com/api/sessions --insecure
'''
        }
      }
    }
  }