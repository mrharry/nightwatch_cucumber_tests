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
    stage('') {
      steps {
        cucumber 'cucumber.json'
      }
    }
  }
}