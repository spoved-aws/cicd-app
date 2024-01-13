pipeline {
    agent any
    tools {
        maven "Maven3"
        // jdk "OracleJDK8"
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
        SONARSERVER         = 'sonarserver'
        SONARSCANNER        = 'sonarscanner'

    }

    stages {
        stage('Build') {
            environment {
                JAVA_HOME = '/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64'
            }
            steps {
                sh '''echo "JAVA_HOME is set to: $JAVA_HOME"
                $JAVA_HOME/bin/java -version'''
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
                sh '''echo "JAVA_HOME is set to: $JAVA_HOME"
                $JAVA_HOME/bin/java -version'''
                sh 'mvn -s settings.xml test'
            }
        }

        stage('Checkstyle Analysis - Code Analysis') {
            steps {
                sh '''
                echo "JAVA_HOME is set to: $JAVA_HOME"
                $JAVA_HOME/bin/java -version'''
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
                JAVA_HOME = '/opt/java/openjdk'
            }
            steps {
                 withSonarQubeEnv("${SONARSERVER}") {
                    sh '''
                    echo "JAVA_HOME is set to: $JAVA_HOME"
                    $JAVA_HOME/bin/java -version
                    ${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=spoved-sq-vprofile \
                   -Dsonar.projectName=spoved-sq-vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                 }
            }
        }

        stage ('Quality Gate') {
            steps{
                timeout(time: 1, unit: 'HOURS') {
                // Parameter to indicate whether to set the pipeline to UNSTABLE
                // true = set UNSTABLE, false = don't
                waitForQualityGate abortPipeline: true
                }

            }
            
        }
    }
}