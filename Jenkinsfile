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
	
        stage('Setup localized kubectl CLI') {
            steps {
                // Downloads and marks a local workspace copy of kubectl as executable
                sh '''
                    curl -LO "https://k8s.io"
                    chmod +x ./kubectl
                '''
            }
        }

        stage('Debug Kubernetes Connection') {
            steps {
                withCredentials([file(credentialsId: 'minikube-kubeconfig', variable: 'KUBECONFIG')]) {
                    // Executing via "./kubectl" bypasses the host shell system PATH limits
                    sh '''
                        set -eu
                        echo "Checking Kubernetes context..."
                        ./kubectl config current-context

                        echo "Checking Kubernetes API..."
                        ./kubectl get --raw=/version

                        echo "Checking cluster nodes..."
                        ./kubectl get nodes
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'minikube-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        set -eu
                        ./kubectl apply -f deployment.yaml
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withCredentials([file(credentialsId: 'minikube-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        set -eu
                        ./kubectl get deployments
                        ./kubectl get pods
                        ./kubectl get services
                    '''
                }
            }
        }
    }
}
