# cicd-app
CD pipelines to vproapp built using Jenkins.

1. Jenkins installed on MacOS directly because I couldn't get the Jenkins container to run docker engine to build the image in the pipeline.
   - Installed the docker engine by exec into the container but docker wouldn't connect to the daemon.
   - Tried several ways to achieve this but nothing worked -- will try jenkins container method again.
   - errors: Docker is not running ... failed! ,
   - System has not been booted with systemd as init system (PID  1).Can't operate. Failed to connect to bus: Host is       down.
2. Jenkins installed in Ubuntu VM 23. Docker installed via instructions on docker page: https://www.jenkins.io/doc/book/installing/linux/
3. Nexus Repo running on docker container : accessed by localhost:8081
4. Sonarqube running on docker container : accessed by localhost:9000
5. Kubernetes cluster is running on MacOS as minikube with 1 node. 
6. Install kubectl in jenkins. Requires to symlinks to connect to the cluster running on the host machine:
   * Mount /Users/macuser/.kube and  /Users/macuser/.minikube to the VM - this should come up in /media/psf/.
   * Create /home/jenkins from root.
   * Create a password for the jenkins user.
   * Add the *jenkins* user to the sudoer file.
   * Switch to the jenkins user and create a directory /User/macuser with sudo command.
   * Create a sym link between the host .kube and .minikube directories.
   * ln -s /media/psf/.kube /Users/macuser/ ( --> this is the directory on ubuntu )
   * ln -s /media/psf/.minikube /Users/macuser/
7. Faced issues while pushing the image to github using the docker workflow plugin. After many attempts was able to push the image using docker.withRegistry(env.GITHUB_REGISTRY, env.GITHUB_TOKEN). Important thing to remember here is that the token should be saved in jenkins as userid/password NOT just the secret text.
8. Faced issue with mvn install - instructor used another branch <docker> to build the image from the multi-stage docker file- I added new pom file since the original pom had nexus ip and port parameterized - fixed the issue of image build by adding the step of docker build - RUN cd cicd-app && git checkout cicd-jenkins-local && **git pull** && mvn install -f pom-for-dockerfile.xml


