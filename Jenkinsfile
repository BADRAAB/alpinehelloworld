pipeline {
    agent none

    environment {
        IMAGE_NAME = "alpinehelloworld"
        IMAGE_TAG = "latest"
        EC2_SSH_CREDENTIALS = 'ssh_key_ec2'  // ID de tes identifiants SSH dans Jenkins
        EC2_HOST = '63.35.188.224' 
    }

    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh "docker build -t pedro1993/$IMAGE_NAME:$IMAGE_TAG ."
                }
            }
        }
        
        stage('Run container based on built image') {
            agent any
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

        stage('Deploy to AWS EC2') {
            agent any
            steps {
                script {
                    sshagent([EC2_SSH_CREDENTIALS]) {
                        sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@$EC2_HOST << 'ENDSSH'
                                docker pull pedro1993/$IMAGE_NAME:$IMAGE_TAG
                                docker stop $IMAGE_NAME || true
                                docker rm $IMAGE_NAME || true
                                docker run --name alpine_cont -d -p 50001:5000 pedro1993/$IMAGE_NAME:$IMAGE_TAG
                            ENDSSH
                        '''
                    }
                }
            }
        }
    }
}
