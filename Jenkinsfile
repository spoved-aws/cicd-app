pipeline {
    agent any
    tools{
        maven "Maven3"
        jdk "OracleJDK8"
    }

    environment {
        SNAP_REPO           = 'spoved-vprofile-snapshot'
        NEXUS_USER          = 'admin'
        NEXUS_PASS          = 'nexus@123'
        RELEASE_REPO        = 'spoved-vprofile-release'
        CENTRAL_REPO        = 'spoved-vprofile-maven-central'
        NEXUSIP             = '172.20.0.2'
        NEXUSPORT           = '8081'
        NEXUS_GRP_REPO      = 'spoved-vprofile-maven-group'
        NEXUS_LOGIN         = 'nexuslogin'

    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('Test') {
            steps {
                sh 'mvn -s settings.xml test'
            }
        }

        stage('Checkstyle Analysis - Code Analysis') {
            steps {
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }
    }
}