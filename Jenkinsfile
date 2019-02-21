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
            withCredentials([usernamePassword(credentialsId: 'smartcheck-credentials',
            usernameVariable: 'USER', passwordVariable: 'PASSWORD')]) {
              def NAME = env.IMAGETAG+'-'+env.BUILD_ID
              $FLAG = sh([ script: 'python /home/scAPI.py', returnStdout: true ]).trim()
              if ($FLAG == '1') {sh 'docker tag smartcheck-registry sc-blessed'
              docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                docker.image('sc-blessed').push(NAME) }
              } else {
                sh 'docker tag smartcheck-registry sc-quarantined'
                docker.withRegistry('https://102212442704.dkr.ecr.us-west-1.amazonaws.com', 'ecr:us-west-1:demo-ecr-credentials') {
                  docker.image('sc-quarantined').push(NAME) }
                  sh 'exit 1'
                }
              }
            }

          }
        }
        stage('Deploy') {
          steps {
            script {
              env.PATH = "/usr/bin:/usr/local/bin:/home/bin:/home/ec2-user:${env.PATH}"
              env.KUBECONFIG = "/home/.kube/config"
              sh 'aws eks update-kubeconfig --name eks-deploy'
              def NAME = env.IMAGETAG+'-'+env.BUILD_ID

              try {
                sh returnStdout: true, script: "/usr/local/bin/helm install --name=newmyapp /home/myapp --set image.repository=${REPOSITORY} --set image.tag=${NAME}"
              }
              catch (exc) {
                sh returnStdout: true, script: "helm upgrade --wait --recreate-pods newmyapp /home/myapp --set image.repository=${REPOSITORY} --set image.tag=${NAME}"
              }
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
      }
    }