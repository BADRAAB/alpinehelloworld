pipeline {
    agent any

    environment {
        IMAGE_NAME = "alpinehelloworld"
        IMAGE_TAG = "latest"
        EC2_SSH_CREDENTIALS = 'SSH'  
        EC2_HOST = '63.35.188.224' 
    }

    stages {
        stage('Build image') {
          
            steps {
                script {
                    sh "docker build -t pedro1993/$IMAGE_NAME:$IMAGE_TAG ."
                }
            }
        }
        
        stage('Run container based on built image') {
          
            steps {
                script {
                    sh '''
                        docker run --name alpine_cont -d -p 50001:5000 pedro1993/$IMAGE_NAME:$IMAGE_TAG
                        sleep 5
                    '''
                }
            }
        }
stage('Test image') {
            agent any
            steps {
                script {
                    sh '''
                        curl -s http://52.49.62.165:50001 | grep -q "Hello world!"
                    '''
                }
            }
        }
  stage('Clean Container') {
            agent any
            steps {
                script {
                    sh '''
                        docker stop alpine_cont || true
                        docker rm  alpine_cont || true
                    '''
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    
                       withCredentials([usernamePassword(credentialsId: 'DOCKERHUB', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker login -u $USERNAME -p $PASSWORD"
                        sh "docker push pedro1993/$IMAGE_NAME:$IMAGE_TAG"
                    }
                }
            }
            }

         stage('Deploy to AWS EC2') {
           steps {
    script {
        sshagent([EC2_SSH_CREDENTIALS]) {
            sh '''
                ssh -o StrictHostKeyChecking=no ubuntu@$EC2_HOST << ENDSSH
                docker pull pedro1993/$IMAGE_NAME:$IMAGE_TAG
                if [ "$(docker ps -a -q -f name=alpine_cont)" ]; then
                        docker stop alpine_cont || true
                        docker rm alpine_cont || true
                fi
                docker run --name alpine_cont -d -p 50001:5000 pedro1993/$IMAGE_NAME:$IMAGE_TAG
                ENDSSH
            '''
        }
    }
}

        }
    
       
    }
}
