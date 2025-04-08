FROM ubuntu:22.04 AS base

############################################################
# Distro setup
############################################################

WORKDIR /home/tcec/

RUN apt-get update && \
    apt-get install -y \
        # Convenience
        dos2unix nano \
        # update-sh
        software-properties-common make git \
        # update-nobuild.sh
        curl wget unzip && \
    add-apt-repository ppa:dotnet/backports && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0

FROM base AS ubuntu-playground

############################################################
# Repo setup
############################################################

WORKDIR /home/tcec/
COPY update-nobuild.sh /home/tcec/
COPY update.sh /home/tcec/

RUN dos2unix *.sh
RUN chmod +x /home/tcec/update-nobuild.sh
RUN chmod +x /home/tcec/update.sh

# SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/home/tcec/update.sh"]
# ENTRYPOINT ["/home/tcec/update-nobuild.sh"]
