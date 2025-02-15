pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')  // AWS Credentials
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        SSH_KEY = credentials('EC2_SSH_KEY')  // SSH Key for EC2 access
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_GITHUB/2048-Terraform-Jenkins.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                cd terraform
                terraform init
                terraform apply -auto-approve
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t 2048-game .'
            }
        }

        stage('Deploy 2048 Game') {
            steps {
                sshagent(['EC2_SSH_KEY']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@<EC2_PUBLIC_IP> <<EOF
                    docker stop 2048-container || true
                    docker rm 2048-container || true
                    docker run -d --name 2048-container -p 80:80 2048-game
                    EOF
                    '''
                }
            }
        }
    }
}
