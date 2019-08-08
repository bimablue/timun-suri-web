#!groovy
import groovy.json.*

def version = "ICE-"+ branchName.take(10) ?: "ICE-master"
def cucumberTags = customTag ?: "@smoke-test and not @directory"

stage("Setup") {
  node('docker') {
      step([$class: 'WsCleanup'])
      sh "mkdir -p $WORKSPACE/report"
      sh "docker login -u _json_key --password-stdin https://gcr.io < ~/gce-jenkins.json"
      sh "docker pull gcr.io/sleekr-hr-staging/sleekr/kryptonite:${version}"
      sh "docker ps"
      sh "docker images"
    }
}

stage("Testing") {
  node('docker') {
      timeout(30) {
        try {
          def docker_run = "docker run -v $WORKSPACE/report:/app/report -e t='\"${cucumberTags}\"' gcr.io/sleekr-hr-staging/sleekr/kryptonite:${version}"
          echo docker_run
          sh docker_run
        }catch(Exception error){
          echo "Cucumber test: FAILED"
          echo error
        }finally{
          sh "ls -a "
          cucumber fileIncludePattern: '**/*.json', jsonReportDirectory: "$WORKSPACE/report/output",  buildStatus: 'UNSTABLE', failedScenariosNumber: 5, trendsLimit: 5
        }
      }
    }
}

stage('Notify'){
  node('docker') {
    sh 'report/'
    sh 'ls -a'
  }
}