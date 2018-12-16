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
            docker.image('smartcheck-registry').push('image-test')}
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
              sh 'docker tag smartcheck-registry sc-blessed'
              docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                docker.image('sc-blessed').push('image-test') }
              } else {
                sh 'docker tag smartcheck-registry sc-quarantined'
                echo 'I execute elsewhere'
                docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                  docker.image('sc-quarantined').push('image-test') }
                }
              }

            }
          }
        }
      }