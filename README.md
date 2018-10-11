[![Build Status](https://img.shields.io/travis/function61/buildkit-js.svg?style=for-the-badge)](https://travis-ci.org/function61/buildkit-js)
[![Download](https://img.shields.io/docker/pulls/fn61/buildkit-js.svg?style=for-the-badge)](https://hub.docker.com/r/fn61/buildkit-js/)

JavaScript buildkit - frequently used compile tools for standardization across our projects.

See [Turbo Bob](https://github.com/function61/turbobob) for more details.

Tool versions are selected to closely match AWS Lambda to try to guarantee dev/prod parity.


Contains
--------

- Node.js (with NPM and Yarn)
- aws-sdk if developing for Lambda (because Lambda has it integrated as well)
- [TypeScript](https://www.typescriptlang.org/) compiler & some @types
- [Prettier](https://prettier.io/) to standardize code formatting
- [tslint](https://palantir.github.io/tslint/) for static analysis
- [jfrog-cli](https://github.com/jfrog/jfrog-cli-go) to upload artefacts to
  [Bintray](https://bintray.com/) (e.g. .zip files for Lambda)
- Build script to standardize build process across projects
- Standardized configuration for ensuring highest possible quality code
