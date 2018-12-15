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
          docker.build('image')
        }

      }
    }
    stage('ECR push') {
      steps {
        script {
          docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com/smartcheck-registry', 'ecr:us-west-1:demo-ecr-credentials') {
            docker.image('image').push('image-test') }
          }

        }
      }
      stage('Smartcheck') {
        environment {
          IMAGETAG = 'image-test'
        }
        steps {
          script {
            $FLAG = sh([ script: 'python /home/scAPI.py', returnStdout: true ]).trim()
            echo $FLAG
            if ($FLAG == '1') {
              docker.withRegistry('102212442704.dkr.ecr.us-west-1.amazonaws.com/sc-blessed', 'ecr:us-west-1:demo-ecr-credentials') {
                docker.image('image').push('image-test') }
              } else {
                echo 'I execute elsewhere'
                docker.withRegistry('102212442704.dkr.ecr.us-west-1.amazonaws.com/sc-quarantined', 'ecr:us-west-1:demo-ecr-credentials') {
                  docker.image('image').push('image-test') }
                }
              }

            }
          }
        }
      }