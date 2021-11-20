pipeline {
    agent any
    stages {
            stage('GitHub trigger for GITScm polling') {
                steps {
                    script {
                        properties([[$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/bipin115/PG_DevOps_SimpliLearn_Projects.git/'], pipelineTriggers([pollSCM('* * * * *')])])
                    }  
                }
            }
            stage('Git project checkout') {
            steps {
                    git branch: 'main', url: 'https://github.com/bipin115/PG_DevOps_SimpliLearn_Projects.git'  
            }
            }
            stage('Build Application') {
                steps {
                    sh 'mvn -f java-tomcat-sample-docker/pom.xml clean package'
                }
                post {
                    success {
                        echo "Now Archiving the Artifacts...."
                        archiveArtifacts artifacts: '**/*.war'
                    }
                }
            }
            stage('Clean existing Images and stop and remove already running container') {            
                steps {
                catchError (buildResult:'SUCCESS', stageResult: 'FAILURE') {
                sh "docker images"
                sh "docker container ls"
                sh "docker container stop samplewebapp"
                sh "docker rm -f samplewebapp"
                sh "docker image rm -f bipin115/samplewebapp"
                }
                }
            }

            stage('Docker Build and Tag using Ansible-playbook') {
            steps {
                    sh 'docker build -t samplewebapp:latest .'  
                    sh 'docker tag samplewebapp bipin115/samplewebapp:latest'       
            }
            }
            stage('Publish image to Docker Hub') {
                
                steps {
                        withDockerRegistry([ credentialsId: "dockerHub", url: "" ]) {
                        sh  'docker push bipin115/samplewebapp:latest'
                        } 
                }
            }
            stage('Run Docker container') {
                
                steps {
                    sh "docker run --name samplewebapp -d -p 9090:8080 bipin115/samplewebapp"
                }
            }
    }
}
