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
        NEXUS_IP            = 'localhost'
        NEXUS_PORT          = '8081'
        NEXUS_GRP_REPO      = 'spoved-vprofile-maven-group'
        NEXUS_LOGIN         = 'nexuslogin'

    }

    stages {
        stage {
            sh 'mvn -s settings.xml -DskipTests install'
        }

    }
}