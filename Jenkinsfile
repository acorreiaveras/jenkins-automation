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
          sh '''export VALUE=$(python /home/scAPI.py)
echo $VALUE
echo "VALUE is $VALUE"
if [[ "$VALUE" = "1" ]]; then
   echo "confirmed"
fi
'''
          script {
            if (env.VALUE == '1') {
              echo 'I only execute on the master branch'
            } else {
              echo 'I execute elsewhere'
            }
          }

        }
      }
    }
    environment {
      IMAGETAG = 'jenkins-test1'
    }
  }