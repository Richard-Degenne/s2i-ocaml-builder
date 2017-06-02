
# s2i-ocaml-builder
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
MAINTAINER Richard Degenne <richdeg2@gmail.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
#LABEL io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y

RUN wget -O /usr/bin/opam https://github.com/ocaml/opam/releases/download/2.0.0-beta3/opam-2.0.0-beta3-x86_64-Linux
RUN chmod 755 /usr/bin/opam

# This default user is created in the openshift/base-centos7 image
RUN chown -R 1001:1001 /opt/app-root
USER 1001

RUN opam init -y
RUN eval `opam config env`

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
