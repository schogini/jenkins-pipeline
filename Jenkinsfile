def hostWorkspace
pipeline {
    agent any
    parameters {
        string(name: 'JENKINSDIR', defaultValue: '/Developer/Collabera/gayatri/jenkins/new/session1/jenkins_home/workspace/', description: 'Jenkins home dir wrt host docker engine')
        
    }
    stages {
        stage ('Build Project') {
            steps {
                git url: 'https://github.com/gayatri-sa/samplejava'
                withMaven(maven: 'mvn3.6.0') {
                    sh 'mvn clean package'
                }
            }
            post {
                success {
                    stash includes: '**/target/*.war', name: 'app' 
                }
            }
        }
        stage ('Build Image') {
            steps {
                script {
                    hostWorkspace = env.WORKSPACE.replace("/var/jenkins_home/workspace/", "${JENKINSDIR}")
                }
                sh("rm -fr ./*")
                git url: 'https://github.com/gayatri-sa/jenkins-pipeline'
                unstash 'app'
                // sh 'ls -la'
                // sh ("echo '${hostWorkspace}'")
                sh("docker run --rm --name ansible-ws -v ${hostWorkspace}/ansible:/etc/ansible -v ${hostWorkspace}/tomcat:/etc/ansible/tomcat -v ${hostWorkspace}/target:/etc/ansible/tomcat/target -v /var/run/docker.sock:/var/run/docker.sock -w /etc/ansible -e 'BUILD_ID=${env.BUILD_ID}' gayatrisa/ansible-with-docker-ws ansible-playbook build-image.yml")
            }
        }
        stage ('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh("docker login -u=${DOCKER_USERNAME} -p=${DOCKER_PASSWORD}")
                    sh("docker push gayatrisa/tomcat:pipeline-${env.BUILD_ID}")
                }
            }
        }
        // stage ('Deploy Image') {
                // sh ("kubectl get deploy")            
        // }
    }
}
