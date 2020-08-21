FROM openliberty/open-liberty:springBoot2-ubi-min as staging
USER root
COPY target/liberty-umask-0.0.1-SNAPSHOT.jar /staging/fatHello.jar

RUN springBootUtility thin \
 --sourceAppPath=/staging/fatHello.jar \
 --targetThinAppPath=/staging/thinHello.jar \
 --targetLibCachePath=/staging/lib.index.cache

FROM openliberty/open-liberty:springBoot2-ubi-min
USER root
COPY --from=staging /staging/lib.index.cache /opt/ol/wlp/usr/shared/resources/lib.index.cache
COPY --from=staging /staging/thinHello.jar /config/dropins/spring/thinHello.jar

RUN chown -R 1001.0 /config && chmod -R g+rw /config && chown -R 1001.0 /opt/ol/wlp/usr/shared/resources/lib.index.cache && chmod -R g+rw /opt/ol/wlp/usr/shared/resources/lib.index.cache

USER 1001
