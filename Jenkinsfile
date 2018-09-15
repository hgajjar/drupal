pipeline {
    agent {
        label "jenkins-nodejs"
    }
    environment {
      ORG               = 'hgajjar'
      APP_NAME          = 'drupal'
      CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    }
    stages {
      stage('Build Release') {
        when {
          branch 'master'
        }
        steps {
          container('nodejs') {
            // ensure we're not on a detached head
            sh "git checkout master"
            // until we switch to the new kubernetes / jenkins credential implementation use git credentials store
            sh "git config --global credential.helper store"
            // so we can retrieve the version in later steps
            sh "echo \$(jx-release-version) > VERSION"
          }
          dir ('./charts/drupal') {
            container('nodejs') {
              sh "jx step git credentials"
              sh "make tag"
            }
          }
          container('nodejs') {
            sh "docker build -t \$JENKINS_X_DOCKER_REGISTRY_SERVICE_HOST:\$JENKINS_X_DOCKER_REGISTRY_SERVICE_PORT/$ORG/$APP_NAME:\$(cat VERSION) ."
            sh "docker push \$JENKINS_X_DOCKER_REGISTRY_SERVICE_HOST:\$JENKINS_X_DOCKER_REGISTRY_SERVICE_PORT/$ORG/$APP_NAME:\$(cat VERSION)"
          }
        }
      }
      stage('Promote to Environments') {
        when {
          branch 'master'
        }
        steps {
          dir ('./charts/drupal') {
            container('nodejs') {
              sh 'jx step changelog --version v\$(cat ../../VERSION)'

              // release the helm chart
              sh 'make release'

              // promote through all 'Auto' promotion Environments
              sh 'jx promote -b --all-auto --timeout 1h --version \$(cat ../../VERSION)'
            }
          }
        }
      }
    }
    post {
        always {
            cleanWs()
        }
    }
  }