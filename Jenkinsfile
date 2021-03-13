pipeline {
    agent any
    stages {
        stage ('Build Project') {
            agent { docker { image 'maven:3.6.1' } }
            steps {
                git url: 'https://github.com/schogini/samplejava.git'
                sh 'mvn --version'
                sh 'mvn clean package'
                // withMaven(maven: 'mvn3.6.1') {
                //     sh 'mvn clean package'
                //     sh 'ls -l'
                //     sh 'find .'
                // }
            }
            post {
                success {
                    stash includes: '**/target/*.war', name: 'app' 
                }
            }
        }
        stage ('Build Image') {
            agent {
                docker {
                    image "gayatrisa/ansible-with-docker-ws"
                    args "-v /var/run/docker.sock:/var/run/docker.sock -w /etc/ansible -e 'BUILD_ID=${env.BUILD_ID}'"
                }
            }
            steps {
                sh("rm -fr ./*")
                git url: 'https://github.com/schogini/jenkins-pipeline'
                unstash 'app'
		
		// move the target folder into the tomcat folder so that it is in the context of the Dockerfile
                sh('rm -fr tomcat/target')
                sh('mv target tomcat/')
                sh("ansible-playbook ansible/build-image.yml")
            }
        }
        stage ('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh("docker login -u=${DOCKER_USERNAME} -p=${DOCKER_PASSWORD}")
                    sh("docker push schogini/tomcat:pipeline-${env.BUILD_ID}")
                }
                
                // to save space on the local Docker Engine.
                // we do not need the new image locally
                sh("docker rmi schogini/tomcat:pipeline-${env.BUILD_ID}")
            }
        }
        stage ('Deploy Image') {
            steps {
		// assumption is made that the deployment deploy/gsa-deploy-tomcat is already created
                //sh ("kubectl set image deploy/gsa-deploy-tomcat tomcat=schogini/tomcat:pipeline-${env.BUILD_ID}")
                echo "SUCCESS"
            }
        }
    }
}
