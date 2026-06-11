pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ci-cd-test'
        CONTAINER_NAME = 'ci-cd-test-dev'
        PORT = '3000'
    }

    options {
        ansiColor('xterm')
        disableConcurrentBuilds()
        timestamps()
    }

    stages {

        stage('Guard: Dev Only and Checkout') {
            when {
                 branch 'dev' 
            }
            steps {
                checkout scm
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

        stage('Deploy Dev Container') {
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
