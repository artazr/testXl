import java.text.*
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                script {
			sh "printenv"
			echo "Target Environnement = ${targetEnv}"
			if ( targetEnv == 'dua' ) {
				echo 'Testing..'
				sh "php -f index.php"
			}
		}
            }
        }

        stage('Build') {
		steps {
			script {
				if ( targetEnv == 'dua' ) {
					echo 'Building..'
					sh "tar -czvf mytest-1.1.${BUILD_NUMBER}.tar.gz index.php"
			    	}
				    
			}
		}
        }
        
        stage('package') {
            steps {
                echo 'packaging xldeploy'
                
                archiveArtifacts artifacts: 'deployit-manifest.xml'
                archiveArtifacts artifacts: 'index.php'
                
            }
        }

        stage('Publish') {
            steps {
                echo 'Publishing....'
                // Push to nexus
                // sh "curl -X PUT -v -u admin:p@ssw0rd --upload-file mytest.tar.gz http://126.246.166.246:8081/nexus/content/repositories/generic-public/"
                // sh "/usr/local/apache-maven/bin/mvn deploy:deploy-file -DgroupId=com.jteisseire.test -DartifactId=mytest -Dversion=1.0 -Dpackaging=jar -Dfile=mytest.tar.gz -Durl=http://126.246.164.63:8081/repository/maven-public/ -DrepositoryId=maven-public"
                nexusArtifactUploader artifacts: [[artifactId: 'mytest', classifier: 'latest', file: 'mytest-1.1.${BUILD_NUMBER}.tar.gz', type: 'tgz']], credentialsId: 'cred-nexus', groupId: 'sp.sd', nexusUrl: '126.246.164.63:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'MyTest', version: '1.1.${BUILD_NUMBER}'
                // Direct publish to XLD
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
