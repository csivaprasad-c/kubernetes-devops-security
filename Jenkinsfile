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
    }

    stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
      post {
        always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        }
      }
    }

    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.projectName='Numeric Application' -Dsonar.host.url=http://devsecops-prasad-cloud.eastus.cloudapp.azure.com:9000"
        }
        timeout(time: 2, unit: 'MINUTES') {
          script {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }

    stage('Vulnerability Scan - Docker') {
      steps {
        parallel(
          "Dependency Scan": {
            sh "mvn dependency-check:check"
          },
          "Trivy Scan": {
            sh "bash trivy-docker-image-scan.sh"
          }
        )
      }
    }

    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: 'docker-hub', url: '']) {
          sh 'printenv'
          sh 'docker build -t csivaprasadc/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push csivaprasadc/numeric-app:""$GIT_COMMIT""'
        }
      }
    }

    stage('k8s Deployment - Dev') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh "sed -i 's#replace#csivaprasadc/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }
  }

  post {
    always {
        junit 'target/surefire-reports/*.xml'
        jacoco execPattern: 'target/jacoco.exec'
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
    }
  }
}