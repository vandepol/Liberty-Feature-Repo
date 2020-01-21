# Liberty Feature Repo

This project is used to create a single docker containers that contains the Liberty Lars Feature Repo, so that you can build and host a Liberty Feature server within an air gapped environment. 

The instructions for creating this from scratch are found here:
https://github.com/WASdev/tool.lars
Here we just package the binaries 
(Future updates may include multi stage build to build the LARS product first and then package it, however there we minor modifications to the server.xml required)

Note:  This repo DOES NOT contain the Liberty features.  They are too large and I don't want to host IBM content publically.  You can download the feature here:
https://www-945.ibm.com/support/fixcentral/swg/selectFixes?parent=ibm~WebSphere&product=ibm/WebSphere/WebSphere+Liberty&release=All&platform=All&function=fixId&fixids=wlp-featureRepo-*&includeSupersedes=0

When you download them, you can unzip them into a folder called featureRepo19004 for example, then when you run a docker build it will pick those up from there. 

Modifying the Dockerfile for newer feature repositories should be very simple, just download the newer version of the files and replace 19004 with the version you downloaded. 

To build the docker contain just run:
`docker build . -f Dockerfile19004 -t liberty-feature-repo:19.0.0.4`

To run the docker container locally run:
`docker run --name liberty-feature-repo-19004 -p9080:9080 liberty-feature-repo:19.0.0.4`

To run on Kubernetes you will need to push your docker image to your docker registry, example below is for dockerhub
`docker tag liberty-feature-repo:19.0.0.4 vandepol/liberty-feature-repo:19.0.0.4`
`docker push vandepol/liberty-feature-repo:19.0.0.4`
`kubectl create -f deployment.yaml`
`kubectl create -f service.yaml`
`kubectl get services | grep liberty-feature-repo`


To configure liberty to point to your own repo, add the `repositories.properties` to your `wlp/etc` directory (You may need to create etc folder).  See example here https://github.com/vandepol/Liberty-Feature-Repo/blob/master/etc/repositories.properties

