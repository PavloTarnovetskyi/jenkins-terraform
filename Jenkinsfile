pipeline {
    
    agent any
    
    tools {
        terraform 'terraform'
    }
    
    stages{
        stage('Terraform git checkout') {
            steps {
                git credentialsId: 'github', url: 'git@github.com:PavloTarnovetskyi/terraform-ansible.git'
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