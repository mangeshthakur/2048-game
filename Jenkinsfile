pipeline {
    agent any  // Run on any available Jenkins agent

    environment {
        AWS_REGION = "us-east-1"  // Change as per your setup
        INSTANCE_USER = "ubuntu"
        TERRAFORM_DIR = "$WORKSPACE/terraform-setup"  // Directory with main.tf
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Pravesh-Sudha/2048-game.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        dir(TERRAFORM_DIR) {
                            sh """
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            terraform init
                            """
                        }
                    }
                }
            }
        }

        stage('Terraform Apply - Provision EC2 Instance') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        dir(TERRAFORM_DIR) {
                            sh """
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            terraform apply -auto-approve
                            """
                        }
                    }
                }
            }
        }

        stage('Get EC2 Public IP') {
            steps {
                script {
                    dir(TERRAFORM_DIR) {
                        def output = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                        env.INSTANCE_IP = output
                        echo "New EC2 Instance IP: ${env.INSTANCE_IP}"
                    }
                }
            }
        }

        stage('Wait for EC2 to be Ready') {
            steps {
                script {
                    sleep(60)  // Wait for 1 minute to allow instance setup
                }
            }
        }

        stage('Setup Docker on EC2') {
            steps {
                withCredentials([file(credentialsId: 'EC2_SSH_KEY', variable: 'KEY_PATH')]) {
                    script {
                        sh """
                        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} ${INSTANCE_USER}@${env.INSTANCE_IP} << 'EOF'
                            sudo apt-get update
                            sudo apt-get install -y docker.io
                            sudo systemctl start docker
                            sudo systemctl enable docker
                        EOF
                        """
                    }
                }
            }
        }

        stage('Deploy 2048 Game') {
            steps {
                withCredentials([file(credentialsId: 'EC2_PRIVATE_KEY', variable: 'KEY_PATH')]) {
                    script {
                        sh """
                        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} ${INSTANCE_USER}@${env.INSTANCE_IP} << 'EOF'
                            cat <<EOT > Dockerfile
                            FROM ubuntu:22.04
                            RUN apt-get update
                            RUN apt-get install -y curl zip nginx
                            RUN echo "daemon off;" >> /etc/nginx/nginx.conf
                            RUN curl -o /var/www/html/master.zip -L https://codeload.github.com/gabrielecirulli/2048/zip/master
                            RUN cd /var/www/html && unzip master.zip && mv 2048-master/* . && rm -rf 2048-master master.zip
                            EXPOSE 80
                            CMD [ "/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf" ]
                            EOT
                            
                            docker build -t 2048-game .
                            docker run -d -p 80:80 2048-game
                        EOF
                        """
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo "Game should be running at: http://${env.INSTANCE_IP}"
                }
            }
        }
    }
}
