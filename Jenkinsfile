properties([pipelineTriggers([githubPush()])])
pipeline {
    
    agent any
    
    environment {
        AWS_DEFAULT_REGION= "eu-north-1"
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')


    }

    tools {
        terraform 'terraform'
    }
    
    stages{
        stage('Terraform git checkout') {
            steps {
                 git branch: 'jenkins', credentialsId: 'github', url: 'git@github.com:PavloTarnovetskyi/terraform-ansible.git'
             }
        }
        stage('Terraform init'){
            steps{
                                
                sh ("terraform init");
                sh ("terraform validate");
                sh ("terraform apply --auto-approve");
                
            }
        }
    }
}
