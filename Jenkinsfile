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
      description: 'Host to deploy to........'
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
       office365ConnectorSend (
       webhookUrl: "https://cruisecomputersltd.webhook.office.com/webhookb2/dbacab0c-d252-4a01-a583-16756d169829@03997cfc-e9dd-4570-b3d9-e7a22204ecf2/IncomingWebhook/8dc54f3a59434a61b9e457c92d0bf53c/154c2151-ad38-4a12-b94a-9e51d20dd477",
       color: "${currentBuild.currentResult} == 'SUCCESS' ? '00ff00' : 'ff0000'",
       factDefinitions:[
          [ name: "Commit Message", template: "${commit_message}"],
          [ name: "Pipeline Duration", template: "${currentBuild.durationString.minus(' and counting')}"]
       ]
       )
     }
   }
}