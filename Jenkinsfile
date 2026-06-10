pipeline {
    agent any

    environment {
        GIT_CREDS = 'git-creds'
        REPO_URL = 'https://github.com/GovindYadav15/ci-cd-demo.git'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Merge dev → stage') {
            steps {
                script {
                    sh '''
                    git config user.email "jenkins@demo.com"
                    git config user.name "Jenkins"

                    git checkout stage
                    git merge dev
                    git push ${REPO_URL} stage
                    '''
                }
            }
        }

        stage('QA Gate - Manual Approval') {
            steps {
                input message: "Approve promotion to PROD?", ok: "Approve"
            }
        }

        stage('Merge stage → prod') {
            steps {
                sh '''
                git checkout prod
                git merge stage
                git push ${REPO_URL} prod
                '''
            }
        }

        stage('Start App (Prod Simulation)') {
            steps {
                sh 'node app/server.js &'
                sleep 5
            }
        }

        stage('Smoke Test') {
            steps {
                sh 'curl -f http://localhost:3000/health'
            }
        }

        stage('Merge prod → main') {
            steps {
                sh '''
                git checkout main
                git merge prod
                git push ${REPO_URL} main
                '''
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed! Rolling back..."

            sh '''
            git checkout prod
            git reset --hard HEAD~1
            git push ${REPO_URL} prod --force
            '''
        }

        success {
            echo "Deployment Successful!"
        }
    }
}