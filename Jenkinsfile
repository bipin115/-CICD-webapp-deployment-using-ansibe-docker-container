pipeline {
    agent any
    tools {
    	maven 'Maven_Home'
        jdk 'JDK_11'
	}
    stages {
            stage('GitHub trigger for GITScm polling') {
                steps {
                    script {
                        properties([[$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/bipin115/CICD-webapp-deployment-using-ansibe-docker-container.git/'], pipelineTriggers([pollSCM('* * * * *')])])
                    }  
                }
            }
            stage('Git project checkout') {
                steps {
                        git branch: 'master', url: 'https://github.com/bipin115/CICD-webapp-deployment-using-ansibe-docker-container.git'  
                }
            }
            stage('Clean Existing Images and Stop and remove Running container') {            
                steps {
                    catchError (buildResult:'SUCCESS', stageResult: 'FAILURE') {
                    sh "docker images"
                    sh "docker container ls"
                    sh "docker container stop html-server-image-nginx"
                    sh "docker rm -f html-server-image-nginx"
                    sh "docker image rm -f bipin115/html-server-image-nginx"
                    }
                }
            }
            stage('Docker Build and Tag using Ansible-playbook') {
                steps {
                         sh 'docker build -t html-server-image-nginx .'  
                         sh 'docker tag html-server-image-nginx bipin115/html-server-image-nginx:v1'       
                }
            }
            stage('Publish image to Docker Hub') {
                
                steps {
                        withDockerRegistry([ credentialsId: "dockerHub", url: "" ]) {
                        sh  'docker push bipin115/html-server-image-nginx:v1'
                        } 
                }
            }
            stage('Run Docker container') {
                
                steps {
                    sh "docker run --name html-server-image-nginx -d -p 9090:80 bipin115/html-server-image-nginx:v1"
                }
            }
    }
}
