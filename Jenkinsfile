pipeline {
  agent any

  stages {
    stage('Build Artifact') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
      }
    }

    stage('Unit Tests') {
      steps {
        sh "mvn test"
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }

    stage('Docker Build and Push') {
      steps {
        sh 'printenv'
        sh 'docker build -t csivaprasadc/numeric-app:""$GIT_COMMIT"" .'
        sh 'docker push csivaprasadc/numeric-app:""$GIT_COMMIT""'
      }
    }
  }
}