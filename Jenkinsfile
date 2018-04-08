pipeline {
  agent any
  stages {
    stage('checkout') {
      steps {
        echo 'hello'
      }
    }
    stage('E2E-TEST') {
      steps {
        sh 'npm -v'
      }
    }
    stage('error') {
      steps {
        cucumber 'cucumber*'
      }
    }
    stage('End') {
      steps {
        echo 'end of the pipeline'
      }
    }
  }
}
