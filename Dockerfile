FROM gradle:3.5-jdk-alpine

# The gradle image runs under the user "gradle", but when you run as gradle, the gradle cache directory is inside a
# volume, which results in dependencies being wiped on every step in the docker build.
USER root

# There is no point in running the gradle daemon, as it would be stopped by docker on every step in the build anyway.
ENV GRADLE_OPTS -Dorg.gradle.daemon=false

# Working directory
RUN mkdir /kubernetes-volume-backup
WORKDIR /kubernetes-volume-backup

# Dependencies
COPY build.gradle .
RUN gradle downloadDependencies

# Compilation
COPY . .
RUN gradle classes

CMD ["gradle", "run"]