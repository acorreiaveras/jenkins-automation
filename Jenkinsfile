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
            env.PATH = "/usr/bin:/usr/local/bin:/home/bin:/home/ec2-user:${env.PATH}"
            env.KUBECONFIG = "/home/.kube/config"
            sh '/usr/local/bin/helm install --name=newmyapp /home/myapp --set image.repository=$env.REPOSITORY --set image.tag=$env.NAME'
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
      USER = 'administrator'
      PASSWORD = 'trendmicro'
      REPOSITORY = '102212442704.dkr.ecr.us-west-1.amazonaws.com/sc-blessed'
      KUBECONFIG = '/home/.kube/config'
      NAMESPACE = 'default'
      NAME = 'name'
    }
  }