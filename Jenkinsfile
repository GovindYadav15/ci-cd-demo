pipeline {
    agent any

    environment {
        IMAGE_NAME = 'robert803556/ci-cd-test'
        TAG = '${GIT_COMMIT}'
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds'
        HOST_PORT = '3001'
        CONTAINER_PORT = '3000'
    }

    options {
        disableConcurrentBuilds()
        timestamps()
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image ') {
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
                    credentialsId: "${DOCKER_CREDENTIALS_ID}", 
                    usernameVariable: 'DOCKER_USERNAME', 
                    passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    '''
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                sh '''
                    docker push ${IMAGE_NAME}:${TAG}
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        // stage('Trigger Stage Deploy') {
        //     when {
        //         branch 'stage'
        //     }
        //     steps {
        //         build job: 'deploy-stage'
        //     }
        // }

        // stage('Trigger Prod Deploy') {
        //     when {
        //         branch 'main' || branch 'prod'
        //     }
        //     steps {
        //         build job: 'deploy-prod'
        //     }
        // }
        
        stage('Deploy DEV') {
            steps {
                sh '''
                    docker-compose -f docker-compose.dev.yml down || true
                    docker-compose -f docker-compose.dev.yml up -d
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

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
        always {
            cleanWs()
        }
    }
}
