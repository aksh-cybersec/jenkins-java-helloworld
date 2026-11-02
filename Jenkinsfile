pipeline {
    agent any

    stages {
        stage('Pull Code from GitHub') {
            steps {
                // Jenkins pulls the Dockerfile and Java code from your repo
                git branch: 'main', url: 'https://github.com/aksh-cybersec/jenkins-java-helloworld'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds the image using the Dockerfile in the root directory
                sh 'docker build -t java-hello-world:latest .'
            }
        }

        stage('Run Docker Container Locally') {
            steps {
                // Removes any older container with the same name and runs the new one
                sh 'docker run --name java-app-container java-hello-world:latest'
            }
        }
    }
}
