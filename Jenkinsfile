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
          echo env.IMAGE_NAME

          docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
            docker.image('smartcheck-registry').push(env.IMAGE_NAME)}
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
                docker.image('sc-blessed').push(${env.IMAGE_NAME}) }
              } else {
                sh 'docker tag smartcheck-registry sc-quarantined'
                echo 'I execute elsewhere'
                docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                  docker.image('sc-quarantined').push(${env.IMAGE_NAME}) }
                }

                sh 'docker rmi $(docker images -q) -f 2> /dev/null'
              }

            }
          }
        }
        environment {
          IMAGE_NAME = 'test5'
        }
      }