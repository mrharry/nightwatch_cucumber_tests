pipeline {
  agent any
  stages {
    stage('checkout') {
      steps {
        echo 'hello'
      }
    }
    stage('next') {
      steps {
        echo 'next hello'
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