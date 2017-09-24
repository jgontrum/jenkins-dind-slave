# Jenkins Docker-in-Docker slave

None of the existing Dockerfiles are working anymore, so I wrote one from scratch.

Usecase: Run Jenkins as a Docker container and use other containers (Jenkins slaves) to execute build files.

# Configuration

1. Install docker-plugin https://wiki.jenkins.io/display/JENKINS/Docker+Plugin
2. For main Jenkins: Mount volume "/var/run/docker.sock:/var/run/docker.sock"
3. Image: jgontrum/jenkins-dind-slave
4. Settings in Manage Jenkins -> Cloud -> Container Settings:
   - Volumes: /var/run/docker.sock:/var/run/docker.sock
   - Run container privileged: Yes
5. Launch credentials: User/PW - jenkins:jenkins
