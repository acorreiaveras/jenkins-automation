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
    stage('ECR push') {
      steps {
        script {
          docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
            docker.image('smartcheck-registry').push($IMAGETAG) }
          }

        }
      }
      stage('Smartcheck') {
        steps {
          script {
            $FLAG = sh([ script: 'python /home/scAPI.py', returnStdout: true ]).trim()
            echo $VALUE
            if ($FLAG == '1') {
              docker.withRegistry('102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                docker.image('sc-blessed').push($IMAGETAG) }
              } else {
                echo 'I execute elsewhere'
                docker.withRegistry('102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                  docker.image('sc-quarantined').push($IMAGETAG) }
                }
              }

            }
          }
        }
        environment {
          IMAGETAG = 'image-test'
        }
      }