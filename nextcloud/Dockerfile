ARG NEXTCLOUD_VERSION=21.0.3
FROM nextcloud:${NEXTCLOUD_VERSION}-apache

# Specify URL and secrets. When using AWS_S3_SECRET_ACCESS_KEY_FILE, the secret
# key will be read from that file itself, which helps passing further passwords
# using Docker secrets. You can either specify the path to an authorisation
# file, set environment variables with the key and the secret.
ENV AWS_S3_URL=https://s3.amazonaws.com
ENV AWS_S3_ACCESS_KEY_ID=
ENV AWS_S3_SECRET_ACCESS_KEY=
ENV AWS_S3_SECRET_ACCESS_KEY_FILE=
ENV AWS_S3_AUTHFILE=
ENV AWS_S3_BUCKET=

# User and group ID of share owner
ENV RUN_AS=
ENV UID=0
ENV GID=0

# Location of directory where to mount the drive into the container and where to mount the appdata
ENV AWS_S3_MOUNT=/opt/s3fs/bucket
ENV APPDATA_FOLDER

# Following should match the AWS_S3_MOUNT and APPDATA_FOLDER environment variables respectively.
VOLUME [ "/opt/s3fs/bucket" ]
VOLUME [ "/opt/nextcloud/appdata" ]

# s3fs tuning
ENV S3FS_DEBUG=0
ENV S3FS_ARGS=

RUN mkdir /opt/s3fs && \
    apt-get update && \
    apt-get install -y \
     fuse \
     s3fs \
     supervisor && \
     s3fs --version

# allow access to volume by different user to enable UIDs other than root when using volumes
RUN echo user_allow_other >> /etc/fuse.conf

COPY *.sh /usr/local/bin/

# The default is to perform all system-level mounting as part of the entrypoint
# to then have a command that will keep listing the files under the main share.
# Listing the files will keep the share active and avoid that the remote server
# closes the connection.
#ENTRYPOINT [ "tini", "-g", "--", "docker-s3fs-entrypoint.sh" ]
#CMD [ "empty.sh" ]

STOPSIGNAL SIGTERM
ENV NEXTCLOUD_UPDATE=1

ENTRYPOINT [ "docker-s3fs-entrypoint.sh" ]
COPY supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
