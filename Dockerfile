# closest to AWS Lambda that has 8.10
FROM node:8.11.4-slim

WORKDIR /workspace

# it boggles my mind, why this is left unconfigured in official node image..
ENV NODE_PATH=/usr/local/lib/node_modules

# docs for AWS lambda node/aws-sdk etc. versions:
# 	https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html

RUN apt update && apt install -y zip \
	&& npm install -g  \
		yarn@1.12.3 \
		typescript@3.1.1 \
		tslint@5.11.0 \
		tslint-plugin-prettier@2.0.1 \
		prettier@1.15.3 \
		aws-sdk@2.290.0 \
		@types/node@8.10.34 \
		@types/aws-lambda@8.10.13 \
	&& chmod +x /usr/local/bin/yarn \
	&& ln -s /usr/local/lib/node_modules /node_modules

# /node_modules symlink trick because TypeScript compiler doesn't seem to use NODE_PATH

ADD build-common.sh /build-common.sh

COPY tsconfigs /etc/tsconfigs

ADD prettier-config.json /etc/prettier-config.json
ADD tslint.json /etc/tslint.json
