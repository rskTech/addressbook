pipeline {
    agent any
    stages {
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Fingerprint') {
            steps {
                // This tells Jenkins to record the MD5 hash of your build artifact
                fingerprint 'target/*.jar'
            }
        }
    }
}
