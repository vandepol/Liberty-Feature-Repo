FROM websphere-liberty:full


USER 1001:0
COPY larsServerPackage.jar /tmp/

COPY --chown=1001:0 larsClient /tmp/larsClient
RUN cat /etc/*release
#RUN /opt/ibm/wlp/bin/installUtility install --acceptLicense \
#com.ibm.websphere.appserver.mongodb-2.0 \
#com.ibm.websphere.appserver.cdi-1.0 \
#com.ibm.websphere.appserver.jaxrs-1.1 \
#com.ibm.websphere.appserver.appSecurity-2.0 \
#com.ibm.websphere.appserver.ssl-1.0 \
#com.ibm.websphere.appserver.jndi-1.0

RUN java -jar /tmp/larsServerPackage.jar --acceptLicense /opt/ibm/wlp
COPY server.xml /opt/ibm/wlp/usr/servers/larsServer/server.xml

USER root
COPY offlinepackages/*.deb /offlinepackages/
RUN apt-get install /offlinepackages/*.deb
RUN rm -rf /offlinepackages

RUN mkdir -p /data/db
RUN chmod 755 /data/db
RUN chown 1001 /data/db
RUN chmod  777 /
USER 1001:0


USER root
#RUN mongod & sleep 10s && /opt/ibm/wlp/bin/server start larsServer && /tmp/larsClient/bin/larsClient upload /featureRepo/features/19.0.0.12/*.esa --url=http://localhost:9080/ma/v1 --username=admin --password=admin
#RUN /opt/ibm/wlp/bin/server stop larsServer


CMD ["sh", "-c", "mongod  & /opt/ibm/wlp/bin/server run larsServer"]
