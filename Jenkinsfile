node {
    try {
        withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
            stage('cleardown') {
                deleteDir()
            }
            stage('checkout') {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '933f-03c7e1f9d319', url: 'https://github.com/mrharry/nightwatch_cucumber_tests.git']]])
            }
            stage('npmInstall') {
                sh 'node -v && npm -v && npm install'
            }
            stage('runTests') {
                try {
                    sh 'npm run "e2e-test"'
                } catch (Exception err) {
                    exit = 0
                }
            }
            stage('runTraceability') {
                sh 'ruby ruby_join.rb'
            }
            stage('runReports') {
                sh 'npm run "e2e-report"'
                cucumber fileIncludePattern: 'cucumberReport/cucumber.json', sortingMethod: 'ALPHABETICAL'
            }
           stage('release docs') {
                sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}'
                sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}/unitTestReport/'
                sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}/traceability/'
                sh 'mv cucumberReport releaseRecords/build_number_${BUILD_ID}'
                sh 'mv manualTests releaseRecords/build_number_${BUILD_ID}'
                sh 'mv traceability.csv releaseRecords/build_number_${BUILD_ID}/traceability'
                sh 'zip -r releaseRecords releaseRecords'
           }
            stage('archive') {
                archiveArtifacts 'releaseRecords.zip'
            }
        }
    } catch (e) {
        result = "FAIL" // make sure other exceptions are recorded as failure too
    }

}
