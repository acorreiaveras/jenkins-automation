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
            docker.image('smartcheck-registry').push('vulnerable') }
          }

        }
      }
      stage('Smartcheck') {
        environment {
          IMAGETAG = 'jenkins-test1'
          VALUE = ''
        }
        steps {
          sh '''python scAPI.py


'''
        }
      }
    }
    environment {
      IMAGETAG = 'jenkins-test1'
    }
  }