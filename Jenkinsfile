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
                        git branch: 'main', url: 'https://github.com/bipin115/CICD-webapp-deployment-using-ansibe-docker-container.git'  
                }
            }

            stage('Docker Build and Tag using Ansible-playbook') {
                steps {
                        sh 'ansible all -m ping'
                        sh 'ansible webappserver -m file -a "name=/tmp/sample1.txt state=touch"'
                        sh 'ansible-playbook -i webappserver ./create-docker-container.yaml'
                        //sh 'docker build -t html-server-image .'  
                        // sh 'docker tag html-server-image bipin115/html-server-image:v1'       
                }
            }
            stage('Publish image to Docker Hub') {
                
                steps {
                        withDockerRegistry([ credentialsId: "dockerHub", url: "" ]) {
                        sh  'docker push bipin115/html-server-image:v1'
                        } 
                }
            }
            stage('Run Docker container') {
                
                steps {
                    sh "docker run --name html-server-image -d -p 9090:8080 bipin115/html-server-image:v1"
                }
            }
    }
}
