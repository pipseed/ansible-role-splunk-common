pipeline {
    agent { label 'ansible-master' }
    parameters {
    choice(
      name: 'Site',
      choices: ['Home', 'AWS', 'Test'],
      description: 'Site Location:\nHome\nAWS\nTesting'
    )
    choice(
      name: 'Host',
      choices: ['dev-kvm-04', 'dev-kvm-10', 'dev-kvm-09', 'dev-kvm-08', 'dev-kvm-07'],
      description: 'Host to deploy to.......'
    )
    }
    environment {
          PATH="/home/auto-test/.local/bin:${env.PATH}"
    }
    stages {
      stage('Fetch Roles') {
        steps {
          sh "ansible-galaxy install -p provision/roles -r provision/splunk-common.yml"
        }
      }
      
      stage('Run Playbook') {
        steps {
          sh "ansible-playbook provision/splunk-install.yml -i provision/hosts -e 'chosen_hosts=${params.Host}'"
        }
      }
   }
   post {
     success {
       sh 'pwd'
       sh 'ls -ltra'
       sh 'git checkout main'
       sh 'git merge dev'
       sh 'git push'
     }
   } 
}
