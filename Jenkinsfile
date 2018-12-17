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
            docker.image('smartcheck-registry').push(env.IMAGETAG+'-'+env.BUILD_ID)}
          }

        }
      }
      stage('Smartcheck') {
        steps {
          script {
            $FLAG = sh([ script: 'python /home/scAPI.py', returnStdout: true ]).trim()
            if ($FLAG == '1') {
              sh 'docker tag smartcheck-registry sc-blessed'
              docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                docker.image('sc-blessed').push(env.IMAGETAG+'-'+env.BUILD_ID) }
              } else {
                sh 'docker tag smartcheck-registry sc-quarantined'
                docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                  docker.image('sc-quarantined').push(env.IMAGETAG+'-'+env.BUILD_ID) }
                }
                sh 'docker rmi $(docker images -q) -f 2> /dev/null'
              }

            }
          }
        }
        environment {
          IMAGETAG = 'tomcat'
          HIGH = '1'
          MEDIUM = '5'
          LOW = '5'
          NEGLIGIBLE = '5'
          UNKNOWN = '5'
        }
      }