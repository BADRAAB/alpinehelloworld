pipeline {
    agent any

    environment {
        IMAGE_NAME = "alpinehelloworld"
        IMAGE_TAG = "latest"
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
 
    
       
    }
}
