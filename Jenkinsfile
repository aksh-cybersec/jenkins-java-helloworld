pipeline {
    agent any
    
    environment {
        DOCKER_USER = 'akshadasable'
    }

    stages {
        stage('Pull Code from GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/aksh-cybersec/jenkins-java-helloworld'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t java-hello-world:latest .'
            }
        }

        stage('Run Docker Container Locally') {
            steps {
                sh '''
                    docker rm -f java-app-container || true
                    docker run -d --name java-app-container java-hello-world:latest
                '''
            }
        }

        stage('Tag & Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-docker-hub-credentials-id', passwordVariable: 'DOCKER_PASS_ENV', usernameVariable: 'DOCKER_USER_ENV')]) {
                    sh 'echo "$DOCKER_PASS_ENV" | docker login -u "$DOCKER_USER_ENV" --password-stdin'
                    sh "docker tag java-hello-world:latest ${DOCKER_USER}/java-hello-world:latest"
                    sh "docker push ${DOCKER_USER}/java-hello-world:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Securely binds the cluster config so kubectl can authenticate
                withCredentials([file(credentialsId: 'minikube-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }

        stage('Verify K8s Pod Status') {
            steps {
                // Securely binds the cluster config so kubectl can pull stats
                withCredentials([file(credentialsId: 'minikube-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'kubectl get pods -l app=java-hello'
                }
            }
        }
    }
}
