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
            env.PATH = "/usr/local/bin:/home/bin:${env.PATH}"
            env.KUBECONFIG = "/home/.kube/config"
            print env.PATH
            sh 'aws sts get-caller-identity'
            sh 'aws-iam-authenticator token -i eks-deploy'
            sh 'kubectl config --kubeconfig=/home/.kube/config'

            sh 'kubectl get nodes --all-namespaces --v=99'
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
    }
  }