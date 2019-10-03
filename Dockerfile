# Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow 
# a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all 
# out as one package.

From nvcr.io/nvidia/pytorch:19.04-py3
# pytorch is used for computer vision

RUN apt-get -y update

RUN apt-get install -y python3-pip software-properties-common wget ffmpeg
#  ffmpeg can convert between different file formats,

RUN add-apt-repository ppa:git-core/ppa

RUN apt-get -y update

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt-get install -y git-lfs --allow-unauthenticated

RUN git lfs install

ENV GIT_WORK_TREE=/data
# GIT_WORK_TREE is the location of the root of the working directory for a non-bare repository.

RUN mkdir -p /root/.torch/models

RUN mkdir -p /data/models

RUN wget -O /root/.torch/models/vgg16_bn-6c64b313.pth https://download.pytorch.org/models/vgg16_bn-6c64b313.pth

RUN wget -O /root/.torch/models/resnet34-333f7ec4.pth https://download.pytorch.org/models/resnet34-333f7ec4.pth

RUN wget -O /data/models/ColorizeArtistic_gen.pth https://www.dropbox.com/s/zkehq1uwahhbc2o/ColorizeArtistic_gen.pth?dl=0 

ADD . /data/

WORKDIR /data

RUN pip install -r requirements.txt

RUN cd /data/test_images && git lfs pull

EXPOSE 8888

ENTRYPOINT ["sh", "/data/run_notebook.sh"]

