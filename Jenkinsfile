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
    }
}