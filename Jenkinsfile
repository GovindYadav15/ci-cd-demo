pipeline {
    agent any

    environment {
        CI = 'true'
        IMAGE_NAME = 'wiseai-chat-widget'
        CONTAINER_NAME = 'wiseai-chat-widget-dev'
        PORT = '3000'
    }

    options {
        ansiColor('xterm')
        disableConcurrentBuilds()
        timestamps()
    }

    stages {

        stage('Guard: Dev Only') {
            when {
                not { branch 'dev' }
            }
            steps {
                script {
                    echo "Skipping build for branch: ${env.BRANCH_NAME}"
                    currentBuild.result = 'SUCCESS'
                    error("Only dev branch is allowed")
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                script {
                    docker.image('node:22-alpine').inside {
                        sh '''
                        npm ci
                        npm run lint || true
                        npm test || true
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Deploy to Dev') {
            steps {
                sh '''
                set -e

                echo "Stopping old container..."
                docker rm -f ${CONTAINER_NAME} || true

                echo "Starting new container..."
                docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${PORT}:${PORT} \
                    ${IMAGE_NAME}:${BUILD_NUMBER}

                echo "Waiting for app..."
                sleep 5

                echo "Running health check..."
                curl --retry 5 --retry-delay 2 --fail http://localhost:${PORT}/health

                echo "Dev deployment successful!"
                '''
            }
        }
    }

    post {
        success {
            echo "Dev pipeline completed successfully"
        }
        failure {
            echo "Dev pipeline failed"
        }
        always {
            cleanWs()
        }
    }
}