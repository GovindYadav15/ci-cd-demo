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

        stage('Debug: Agent and Workspace') {
            steps {
                sh '''
                echo "[CI DEBUG] --- Debug Stage ---"
                echo "[CI DEBUG] uname: $(uname -a || true)"
                echo "[CI DEBUG] whoami: $(whoami || true)"
                echo "[CI DEBUG] PATH: $PATH"
                echo "[CI DEBUG] PWD: $(pwd)"
                echo "[CI DEBUG] Listing workspace:"
                ls -la || true
                echo "[CI DEBUG] End Debug Stage"
                '''
            }
        }

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
                echo "[CI DEBUG] PATH: $PATH"
                echo "[CI DEBUG] whoami: $(whoami)"
                echo "[CI DEBUG] docker version and info"
                docker --version || true
                docker info || true

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

                echo "Current docker ps -a:" 
                docker ps -a || true

                echo "Starting new container..."
                docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${PORT}:${PORT} \
                    ${IMAGE_NAME}:${BUILD_NUMBER}

                echo "Container started, showing recent containers:"
                docker ps -a || true

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
