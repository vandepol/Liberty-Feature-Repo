# Liberty Feature Repo

This project is used to create a single docker containers that contains the Liberty Lars Feature Repo, so that you can build and host a Liberty Feature server within an air gapped environment.

The instructions for creating this from scratch are found here:
https://github.com/WASdev/tool.lars
Here we just package the binaries
(Future updates may include multi stage build to build the LARS product first and then package it, however there we minor modifications to the server.xml required)

Note:  This repo DOES NOT contain the Liberty features.  They are too large and I don't want to host IBM content publicly, also they are updated to recently to keep track of.  You can download the feature here:
https://www-945.ibm.com/support/fixcentral/swg/selectFixes?parent=ibm~WebSphere&product=ibm/WebSphere/WebSphere+Liberty&release=All&platform=All&function=fixId&fixids=wlp-featureRepo-*&includeSupersedes=0

The pre-built docker container can be downloaded from https://hub.docker.com/r/vandepol/liberty-lars-feature-repo/

If you want to build the docker container yourself just run
`docker build . -f Dockerfile -t liberty-lars-feature-repo`

To run the LARS server run the following command.
`docker run --rm --name liberty-lars-feature-repo -v /Users/davidvandepol/larsdata:/data/db -p9080:9080 vandepol/liberty-lars-feature-repo`

This will start the LARS server.  Note this initially will not have any features populated into it.

To populate features into this server we run the following command. Whenever a new version of Liberty comes out, you will have to populate the server with the new features.  This is accumulative, so the database will increase after each release.  

`docker run -v /Users/davidvandepol/wlp-featureRepo-19.0.0.12/:/featureRepo/ vandepol/liberty-lars-feature-repo /bin/sh -c '/tmp/larsClient/bin/larsClient upload /featureRepo/features/19.0.0.12/*.esa --url=http://<HOSTNAME>:9080/ma/v1 --username=admin --password=admin'`

So what's happening above?  Here we are connecting to the running Liberty server we just started.  We run the application client and point to the features repo.  


To run on Kubernetes you will need to push your docker image to your docker registry, example below is for dockerhub
`docker tag liberty-feature-repo:19.0.0.4 vandepol/liberty-feature-repo:19.0.0.4`
`docker push vandepol/liberty-feature-repo:19.0.0.4`
`kubectl create -f deployment.yaml`
`kubectl create -f service.yaml`
`kubectl get services | grep liberty-feature-repo`


To configure liberty to point to your own repo, add the `repositories.properties` to your `wlp/etc` directory (You may need to create etc folder).  See example here https://github.com/vandepol/Liberty-Feature-Repo/blob/master/etc/repositories.properties
