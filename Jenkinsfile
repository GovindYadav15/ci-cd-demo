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
                    echo "Pushing ${IMAGE_NAME}:latest"
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }
        stage('Deploy DEV (running as a container)') {
            steps {
                sh '''
                    docker rm -f ci-cd-demo-dev || true
                    docker run -d --name ci-cd-demo-dev -p 4173:3000 ${IMAGE_NAME}:latest
                '''
            }
        }
        stage('Health Check') {
            steps {
                sh '''
                    for i in 1 2 3 4 5; do
                        docker exec ci-cd-demo-dev node -e 'const http=require("http"); http.get("http://127.0.0.1:3000", res=>{ if (res.statusCode===200) process.exit(0); console.error("status", res.statusCode); process.exit(1); }).on("error", e=>{ console.error(e.message); process.exit(1); });' && exit 0
                        echo "Waiting for app to become ready..."
                        sleep 3
                    done
                    echo "Container logs:"
                    docker logs ci-cd-demo-dev
                    exit 1
                '''
            }
        }
    }
}