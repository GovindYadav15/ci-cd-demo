pipeline {
    agent any

    environment {
        IMAGE_NAME = 'robert803556/ci-cd-test'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set TAG (Git SHA)') {
            steps {
                script {
                    env.TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                }
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${TAG} .
                    docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    echo "Pushing ${IMAGE_NAME}:${TAG}"
                    docker push ${IMAGE_NAME}:${TAG}
                '''
            }
        }
        stage('Deploy DEV (running as a container)') {
    steps {
        sh '''
            docker compose -f docker-compose.dev.yml down || true
            docker compose -f docker-compose.dev.yml up -d
        '''
    }
}
        stage('Health Check') {
            steps {
                sh '''
                    sleep 5
                    curl --fail http://localhost:4173
                '''
            }
    }
    }
}