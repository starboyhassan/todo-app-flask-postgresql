pipeline{
    agent{
        label "any"
    }
    environment {  
        ECR_REPO = '767397888237.dkr.ecr.us-east-1.amazonaws.com/project_repo'   // ECR repo URI
        APP_IMAGE_NAME = 'todo-python-app'                                             // name of App image
        DB_IMAGE_NAME = 'todo-python-db'                                                // name of DB image
        DEPLOTMENT_PATH = 'Kubernetes/deployment.yaml'                      // path to deployment.yml in GitHub repo
        STATEFULSET_PATH = 'Kubernetes/statefulset.yaml'                   // path to the statefulset.yml in GitHub repo
        AWS_CREDENTIALS_ID = 'aws'                                        // AWS credentials variable ID in jenkins-credentials
        KUBECONFIG_ID = 'kubeconfig'                                     // EKS-cluster credentials variable ID in jenkins-credentials
        }
    
    stages{
        stage("Checkout from Github"){
            steps{
                git branch: 'main', url: 'https://github.com/starboyhassan/todo-app-flask-postgresql'
            }
        }
        
        stage('Build Images') {
            steps {
                // build and tag images to push them to ECR
                sh "docker build -t ${ECR_REPO}:${APP_IMAGE_NAME}-${BUILD_NUMBER} -f Dockerfile_app ."
                sh "docker build -t ${ECR_REPO}:${DB_IMAGE_NAME}-${BUILD_NUMBER} -f Dockerfile_db ."
            }
        }

        stage('Push Images') {
            steps {
                withAWS(credentials: "${AWS_CREDENTIALS_ID}"){
                    sh "(aws ecr get-login-password --region us-east-1) | docker login -u AWS --password-stdin ${ECR_REPO}"
                    sh "docker push ${ECR_REPO}:${APP_IMAGE_NAME}-${BUILD_NUMBER}"
                    sh "docker push ${ECR_REPO}:${DB_IMAGE_NAME}-${BUILD_NUMBER}" 
                }
            }
        }

        stage('Remove Images') {
            steps {
                // delete images from jenkins server
                sh "docker rmi ${ECR_REPO}:${APP_IMAGE_NAME}-${BUILD_NUMBER}"
                sh "docker rmi ${ECR_REPO}:${DB_IMAGE_NAME}-${BUILD_NUMBER}"
            }
        }

        stage('Update k8s Manifests') {
            steps {
                // update images in deployment & statefulset manifists with ECR new images
                sh "sed -i 's|image:.*|image: ${ECR_REPO}:${APP_IMAGE_NAME}-${BUILD_NUMBER}|g' ${DEPLOTMENT_PATH}"
                sh "sed -i 's|image:.*|image: ${ECR_REPO}:${DB_IMAGE_NAME}-${BUILD_NUMBER}|g' ${STATEFULSET_PATH}"
                    
            }
        }
        stage('Deploy on EKS') {
            steps {
                //Deploy kubernetes manifists in EKS cluster
                withAWS(credentials: "${AWS_CREDENTIALS_ID}"){
                    withCredentials([file(credentialsId: "${KUBECONFIG_ID}", variable: 'KUBECONFIG')]) {
                        sh "kubectl apply -f Kubernetes"   // 'Kubernetes' is a directory contains all kubernetes manifists
                    }                          
                }
            }
        }
        stage('Website URL') {
            steps {
                script {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}"){
                        withCredentials([file(credentialsId: "${KUBECONFIG_ID}", variable: 'KUBECONFIG')]) {
                            def url = sh(script: 'kubectl get svc todo-app-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"', returnStdout: true).trim()
                            echo "Website url: http://${url}/"
                        }
                    }
                }
            }
        }

    }

    post {
        success {
            script {
                // Slack notification on successful build
                slackSend(
                    channel: "jenkinschannel",
                    color: "#00FF80",
                    message:"SUCCESSED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
                )
            }
        }
        failure {
            script {
                // Slack notification on failed build
                slackSend(
                    channel: "jenkinschannel",
                    color: "#FF0000",
                    message:"FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
                )
            }
        }
    }
}

