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
          
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
