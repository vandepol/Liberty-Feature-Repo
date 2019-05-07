FROM websphere-liberty

COPY larsServerPackage.jar /tmp/
RUN /opt/ibm/wlp/bin/installUtility install --acceptLicense \
com.ibm.websphere.appserver.mongodb-2.0 \
com.ibm.websphere.appserver.cdi-1.0 \
com.ibm.websphere.appserver.jaxrs-1.1
RUN java -jar /tmp/larsServerPackage.jar --acceptLicense /opt/ibm/wlp
COPY server.xml /opt/ibm/wlp/usr/servers/larsServer/server.xml

USER root
RUN apt-get update && apt-get install -y mongodb
RUN mkdir -p /data/db


COPY larsClient /tmp/larsClient
COPY featureRepo /featureRepo


RUN mongod  & sleep 10s && /opt/ibm/wlp/bin/server start larsServer  && /tmp/larsClient/bin/larsClient upload /featureRepo/features/19.0.0.1/*.esa --url=http://localhost:9080/ma/v1 --username=admin --password=admin 
#RUN /opt/ibm/wlp/bin/server stop larsServer

RUN rm -rf /featureRepo

CMD ["sh", "-c", "mongod  & /opt/ibm/wlp/bin/server run larsServer"]

