node {
    try {
        // some block
        stage('Checkout') {
        // some block
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '933f-03c7e1f9d319', url: 'https://github.com/mrharry/nightwatch_cucumber_tests.git']]])
        }
        stage('print') {
        // some block
            echo 'hello'
        }
        stage('npm') {
            withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
                sh 'node -v'
                sh 'npm -v'
                sh 'npm install'
            }

        }
        stage('Test') {
            withEnv(["PATH+NODE=${tool name: 'JenkinsNode'}/bin"]) {
                sh 'npm run "e2e-test"'
            }
            echo result
        }
        stage('CheckBuild') {
            // some block
            echo result
        }
    }   catch (e) {
            result = "FAIL" // make sure other exceptions are recorded as failure too
    }

}