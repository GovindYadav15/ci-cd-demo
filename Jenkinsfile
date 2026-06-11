pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ci-cd-test'
        CONTAINER_NAME = 'ci-cd-test-stage'
        HOST_PORT = '3001'
        CONTAINER_PORT = '3000'
    }

    options {
        disableConcurrentBuilds()
        timestamps()
    }

    stages {
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
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}:${BUILD_NUMBER}
                    sleep 5
                    curl --retry 5 --retry-delay 2 --fail http://localhost:${HOST_PORT}/health
                '''
            }
        }
    }

    post {
        success {
            echo 'Dev pipeline completed successfully'
        }
        failure {
            echo 'Dev pipeline failed'
        }
        always {
            cleanWs()
        }
    }
}
