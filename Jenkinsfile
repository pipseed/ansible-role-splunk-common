pipeline {
    agent { label 'ansible-master' }

    environment {
          MS_TEAMS = credentials('TeamsURL')
          PATH="/home/auto-test/.local/bin:${env.PATH}"
    }

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
               webhookUrl: '$MS_TEAMS',
               color: "${currentBuild.currentResult} == 'SUCCESS' ? '00ff00' : 'ff0000'",
               factDefinitions:[
                  [ name: "Message", template: "ansible-role-splunk-common"],
                  [ name: "Pipeline Duration", template: "${currentBuild.durationString.minus(' and counting')}"]
               ]
            )
          }
       failure {
            office365ConnectorSend (
               webhookUrl: '$MS_TEAMS',
               color: "${currentBuild.currentResult} == 'FAILURE' ? 'ff0000' : '00ff00'",
               factDefinitions:[
                  [ name: "Message", template: "${JOB_NAME}"],
                  [ name: "Pipeline Duration", template: "${currentBuild.durationString.minus(' and counting')}"]
               ]
            )
         }
   }
}