pipeline {
    agent any
    
    environment {
        // Your exact DockerHub username
        DOCKER_USER = 'akshadasable'
{
        stage('Pull Code from GitHub') {
            steps {
                // Jenkins pulls the Dockerfile and Java code from your repo
                git branch: 'main', url: 'https://github.com/aksh-cybersec/jenkins-java-helloworld'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds the local image exactly like your previous layout
                sh 'docker build -t java-hello-world:latest .'
            }
        }

        stage('Run Docker Container Locally') {
            steps {
                // Safely cleans up the older container instance if it exists, then runs it locally
                sh '''
                    docker run -d --name java-app-container java-hello-world:latest
                '''
            }
        }

        stage('Tag & Push     }

    stages {
        stage('Pull Code from GitHub') {
            steps {
                // Jenkins pulls the Dockerfile and Java code from your repo
                git branch: 'main', url: 'https://github.com/aksh-cybersec/jenkins-java-helloworld'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds the local image exactly like your previous layout
                sh 'docker build -t java-hello-world:latest .'
            }
        }

        stage('Run Docker Container Locally') {
            steps {
                // Safely cleans up the older container instance if it exists, then runs it locally
                sh '''
                    docker run -d --name java-app-container java-hello-world:latest
                '''
            }
        }

        stage('Tag & Push to DockerHub') {
            steps {
                // Binds your precise Jenkins credentials ID
                withCredentials([usernamePassword(credentialsId: 'my-docker-hub-credentials-id', passwordVariable: 'DOCKER_PASS_ENV', usernameVariable: 'DOCKER_USER_ENV')]) {
                    
                    // Uses single quotes to prevent Groovy from intercepting the shell variables
                    sh 'echo "$DOCKER_PASS_ENV" | docker login -u "$DOCKER_USER_ENV" --password-stdin'
                    
                    // Properly tags and pushes your local image using your target DockerHub account prefix
                    sh "docker tag java-hello-world:latest ${DOCKER_USER}/java-hello-world:latest"
                    sh "docker push ${DOCKER_USER}/java-hello-world:latest"
                }
            }

	stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }

        stage('Verify K8s Pod Status') {
            steps {
                sh 'kubectl get pods -l app=java-hello'
            }
        }
    }
}
}
