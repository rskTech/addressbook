pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/suhassg25/addressbook.git'
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '409171460696.dkr.ecr.ap-south-1.amazonaws.com/jenkinsecr'
        IMAGE_TAG = 'latest'
        IMAGE_URI = "${ECR_REPO}:${IMAGE_TAG}"
        EKS_CLUSTER = 'my-cluster'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Clone') {
            steps {
                git url: "${GIT_REPO}", branch: 'master'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_REPO
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_URI .'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_URI'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                 echo "Current directory:"
        pwd

        echo "List files:"
        ls -l
                aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER

                kubectl apply -f deployment.yaml
                kubectl apply -f servicelb.yaml
                '''
            }
        }
    }
}
