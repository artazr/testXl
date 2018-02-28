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
                sh "sed -i 's/TOREPLACE/1.1.${BUILD_NUMBER}/g' deployit-manifest.xml"
                archiveArtifacts artifacts: 'deployit-manifest.xml'
                archiveArtifacts artifacts: 'index.php'
                xldCreatePackage artifactsPath: '.', manifestPath: 'deployit-manifest.xml', darPath: 'testxlr-1.1.${BUILD_NUMBER}.dar'
                
            }
        }

        stage('Publish') {
            steps {
                echo 'Publishing....'
                // Direct publish to XLD
                xldPublishPackage serverCredentials: 'cred-xld', darPath: 'testxlr-1.1.${BUILD_NUMBER}.dar'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                xldDeploy serverCredentials: 'cred-xld', environmentId: 'Environments/DUA', packageId: 'Applications/MyTest/1.1.${BUILD_NUMBER}'
            }
        }
    }
}
