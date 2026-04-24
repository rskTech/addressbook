pipeline {
    agent any

    environment {
        GIT_REPO            = 'https://github.com/abhisheksajjan73-create/Java_project1.git'
        AWS_REGION          = 'ap-south-1'
        AWS_ACCOUNT_ID      = '966537025366'
        ECR_REPO_NAME       = 'dockerimages'
        IMAGE_TAG           = 'latest'
        IMAGE_URI           = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"
        EKS_CLUSTER         = 'my-eks-cluster'
    }

    stages {

        stage('Install AWS CLI') {
            steps {
                sh '''
                    set -e
                    echo "Installing AWS CLI..."

                    sudo apt update
                    sudo apt install -y unzip curl

                    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
                    unzip -q awscliv2.zip
                    sudo ./aws/install --update

                    aws --version
                '''
            }
        }

        stage('Configure AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                        echo "Verifying AWS identity..."
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('Clone Repository') {
            steps {
                git url: "${GIT_REPO}", branch: 'master'
            }
        }

        stage('Build Application') {
            steps {
                sh '''
                    echo "Building Java application..."
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                        echo "Logging into AWS ECR..."

                        aws ecr get-login-password --region ${AWS_REGION} \
                        | docker login \
                        --username AWS \
                        --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t ${IMAGE_URI} .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo "Pushing Docker image..."
                    docker push ${IMAGE_URI}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Docker image built and pushed successfully."
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
