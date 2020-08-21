#----
# Build stage
#----
FROM maven:3.5-jdk-8 as buildstage
# Copy only pom.xml of your projects and download dependencies
COPY pom.xml .
RUN mvn -B -f pom.xml dependency:go-offline
# Copy all other project files and build project
COPY . .
RUN mvn -B install -Dmaven.test.skip

FROM openliberty/open-liberty:springBoot2-ubi-min as staging
USER root
COPY --from=buildstage ./target/liberty-umask-0.0.1-SNAPSHOT.jar /staging/fatHello.jar

RUN springBootUtility thin \
 --sourceAppPath=/staging/fatHello.jar \
 --targetThinAppPath=/staging/thinHello.jar \
 --targetLibCachePath=/staging/lib.index.cache

FROM openliberty/open-liberty:springBoot2-ubi-min
USER root
COPY --from=staging /staging/lib.index.cache /opt/ol/wlp/usr/shared/resources/lib.index.cache
COPY --from=staging /staging/thinHello.jar /config/dropins/spring/thinHello.jar
COPY server.env /config

RUN chown -R 1001.0 /config && chmod -R g+rw /config && chown -R 1001.0 /opt/ol/wlp/usr/shared/resources/lib.index.cache && chmod -R g+rw /opt/ol/wlp/usr/shared/resources/lib.index.cache

USER 1001
