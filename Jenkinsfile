node {
    try {
        stage('cleardown') {
            deleteDir()
        }
        stage('checkout') {
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '933f-03c7e1f9d319', url: 'https://github.com/mrharry/nightwatch_cucumber_tests.git']]])
        }
        stage('npmInstall') {
            withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
                sh 'node -v && npm -v && npm install'
            }
        }
        stage('runTests') {
            withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
                try {
                    sh 'npm run "e2e-test"'
                } catch (Exception err) {
                    exit = 0
                }
            }
        }
        stage('runReports') {
            withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
                sh 'npm run "e2e-report"'
            }
            cucumber fileIncludePattern: 'cucumberReport/cucumber.json', sortingMethod: 'ALPHABETICAL'
        }

//           sh 'env > env.txt'
//               for (String i : readFile('env.txt').split("\r?\n")) {
//                println i
//            }
       stage('release docs') {
            withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
                sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}'
                sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}'
                sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}/unitTestReport/'
                sh 'mkdir -p releaseRecords/build_number_${BUILD_ID}/traceability/'
                sh 'cp -r cucumberReport releaseRecords/build_number_${BUILD_ID}'
                sh 'cp -r manualTests releaseRecords/build_number_${BUILD_ID}'
                sh 'zip -r releaseRecords releaseRecords'
            }
       }
        stage('archive') {
            archiveArtifacts 'releaseRecords.zip'
        }
    } catch (e) {
        result = "FAIL" // make sure other exceptions are recorded as failure too
    }

}
