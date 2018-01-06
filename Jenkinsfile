node {
    try {
          sh 'env > env.txt'
          readFile('env.txt').split("\r?\n").each {
          println it
            }
        withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
            if (release == "deploy") {
                checkout()


                stage('npmInstall') {
                    sh 'node -v && npm -v && npm install'
                }
            }
            if (release == "deploy" || "test") {
                stage('runTests') {
                    try {
                        sh 'npm run "e2e-test"'
                    } catch (Exception err) {
                        exit = 0
                    }
                }
                stage('runReports') {
                    sh 'npm run "e2e-report"'
                    cucumber fileIncludePattern: 'cucumberReport/cucumber.json', sortingMethod: 'ALPHABETICAL'
                }
            }
            if (release == "deploy") {
                stage('runTraceability') {
                    sh """#!/bin/bash -l
                       rvm use ruby-2.2.3
                       ruby getFeatureResults.rb
                       ruby getRedmineTickets.rb ${REDMINE} ${USER} ${PASSWORD} ${BUILD_ID}
                    """
                }
               stage('release docs') {
                    sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}'
                    sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}/unitTestReport/'
                    sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}/traceability/'
                    sh 'mv cucumberReport releaseRecords/build_number_${BUILD_ID}'
                    sh 'mv manualTests releaseRecords/build_number_${BUILD_ID}'
                    sh 'mv traceability_build_$BUILD_ID*.csv releaseRecords/build_number_${BUILD_ID}/traceability'
                    sh 'zip -r releaseRecords releaseRecords'
               }
                stage('archive') {
                    archiveArtifacts 'releaseRecords.zip'
                }
            }
        }
    } catch (e) {
        result = "FAIL" // make sure other exceptions are recorded as failure too
    }

    def checkout () {
       stage 'checkout'
         deleteDir()
         checkout scm
    }

}
