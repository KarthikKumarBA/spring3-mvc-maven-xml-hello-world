pipeline {
    agent any
    tools {
      maven 'MAVEN_HOME'
    }
    stages{
        stage("scm"){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/KarthikKumarBA/spring3-mvc-maven-xml-hello-world.git']]])
            }
        }
        stage("mvn build"){
            steps{
                sh "mvn clean install"
            }
        }
        stage("Sonar"){
            steps{
                script{
                     withSonarQubeEnv(credentialsId: 'sonar') {
                        sh "mvn verify sonar:sonar -Dsonar.projectKey=Spring"
                        sh "echo ${env.SONAR_HOST_URL}"
                
                    }
                }
            }
        }
        stage("docker build"){
            steps{
              
                sh '''docker build -t myapp .'''
            }
        }
        stage("docker tag"){
                steps{
                    sh "docker tag myapp bakarthi/myapp:v1.0.${BUILD_NUMBER}"
                }
            }
            stage("docker push"){
                steps{
                    withCredentials([string(credentialsId: 'docker_hub', variable: 'docker_hub')]) {
                    sh "docker login -u bakarthi -p ${docker_hub}"
                    sh "docker push bakarthi/myapp:v1.0.${BUILD_NUMBER}"
                }
                }
            }
      stage("ecs deploy"){
                steps{
                    sh"sed 's|myapp|bakarthi/myapp:v1.0.${BUILD_NUMBER}|/g' main.tf"
                    sh "terraform init"
                    sh "terraform apply -auto-approve"
                    sh"aws ecs update-service --cluster main --service test-http --task-definition test-http --force-new-deployment"
                }
            }
    }
}
