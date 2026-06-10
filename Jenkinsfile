pipeline {
    agent {
        docker {
            image 'node:18'
        }
    }

    environment {
        GIT_CREDS = 'git-creds'
        REPO = 'github.com/GovindYadav15/ci-cd-demo.git'
    }

    stages {

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
                withCredentials([usernamePassword(
                    credentialsId: "${GIT_CREDS}",
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {
                    sh '''
                    git config user.email "jenkins@demo.com"
                    git config user.name "Jenkins"

                    git fetch origin

                    git checkout -B stage origin/stage
                    git merge origin/dev

                    git push https://${GIT_USER}:${GIT_PASS}@${REPO} stage
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
                withCredentials([usernamePassword(
                    credentialsId: "${GIT_CREDS}",
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {
                    sh '''
                    git fetch origin

                    git checkout -B prod origin/prod
                    git merge origin/stage

                    git push https://${GIT_USER}:${GIT_PASS}@${REPO} prod
                    '''
                }
            }
        }

        stage('Start App (Prod Simulation)') {
            steps {
                sh 'node app/server.js &'
                sh 'sleep 5'
            }
        }

        stage('Smoke Test') {
            steps {
                sh 'curl -f http://localhost:3000/health'
            }
        }

        stage('Merge prod → main') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${GIT_CREDS}",
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {
                    sh '''
                    git fetch origin

                    git checkout -B main origin/main
                    git merge origin/prod

                    git push https://${GIT_USER}:${GIT_PASS}@${REPO} main
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed! Rolling back..."

            withCredentials([usernamePassword(
                credentialsId: "${GIT_CREDS}",
                usernameVariable: 'GIT_USER',
                passwordVariable: 'GIT_PASS'
            )]) {
                sh '''
                git fetch origin

                git checkout -B prod origin/prod
                git reset --hard HEAD~1

                git push https://${GIT_USER}:${GIT_PASS}@${REPO} prod --force
                '''
            }
        }

        success {
            echo "Deployment Successful!"
        }
    }
}