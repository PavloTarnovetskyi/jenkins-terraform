pipeline {
    
    agent any
    
    environment {
        AWS_DEFAULT_REGION= "eu-north-1"
        
        
    }

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
                withCredentials([<object of type com.cloudbees.jenkins.plugins.awscredentials.AmazonWebServicesCredentialsBinding>]){
                                 
                sh ("terraform init");
                sh ("terraform apply --auto-approve");
                }
            }
        }
    }
}
