FROM ruby:2.2.7

WORKDIR /app

ARG NODE_VER
ENV NODE_VER $NODE_VER

#ADD https://deb.nodesource.com/setup_${NODE_VER:-lts}.x  /tmp/setup_nodejs.x 
#RUN chmod a+x /tmp/setup_nodejs.x 
#RUN /tmp/setup_nodejs.x 

