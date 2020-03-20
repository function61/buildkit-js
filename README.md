![Build status](https://github.com/function61/buildkit-js/workflows/Build/badge.svg)
[![Download](https://img.shields.io/docker/pulls/fn61/buildkit-js.svg?style=for-the-badge)](https://hub.docker.com/r/fn61/buildkit-js/)

JavaScript buildkit - frequently used compile tools for standardization across our projects.

See [Turbo Bob](https://github.com/function61/turbobob) for more details.

Tool versions are selected to closely match AWS Lambda to try to guarantee dev/prod parity.


Version pinning
---------------

[NPM doesn't support our use case of installing global dependencies from package.json](https://stackoverflow.com/q/14657170),
so we to specify the `node_modules` to install in our `Dockerfile` instead. It'd be painful
without `package.json` to update the packages so we have to compromise and get the latest
packages (= not pin versions).

Effectively the versions will be pinned though by the virtue of our Docker image immutability.

Why do we want to do this: if we have multiple projects wanting to use the same kind of
infrastructure that this base image delivers, it'd be painful to manage all the base stuff
separately in each project (like NPM tries to force us into).


Contains
--------

- Node.js (with NPM and Yarn)
- aws-sdk if developing for Lambda (because Lambda has it integrated as well)
- [TypeScript](https://www.typescriptlang.org/) compiler & some @types
- [Prettier](https://prettier.io/) to standardize code formatting
- [tslint](https://palantir.github.io/tslint/) for static analysis
- Build script to standardize build process across projects
- Standardized TypeScript/tslint/Prettier configuration for ensuring highest possible quality code
