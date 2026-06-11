pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ci-cd-test'
        CONTAINER_NAME = 'ci-cd-test-dev'
        PORT = '3000'
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
                    curl --retry 5 --retry-delay 2 --fail http://localhost:${PORT}/health
                '''
            }
        }

        stage('Promote to stage') {
            steps {
                script {
                    def currentBranch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                    if (currentBranch == 'dev' || currentBranch == 'origin/dev') {
                        withCredentials([usernamePassword(credentialsId: 'git-creds', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                            sh '''
                                git config user.name "jenkins"
                                git config user.email "jenkins@ci.local"
                                git fetch origin
                                git checkout -B stage origin/stage
                                git merge --no-ff origin/dev -m "Promote dev to stage from build ${BUILD_NUMBER}"
                                git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/GovindYadav15/ci-cd-demo.git stage
                            '''
                        }
                    } else {
                        echo "Skipping promotion: current branch is ${currentBranch}"
                    }
                }
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
