pipeline {
    agent {
        docker {
            image 'node:18'
        }
    }

    environment {
        GIT_CREDS = 'sdfhkjhf-343434'
        REPO_URL  = 'https://github.com/GovindYadav15/ci-cd-demo.git'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {

        stage('Guard: Allow only dev CI execution') {
            when {
                not {
                    branch 'dev'
                }
            }
            steps {
                script {
                    echo "Skipping pipeline for branch: ${env.BRANCH_NAME}"
                    currentBuild.result = 'SUCCESS'
                    error("Not dev branch - stopping CI execution")
                }
            }
        }

        stage('Test') {
            steps {
                sh 'chmod +x test.sh'
                sh './test.sh'
            }
        }

        stage('Promote Dev -> Stage') {
            when {
                branch 'dev'
            }

            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${GIT_CREDS}",
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_PASS'
                    )
                ]) {

                    sh '''
                        set -e

                        git config user.email "jenkins@example.com"
                        git config user.name "Jenkins"

                        git fetch origin +refs/heads/*:refs/remotes/origin/*

                        git reset --hard HEAD
                        git clean -fd

                        git checkout -B stage origin/stage
                        git merge --ff-only origin/dev

                        git push https://$GIT_USER:$GIT_PASS@github.com/GovindYadav15/ci-cd-demo.git stage

                        echo "DEV → STAGE promotion done"
                    '''
                }
            }
        }

        stage('Promote Stage -> Prod') {
            when {
                branch 'dev'   
            }

            input {
                message "Approve STAGE → PROD promotion?"
                ok "Approve"
            }

            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${GIT_CREDS}",
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_PASS'
                    )
                ]) {

                    sh '''
                        set -e

                        git fetch origin +refs/heads/*:refs/remotes/origin/*

                        git checkout -B prod origin/prod
                        git merge --ff-only origin/stage

                        git push https://$GIT_USER:$GIT_PASS@github.com/GovindYadav15/ci-cd-demo.git prod

                        echo "STAGE → PROD promotion done"
                    '''
                }
            }
        }

        stage('Deploy Production') {
            when {
                branch 'dev'
            }

            steps {
                sh '''
                    echo "Starting production simulation..."
                    node app/server.js &
                    sleep 5
                    curl -f http://localhost:3000/health
                '''
            }
        }

        stage('Sync Prod -> Main') {
            when {
                branch 'dev'
            }

            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${GIT_CREDS}",
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_PASS'
                    )
                ]) {

                    sh '''
                        set -e

                        git fetch origin +refs/heads/*:refs/remotes/origin/*

                        git checkout -B main origin/main
                        git merge --ff-only origin/prod

                        git push https://$GIT_USER:$GIT_PASS@github.com/GovindYadav15/ci-cd-demo.git main

                        echo "PROD → MAIN sync done"
                    '''
                }
            }
        }
    }

    post {

        success {
            echo "Pipeline completed successfully on ${env.BRANCH_NAME}"
        }

        failure {
            echo "Pipeline failed on ${env.BRANCH_NAME}"
        }

        always {
            sh '''
                echo "DEBUG"
                echo "Branch: $BRANCH_NAME"
                git branch -a || true
                git log --oneline -5 || true
            '''
        }
    }
}