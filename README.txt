~~~~~~~~~ THIS IS FOR DEMO/LEARNING. ~~~~~~~

Here the assumption is made that your Jenkins server is a Docker container.
To create the Jenkins server container execute this command:

docker run --rm -dit -e JENKINS_USER=$(id -u) --rm -p 8126:8080 -p 50001:50000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $PWD/jenkins_home:/var/jenkins_home \
-v ~/.kube:/root/.kube \
-v $HOME/.m2:/root/.m2 \
--name my-jenkins2 gsajenkins

This Jenkins server image has docker engine, kubectl, git and is based on the official Jenkins image (jenkins/jenkins:lts)
We are mapping the .kube folder to manage the cluster the our host machine.

- Gayatri S Ajith
gayatri@schogini.com
