FROM websphere-liberty

COPY larsServerPackage.jar /tmp/
RUN /opt/ibm/wlp/bin/installUtility install --acceptLicense \
com.ibm.websphere.appserver.mongodb-2.0 \
com.ibm.websphere.appserver.cdi-1.0 \
com.ibm.websphere.appserver.jaxrs-1.1
RUN java -jar /tmp/larsServerPackage.jar --acceptLicense /opt/ibm/wlp
COPY server.xml /opt/ibm/wlp/usr/servers/larsServer/server.xml

CMD ["/opt/ibm/wlp/bin/server", "run", "larsServer"]
