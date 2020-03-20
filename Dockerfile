# closest to AWS Lambda (Lambda has 12.x)
FROM node:12.16-slim

# docs for AWS lambda node/aws-sdk etc. versions:
# 	https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html

WORKDIR /workspace

# it boggles my mind, why this is left unconfigured in official node image..
ENV NODE_PATH=/usr/local/lib/node_modules

# /node_modules symlink trick because TypeScript compiler doesn't seem to use NODE_PATH
RUN apt update && apt install -y zip \
	&& npm install -g \
		typescript \
		tslint \
		tslint-plugin-prettier \
		prettier \
		@types/node \
		webpack \
		webpack-cli \
		ts-loader \
		tsconfig-paths-webpack-plugin \
		circular-dependency-plugin \
	&& ln -s /usr/local/lib/node_modules /node_modules

ADD bin/build-common.sh /build-common.sh
ADD bin/tslint.sh /usr/local/bin/tslint.sh

COPY tsconfigs /etc/tsconfigs

ADD prettier-config.json /etc/prettier-config.json
ADD tslint.json /etc/tslint.json
