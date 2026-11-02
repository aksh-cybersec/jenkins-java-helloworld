pipeline {
    agent any
    
    environment {
        DOCKER_USER = 'akshadasable'
        IMAGE_NAME = "akshadasable/java-hello-world:latest"
    }

    stages {
        stage('Pull Code from GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/aksh-cybersec/jenkins-java-helloworld'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Docker Container Locally') {
            steps {
                sh '''
                    docker rm -f java-app-container || true
                    docker run -d --name java-app-container ${IMAGE_NAME}
                '''
            }
        }

        stage('Tag & Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-docker-hub-credentials-id', passwordVariable: 'DOCKER_PASS_ENV', usernameVariable: 'DOCKER_USER_ENV')]) {
                    sh '''
                        set +x
                        echo "$DOCKER_PASS_ENV" | docker login -u "$DOCKER_USER_ENV" --password-stdin
                    '''
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }

        stage('Debug Kubernetes Connection') {
            steps {
                withCredentials([file(credentialsId: 'minikube-config', variable: 'KUBECONFIG')]) {
                    sh '''
                        set -eu
                        echo "Checking Kubernetes context..."
                        kubectl config current-context
                        echo "Checking cluster nodes..."
                        kubectl get nodes
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'minikube-config', variable: 'KUBECONFIG')]) {
                    sh '''
                        set -eu
                        kubectl apply -f deployment.yaml
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withCredentials([file(credentialsId: 'minikube-config', variable: 'KUBECONFIG')]) {
                    sh '''
                        set -eu
                        echo "Verifying deployments, pods, and services..."
                        kubectl get deployments
                        kubectl get pods
                        kubectl get services
                    '''
                }
            }
        }
    }
}
